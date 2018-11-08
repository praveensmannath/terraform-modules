output "arn" {
  value = "${aws_iam_role.iam-role.arn}"
}

output "unique_id" {
  value = "${aws_iam_role.iam-role.unique_id}"
}

output "name" {
  value = "${aws_iam_role.iam-role.name}"
}
