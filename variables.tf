variable "region" {
  default = "us-east-1"
}

variable "s3bucket" {
  default = ""
}

variable "access_key" {
  default = ""
}

variable "secret_key" {
  default = ""
}

variable "name" {
  default = "test"
}

variable "env" {
  default = ""
}

variable "created_by" {
  default = ""
}


###############################################SUBNETS########################
variable "cidr" {
  default = "10.11.0.0/16"
}


###################Public###################
variable "public_subnets" {
  default = ["10.11.2.0/24","10.11.1.0/24"]
}

###################Private###################
variable "private_subnets" {
  default = ["10.11.3.0/24","10.11.4.0/24"]
}

###################DB###################
variable "db_subnets" {
  default = ["10.11.5.0/24","10.11.6.0/24"]
}

variable "sgs" {
  default = {"elb"="SG for ELB"
  "web"= "SG for web"
  "jumphost"= "SG for Jumphost"
  "db"="SG for DB"}
}
