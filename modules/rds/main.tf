resource "aws_rds_cluster" "aurora_cluster" {
  cluster_identifier           = "${var.c_name}-aurora-cluster"
  database_name                = "${var.database_name}"
  master_username              = "${var.master_username}"
  master_password              = "${var.master_password}"
  backup_retention_period      = "${var.backup_retention_period}"
  preferred_backup_window      = "02:00-03:00"
  preferred_maintenance_window = "wed:03:00-wed:04:00"
  db_subnet_group_name         = "${var.db_subnet_group_name}"
  final_snapshot_identifier    = "${var.c_name}-aurora-cluster"

  vpc_security_group_ids = [
    "${var.vpc_security_group_ids}",
  ]

  tags = "${var.tags}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_rds_cluster_instance" "cluster_instance" {
  count = "${length(split(",", var.vpc_rds_subnet_ids))}"

  identifier           = "${var.c_name}-aurora-instance-${count.index}"
  cluster_identifier   = "${aws_rds_cluster.aurora_cluster.id}"
  instance_class       = "${var.instance_class}"
  db_subnet_group_name = "${var.db_subnet_group_name}"
  publicly_accessible  = "${var.publicly_accessible}"

  tags = "${var.tags}"

  lifecycle {
    create_before_destroy = true
  }
}
