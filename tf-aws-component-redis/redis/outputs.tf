output "elasticache_replication_group_arn" {
  value       = module.elasticache_redis.elasticache_replication_group_arn
  description = "The Amazon Resource Name (ARN) of the created ElastiCache Replication Group."
}

output "elasticache_replication_group_id" {
  value       = module.elasticache_redis.elasticache_replication_group_id
  description = "The ID of the ElastiCache Replication Group."
}

output "elasticache_replication_group_primary_endpoint_address" {
  value       = module.elasticache_redis.elasticache_replication_group_primary_endpoint_address
  description = "The address of the endpoint for the primary node in the replication group."
}

output "elasticache_replication_group_reader_endpoint_address" {
  value       = module.elasticache_redis.elasticache_replication_group_reader_endpoint_address
  description = "The address of the endpoint for the reader node in the replication group."
}

output "elasticache_replication_group_member_clusters" {
  value       = module.elasticache_redis.elasticache_replication_group_member_clusters
  description = "The identifiers of all the nodes that are part of this replication group."
}

output "elasticache_auth_token" {
  description = "The Redis Auth Token."
  value       = module.elasticache_redis.elasticache_auth_token
  sensitive   = true
}

output "elasticache_port" {
  description = "The Redis port."
  value       = module.elasticache_redis
}