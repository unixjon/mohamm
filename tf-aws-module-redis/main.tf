provider "aws" {
  region = "us-east-2"
}
resource "aws_elasticache_replication_group" "redis" {
  engine = var.global_replication_group_id == null ? "redis" : null

  parameter_group_name = var.global_replication_group_id == null ? module.elasticache_parameter_group.elasticache_parameter_group_name : null
  subnet_group_name    = module.elasicache_subnet_group.subnet_group_name
  security_group_ids   = concat(var.security_group_ids, [module.elasticache_security_groups.security_group_id])

  preferred_cache_cluster_azs = var.preferred_cache_cluster_azs
  replication_group_id        = var.global_replication_group_id == null ? "${var.name_prefix}-redis" : "${var.name_prefix}-redis-replica"
  num_cache_clusters          = var.cluster_mode_enabled ? null : var.num_cache_clusters
  node_type                   = var.global_replication_group_id == null ? var.node_type : null

  engine_version = var.global_replication_group_id == null ? var.engine_version : null
  port           = var.port

  maintenance_window         = var.maintenance_window
  snapshot_window            = var.snapshot_window
  snapshot_retention_limit   = var.snapshot_retention_limit
  final_snapshot_identifier  = var.final_snapshot_identifier
  automatic_failover_enabled = var.automatic_failover_enabled && var.num_cache_clusters >= 2 ? true : false
  auto_minor_version_upgrade = var.auto_minor_version_upgrade
  multi_az_enabled           = var.multi_az_enabled

  at_rest_encryption_enabled  = var.global_replication_group_id == null ? var.at_rest_encryption_enabled : null
  transit_encryption_enabled  = var.global_replication_group_id == null ? var.transit_encryption_enabled : null
  auth_token                  = var.auth_token != "" ? var.auth_token : null
  kms_key_id                  = var.kms_key_id
  global_replication_group_id = var.global_replication_group_id

  apply_immediately = var.apply_immediately

  description = var.description

  data_tiering_enabled = var.data_tiering_enabled

  notification_topic_arn = var.notification_topic_arn

  replicas_per_node_group = var.cluster_mode_enabled ? var.replicas_per_node_group : null
  num_node_groups         = var.cluster_mode_enabled ? var.num_node_groups : null

  dynamic "log_delivery_configuration" {
    for_each = var.log_delivery_configuration

    content {
      destination_type = log_delivery_configuration.value.destination_type
      destination      = log_delivery_configuration.value.destination
      log_format       = log_delivery_configuration.value.log_format
      log_type         = log_delivery_configuration.value.log_type
    }
  }

  tags = merge(
    {
      "Name" = "${var.name_prefix}-redis"
    },
    var.tags,
  )
}

module "elasticache_parameter_group" {
  source          = "modules/elasticache_parameter_group"
  name_prefix     = var.name_prefix
  description     = var.description
  family          = var.family
  tags            = var.tags
  num_node_groups = var.num_node_groups
  parameter       = var.parameter
}

module "elasicache_subnet_group" {
  source                      = "modules/elasticache_subnet_group"
  name_prefix                 = var.name_prefix
  subnet_ids                  = var.subnet_ids
  description                 = var.description
  global_replication_group_id = var.global_replication_group_id
  tags                        = var.tags
}

module "elasticache_security_groups" {
  source                  = "modules/elasticache_security_groups"
  name_prefix             = var.name_prefix
  vpc_id                  = var.vpc_id
  allowed_security_groups = var.allowed_security_groups
  ingress_cidr_blocks     = var.ingress_cidr_blocks
  ingress_self            = var.ingress_self
  port                    = var.port
  tags                    = var.tags
}