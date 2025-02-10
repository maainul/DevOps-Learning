resource "aws_db_subnet_group" "db_subnet" {
  name       = "${var.env}-db-subnet-group"
  subnet_ids = var.private_subnet_ids # ✅ Corrected

  tags = {
    Name = "${var.env}-db-subnet-group"
  }
}


resource "aws_db_instance" "postgres" {
  identifier             = "${var.env}-postgres-db"
  engine                 = "postgres"
  instance_class         = "db.t2.micro"
  allocated_storage      = 20
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.db_subnet.name
  vpc_security_group_ids = [module.network.database_sg.id]

  publicly_accessible = false # Keep the database private
  skip_final_snapshot = true

  tags = {
    Name = "${var.env}-postgres"
  }
}

