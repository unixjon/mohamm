data "aws_caller_identity" "current" {}

locals {
  common_tags = {
    "Environment"       = var.medtronic-tags["environment-stage"]
    "Business Unit"     = var.medtronic-tags["business-unit"]
    "Business Contact"  = var.medtronic-tags["business-contact"]
    "Support Contact"   = var.medtronic-tags["support-contact"]
    "Cost Center"       = var.medtronic-tags["cost-center"]
    "WBS"               = var.medtronic-tags["wbs-code"]
    "deployment_source" = var.project-info["deployment-source"]
    "project-id"         = var.project-info["project-id"]
    "environment-name"  = var.project-info["environment-name"]
  }

  rds_identifier = replace("rds-${var.appshortname}-${var.envstage}-${var.rdsshortname}", "_", "-")

  rds_storage_principals_list           = var.rds_storage_key_policy == "" ? ( 
                                            formatlist(
                                                "arn: aws:iam::${var.backendconfig["accountid"]}:%s",
                                                var.rds_storage_principals)
                                            )       : []
  rds_storage_principals_full           = distinct(concat(local.rds_storage_principals_list, 
                                                          var.rds_storage_principals_explicit,
                                                          var.backendconfig["default_resource_user_principals"]["all"],
                                                          var.backendconfig["default_resource_user_principals"]["rds"]))
  performinsights_principals_list       = var.performinsights_key_policy == "" ? ( 
                                            formatlist(
                                                "arn: aws:iam::${var.backendconfig["accountid"]}:%s",
                                                var.performinsights_principals)
                                            )       : []
  performinsights_principals_full       = distinct(concat(local.performinsights_principals_list, 
                                                          var.performinsights_principals_explicit,
                                                          var.backendconfig["default_resource_user_principals"]["all"],
                                                          var.backendconfig["default_resource_user_principals"]["rds"]))
  admin_principals_full                 = distinct(concat(var.backendconfig["default_resource_admin_principals"]["all"],
                                                          var.backendconfig["default_resource_admin_principals"]["rds"],
                                                          [data.aws_caller_identity.current.arn]))

  db_port_rule = contains(["aurora", "aurora-mysql", "mariadb", "mysql"], var.engine) ? "mysql-tcp" : (
                   contains(["postgres"], var.engine) ? "postgresql-tcp" : "mssql-tcp"
                 )

}

module "this_rds_storage_key" {
    source = "git::https://dev.azure.com/BPS-IT/SADI/_git/tf-aws-module-kms?ref=develop"


    count = var.use_default_encryption_key ? 0 : 1

    alias                    = "alias/${local.rds_identifier}-rds-key"
    customer_master_key_spec = "SYMMETRIC_DEFAULT"
    deletion_window_in_days  = 10
    description              = "KMS key for RDS instance: ${local.rds_identifier}"
    enable_key_rotation      = true
    key_usage                = "ENCRYPT_DECRYPT"
    policy                   = coalesce ( var.rds_storage_key_policy, 
                                          templatefile("${path.module}/policies/kms-key-policy.json.tmpl", 
                                            { "user_principals" = jsonencode(local.rds_storage_principals_full),
                                              "admin_principals"  = jsonencode(local.admin_principals_full)} )                                          
                                        )
    tags                     = merge(local.common_tags, { "name" = "${local.rds_identifier}-rds-key" })
}


module "this_performance_insights_key" {
    source = "git::https://dev.azure.com/BPS-IT/SADI/_git/tf-aws-module-kms?ref=develop"


    count = var.performance_insights_enabled ? 1 : 0

    alias                    = "alias/${local.rds_identifier}-perfominsights-key"
    customer_master_key_spec = "SYMMETRIC_DEFAULT"
    deletion_window_in_days  = 10
    description              = "KMS key for RDS Perf Insights: ${local.rds_identifier}"
    enable_key_rotation      = true
    key_usage                = "ENCRYPT_DECRYPT"
    policy                   = coalesce ( var.performinsights_key_policy, 
                                          templatefile("${path.module}/policies/kms-key-policy.json.tmpl", 
                                            { "user_principals" = jsonencode(local.performinsights_principals_full),
                                              "admin_principals"  = jsonencode(local.admin_principals_full)} )                                          
                                        )
    tags                     = merge(local.common_tags, { "name" = "${local.rds_identifier}-performinsights-key" })
}

data "aws_vpc_endpoint" "private_s3" {
    vpc_id       = module.network_info.vpc-id
    service_name = "com.amazonaws.us-east-1.s3"
}

module "network_info" {
  source = "git::https://dev.azure.com/BPS-IT/SADI/_git/tf-aws-module-lz-network?ref=1.0.0"
}


module "this_rds_security_group" {
  source = "git::https://dev.azure.com/BPS-IT/SADI/_git/tf-aws-module-security-group?ref=1.1.0"

  count = length(var.vpc_security_group_ids) == 0 ? 1 : 0

  name            = "sgrp-${local.rds_identifier}"
  description     = "Security group for ${local.rds_identifier}"
  vpc_id          = module.network_info.vpc-id
  use_name_prefix = false
  
  tags = local.common_tags

  egress_prefix_list_ids = [ ]

  ingress_with_self = [
      {
          rule = "all-all"
      }
    ]
  # egress_with_self = [
  #     {
  #         rule = "all-all"
  #     }
  # ]

