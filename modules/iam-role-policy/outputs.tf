output "myOutput" {
   value = "${aws_iam_role_policy.role_policy.id}"
}