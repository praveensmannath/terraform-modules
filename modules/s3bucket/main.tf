resource "aws_s3_bucket" "s3" {
  bucket = "${var.name}"
  acl    = "${var.acl}"

  tags = "${var.tags}"

  versioning {
    enabled = "${var.versioning}"
  }
}
