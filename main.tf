module "vpc" {
  source = "./Modules/vpc"
}

module "alb" {
  source = "./Modules/alb"
  vpc_id            = module.vpc.vpc_id
  public_subnet_us-east-1a_id  = module.vpc.public_subnet_us-east-1a_id # Az- a
  public_subnet_us-east-1b_id  = module.vpc.public_subnet_us-east-1b_id # Az- b
}

module "ecs" {
  source = "./Modules/ecs" 
  vpc_id           = module.vpc.vpc_id

  alb_security_group_id = module.alb.alb_security_group_id
  target_group_arn      = module.alb.target_group_arn
  private_subnet_us_east_1a_id     = module.vpc.private_subnet_us_east_1a_id
  ecs_listener_arn      = module.alb.ecs_listener_arn
}

module "rds" {
  source = "./Modules/rds"

  private_subnet_us_east_1a_id = module.vpc.private_subnet_us_east_1a_id # AZ - a
  private_subnet_us_east_1b_id = module.vpc.private_subnet_us_east_1b_id # AZ - b
  ecs_service_sg_id = module.ecs.ecs_service_sg_id  
  vpc_id = module.vpc.vpc_id
}

module "provider" {
  source = "./Modules/provider"
}

#Note:
# need to get the output value and pass to the modules. 