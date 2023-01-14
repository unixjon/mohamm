variable "description" {
  default     = "Managed by Terraform"
  type        = string
  description = "The description of the all resources."
}
variable "name_prefix" {
  type        = string
  description = "The replication group identifier. This parameter is stored as a lowercase string."
}
variable "tags" {
  default     = {}
  type        = map(string)
  description = "A mapping of tags to assign to all resources."
}
variable "subnet_ids" {
  type        = list(string)
  description = "List of VPC Subnet IDs for the cache subnet group."
}
variable "global_replication_group_id" {
  description = "The ID of the global replication group to which this replication group should belong."
  type        = string
  default     = null
}