provider "aws" {
  region     = "${var.region}"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
}

locals {
  common_tags = {
    Name       = "${var.name}"
    ENV        = "${var.env}"
    CREATED_BY = "${var.created_by}"
  }
}

module "vpc" {
  source = "./modules/vpc"
  tags   = "${local.common_tags}"
}

############################# Public Subnets #########################
module "pub_subnet_a" {
  source = "./modules/subnet"
  vpc_id = "${module.vpc.vpc_id}"
  cidr   = "${var.public_subnet_a}"
  az     = "${var.region}a"
  tags   = "${merge(map("Name", "${var.name}-pub-a"), map("ENV", "${var.env}"), map("CREATED_BY", "${var.created_by}") , map("SubnetType", "Public"))}"
}

module "pub_subnet_b" {
  source = "./modules/subnet"
  vpc_id = "${module.vpc.vpc_id}"
  cidr   = "${var.public_subnet_b}"
  az     = "${var.region}b"
  tags   = "${merge(map("Name", "${var.name}-pub-b"), map("ENV", "${var.env}"), map("CREATED_BY", "${var.created_by}") , map("SubnetType", "Public"))}"
}

############################# Private Subnets #########################
module "priv_subnet_a" {
  source = "./modules/subnet"
  vpc_id = "${module.vpc.vpc_id}"
  cidr   = "${var.private_subnet_a}"
  az     = "${var.region}a"
  tags   = "${merge(map("Name", "${var.name}-priv-a"), map("ENV", "${var.env}"), map("CREATED_BY", "${var.created_by}") , map("SubnetType", "Public"))}"
}

module "priv_subnet_b" {
  source = "./modules/subnet"
  vpc_id = "${module.vpc.vpc_id}"
  cidr   = "${var.private_subnet_b}"
  az     = "${var.region}b"
  tags   = "${merge(map("Name", "${var.name}-priv-b"), map("ENV", "${var.env}"), map("CREATED_BY", "${var.created_by}") , map("SubnetType", "Public"))}"
}

############################# Database Subnets #########################
module "db_subnet_a" {
  source = "./modules/subnet"
  vpc_id = "${module.vpc.vpc_id}"
  cidr   = "${var.db_subnet_a}"
  az     = "${var.region}a"
  tags   = "${merge(map("Name", "${var.name}-db-a"), map("ENV", "${var.env}"), map("CREATED_BY", "${var.created_by}") , map("SubnetType", "Public"))}"
}

module "db_subnet_b" {
  source = "./modules/subnet"
  vpc_id = "${module.vpc.vpc_id}"
  cidr   = "${var.db_subnet_b}"
  az     = "${var.region}b"
  tags   = "${merge(map("Name", "${var.name}-db-b"), map("ENV", "${var.env}"), map("CREATED_BY", "${var.created_by}") , map("SubnetType", "Public"))}"
}

############################ IGW #####################################

module "igw" {
  source = "./modules/gateway"
  vpc_id = "${module.vpc.vpc_id}"
  tags   = "${merge(local.common_tags)}"
}
