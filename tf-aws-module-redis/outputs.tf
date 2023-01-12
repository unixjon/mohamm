output "elasticache_replication_group_arn" {
  value       = aws_elasticache_replication_group.redis.arn
  description = "The Amazon Resource Name (ARN) of the created ElastiCache Replication Group."
}

output "elasticache_replication_group_id" {
  value       = aws_elasticache_replication_group.redis.id
  description = "The ID of the ElastiCache Replication Group."
}

output "elasticache_replication_group_primary_endpoint_address" {
  value       = var.num_node_groups > 0 ? aws_elasticache_replication_group.redis.configuration_endpoint_address : aws_elasticache_replication_group.redis.primary_endpoint_address
  description = "The address of the endpoint for the primary node in the replication group."
}

output "elasticache_replication_group_reader_endpoint_address" {
  value       = var.num_node_groups > 0 ? aws_elasticache_replication_group.redis.configuration_endpoint_address : aws_elasticache_replication_group.redis.reader_endpoint_address
  description = "The address of the endpoint for the reader node in the replication group."
}

output "elasticache_replication_group_member_clusters" {
  value       = aws_elasticache_replication_group.redis.member_clusters
  description = "The identifiers of all the nodes that are part of this replication group."
}

output "elasticache_auth_token" {
  description = "The Redis Auth Token."
  value       = aws_elasticache_replication_group.redis.auth_token
  sensitive   = true
}

output "elasticache_port" {
  description = "The Redis port."
  value       = aws_elasticache_replication_group.redis.port
}

output "subnet_group_name" {
  value       = module.elasicache_subnet_group.subnet_group_name
  description = "The subnet group name of the Redis ElastiCache."
}

output "security_group_id" {
  value       = module.elasticache_security_groups.security_group_id
  description = "The ID of the Redis ElastiCache security group."
}

output "security_group_arn" {
  value       = module.elasticache_security_groups.security_group_arn
  description = "The ARN of the Redis ElastiCache security group."
}

output "security_group_vpc_id" {
  value       = module.elasticache_security_groups.security_group_vpc_id
  description = "The VPC ID of the Redis ElastiCache security group."
}

output "security_group_owner_id" {
  value       = module.elasticache_security_groups.security_group_owner_id
  description = "The owner ID of the Redis ElastiCache security group."
}

output "security_group_name" {
  value       = module.elasticache_security_groups.security_group_name
  description = "The name of the Redis ElastiCache security group."
}

output "security_group_description" {
  value       = module.elasticache_security_groups.security_group_description
  description = "The description of the Redis ElastiCache security group."
}

output "security_group_ingress" {
  value       = module.elasticache_security_groups.security_group_ingress
  description = "The ingress rules of the Redis ElastiCache security group."
}

output "security_group_egress" {
  value       = module.elasticache_security_groups.security_group_egress
  description = "The egress rules of the Redis ElastiCache security group."
}

output "elasticache_parameter_group_id" {
  value       = module.elasticache_parameter_group.elasticache_parameter_group_id
  description = "The ElastiCache parameter group id."
}
output "elasticache_parameter_group_name" {
  value       = module.elasticache_parameter_group.elasticache_parameter_group_name
  description = "The ElastiCache parameter group name."
}