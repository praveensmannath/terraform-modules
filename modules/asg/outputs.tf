output "arn" {
  value = "${aws_autoscaling_group.autoscaling-group.arn}"
}

output "id" {
  value = "${aws_autoscaling_group.autoscaling-group.id}"
}
