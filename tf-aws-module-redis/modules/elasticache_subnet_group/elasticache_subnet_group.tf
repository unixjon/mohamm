resource "aws_elasticache_subnet_group" "redis" {
  name        = var.global_replication_group_id == null ? "${var.name_prefix}-redis-sg" : "${var.name_prefix}-redis-sg-replica"
  subnet_ids  = var.subnet_ids
  description = var.description

  tags = var.tags
}