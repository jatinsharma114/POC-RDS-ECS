# # ➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤➤
# Note when we configure ECS -- 
# Lunching Type | Task defination | Replica | Networking | ALB - Tg | AutoScaling on CPU 75%.

# ➤ ECS Service
data "aws_lb_listener" "listener" {
  arn = var.ecs_listener_arn
}

resource "aws_ecs_service" "poc_service" {
  name            = "poc-ecs-service"
  cluster         = aws_ecs_cluster.poc_cluster.id
  task_definition = aws_ecs_task_definition.poc_task.arn
  launch_type     = "FARGATE"
  desired_count   = 2 # atleast create the 2 containers

  network_configuration {
    subnets         = [var.private_subnet_us_east_1a_id] # Putting only in One Subnet for Test. 
    security_groups = [aws_security_group.ecs_service_sg.id] # From securityGROUP which is taking teh traffic only from the ALB !! 
    assign_public_ip = false # No direct connection. 
  }

  load_balancer {
    target_group_arn = var.target_group_arn # passing from the ALB - Target Group ARN. 
    container_name   = var.container_name # pod
    container_port   = var.container_port # application Run on Port: 8082
  }

  deployment_controller {
    type = "ECS"
  }

  # During deployment, at least 50% of the desired tasks must remain running and healthy.
  # ECS will not stop more than 50% of your tasks at once.
  deployment_minimum_healthy_percent = 50

  # If desired_count = 2, ECS can run up to 4 tasks temporarily
  deployment_maximum_percent         = 200

  ### 👇 ALB create first and then ECS will create. :: InvalidParameterException: The target group is not ready
  depends_on = [data.aws_lb_listener.listener]
}

# ➤ Application Auto Scaling
resource "aws_appautoscaling_target" "ecs_scaling_target" {
  max_capacity       = 3
  min_capacity       = 2

  # It connects Auto Scaling to yr ECS service, using the correct forma --> service/<ecs-cluster-name>/<ecs-service-name>
  # Auto Scaling knows exactly which ECS service to scale - Tha's why we need to add this here.
  resource_id        = "service/${aws_ecs_cluster.poc_cluster.name}/${aws_ecs_service.poc_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

resource "aws_appautoscaling_policy" "cpu_scaling_policy" {
  name               = "cpu-utilization-scaling"
  service_namespace  = "ecs"
  resource_id        = aws_appautoscaling_target.ecs_scaling_target.resource_id
  scalable_dimension = "ecs:service:DesiredCount"
  policy_type        = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    target_value       = 75.0

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    scale_in_cooldown  = 60
    scale_out_cooldown = 60
  }
}
