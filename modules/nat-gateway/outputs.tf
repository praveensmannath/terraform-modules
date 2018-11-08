output "nat_id" {
  value = "${aws_nat_gateway.nat-gateway.id}"
}

output "nat_allocation_id" {
  value = "${aws_nat_gateway.nat-gateway.allocation_id}"
}

output "nat_subnet_id" {
  value = "${aws_nat_gateway.nat-gateway.subnet_id}"
}

output "nat_network_interface_id" {
  value = "${aws_nat_gateway.nat-gateway.network_interface_id}"
}

output "nat_private_ip" {
  value = "${aws_nat_gateway.nat-gateway.private_ip}"
}

output "nat_public_ip" {
  value = "${aws_nat_gateway.nat-gateway.public_ip}"
}
