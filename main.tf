#--------root/main.tf

module "networking" {
  source                  = "./networking"
  vpc_cidr                = "10.0.0.0/16"
  public_sn_count         = 2
  public_cidrs            = ["10.0.1.0/24", "10.0.2.0/24"]
  map_public_ip_on_launch = true
}

module "compute" {
  source         = "./compute"
  instance_type  = "t2.micro"
  public_subnets = module.networking.public_subnets
  vpc_sg         = module.networking.vpc_sg
  key_name       = "MazeKeys"
}
