output "elasticache_parameter_group_id" {
  value       = aws_elasticache_parameter_group.redis.id
  description = "The ElastiCache parameter group name."
}