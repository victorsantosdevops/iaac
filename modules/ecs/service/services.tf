resource "aws_ecs_service" "web-server" {
  name            = var.app_service_name
  cluster         = var.cluster_id
  task_definition = aws_ecs_task_definition.task_definition.arn
  desired_count   = var.desired_tasks

  launch_type = "FARGATE"


  load_balancer {
    target_group_arn = aws_alb_target_group.target_group.arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  network_configuration {
    security_groups = var.security_groups_ids
    subnets         = var.availability_zones
    assign_public_ip = true
  }




#  lifecycle {
#    ignore_changes = ["desired_count"]
#  }

  depends_on = [aws_alb_target_group.target_group]
}