output "vpc_id" {
  value = "${aws_vpc.vpc.id}"
}

output "vpc_arn" {
  value = "${aws_vpc.vpc.arn}"
}

output "cidr_block" {
  value = "${aws_vpc.vpc.cidr_block}"
}

output "default_rt_id" {
  value = "${aws_vpc.vpc.default_route_table_id}"
}

output "defaut_sg_id" {
  value = "${aws_vpc.vpc.default_security_group_id}"
}

output "main_rt_id" {
  value = "${aws_vpc.vpc.default_route_table_id}"
}

output "default_nacl_id" {
  value = "${aws_vpc.vpc.default_network_acl_id}"
}

output "dhcp_options_id" {
  value = "${aws_vpc_dhcp_options.dhcp_options.id}"
}

output "dhcp_association_id" {
  value = "${aws_vpc_dhcp_options_association.dhcp_association.id}"
}
