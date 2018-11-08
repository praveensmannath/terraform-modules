variable "name" {}

variable "acl" {
  default = "private"
}

variable "tags" {
  type = "map"
}

variable "versioning" {
  default = "true"
}
