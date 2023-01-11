output "security_group_id" {
  value       = aws_security_group.redis.id
  description = "The ID of the Redis ElastiCache security group."
}

output "security_group_arn" {
  value       = aws_security_group.redis.arn
  description = "The ARN of the Redis ElastiCache security group."
}

output "security_group_vpc_id" {
  value       = aws_security_group.redis.vpc_id
  description = "The VPC ID of the Redis ElastiCache security group."
}

output "security_group_owner_id" {
  value       = aws_security_group.redis.owner_id
  description = "The owner ID of the Redis ElastiCache security group."
}

output "security_group_name" {
  value       = aws_security_group.redis.name
  description = "The name of the Redis ElastiCache security group."
}

output "security_group_description" {
  value       = aws_security_group.redis.description
  description = "The description of the Redis ElastiCache security group."
}

output "security_group_ingress" {
  value       = aws_security_group.redis.ingress
  description = "The ingress rules of the Redis ElastiCache security group."
}

output "security_group_egress" {
  value       = aws_security_group.redis.egress
  description = "The egress rules of the Redis ElastiCache security group."
}