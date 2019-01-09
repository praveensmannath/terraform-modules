resource "aws_route_table_association" "rta" {
  count = "${length(var.subnets)}"
  subnet_id      = "${element(var.subnets, count.index)}"
  route_table_id = "${var.route_table_id}"
}