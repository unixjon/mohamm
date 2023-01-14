output "subnet_group_name" {
  value       = aws_elasticache_subnet_group.redis.name
  description = "The subnet group name of the Redis ElastiCache."
}