# # ➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤

# ➤ Task Definition
resource "aws_ecs_task_definition" "poc_task" {
  family                   = "poc-task"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 1024    # ek CPU 
  memory                   = 2048    # 2 GB memory 
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"   # When Build not on the ARM based system like MSC-OS 
  }

  container_definitions = jsonencode([
    {
      name      = var.container_name
      image     = "${aws_ecr_repository.poc_ecr.repository_url}:latest"// Need to pass the image!
      portMappings = [
        {
          containerPort = var.container_port
        }
      ]
      logConfiguration = {
        logDriver = "awslogs",
        options = {
          awslogs-group         = var.ecs_log_group_name,
          awslogs-region        = "us-east-1",
          awslogs-stream-prefix = "ecs"
        }
      }
      healthCheck = {
        command     = ["CMD-SHELL", "curl -f http://localhost:${var.container_port}/health || exit 1"]
        interval    = 30 # check this route - request after every 30 sec
        timeout     = 5
        retries     = 3
        startPeriod = 10
      }
    }
  ])
}
