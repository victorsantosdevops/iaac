# Target Group for Web App
resource "aws_alb_target_group" "target_group" {
  name_prefix = var.target_group_sufix
  port        = var.container_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
  deregistration_delay = 300


  health_check {
    protocol = "HTTP"
    path = "/"
    timeout = 2
    interval = 5
    matcher  = "200-299"
    healthy_threshold = 3
    unhealthy_threshold = 10
  }

  lifecycle {
    create_before_destroy = true
  }

}


resource "aws_alb_listener" "web_app" {
  load_balancer_arn = var.alb_arn
  port              = var.alb_port
  protocol          = "HTTP"
  depends_on        = [aws_alb_target_group.target_group]

  default_action {
    target_group_arn = aws_alb_target_group.target_group.arn
    type             = "forward"
  }


}


#
#resource "aws_lb_listener_rule" "static" {
#  listener_arn = var.listener_arn
#  priority     = var.priority
#
#  action {
#    type             = "forward"
#    target_group_arn = aws_alb_target_group.target_group.arn
#  }
#
#   condition {
#    host_header {
#      values = [var.domain_name]
#    }
#  }
#}
#


