variable "name_prefix" {
  type        = string
  description = "The replication group identifier. This parameter is stored as a lowercase string."
}
variable "tags" {
  default     = {}
  type        = map(string)
  description = "A mapping of tags to assign to all resources."
}
variable "port" {
  default     = 6379
  type        = number
  description = "The port number on which each of the cache nodes will accept connections."
}
variable "vpc_id" {
  type        = string
  description = "VPC Id to associate with Redis ElastiCache."
}
variable "ingress_cidr_blocks" {
  type        = list(string)
  description = "List of Ingress CIDR blocks."
  default     = []
}
variable "ingress_self" {
  type        = bool
  description = "Specify whether the security group itself will be added as a source to the ingress rule."
  default     = false
}
variable "allowed_security_groups" {
  type        = list(string)
  description = "List of existing security groups that will be allowed ingress via the elaticache security group rules"
  default     = []
}