resource "aws_iam_instance_profile" "instance-profile" {
  name = "masters-${var.name_prefix}"
  role = "${var.role}"
}
