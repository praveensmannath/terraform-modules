resource "aws_eip" "eip" {
  vpc      = "${var.in_vpc}"
  instance = "${var.instance_id}"
  tags     = "${var.tags}"
}
