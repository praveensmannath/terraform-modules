resource "aws_launch_configuration" "launch-configuration" {
  name_prefix                 = "${var.name_prefix}"
  image_id                    = "${var.image_id}"
  instance_type               = "${var.instance_type}"
  key_name                    = "${var.key_name}"
  iam_instance_profile        = "${var.iam_instance_profile}"
  security_groups             = ["${var.security_groups}"]
  associate_public_ip_address = "${var.associate_public_ip_address}"
  user_data                   = "${var.user_data}"

  root_block_device = {
    volume_type           = "${var.volume_type}"
    volume_size           = "${var.volume_size}"
    delete_on_termination = "${var.delete_on_termination}"
  }

  lifecycle = {
    create_before_destroy = true
  }

  enable_monitoring = "${var.enable_monitoring}"
}
