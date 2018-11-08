output "routes_route_table_id" {
  value = "${aws_route.route.route_table_id}"
}

output "routes_destination_cidr_block" {
  value = "${aws_route.route.destination_cidr_block}"
}

output "routes_gateway_id" {
  value = "${aws_route.route.gateway_id}"
}

output "routes_nat_gateway_id" {
  value = "${aws_route.route.nat_gateway_id}"
}
