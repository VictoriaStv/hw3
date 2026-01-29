locals {
  db_port = var.engine == "mysql" ? 3306 : 5432
}

resource "aws_db_subnet_group" "this" {
  name       = "${var.db_name}-subnets"
  subnet_ids = var.private_subnet_ids

  tags = merge(var.tags, {
    Name = "${var.db_name}-db-subnets"
  })
}

resource "aws_security_group" "db_sg" {
  name        = "${var.db_name}-db-sg"
  description = "Security group для бази даних"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = local.db_port
    to_port     = local.db_port
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(var.tags, {
    Name = "${var.db_name}-db-sg"
  })
}

resource "aws_db_parameter_group" "this" {
  count = var.use_aurora ? 0 : 1

  name   = "${var.db_name}-rds-params"
  family = var.rds_parameter_group_family

  parameter {
    name         = "max_connections"
    value        = "200"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "log_statement"
    value        = "none"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "work_mem"
    value        = "4MB"
    apply_method = "pending-reboot"
  }

  tags = merge(var.tags, {
    Name = "${var.db_name}-rds-params"
  })
}

resource "aws_rds_cluster_parameter_group" "aurora" {
  count = var.use_aurora ? 1 : 0

  name   = "${var.db_name}-aurora-params"
  family = var.aurora_parameter_group_family

  parameter {
    name         = "max_connections"
    value        = "200"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "log_statement"
    value        = "none"
    apply_method = "pending-reboot"
  }

  parameter {
    name         = "work_mem"
    value        = "4MB"
    apply_method = "pending-reboot"
  }

  tags = merge(var.tags, {
    Name = "${var.db_name}-aurora-params"
  })
}
