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
  cidr   = "${var.cidr}"
  tags   = "${local.common_tags}"
}

data "aws_availability_zones" "available" {}

############################# Public Subnets #########################
module "pub_subnet" {
  source     = "./modules/subnet"
  vpc_id     = "${module.vpc.vpc_id}"
  subnets    = "${var.public_subnets}"
  azs        = "${data.aws_availability_zones.available.names}"
  name       = "${var.name}"
  SubnetType = "public"
  tags       = "${merge(map("ENV", "${var.env}"), map("CREATED_BY", "${var.created_by}") , map("SubnetType", "public"))}"
}

############################# Private Subnets #########################
module "priv_subnet" {
  source     = "./modules/subnet"
  vpc_id     = "${module.vpc.vpc_id}"
  subnets    = "${var.private_subnets}"
  azs        = "${data.aws_availability_zones.available.names}"
  name       = "${var.name}"
  SubnetType = "private"
  tags       = "${merge(map("ENV", "${var.env}"), map("CREATED_BY", "${var.created_by}") , map("SubnetType", "private"))}"
}

############################# Database Subnets #########################
module "db_subnet" {
  source     = "./modules/subnet"
  vpc_id     = "${module.vpc.vpc_id}"
  subnets    = "${var.db_subnets}"
  azs        = "${data.aws_availability_zones.available.names}"
  name       = "${var.name}"
  SubnetType = "database"
  tags       = "${merge(map("ENV", "${var.env}"), map("CREATED_BY", "${var.created_by}") , map("SubnetType", "database"))}"
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
  subnet_id = "${module.pub_subnet.subnet_id[0]}"
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
module "pub_rta" {
  source         = "./modules/route-table-association"
  subnets        = "${module.pub_subnet.subnet_id}"
  route_table_id = "${module.public_rt.rt_id}"
}

module "priv_rta" {
  source         = "./modules/route-table-association"
  subnets        = "${module.priv_subnet.subnet_id}"
  route_table_id = "${module.private_rt.rt_id}"
}

module "db_rta" {
  source         = "./modules/route-table-association"
  subnets        = "${module.db_subnet.subnet_id}"
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

# ################################# SEC Groups  ############################################
module "sg" {
  source = "./modules/security-group"
  vpc_id = "${module.vpc.vpc_id}"
  tags   = "${local.common_tags}"
  sgs    = "${var.sgs}"
}

# ################################# SEC Group Rules Egress############################################

module "egress_rules" {
  source            = "./modules/security-group-rules-cidr"
  type              = "egress"
  security_group_id = "${module.sg.id}"
}

################################# SEC Group Rules ingress############################################

module "sg_rules_jump_host_22" {
  source            = "./modules/security-group-rules-cidr"
  type              = "ingress"
  security_group_id = "${module.sg_jumphost.id}"
  from_port         = "22"
  to_port           = "22"
  protocol          = "tcp"
}


module "sg_rules_app_host_22" {
  source                   = "./modules/security-group-rules-sg"
  type                     = "ingress"
  security_group_id        = "${module.sg_web.id}"
  source_security_group_id = "${module.sg_jumphost.id}"
  from_port                = "22"
  to_port                  = "22"
  protocol                 = "tcp"
}


module "sg_rules_app_host_80" {
  source                   = "./modules/security-group-rules-sg"
  type                     = "ingress"
  security_group_id        = "${module.sg_web.id}"
  source_security_group_id = "${module.sg_elb.id}"
  from_port                = "80"
  to_port                  = "80"
  protocol                 = "tcp"
}


module "sg_rules_app_host_443" {
  source                   = "./modules/security-group-rules-sg"
  type                     = "ingress"
  security_group_id        = "${module.sg_web.id}"
  source_security_group_id = "${module.sg_elb.id}"
  from_port                = "443"
  to_port                  = "443"
  protocol                 = "tcp"
}


module "sg_rules_db_host_3306" {
  source                   = "./modules/security-group-rules-sg"
  type                     = "ingress"
  security_group_id        = "${module.sg_db.id}"
  source_security_group_id = "${module.sg_web.id}"
  from_port                = "3306"
  to_port                  = "3306"
  protocol                 = "tcp"
}


module "sg_rules_elb_80" {
  source            = "./modules/security-group-rules-cidr"
  type              = "ingress"
  security_group_id = "${module.sg_elb.id}"
  from_port         = "80"
  to_port           = "80"
  protocol          = "tcp"
}


module "sg_rules_elb_443" {
  source            = "./modules/security-group-rules-cidr"
  type              = "ingress"
  security_group_id = "${module.sg_elb.id}"
  from_port         = "443"
  to_port           = "443"
  protocol          = "tcp"
}


################################# S3 bucket ####################
module "create_s3_bucket" {
  source     = "./modules/s3bucket"
  name       = "${var.name}-${var.env}-${var.bucket-name}"
  tags       = "${local.common_tags}"
  versioning = "false"
}


###################################IAM ###########################
module "iam_role" {
  source      = "./modules/iam-role"
  name        = "${var.name}-${var.env}-role"
  description = "IAM role for accessing s3 buckets from ec2"
  role_policy = "${file("${path.module}/data/iam-roles/ec2-iam-role")}"
}


data "template_file" "iam_role_s3" {
  template = "${file("data/iam-policy/s3-bucket-access")}"


  vars {
    s3ARN = "${module.create_s3_bucket.arn}"
  }
}


module "iam_role_s3_policy" {
  source = "./modules/iam-role-policy"
  name   = "${var.name}-${var.env}-s3_policy"
  role   = "${var.name}-${var.env}-role"
  policy = "${data.template_file.iam_role_s3.rendered}"
}


################################ ECR ##############################


module "ecr" {
  source = "./modules/ecr"
  name   = "${var.name}-${var.env}-${var.ecrname}"
}


data "template_file" "iam_role_erc" {
  template = "${file("data/iam-policy/ecr")}"


  vars {
    ecrARN = "${module.ecr.arn}"
  }
}


module "iam_role_ecr_policy" {
  source = "./modules/iam-role-policy"
  name   = "${var.name}-${var.env}-ecr-policy"
  role   = "${var.name}-${var.env}-role"
  policy = "${data.template_file.iam_role_erc.rendered}"
}


################################### Launch Configuraions #########################


module "aws_ec2_key" {
  source = "./modules/ec2-key"
  name = "${var.name}-${var.env}"
  public_key = "${file("${path.module}/data/pub_keys/id_rsa.pub")}"
}


module "jump_host_lamunch_configuraions" {
  source = "./modules/launch-configuration"
  name_prefix = "${var.name}-${var.env}"
  image_id = "${var.image_id}"
  instance_type = "t2.micro"
  key_name = "${module.aws_ec2_key.key_name}"
  security_groups = "${module.sg_jumphost.id}"
  associate_public_ip_address = true
  volume_size = "10"
}


module "iam_instance_profile" {
  source = "./modules/iam-instance-profile"
  name_prefix = "${var.name}-${var.env}"
  role = "${module.iam_role.name}"
}


module "web_server_lamunch_configuraions" {
  source = "./modules/launch-configuration"
  name_prefix = "${var.name}-${var.env}-web"
  image_id = "${var.image_id}"
  instance_type = "t2.micro"
  iam_instance_profile = "${module.iam_instance_profile.name}"
  key_name = "${module.aws_ec2_key.key_name}"
  security_groups = "${module.sg_web.id}"
  volume_size = "20"
}


############################### ASG #####################
module "asg_jump_host" {
  source = "./modules/asg"
  name = "${var.name}-${var.env}-jump"
  launch_configuration = "${module.jump_host_lamunch_configuraions.id}"
  subnet_a = "${module.pub_subnet_a.subnet_id}"
  subnet_b = "${module.pub_subnet_b.subnet_id}"
  env = "${var.env}"
}


module "asg_web_servers" {
  source = "./modules/asg"
  name = "${var.name}-${var.env}-web"
  launch_configuration = "${module.web_server_lamunch_configuraions.id}"
  subnet_a = "${module.priv_subnet_a.subnet_id}"
  subnet_b = "${module.priv_subnet_b.subnet_id}"
  env = "${var.env}"
}

