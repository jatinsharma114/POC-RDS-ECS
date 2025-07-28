# ➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤

# ➤ IAM Role for Task Execution
resource "aws_iam_role_policy_attachment" "ecs_task_execution_attach" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        # This principal is allowed to assume this IAM role and use its permissions.”
        # that's how it normally works in IAM permission policies — but sts:AssumeRole is a special case, 
        # because it deals with identity not with a specific AWS resource like EC2 or S3.
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com" 
          # built-in AWS Service Principal. It is not something you create 
          # it is managed by AWS and used to identify the Amazon ECS Tasks service when assuming IAM roles.
        }
      }
    ]
  })
}


# Note:-
#Yes, the role you created is the one you must create yourself.
#AWS does not create the task-execution role automatically; 
#it only creates the “ecsTaskExecutionRole” for you if you run a task via the console and tick “Auto-create IAM role”.
#When you use Terraform, you must declare both:
#The IAM role (aws_iam_role.ecs_task_execution_role).
#The attachment of the managed policy (AmazonECSTaskExecutionRolePolicy).
#So the two blocks you have are exactly what you need:
#aws_iam_role → trust policy for ecs-tasks.amazonaws.com
#aws_iam_role_policy_attachment → gives the role permission to pull images, write CloudWatch logs, fetch Secrets Manager values, etc.

