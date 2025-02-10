
module "network" {
  source                = "../../modules/network"
  env                   = "staging"
  vpc_cidr              = "10.2.0.0/16"
  public_subnet_cidr    = "10.2.1.0/24"
  public_subnet_cidr_2  = "10.2.1.0/24"
  private_subnet_cidr   = "10.2.2.0/24"
  private_subnet_cidr_2 = "10.2.3.0/24"
}

module "compute" {
  source            = "../../modules/compute"
  env               = "staging"
  private_subnet_id = module.network.private_subnet_id
  public_subnet_id  = module.network.public_subnet_id
  backend_sg_id     = module.network.backend_sg_id
  frontend_sg_id    = module.network.frontend_sg_id
}

module "database" {
  source             = "../../modules/database"
  env                = "staging"
  db_username        = "staging_admin"
  db_password        = "123"
  private_subnet_ids = module.network.private_subnet_ids
}
