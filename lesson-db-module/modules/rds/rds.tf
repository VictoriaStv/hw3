resource "aws_db_instance" "this" {
  count = var.use_aurora ? 0 : 1

  identifier = "${var.db_name}-rds"

  engine         = var.engine
  engine_version = var.engine_version
  instance_class = var.instance_class

  allocated_storage = var.allocated_storage

  db_name  = var.db_name
  username = var.master_username
  password = var.master_password

  db_subnet_group_name = aws_db_subnet_group.this.name

  vpc_security_group_ids = [
    aws_security_group.db_sg.id
  ]

  multi_az            = var.multi_az
  publicly_accessible = false

  port = local.db_port

  parameter_group_name = var.use_aurora ? null : aws_db_parameter_group.this[0].name

  skip_final_snapshot = true
  deletion_protection = false

  tags = merge(var.tags, {
    Name = "${var.db_name}-rds"
  })
}
