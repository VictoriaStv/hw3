resource "aws_rds_cluster" "this" {
  count = var.use_aurora ? 1 : 0

  cluster_identifier = "${var.db_name}-aurora-cluster"

  engine = var.engine == "mysql" ? "aurora-mysql" : "aurora-postgresql"

  engine_version = var.engine_version

  database_name   = var.db_name
  master_username = var.master_username
  master_password = var.master_password

  db_subnet_group_name = aws_db_subnet_group.this.name

  vpc_security_group_ids = [
    aws_security_group.db_sg.id
  ]

  port = local.db_port

  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.aurora[0].name

  storage_encrypted   = true
  deletion_protection = false
  skip_final_snapshot = true

  tags = merge(var.tags, {
    Name = "${var.db_name}-aurora-cluster"
  })
}

resource "aws_rds_cluster_instance" "this" {
  count = var.use_aurora ? var.aurora_instances : 0

  identifier         = "${var.db_name}-aurora-${count.index + 1}"
  cluster_identifier = aws_rds_cluster.this[0].id

  instance_class = var.instance_class
  engine         = aws_rds_cluster.this[0].engine

  publicly_accessible = false

  tags = merge(var.tags, {
    Name = "${var.db_name}-aurora-instance-${count.index + 1}"
  })
}
