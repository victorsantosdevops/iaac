# Target Group for Web App
resource "aws_alb_target_group" "server_target_group" {
  name_prefix = var.target_group_sufix
  port        = var.container_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"
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



#resource "aws_alb_listener_rule" "redirect_http_to_https" {
#  listener_arn = aws_alb_listener.web_app.arn
#
#  action {
#    type = "redirect"
#
#    redirect {
#      port        = "443"
#      protocol    = "HTTPS"
#      status_code = "HTTP_301"
#    }
#  }
#
#  condition {
#    http_header {
#      http_header_name = "X-Forwarded-For"
#      values           = ["192.168.1.*"]
#    }
#  }
#}


