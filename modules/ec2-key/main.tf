resource "aws_key_pair" "public-key" {
  key_name   = "${var.name}"
  public_key = "${var.public_key}"
}