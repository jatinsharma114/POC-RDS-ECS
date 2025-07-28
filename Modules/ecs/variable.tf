# ECS Cluster Variables
# CloudWatch Log Group Variables
variable "ecs_log_group_name" {
  description = "Name of the CloudWatch log group"
  type        = string
  default     = "/ecs/poc-task"
}

# ➤ ECS Service SG Variables
# ➤ ECS Task Definition Variables

variable "container_name" {
  description = "Container name"
  type        = string
  default     = "backend"
}

variable "container_port" {
  description = "Port the container listens on"
  type        = number
  default     = 8082
}

# -------
# Coming from the Output: 
variable "vpc_id" {
  description = "VPC ID from the VPC module"
  type        = string
}

variable "private_subnet_us_east_1a_id" {
  description = "Public Subnet ID from VPC module"
  type        = string
}

variable "alb_security_group_id" {
  type = string
}

variable "target_group_arn" {
  type = string
}

variable "ecs_listener_arn" {
  type = string
  description = "ARN of the ALB listener"
}

