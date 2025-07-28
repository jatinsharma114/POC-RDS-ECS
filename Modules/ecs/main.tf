# ➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤

# ➤ ECS Cluster
resource "aws_ecs_cluster" "poc_cluster" {
  name = "poc-test-dev-ecs-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name = "POC_ECS_Cluster"
  }
}

# ➤ CloudWatch Log Group
resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = var.ecs_log_group_name
  retention_in_days = 1 # set a/c to your requirementsss!! 
}
