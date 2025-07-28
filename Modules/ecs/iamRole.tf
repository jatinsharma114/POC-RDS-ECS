# ➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤

# ➤ IAM Role for Task Execution using Trust Policy. 
resource "aws_iam_role_policy_attachment" "ecs_task_execution_attach" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy" # (AmazonECSTaskExecutionRolePolicy) Creation November 17, 2017, 00:18 (UTC+05:30)
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        # STS - Token Generate - { Trust Policy } we are using. 
        # ECS Assume this Role and ECS service generate the Role to Access the ECS service. 
        Action = "sts:AssumeRole", #  AWS Security Token Service 
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })
}

# Note : ECS Assume this Role - generate the token with the Action (STS) to access the ECR (by using the AmazonECSTaskExecutionRolePolicy)