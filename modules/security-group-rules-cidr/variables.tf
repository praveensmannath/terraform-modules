variable "type" {
  default = "ingress"
}

variable "security_group_id" {}

variable "from_port" {
  default = "0"
}

variable "to_port" {
  default = "0"
}

variable "protocol" {
  default = "-1"
}

variable "cidr_blocks" {
  type    = "list"
  default = ["0.0.0.0/0"]
}
