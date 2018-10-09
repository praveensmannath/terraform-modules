output "vpc_id" {
   value = "${module.vpc.vpc_id}"
}
output "vpc_arn" {
   value = "${module.vpc.vpc_arn}"
}
output "cidr_block" {
   value = "${module.vpc.cidr_block}"
}

output "default_rt_id" {
   value = "${module.vpc.default_rt_id}"
}

output "defaut_sg_id" {
   value = "${module.vpc.defaut_sg_id}"
}

output "main_rt_id" {
   value = "${module.vpc.default_rt_id}"
}

output "default_nacl_id" {
   value = "${module.vpc.default_nacl_id}"
}

#########################################################SUBNETS######################
output "public_subnet_a_arn" {
   value = "${module.pub_subnet_a.subnet_arn}"
}

output "public_subnet_a_id" {
   value = "${module.pub_subnet_a.subnet_id}"
}

output "public_subnet_a_az" {
   value = "${module.pub_subnet_a.subnet_az}"
}

output "public_subnet_a_cidr" {
   value = "${module.pub_subnet_a.cidr_block}"
}


output "public_subnet_b_arn" {
   value = "${module.pub_subnet_b.subnet_arn}"
}

output "public_subnet_b_id" {
   value = "${module.pub_subnet_b.subnet_id}"
}

output "public_subnet_b_az" {
   value = "${module.pub_subnet_b.subnet_az}"
}

output "public_subnet_b_cidr" {
   value = "${module.pub_subnet_b.cidr_block}"
}

output "private_subnet_a_arn" {
   value = "${module.priv_subnet_a.subnet_arn}"
}

output "private_subnet_a_id" {
   value = "${module.priv_subnet_a.subnet_id}"
}

output "private_subnet_a_az" {
   value = "${module.priv_subnet_a.subnet_az}"
}

output "private_subnet_a_cidr" {
   value = "${module.priv_subnet_a.cidr_block}"
}


output "private_subnet_b_arn" {
   value = "${module.priv_subnet_b.subnet_arn}"
}

output "private_subnet_b_id" {
   value = "${module.priv_subnet_b.subnet_id}"
}

output "private_subnet_b_az" {
   value = "${module.priv_subnet_b.subnet_az}"
}

output "private_subnet_b_cidr" {
   value = "${module.priv_subnet_b.cidr_block}"
}

#########



output "db_subnet_a_arn" {
   value = "${module.db_subnet_a.subnet_arn}"
}

output "db_subnet_a_id" {
   value = "${module.db_subnet_a.subnet_id}"
}

output "db_subnet_a_az" {
   value = "${module.db_subnet_a.subnet_az}"
}

output "db_subnet_a_cidr" {
   value = "${module.db_subnet_a.cidr_block}"
}


output "db_subnet_b_arn" {
   value = "${module.db_subnet_b.subnet_arn}"
}

output "db_subnet_b_id" {
   value = "${module.db_subnet_b.subnet_id}"
}

output "db_subnet_b_az" {
   value = "${module.db_subnet_b.subnet_az}"
}

output "db_subnet_b_cidr" {
   value = "${module.db_subnet_b.cidr_block}"
}

############### IGW ##################
output "igw_id" {
   value = "${module.igw.gateway_id}"
}

##########EIP ############
output "eip_id" {
   value = "${module.eip.eip_id}"
}