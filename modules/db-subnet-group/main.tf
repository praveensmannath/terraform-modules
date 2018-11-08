resource "aws_db_subnet_group" "db-sg-group" {
  name        = "${var.name}"
  subnet_ids  = ["${var.subnet_a}", "${var.subnet_b}"]
  description = "${var.description}"
  tags        = "${var.tags}"
}
