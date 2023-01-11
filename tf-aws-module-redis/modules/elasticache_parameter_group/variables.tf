variable "num_node_groups" {
  type        = number
  default     = 0
  description = "Specify the number of node groups (shards) for this Redis replication group. Changing this number will trigger an online resizing operation before other settings modifications."
}
variable "parameter" {
  type = list(object({
    name  = string
    value = string
  }))
  default     = []
  description = "A list of Redis parameters to apply. Note that parameters may differ from one Redis family to another"
}
variable "tags" {
  default     = {}
  type        = map(string)
  description = "A mapping of tags to assign to all resources."
}
variable "family" {
  default     = "redis6.x"
  type        = string
  description = "The family of the ElastiCache parameter group."
}
variable "description" {
  default     = "Managed by Terraform"
  type        = string
  description = "The description of the all resources."
}
variable "name_prefix" {
  type        = string
  description = "The replication group identifier. This parameter is stored as a lowercase string."
}