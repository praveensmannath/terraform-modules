variable "name_prefix" {}
variable "image_id" {}

variable "instance_type" {}

variable "key_name" {}

variable "security_groups" {}

variable "associate_public_ip_address" {
  default = false
}

variable "user_data" {
  default = "echo hello"
}

variable "volume_type" {
  default = "gp2"
}

variable "iam_instance_profile" {
  default = ""
}

variable "volume_size" {
  default = "40"
}

variable "delete_on_termination" {
  default = false
}

variable "create_before_destroy" {
  default = true
}

variable "enable_monitoring" {
  default = false
}

variable "role_name" {
  default = ""
}
