resource "aws_db_instance" "bs_mysql" {
  name                 = format("%s-database", var.environment)
  allocated_storage    = var.db_volume
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = var.db_instance
  username             = var.db_username
  password             = var.db_password
  parameter_group_name = "default.mysql5.7"
  db_subnet_group_name = aws_db_subnet_group.bs_db_sg.name
  multi_az             = true
}

resource "aws_db_subnet_group" "bs_db_sg" {
  name       = format("%s-database-sg", var.environment)
  subnet_ids = aws_subnet.db_subnet.*.id
}
