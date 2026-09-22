module "vpc" {
  source = "./vpc"
  env    = "dev"

}

module "ec2" {
  source    = "./ec2"
  env       = "dev"
  vpc_id    = module.vpc.vpc_id
  subnet_id = module.vpc.public_subnet_id
  ami       = "ami-0b6d9d3d33ba97d99"
  alb_sg_id = module.alb.alb_sg_id

}
module "alb" {
  source = "./alb"
  vpc_id = module.vpc.vpc_id
  instance_ids = module.ec2.instance_ids
  env = "dev"
  subnet_ids = [module.vpc.public_subnet_id, module.vpc.public_subnet2_id]
  
}