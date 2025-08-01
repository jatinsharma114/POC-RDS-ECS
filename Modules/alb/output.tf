output "alb_security_group_id" {
  value = aws_security_group.alb_sg.id
}

output "target_group_arn" {
  value = aws_lb_target_group.alb_target_group.arn
}

output "ecs_listener_arn" {
  value = aws_lb_listener.ecs_listener.arn
}