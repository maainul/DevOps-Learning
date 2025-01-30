
provider "aws" {
  region = "us-east-1"
}

resource "aws_db_instance" "myrds" {
  engine         = "mariadb"
  instance_class = "db.t2.micro"
}

#defining the provider as aws
provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

#create a RDS Database Instance
resource "aws_db_instance" "myrds" {
  engine              = "mariadb"
  identifier          = "myrds"
  allocated_storage   = 20
  engine_version      = "10.6.14"
  instance_class      = "db.t2.micro"
  username            = "admin"
  password            = "admin123"
  skip_final_snapshot = true
  publicly_accessible = true
}