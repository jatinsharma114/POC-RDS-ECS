# ➤ RDS Variables
variable "rds_engine" {
  default = "mysql"
}

variable "rds_engine_version" {
  default = "8.0.36"
}

variable "rds_instance_class" {
  default = "db.t3.micro"
}

variable "rds_username" {
  default = "admin"
}

variable "rds_password" {
  default = "Passw0rd!123"
}


# =======

variable "private_subnet_us_east_1a_id" {
  description = "Public Subnet ID from VPC module"
  type        = string
}

variable "private_subnet_us_east_1b_id" {
  description = "Public Subnet ID from VPC module"
  type        = string
}

variable "ecs_service_sg_id" {
  description = "Security group ID of the ECS tasks"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID from the VPC module"
  type        = string
}