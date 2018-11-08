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
  tags   = "${merge(map("Name", "${var.name}-priv-a"), map("ENV", "${var.env}"), map("CREATED_BY", "${var.created_by}") , map("SubnetType", "Private"))}"
}

module "priv_subnet_b" {
  source = "./modules/subnet"
  vpc_id = "${module.vpc.vpc_id}"
  cidr   = "${var.private_subnet_b}"
  az     = "${var.region}b"
  tags   = "${merge(map("Name", "${var.name}-priv-b"), map("ENV", "${var.env}"), map("CREATED_BY", "${var.created_by}") , map("SubnetType", "Private"))}"
}

############################# Database Subnets #########################
module "db_subnet_a" {
  source = "./modules/subnet"
  vpc_id = "${module.vpc.vpc_id}"
  cidr   = "${var.db_subnet_a}"
  az     = "${var.region}a"
  tags   = "${merge(map("Name", "${var.name}-db-a"), map("ENV", "${var.env}"), map("CREATED_BY", "${var.created_by}") , map("SubnetType", "DB-Private"))}"
}

module "db_subnet_b" {
  source = "./modules/subnet"
  vpc_id = "${module.vpc.vpc_id}"
  cidr   = "${var.db_subnet_b}"
  az     = "${var.region}b"
  tags   = "${merge(map("Name", "${var.name}-db-b"), map("ENV", "${var.env}"), map("CREATED_BY", "${var.created_by}") , map("SubnetType", "db-private"))}"
}

############################ IGW #####################################

module "igw" {
  source = "./modules/gateway"
  vpc_id = "${module.vpc.vpc_id}"
  tags   = "${merge(local.common_tags)}"
}

########################### EIP #############################
module "eip" {
  source      = "./modules/elastic-ip"
  instance_id = ""
  tags        = "${merge(local.common_tags)}"
}

########################### NAT #############################
module "nat" {
  source    = "./modules/nat-gateway"
  eip_id    = "${module.eip.eip_id}"
  subnet_id = "${module.pub_subnet_a.subnet_id}"
  tags      = "${merge(local.common_tags)}"
}

########################### Route Tables #############################
module "public_rt" {
  source = "./modules/route-table"
  vpc_id = "${module.vpc.vpc_id}"
  tags   = "${merge(map("Name", "${var.name}-public-rt"), map("ENV", "${var.env}"), map("CREATED_BY", "${var.created_by}") , map("RTType", "Public"))}"
}

module "private_rt" {
  source = "./modules/route-table"
  vpc_id = "${module.vpc.vpc_id}"
  tags   = "${merge(map("Name", "${var.name}-private-rt"), map("ENV", "${var.env}"), map("CREATED_BY", "${var.created_by}") , map("RTType", "Private"))}"
}

############################ Route Table Asssociation #############################
module "pub_a_rta" {
  source         = "./modules/route-table-association"
  subnet_id      = "${module.pub_subnet_a.subnet_id}"
  route_table_id = "${module.public_rt.rt_id}"
}

module "pub_b_rta" {
  source         = "./modules/route-table-association"
  subnet_id      = "${module.pub_subnet_b.subnet_id}"
  route_table_id = "${module.public_rt.rt_id}"
}

module "priv_a_rta" {
  source         = "./modules/route-table-association"
  subnet_id      = "${module.priv_subnet_a.subnet_id}"
  route_table_id = "${module.private_rt.rt_id}"
}

module "priv_b_rta" {
  source         = "./modules/route-table-association"
  subnet_id      = "${module.priv_subnet_b.subnet_id}"
  route_table_id = "${module.private_rt.rt_id}"
}

module "db_a_rta" {
  source         = "./modules/route-table-association"
  subnet_id      = "${module.db_subnet_a.subnet_id}"
  route_table_id = "${module.private_rt.rt_id}"
}

module "db_b_rta" {
  source         = "./modules/route-table-association"
  subnet_id      = "${module.db_subnet_b.subnet_id}"
  route_table_id = "${module.private_rt.rt_id}"
}

###########################ROUTES #########################
module "public_route" {
  source         = "./modules/routes"
  gateway_id     = "${module.igw.gateway_id}"
  route_table_id = "${module.public_rt.rt_id}"
}

