variable "medtronic-tags" {
  type = object({
    environment-stage = string
    cost-center = string
    business-unit = string
    business-contact = string
    support-contact = string
    wbs-code = string
  })
  description = "tags required by medtronic"
}

variable "project-info" {
  type = object({
    environment-name =  string
    deployment-source = string
    project-id = string
  })
  description = "tags for the project"
}

variable "backendconfig" { 
    description = "DO NOT SET DIRECTLY: Backend config supplied by the pipeline" 
    default = null
}

variable "appshortname" { 
    type = string 
    description = " " 
}

variable "envstage" { 
    type = string 
    description = " lifecycle stage. e.g. dev, qa, stage" 
}

variable "rdsshortname" { 
    type = string 
    description = "Short name to include for RDS instance.  NOTE: the database name is set via db_name" 
}

variable "db_name" { 
  type = string 
  description = "Database name to create. If null, then no database is created initially" 
}

variable "use_default_encryption_key" {
  type = bool
  description = "Should we use the default encryption key for the account?"
  default = false
}

variable "engine" { 
  type = string 
  description = "db engine to use"

  validation {
      condition     = contains(["aurora", "aurora-mysql", "mariadb", "mysql", "postgres", "sqlserver-ee", "sqlserver-se", "sqlserver-ex", "sqlserver-web"], var.engine)
      error_message = "Only the following values are allowed: aurora, aurora-mysql, mariadb, mysql, postgres, sqlserver-ee, sqlserver-se, sqlserver-ex, sqlserver-web."
  }  
}

variable "engine_version" { 
  type = string 
  description = "Engine version to use. For valid values See EngineVersion in https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_CreateDBInstance.html" 
}

variable "instance_class" {
  description = "The instance type of the RDS instance"
  type        = string
}

variable "username" {
  description = "Username for the master DB user"
  type        = string
}

variable "password" {
  description = "Password for the master DB user. Note that this may show up in logs, and it will be stored in the state file"
  type        = string
}

variable "maintenance_window" {
  description = "The window to perform maintenance in. Syntax: 'ddd:hh24:mi-ddd:hh24:mi'. Eg: 'Mon:00:00-Mon:03:00'"
  type        = string
  default = "Sat:04:00-Sat:07:00"
}

variable "backup_window" {
  description = "The daily time range (in UTC) during which automated backups are created if they are enabled. Example: '09:46-10:16'. Must not overlap with maintenance_window"
  type        = string
  default = "08:30-09:30"
}

variable "family" {
  description = "The family of the DB parameter group.  "
  type        = string

  validation {
    condition = contains(["aurora-mysql5.7", "aurora-postgresql10", "aurora-postgresql11", "aurora-postgresql12", "aurora-postgresql9.6", "aurora5.6",
                          "docdb3.6", "docdb4.0",
                          "mariadb10.2", "mariadb10.3", "mariadb10.4", "mariadb10.5", "mariadb10.6",
                          "mysql5.6", "mysql5.7", "mysql8.0",
                          "neptune1",
                          "postgres10", "postgres11", "postgres12", "postgres13", "postgres9.6",
                          "sqlserver-ee-11.0", "sqlserver-ee-12.0", "sqlserver-ee-13.0", "sqlserver-ee-14.0", "sqlserver-ee-15.0",
                          "sqlserver-ex-11.0", "sqlserver-ex-12.0", "sqlserver-ex-13.0", "sqlserver-ex-14.0", "sqlserver-ex-15.0", 
                          "sqlserver-se-11.0", "sqlserver-se-12.0", "sqlserver-se-13.0", "sqlserver-se-14.0", "sqlserver-se-15.0",
                          "sqlserver-web-11.0", "sqlserver-web-12.0", "sqlserver-web-13.0", "sqlserver-web-14.0", "sqlserver-web-15.0"],
                          var.family)

    error_message = "Family needs to be in the allowed list.  See terraform code for the very lengthy list of allowed values."
  }
}

variable "allocated_storage" {
  description = "The allocated storage in gigabytes"
  type        = string
}

variable "major_engine_version" {
  description = "Specifies the major version of the engine that this option group should be associated with"
  type        = string
}

variable "rds_storage_key_policy" { 
  type = string 
  description = "Explicit policy for rds storage encryption"
  default = "" 
}

variable "rds_storage_principals" { 
  type = list(string)
  description = "list of short names of pricnipals to add. e.g. role/rds-user, user/bob" 
  default = []
}

variable "rds_storage_principals_explicit" { 
  type = list(string) 
  description = "list of full arns to add as principals.  ignored if rds_storage_key_policy is set" 
  default = []
}

variable "performinsights_key_policy" { 
  type = string 
  description = "Explicit policy for rds storage encryption"
  default = "" 
}

variable "performinsights_principals" { 
  type = list(string)
  description = "list of short names of pricnipals to add. e.g. role/rds-user, user/bob" 
  default = []
}

variable "performinsights_principals_explicit" { 
  type = list(string) 
  description = "list of full arns to add as principals.  ignored if rds_storage_key_policy is set" 
  default = []
}

variable "rds_cidr_blocks" { 
  type = list(map(string))
  description = "list of cidr blocks for this instance needs (account wide defaults will be added). eg [{'cidr_blocks' = '10.0.0.0/8', 'description' = 'All internal IPs'}]"
  default = []
}

variable "addl_ingress_rules" {
  type        = list(map(string))
  description = "list of ingress rules in the same format as rds_cidr_blocks, including the port rule"
  default = []
}

variable "addl_egress_rules" {
  type        = list(map(string))
  description = "list of egress rules in the same format as rds_cidr_blocks, including the port rule"
  default = []
}