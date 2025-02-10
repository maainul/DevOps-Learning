
resource "aws_db_subnet_group" "db_sg" {
    name = "dev-fastfood-db"
    subnet_ids = [aws_subnet.frontend_public_1.id,aws_subnet.backend_public_1.id]
    tags = {
      Name = "dev_fastfood_db"
    } 
}


resource "aws_db_parameter_group" "db_pm_sg" {
  name   = "dv-fastfood-db"
  family = "postgres16"

  parameter {
    name  = "max_connections"
    value = "100"
    apply_method = "pending-reboot"  # ✅ Defers the change until next reboot
  }
}

resource "aws_db_instance" "dev" {
  identifier             = "dev"
  instance_class         = "db.t3.micro"  # ✅ Free Tier Eligible
  allocated_storage      = 5  # AWS Free Tier gives up to 20GB
  engine                 = "postgres"
  engine_version         = "16.3"  # Use a supported version
  username               = var.username
  password               = var.password
  db_subnet_group_name   = aws_db_subnet_group.db_sg.name
  vpc_security_group_ids = [aws_security_group.db_sg.id]
  parameter_group_name   = aws_db_parameter_group.db_pm_sg.name
  publicly_accessible    = true
  skip_final_snapshot    = true
}


