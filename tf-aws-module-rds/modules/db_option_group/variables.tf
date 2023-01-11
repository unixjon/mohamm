variable "create" {
  description = "Whether to create this resource or not?"
  type        = bool
  default     = false
}

variable "name" {
  description = "The name of the option group"
  type        = string
  default     = "demodb"
}

variable "use_name_prefix" {
  description = "Determines whether to use `name` as is or create a unique name beginning with `name` as the specified prefix"
  type        = bool
  default     = false
}

variable "option_group_description" {
  description = "The description of the option group"
  type        = string
  default     = "demodb_group"
}

variable "engine_name" {
  description = "Specifies the name of the engine that this option group should be associated with"
  type        = string
  default     = "mysql"
}

variable "major_engine_version" {
  description = "Specifies the major version of the engine that this option group should be associated with"
  type        = string
  default     = "5.7"
}

variable "options" {
  description = "A list of Options to apply"
  type        = any
  default     = []
}

variable "timeouts" {
  description = "Define maximum timeout for deletion of `aws_db_option_group` resource"
  type        = map(string)
  default = {
    delete = "15m"
  }
}

variable "tags" {
  description = "A mapping of tags to assign to the resource"
  type        = map(string)
  default     = {}
}
