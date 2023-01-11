<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 3.38 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 3.38 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_network_info"></a> [network\_info](#module\_network\_info) | git::https://dev.azure.com/BPS-IT/SADI/_git/tf-aws-module-lz-network?ref=1.0.0 |  |
| <a name="module_rds_database"></a> [rds\_database](#module\_rds\_database) | git::https://dev.azure.com/BPS-IT/SADI/_git/tf-aws-module-rds?ref=FEATURE/update-to-3 |  |
| <a name="module_this_performance_insights_key"></a> [this\_performance\_insights\_key](#module\_this\_performance\_insights\_key) | git::https://dev.azure.com/BPS-IT/SADI/_git/tf-aws-module-kms?ref=develop |  |
| <a name="module_this_rds_security_group"></a> [this\_rds\_security\_group](#module\_this\_rds\_security\_group) | git::https://dev.azure.com/BPS-IT/SADI/_git/tf-aws-module-security-group?ref=1.1.0 |  |
| <a name="module_this_rds_storage_key"></a> [this\_rds\_storage\_key](#module\_this\_rds\_storage\_key) | git::https://dev.azure.com/BPS-IT/SADI/_git/tf-aws-module-kms?ref=develop |  |

## Resources

| Name | Type |
|------|------|
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_vpc_endpoint.private_s3](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/vpc_endpoint) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allocated_storage"></a> [allocated\_storage](#input\_allocated\_storage) | The allocated storage in gigabytes | `string` | n/a | yes |
| <a name="input_appshortname"></a> [appshortname](#input\_appshortname) |  | `string` | n/a | yes |
| <a name="input_db_name"></a> [db\_name](#input\_db\_name) | Database name to create. If null, then no database is created initially | `string` | n/a | yes |
| <a name="input_engine"></a> [engine](#input\_engine) | db engine to use | `string` | n/a | yes |
| <a name="input_engine_version"></a> [engine\_version](#input\_engine\_version) | Engine version to use. For valid values See EngineVersion in https://docs.aws.amazon.com/AmazonRDS/latest/APIReference/API_CreateDBInstance.html | `string` | n/a | yes |
| <a name="input_envstage"></a> [envstage](#input\_envstage) | lifecycle stage. e.g. dev, qa, stage | `string` | n/a | yes |
| <a name="input_family"></a> [family](#input\_family) | The family of the DB parameter group. | `string` | n/a | yes |
| <a name="input_instance_class"></a> [instance\_class](#input\_instance\_class) | The instance type of the RDS instance | `string` | n/a | yes |
| <a name="input_major_engine_version"></a> [major\_engine\_version](#input\_major\_engine\_version) | Specifies the major version of the engine that this option group should be associated with | `string` | n/a | yes |
| <a name="input_medtronic-tags"></a> [medtronic-tags](#input\_medtronic-tags) | tags required by medtronic | <pre>object({<br>    environment-stage = string<br>    cost-center = string<br>    business-unit = string<br>    business-contact = string<br>    support-contact = string<br>    wbs-code = string<br>  })</pre> | n/a | yes |
| <a name="input_password"></a> [password](#input\_password) | Password for the master DB user. Note that this may show up in logs, and it will be stored in the state file | `string` | n/a | yes |
| <a name="input_project-info"></a> [project-info](#input\_project-info) | tags for the project | <pre>object({<br>    environment-name =  string<br>    deployment-source = string<br>    project-id = string<br>  })</pre> | n/a | yes |
| <a name="input_rdsshortname"></a> [rdsshortname](#input\_rdsshortname) | Short name to include for RDS instance.  NOTE: the database name is set via db\_name | `string` | n/a | yes |
| <a name="input_username"></a> [username](#input\_username) | Username for the master DB user | `string` | n/a | yes |
| <a name="input_addl_egress_rules"></a> [addl\_egress\_rules](#input\_addl\_egress\_rules) | list of egress rules in the same format as rds\_cidr\_blocks, including the port rule | `list(map(string))` | `[]` | no |
| <a name="input_addl_ingress_rules"></a> [addl\_ingress\_rules](#input\_addl\_ingress\_rules) | list of ingress rules in the same format as rds\_cidr\_blocks, including the port rule | `list(map(string))` | `[]` | no |
| <a name="input_allow_major_version_upgrade"></a> [allow\_major\_version\_upgrade](#input\_allow\_major\_version\_upgrade) | Indicates that major version upgrades are allowed. Changing this parameter does not result in an outage and the change is asynchronously applied as soon as possible | `bool` | `false` | no |
| <a name="input_apply_immediately"></a> [apply\_immediately](#input\_apply\_immediately) | Specifies whether any database modifications are applied immediately, or during the next maintenance window | `bool` | `false` | no |
| <a name="input_auto_minor_version_upgrade"></a> [auto\_minor\_version\_upgrade](#input\_auto\_minor\_version\_upgrade) | Indicates that minor engine upgrades will be applied automatically to the DB instance during the maintenance window | `bool` | `true` | no |
| <a name="input_availability_zone"></a> [availability\_zone](#input\_availability\_zone) | The Availability Zone of the RDS instance. Don't set unless you know what you're doing | `string` | `null` | no |
| <a name="input_backendconfig"></a> [backendconfig](#input\_backendconfig) | DO NOT SET DIRECTLY: Backend config supplied by the pipeline | `any` | `null` | no |
| <a name="input_backup_retention_period"></a> [backup\_retention\_period](#input\_backup\_retention\_period) | The days to retain backups for | `number` | `null` | no |
| <a name="input_backup_window"></a> [backup\_window](#input\_backup\_window) | The daily time range (in UTC) during which automated backups are created if they are enabled. Example: '09:46-10:16'. Must not overlap with maintenance\_window | `string` | `"08:30-09:30"` | no |
| <a name="input_ca_cert_identifier"></a> [ca\_cert\_identifier](#input\_ca\_cert\_identifier) | Specifies the identifier of the CA certificate for the DB instance | `string` | `null` | no |
| <a name="input_character_set_name"></a> [character\_set\_name](#input\_character\_set\_name) | (Optional) The character set name to use for DB encoding in Oracle instances. This can't be changed. See Oracle Character Sets Supported in Amazon RDS and Collations and Character Sets for Microsoft SQL Server for more information. This can only be set on creation. | `string` | `null` | no |
| <a name="input_copy_tags_to_snapshot"></a> [copy\_tags\_to\_snapshot](#input\_copy\_tags\_to\_snapshot) | On delete, copy all Instance tags to the final snapshot (if final\_snapshot\_identifier is specified) | `bool` | `false` | no |
| <a name="input_create_db_option_group"></a> [create\_db\_option\_group](#input\_create\_db\_option\_group) | (Optional) Create a database option group | `bool` | `true` | no |
| <a name="input_create_db_parameter_group"></a> [create\_db\_parameter\_group](#input\_create\_db\_parameter\_group) | Whether to create a database parameter group | `bool` | `true` | no |
| <a name="input_create_db_subnet_group"></a> [create\_db\_subnet\_group](#input\_create\_db\_subnet\_group) | Whether to create a database subnet group | `bool` | `true` | no |
| <a name="input_create_random_password"></a> [create\_random\_password](#input\_create\_random\_password) | Whether to create random password for RDS primary cluster | `bool` | `false` | no |
| <a name="input_db_instance_tags"></a> [db\_instance\_tags](#input\_db\_instance\_tags) | Additional tags for the DB instance | `map(string)` | `{}` | no |
| <a name="input_db_option_group_tags"></a> [db\_option\_group\_tags](#input\_db\_option\_group\_tags) | Additional tags for the DB option group | `map(string)` | `{}` | no |
| <a name="input_db_parameter_group_tags"></a> [db\_parameter\_group\_tags](#input\_db\_parameter\_group\_tags) | Additional tags for the  DB parameter group | `map(string)` | `{}` | no |
| <a name="input_db_subnet_group_description"></a> [db\_subnet\_group\_description](#input\_db\_subnet\_group\_description) | Description of the DB subnet group to create | `string` | `""` | no |
| <a name="input_db_subnet_group_name"></a> [db\_subnet\_group\_name](#input\_db\_subnet\_group\_name) | Name of DB subnet group. DB instance will be created in the VPC associated with the DB subnet group. If unspecified, will be created in the default VPC | `string` | `null` | no |
| <a name="input_db_subnet_group_tags"></a> [db\_subnet\_group\_tags](#input\_db\_subnet\_group\_tags) | Additional tags for the DB subnet group | `map(string)` | `{}` | no |
| <a name="input_delete_automated_backups"></a> [delete\_automated\_backups](#input\_delete\_automated\_backups) | Specifies whether to remove automated backups immediately after the DB instance is deleted | `bool` | `true` | no |
| <a name="input_deletion_protection"></a> [deletion\_protection](#input\_deletion\_protection) | The database can't be deleted when this value is set to true. | `bool` | `false` | no |
| <a name="input_enabled_cloudwatch_logs_exports"></a> [enabled\_cloudwatch\_logs\_exports](#input\_enabled\_cloudwatch\_logs\_exports) | List of log types to enable for exporting to CloudWatch logs. If omitted, no logs will be exported. Valid values (depending on engine): alert, audit, error, general, listener, slowquery, trace, postgresql (PostgreSQL), upgrade (PostgreSQL). | `list(string)` | `[]` | no |
| <a name="input_final_snapshot_identifier"></a> [final\_snapshot\_identifier](#input\_final\_snapshot\_identifier) | The name of your final DB snapshot when this DB instance is deleted. | `string` | `null` | no |
| <a name="input_final_snapshot_identifier_prefix"></a> [final\_snapshot\_identifier\_prefix](#input\_final\_snapshot\_identifier\_prefix) | The name which is prefixed to the final snapshot on cluster destroy | `string` | `"final"` | no |
| <a name="input_iops"></a> [iops](#input\_iops) | The amount of provisioned IOPS. Setting this implies a storage\_type of 'io1' | `number` | `0` | no |
| <a name="input_license_model"></a> [license\_model](#input\_license\_model) | License model information for this DB instance. Optional, but required for some DB engines, i.e. Oracle SE1 | `string` | `null` | no |
| <a name="input_maintenance_window"></a> [maintenance\_window](#input\_maintenance\_window) | The window to perform maintenance in. Syntax: 'ddd:hh24:mi-ddd:hh24:mi'. Eg: 'Mon:00:00-Mon:03:00' | `string` | `"Sat:04:00-Sat:07:00"` | no |
| <a name="input_max_allocated_storage"></a> [max\_allocated\_storage](#input\_max\_allocated\_storage) | Specifies the value for Storage Autoscaling | `number` | `0` | no |
| <a name="input_multi_az"></a> [multi\_az](#input\_multi\_az) | Specifies if the RDS instance is multi-AZ | `bool` | `false` | no |
| <a name="input_option_group_description"></a> [option\_group\_description](#input\_option\_group\_description) | The description of the option group | `string` | `""` | no |
| <a name="input_option_group_name"></a> [option\_group\_name](#input\_option\_group\_name) | Name of the option group | `string` | `null` | no |
| <a name="input_options"></a> [options](#input\_options) | A list of Options to apply. | `any` | `[]` | no |
| <a name="input_parameter_group_description"></a> [parameter\_group\_description](#input\_parameter\_group\_description) | Description of the DB parameter group to create | `string` | `""` | no |
| <a name="input_parameter_group_name"></a> [parameter\_group\_name](#input\_parameter\_group\_name) | Name of the DB parameter group to associate or create | `string` | `""` | no |
| <a name="input_parameters"></a> [parameters](#input\_parameters) | A list of DB parameters (map) to apply | `list(map(string))` | `[]` | no |
| <a name="input_performance_insights_enabled"></a> [performance\_insights\_enabled](#input\_performance\_insights\_enabled) | Specifies whether Performance Insights are enabled | `bool` | `false` | no |
| <a name="input_performance_insights_retention_period"></a> [performance\_insights\_retention\_period](#input\_performance\_insights\_retention\_period) | The amount of time in days to retain Performance Insights data. Either 7 (7 days) or 731 (2 years). | `number` | `7` | no |
| <a name="input_performinsights_key_policy"></a> [performinsights\_key\_policy](#input\_performinsights\_key\_policy) | Explicit policy for rds storage encryption | `string` | `""` | no |
| <a name="input_performinsights_principals"></a> [performinsights\_principals](#input\_performinsights\_principals) | list of short names of pricnipals to add. e.g. role/rds-user, user/bob | `list(string)` | `[]` | no |
| <a name="input_performinsights_principals_explicit"></a> [performinsights\_principals\_explicit](#input\_performinsights\_principals\_explicit) | list of full arns to add as principals.  ignored if rds\_storage\_key\_policy is set | `list(string)` | `[]` | no |
| <a name="input_random_password_length"></a> [random\_password\_length](#input\_random\_password\_length) | (Optional) Length of random password to create. (default: 10) | `number` | `10` | no |
| <a name="input_rds_cidr_blocks"></a> [rds\_cidr\_blocks](#input\_rds\_cidr\_blocks) | list of cidr blocks for this instance needs (account wide defaults will be added). eg [{'cidr\_blocks' = '10.0.0.0/8', 'description' = 'All internal IPs'}] | `list(map(string))` | `[]` | no |
| <a name="input_rds_storage_key_policy"></a> [rds\_storage\_key\_policy](#input\_rds\_storage\_key\_policy) | Explicit policy for rds storage encryption | `string` | `""` | no |
| <a name="input_rds_storage_principals"></a> [rds\_storage\_principals](#input\_rds\_storage\_principals) | list of short names of pricnipals to add. e.g. role/rds-user, user/bob | `list(string)` | `[]` | no |
| <a name="input_rds_storage_principals_explicit"></a> [rds\_storage\_principals\_explicit](#input\_rds\_storage\_principals\_explicit) | list of full arns to add as principals.  ignored if rds\_storage\_key\_policy is set | `list(string)` | `[]` | no |
| <a name="input_replicate_source_db"></a> [replicate\_source\_db](#input\_replicate\_source\_db) | Specifies that this resource is a Replicate database, and to use this value as the source database. This correlates to the identifier of another Amazon RDS Database to replicate. | `string` | `null` | no |
| <a name="input_skip_final_snapshot"></a> [skip\_final\_snapshot](#input\_skip\_final\_snapshot) | Determines whether a final DB snapshot is created before the DB instance is deleted. If true is specified, no DBSnapshot is created. If false is specified, a DB snapshot is created before the DB instance is deleted, using the value from final\_snapshot\_identifier | `bool` | `false` | no |
| <a name="input_snapshot_identifier"></a> [snapshot\_identifier](#input\_snapshot\_identifier) | Specifies whether or not to create this database from a snapshot. This correlates to the snapshot ID you'd find in the RDS console, e.g: rds:production-2015-06-26-06-05. | `string` | `null` | no |
| <a name="input_storage_type"></a> [storage\_type](#input\_storage\_type) | One of 'standard' (magnetic), 'gp2' (general purpose SSD), or 'io1' (provisioned IOPS SSD). The default is 'io1' if iops is specified, 'gp2' if not. | `string` | `null` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | A list of VPC subnet IDs | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to all resources | `map(string)` | `{}` | no |
| <a name="input_timezone"></a> [timezone](#input\_timezone) | (Optional) Time zone of the DB instance. timezone is currently only supported by Microsoft SQL Server. The timezone can only be set on creation. See MSSQL User Guide for more information. | `string` | `null` | no |
| <a name="input_use_default_encryption_key"></a> [use\_default\_encryption\_key](#input\_use\_default\_encryption\_key) | Should we use the default encryption key for the account? | `bool` | `false` | no |
| <a name="input_vpc_security_group_ids"></a> [vpc\_security\_group\_ids](#input\_vpc\_security\_group\_ids) | List of VPC security groups to associate | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_db_instance_address"></a> [db\_instance\_address](#output\_db\_instance\_address) | The address of the RDS instance |
| <a name="output_db_instance_arn"></a> [db\_instance\_arn](#output\_db\_instance\_arn) | The ARN of the RDS instance |
| <a name="output_db_instance_availability_zone"></a> [db\_instance\_availability\_zone](#output\_db\_instance\_availability\_zone) | The availability zone of the RDS instance |
| <a name="output_db_instance_ca_cert_identifier"></a> [db\_instance\_ca\_cert\_identifier](#output\_db\_instance\_ca\_cert\_identifier) | Specifies the identifier of the CA certificate for the DB instance |
| <a name="output_db_instance_endpoint"></a> [db\_instance\_endpoint](#output\_db\_instance\_endpoint) | The connection endpoint |
| <a name="output_db_instance_hosted_zone_id"></a> [db\_instance\_hosted\_zone\_id](#output\_db\_instance\_hosted\_zone\_id) | The canonical hosted zone ID of the DB instance (to be used in a Route 53 Alias record) |
| <a name="output_db_instance_id"></a> [db\_instance\_id](#output\_db\_instance\_id) | The RDS instance ID |
| <a name="output_db_instance_name"></a> [db\_instance\_name](#output\_db\_instance\_name) | The database name |
| <a name="output_db_instance_port"></a> [db\_instance\_port](#output\_db\_instance\_port) | The database port |
| <a name="output_db_instance_resource_id"></a> [db\_instance\_resource\_id](#output\_db\_instance\_resource\_id) | The RDS Resource ID of this instance |
| <a name="output_db_instance_status"></a> [db\_instance\_status](#output\_db\_instance\_status) | The RDS instance status |
| <a name="output_db_instance_username"></a> [db\_instance\_username](#output\_db\_instance\_username) | The master username for the database |
| <a name="output_db_master_password"></a> [db\_master\_password](#output\_db\_master\_password) | The master password |
| <a name="output_db_option_group_arn"></a> [db\_option\_group\_arn](#output\_db\_option\_group\_arn) | The ARN of the db option group |
| <a name="output_db_option_group_id"></a> [db\_option\_group\_id](#output\_db\_option\_group\_id) | The db option group id |
| <a name="output_db_parameter_group_arn"></a> [db\_parameter\_group\_arn](#output\_db\_parameter\_group\_arn) | The ARN of the db parameter group |
| <a name="output_db_parameter_group_id"></a> [db\_parameter\_group\_id](#output\_db\_parameter\_group\_id) | The db parameter group id |
| <a name="output_db_subnet_group_arn"></a> [db\_subnet\_group\_arn](#output\_db\_subnet\_group\_arn) | The ARN of the db subnet group |
| <a name="output_db_subnet_group_id"></a> [db\_subnet\_group\_id](#output\_db\_subnet\_group\_id) | The db subnet group name |
<!-- END_TF_DOCS -->