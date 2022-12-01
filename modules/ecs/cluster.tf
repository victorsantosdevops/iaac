resource "aws_ecs_cluster" "cluster" {
  name = var.cluster_name

  setting {
    name = "containerInsights"
    value = "enabled"
  }
}

resource "aws_cloudwatch_log_group" "web-app" {
  name = "${var.cluster_name}-logs"

  tags = {
    Application = var.cluster_name
  }

}
