locals {
  volume_name     = "ecs-${var.name}"
  aws_region  = data.aws_region.current.name
}

data "template_file" "task_definition_template" {
  template = "${file("${path.module}/task-definitions/api-task.json")}"

  vars = {
    image               = var.repository_url
    container_name      = var.container_name
    container_port      = var.container_port
    log_group           = var.cw_logs
    desired_task_cpu    = var.desired_task_cpu
    desired_task_memory = var.desired_task_memory
    source_volume       = local.volume_name
    container_path      = "/mnt/${local.volume_name}"
    aws_region          = local.aws_region
  }
}

resource "aws_ebs_volume" "ebs_volume" {
  availability_zone = "us-west-2b"
  size              = 200
  type              = "gp2"

  tags = {
    Name = local.volume_name
  }
}

resource "aws_ecs_task_definition" "task_definition" {
  family                    = "${var.app_service_name}_app"
  container_definitions     = data.template_file.task_definition_template.rendered
  requires_compatibilities  = ["FARGATE"]

  network_mode              = "awsvpc"

  cpu                      = var.desired_task_cpu
  memory                   = var.desired_task_memory

  execution_role_arn = var.ecs_role
  task_role_arn      = var.ecs_role
}

#resource "aws_ecs_task_definition" "web-server" {
#  family                   = "${var.cluster_name}_app"
#  container_definitions    = data.template_file.api_task.rendered
#  requires_compatibilities = ["FARGATE"]
#  network_mode             = "awsvpc"
#  cpu                      = var.desired_task_cpu
#  memory                   = var.desired_task_memory
#
#  execution_role_arn = aws_iam_role.ecs_execution_role.arn
#  task_role_arn      = aws_iam_role.ecs_execution_role.arn
#}
