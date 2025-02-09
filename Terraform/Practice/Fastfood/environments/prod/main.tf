provider "aws" {
  region = "us-east-1"
}

module "network" {
  source                = "../../modules/network"
  env                   = "prod"
  vpc_cidr              = "10.1.0.0/16"
  public_subnet_cidr    = "10.1.1.0/24"
  public_subnet_cidr_2  = "10.1.2.0/24"
  private_subnet_cidr   = "10.1.2.0/24"
  private_subnet_cidr_2 = "10.1.3.0/24"
  private_subnet_ids    = ["10.1.2.0/24", "10.1.3.0/24"]
}

module "compute" {
  source            = "../../modules/compute"
  env               = "prod"
  private_subnet_id = module.network.private_subnet_id
  public_subnet_id  = module.network.public_subnet_id
  backend_sg_id     = module.network.backend_sg_id
  frontend_sg_id    = module.network.frontend_sg_id
}

module "database" {
  source             = "../../modules/database"
  env                = "prod"
  db_username        = "prod_admin"
  db_password        = "123"
  private_subnet_ids = module.network.private_subnet_ids
}
