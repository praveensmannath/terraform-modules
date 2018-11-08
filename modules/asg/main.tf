resource "aws_autoscaling_group" "autoscaling-group" {
  name                 = "${var.name}"
  launch_configuration = "${var.launch_configuration}"
  max_size             = "${var.max_size}"
  min_size             = "${var.min_size}"
  vpc_zone_identifier  = ["${var.subnet_a}", "${var.subnet_b}"]

  tag = {
    key                 = "name"
    value               = "${var.name}"
    propagate_at_launch = true
  }

  tag = {
    key                 = "env"
    value               = "${var.env}"
    propagate_at_launch = true
  }

  metrics_granularity = "1Minute"
  enabled_metrics     = ["GroupDesiredCapacity", "GroupInServiceInstances", "GroupMaxSize", "GroupMinSize", "GroupPendingInstances", "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances"]
}
