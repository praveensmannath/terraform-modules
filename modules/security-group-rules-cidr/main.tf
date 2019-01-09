resource "aws_security_group_rule" "sg_rules" {
  count = "${length(var.security_group_id)}"
  type              = "${var.type}"
  security_group_id = "${element(var.security_group_id, count.index)}"
  from_port         = "${var.from_port}"
  to_port           = "${var.to_port}"
  protocol          = "${var.protocol}"
  cidr_blocks       = "${var.cidr_blocks}"
}
