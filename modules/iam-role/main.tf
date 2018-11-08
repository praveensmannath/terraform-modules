resource "aws_iam_role" "iam-role" {
  name               = "${var.name}"
  description        = "${var.description}"
  assume_role_policy = "${var.role_policy}"
}
