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
    "project-id"        = var.project-info["project-id"]
    "environment-name"  = var.project-info["environment-name"]
  }
  name_prefix = replace("redis-${var.appshortname}-${var.envstage}-${var.name_prefix}", "_", "-")

  admin_principals_full = distinct(concat(var.backendconfig["default_resource_admin_principals"]["all"],
    var.backendconfig["default_resource_admin_principals"]["redis"],
  [data.aws_caller_identity.current.arn]))
  redis_principals_full = distinct(concat(var.backendconfig["default_resource_user_principals"]["all"],
  var.backendconfig["default_resource_user_principals"]["redis"]))
}

module "this_redis_kms_key" {
  source = "git::https://dev.azure.com/BPS-IT/SADI/_git/tf-aws-module-kms?ref=develop"


  count = var.at_rest_encryption_enabled ? 0 : 1

  alias                    = "alias/${local.name_prefix}-redis-key"
  customer_master_key_spec = "SYMMETRIC_DEFAULT"
  deletion_window_in_days  = 10
  description              = "KMS key for Redis at rest: ${local.name_prefix}"
  enable_key_rotation      = true
  key_usage                = "ENCRYPT_DECRYPT"
  policy = templatefile("${path.module}/policies/kms-key-policy.json.tmpl",
    { "user_principals" = jsonencode(local.redis_principals_full),
  "admin_principals" = jsonencode(local.admin_principals_full) })

  tags = merge(local.common_tags, { "name" = "${local.name_prefix}-redis-key" })
}

module "network_info" {
  source = "git::https://dev.azure.com/BPS-IT/SADI/_git/tf-aws-module-lz-network?ref=1.0.0"
}

module "elasticache_redis" {
  source = "git::https://dev.azure.com/BPS-IT/SADI/_git/tf-aws-module-redis?ref=1.0.0"

  name_prefix        = local.name_prefix
  num_cache_clusters = var.num_cache_clusters
  node_type          = var.node_type

  cluster_mode_enabled    = var.cluster_mode_enabled
  replicas_per_node_group = var.replicas_per_node_group
  num_node_groups         = var.num_node_groups

  engine_version           = var.engine_version
  port                     = var.port
  maintenance_window       = var.maintenance_window
  snapshot_window          = var.snapshot_window
  snapshot_retention_limit = var.snapshot_retention_limit

  automatic_failover_enabled = var.automatic_failover_enabled

  at_rest_encryption_enabled = var.at_rest_encryption_enabled
  transit_encryption_enabled = var.transit_encryption_enabled
  auth_token                 = var.auth_token

  apply_immediately = var.apply_immediately
  family            = var.family
  description       = var.description

  subnet_ids = keys(module.network_info.subnet-maps-data)
  vpc_id     = module.network_info.vpc-id

  ingress_cidr_blocks = var.ingress_cidr_blocks

  parameter = var.parameter

  allowed_security_groups     = var.allowed_security_groups
  auto_minor_version_upgrade  = var.auto_minor_version_upgrade
  data_tiering_enabled        = var.data_tiering_enabled
  final_snapshot_identifier   = var.final_snapshot_identifier
  global_replication_group_id = var.global_replication_group_id
  ingress_self                = var.ingress_self
  kms_key_id                  = var.kms_key_id == "" ? module.this_redis_kms_key[0].key_arn : null

  tags = merge(local.common_tags, var.tags)
}