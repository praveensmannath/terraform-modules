variable "gateway_id" {
  default = ""
}

variable "route_table_id" {}

variable "destination_cidr_block" {
  default = "0.0.0.0/0"
}

variable "nat_gateway_id" {
  default = ""
}
