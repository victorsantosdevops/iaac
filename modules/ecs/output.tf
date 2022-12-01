output "repository_url" {
  value = aws_ecr_repository.web-app.repository_url
}

output "alb" {
  value = aws_alb.app_alb.dns_name
}

output "cluster_name" {
  value = aws_ecs_cluster.cluster.name
}

output "cluster_id" {
  value = aws_ecs_cluster.cluster.id
}

output "alb_arn" {
  value = aws_alb.app_alb.arn
}

output "cw_logs" {
  value = aws_cloudwatch_log_group.web-app.name
}

output "ecs_role" {
  value = aws_iam_role.ecs_execution_role.arn
}

#output "listener_arn" {
#  value = aws_alb_listener.web_app.arn
#}