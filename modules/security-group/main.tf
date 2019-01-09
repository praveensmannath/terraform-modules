resource "aws_security_group" "sg" {
  count       = "${length(var.sgs)}"
  name        = "${element(keys(var.sgs), count.index)}"
  vpc_id      = "${var.vpc_id}"
  description = "${element(values(var.sgs), count.index)}"

  tags = "${var.tags}"
}
