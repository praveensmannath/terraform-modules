variable "c_name" {}

variable "database_name" {}

variable "master_username" {
  default = "root"
}

variable "master_password" {
  default = "23wesdxc23WESDXC"
}

variable "backup_retention_period" {
  default = "14"
}

variable "db_subnet_group_name" {}

variable "tags" {
  type = "map"
}

variable "vpc_security_group_ids" {}

variable "instance_class" {
  default = "db.t2.small"
}

variable "publicly_accessible" {
  default = false
}

variable "vpc_rds_subnet_ids" {}