module "private_route" {
  source         = "./modules/routes"
  nat_gateway_id = "${module.nat.nat_id}"
  route_table_id = "${module.private_rt.rt_id}"
}

################################# SEC Groups  ############################################

module "sg_elb" {
  source      = "./modules/security-group"
  name        = "elb_${var.name}"
  vpc_id      = "${module.vpc.vpc_id}"
  description = "SG for Load balancer"
  tags        = "${local.common_tags}"
}

module "sg_web" {
  source      = "./modules/security-group"
  name        = "web_${var.name}"
  vpc_id      = "${module.vpc.vpc_id}"
  description = "SG for Web Server"
  tags        = "${local.common_tags}"
}

module "sg_jumphost" {
  source      = "./modules/security-group"
  name        = "jumphost_${var.name}"
  vpc_id      = "${module.vpc.vpc_id}"
  description = "SF for Jump Host"
  tags        = "${local.common_tags}"
}

module "sg_db" {
  source      = "./modules/security-group"
  name        = "db_${var.name}"
  vpc_id      = "${module.vpc.vpc_id}"
  description = "SG for Aurora DB"
  tags        = "${local.common_tags}"
}

################################# SEC Group Rules Egress############################################

module "esg_rules_jump_host" {
  source            = "./modules/security-group-rules-cidr"
  type              = "egress"
  security_group_id = "${module.sg_jumphost.id}"
}

module "esg_rules_app_host" {
  source            = "./modules/security-group-rules-cidr"
  type              = "egress"
  security_group_id = "${module.sg_web.id}"
}

module "esg_rules_db_host" {
  source            = "./modules/security-group-rules-cidr"
  type              = "egress"
  security_group_id = "${module.sg_db.id}"
}

module "sg_rules_elb" {
  source            = "./modules/security-group-rules-cidr"
  type              = "egress"
  security_group_id = "${module.sg_elb.id}"
}
################################# SEC Group Rules ingress############################################

module "sg_rules_jump_host_22" {
  source            = "./modules/security-group-rules-cidr"
  type              = "ingress"
  security_group_id = "${module.sg_jumphost.id}"
  from_port = "22"
  to_port = "22"
  protocol = "tcp"
}


module "sg_rules_app_host_22" {
  source            = "./modules/security-group-rules-sg"
  type              = "ingress"
  security_group_id = "${module.sg_web.id}"
  source_security_group_id = "${module.sg_jumphost.id}"
  from_port = "22"
  to_port = "22"
  protocol = "tcp"
}

module "sg_rules_app_host_80" {
  source            = "./modules/security-group-rules-sg"
  type              = "ingress"
  security_group_id = "${module.sg_web.id}"
  source_security_group_id = "${module.sg_elb.id}"
  from_port = "80"
  to_port = "80"
  protocol = "tcp"
}

module "sg_rules_app_host_443" {
  source            = "./modules/security-group-rules-sg"
  type              = "ingress"
  security_group_id = "${module.sg_web.id}"
  source_security_group_id = "${module.sg_elb.id}"
  from_port = "443"
  to_port = "443"
  protocol = "tcp"
}

module "sg_rules_db_host_3306" {
  source            = "./modules/security-group-rules-sg"
  type              = "ingress"
  security_group_id = "${module.sg_db.id}"
  source_security_group_id = "${module.sg_web.id}"
  from_port = "3306"
  to_port = "3306"
  protocol = "tcp"
}

module "sg_rules_elb_80" {
  source            = "./modules/security-group-rules-cidr"
  type              = "ingress"
  security_group_id = "${module.sg_elb.id}"
  from_port = "80"
  to_port = "80"
  protocol = "tcp"
}

module "sg_rules_elb_443" {
  source            = "./modules/security-group-rules-cidr"
  type              = "ingress"
  security_group_id = "${module.sg_elb.id}"
  from_port = "443"
  to_port = "443"
  protocol = "tcp"
}

################################# S3 bucket ####################
module "create_s3_bucket" {
   source = "./modules/s3bucket"
   name = "${var.name}-${var.env}-${var.bucket-name}"
   tags = "${local.common_tags}"
   versioning = "false"
}

