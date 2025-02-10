module "network" {
  source                = "../../modules/network"
  env                   = "dev"
  vpc_cidr              = "10.3.0.0/16"
  public_subnet_cidr    = "10.3.0.0/24"
  public_subnet_cidr_2  = "10.3.1.0/24"
  private_subnet_cidr   = "10.3.2.0/24"
  private_subnet_cidr_2 = "10.3.3.0/24"
  availability_zones    = ["us-east-1a", "us-east-1b"]   # ✅ Use a list
  private_subnet_cidrs  = ["10.3.2.0/24", "10.3.3.0/24"] # ✅ Use a list
  # private_subnet_cidrs  = [module.network.private_subnet_cidr, module.network.private_subnet_cidr]  # ✅ Use a list
}

module "compute" {
  source            = "../../modules/compute"
  env               = "dev"
  private_subnet_id = module.network.private_subnet_id
  public_subnet_id  = module.network.public_subnet_id
  backend_sg_id     = module.network.backend_sg_id
  frontend_sg_id    = module.network.frontend_sg_id
}

module "database" {
  source             = "../../modules/database"
  env                = "dev"
  db_username        = "dev_admin"
  db_password        = "123"
  private_subnet_ids = module.network.private_subnet_ids
}
