variable "name" {}

variable "subnet_a" {}

variable "subnet_b" {}

variable "tags" {
  type = "map"
}

variable "description" {
  default = "DB instance"
}
