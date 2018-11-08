variable "domain_name" {
  default = "ec2.internal"
}

variable "cidr" {
  default = "10.10.0.0/16"
}

variable "tags" {
  type = "map"
}
