resource "aws_subnet" "subnet" {
  count             = "${length(var.subnets)}"
  vpc_id            = "${var.vpc_id}"
  cidr_block        = "${element(var.subnets, count.index)}"
  availability_zone = "${element(var.azs, count.index)}"

  tags = "${merge(var.tags,map("Name","${format("%s-%s-%s", var.name,var.SubnetType ,element(split("-", element(var.azs, count.index)),2))}"))}"
  lifecycle{
    ignore_changes = ["tags"]
  }
}
