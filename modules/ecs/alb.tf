

resource "aws_alb" "app_alb" {
  name            = "${var.cluster_name}-alb"
  subnets         =  var.availability_zones
  security_groups = [var.app_sg_id, var.alb_sg_id]

  tags = {
    Name        = "${var.cluster_name}-alb"
    Environment = var.cluster_name
  }
}

