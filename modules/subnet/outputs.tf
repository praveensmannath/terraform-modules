output "subnet_arn" {
  value = "${aws_subnet.subnet.arn}"
}

output "subnet_id" {
  value = "${aws_subnet.subnet.id}"
}

output "subnet_az" {
  value = "${aws_subnet.subnet.availability_zone}"
}

output "cidr_block" {
  value = "${aws_subnet.subnet.cidr_block}"
}