  ingress_with_cidr_blocks = concat(
    [ for cidrblock in var.backendconfig["default_cidrs"]["vpn"]: merge({"rule" = local.db_port_rule}, cidrblock) ],
    [ for cidrblock in var.backendconfig["default_cidrs"]["rds"]: merge({"rule" = local.db_port_rule}, cidrblock) ],
    [ for cidrblock in var.rds_cidr_blocks: merge({"rule" = local.db_port_rule}, cidrblock) ],
    var.addl_ingress_rules,
    [ for cidrblock in keys(module.network_info.subnet-maps-app):
          merge({"rule" = local.db_port_rule}, {"cidr_blocks" = module.network_info.subnet-maps-app[cidrblock]["cidr_block"]}) 
    ],
    [ for cidrblock in keys(module.network_info.subnet-maps-data):
          merge({"rule" = local.db_port_rule}, {"cidr_blocks" = module.network_info.subnet-maps-data[cidrblock]["cidr_block"]}) 
    ]
  )

  egress_with_cidr_blocks = concat(
    [ for cidrblock in var.backendconfig["default_cidrs"]["vpn"]: merge({"rule" = local.db_port_rule}, cidrblock) ],
    [ for cidrblock in var.backendconfig["default_cidrs"]["rds"]: merge({"rule" = local.db_port_rule}, cidrblock) ],
    [ for cidrblock in var.rds_cidr_blocks: merge({"rule" = local.db_port_rule}, cidrblock) ],
    var.addl_egress_rules,
    [ for cidrblock in keys(module.network_info.subnet-maps-app):
          merge({"rule" = local.db_port_rule}, {"cidr_blocks" = module.network_info.subnet-maps-app[cidrblock]["cidr_block"] }) 
    ],
    [ for cidrblock in keys(module.network_info.subnet-maps-data):
          merge({"rule" = local.db_port_rule}, {"cidr_blocks" = module.network_info.subnet-maps-data[cidrblock]["cidr_block"] }) 
    ]
  )

}

module rds_database {
  source = "git::https://dev.azure.com/BPS-IT/SADI/_git/tf-aws-module-rds?ref=FEATURE/update-to-3"

  create_db_instance = true

  # Basics
  identifier = local.rds_identifier

  username               = var.username
  password               = var.password
  create_random_password = var.create_random_password
  random_password_length = var.random_password_length

  engine             = var.engine
  engine_version     = var.engine_version
  instance_class     = var.instance_class
  character_set_name = var.character_set_name
  timezone           = var.timezone

  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  iops                  = var.iops
  storage_encrypted     = true
  kms_key_id            = module.this_rds_storage_key[0].key_arn
  
  port                   = null
  multi_az               = var.multi_az
  publicly_accessible    = false
  vpc_security_group_ids = length(var.vpc_security_group_ids) == 0 ? [module.this_rds_security_group[0].this_security_group_id] : var.vpc_security_group_ids

  #   DB Name
  name = var.db_name
  
  tags = merge(local.common_tags, var.tags)

  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports


  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_kms_key_id       = var.performance_insights_enabled ? module.this_performance_insights_key[0].key_arn : null
  performance_insights_retention_period = var.performance_insights_retention_period

  # subnet groups
  create_db_subnet_group          = var.create_db_subnet_group
  db_subnet_group_description     = var.db_subnet_group_description != "" ? var.db_subnet_group_description : " db subnet group for ${local.rds_identifier}"
  db_subnet_group_name            = var.create_db_subnet_group == true ? "db-subnet-${local.rds_identifier}" : var.db_subnet_group_name 
  db_subnet_group_use_name_prefix = false

  subnet_ids                      = var.create_db_subnet_group ? (
                                          length(var.subnet_ids) > 0 ? var.subnet_ids : keys(module.network_info.subnet-maps-data)
                                        ) : []
  # additional tags
  db_instance_tags        = merge(local.common_tags, var.db_instance_tags)
  db_option_group_tags    = merge(local.common_tags, var.db_option_group_tags)
  db_parameter_group_tags = merge(local.common_tags, var.db_parameter_group_tags)
  db_subnet_group_tags    = merge(local.common_tags, var.db_subnet_group_tags)

  # parameter group
  create_db_parameter_group       = var.create_db_parameter_group
  parameter_group_description     = var.parameter_group_description != "" ? var.parameter_group_description : " db parameter group for ${local.rds_identifier}"
  parameter_group_name            = var.create_db_parameter_group ? "db-param-grp-${local.rds_identifier}" : var.parameter_group_name
  parameter_group_use_name_prefix = false
  parameters                      = var.parameters
  family                          = var.family

  # option group
  create_db_option_group       = var.create_db_option_group
  option_group_description     = var.option_group_description != "" ? var.option_group_description : " db option group for ${local.rds_identifier}"
  option_group_name            = var.create_db_option_group ? "db-options-${local.rds_identifier}" : var.option_group_name
  option_group_use_name_prefix = false
  options                      = var.options
  major_engine_version         = var.major_engine_version


  # rds settings
  allow_major_version_upgrade = var.allow_major_version_upgrade
  auto_minor_version_upgrade  = var.auto_minor_version_upgrade
  apply_immediately           = var.apply_immediately
  backup_retention_period     = var.backup_retention_period
  backup_window               = var.backup_window
  maintenance_window          = var.maintenance_window


  #   deletion
  delete_automated_backups         = var.delete_automated_backups
  deletion_protection              = var.deletion_protection
  copy_tags_to_snapshot            = var.copy_tags_to_snapshot
  final_snapshot_identifier        = var.final_snapshot_identifier
  final_snapshot_identifier_prefix = var.final_snapshot_identifier_prefix
  skip_final_snapshot              = var.skip_final_snapshot


  # least used / unknown / only use if you know what you're doing
  ca_cert_identifier                  = var.ca_cert_identifier
  snapshot_identifier                 = var.snapshot_identifier
  iam_database_authentication_enabled = false
  license_model                       = var.license_model
  replicate_source_db                 = var.replicate_source_db
  storage_type                        = var.storage_type
  availability_zone                   = var.availability_zone

}