resource "aws_cloudwatch_log_group" "group" {
  name              = "/aws/codebuild/${var.name}"
  retention_in_days = var.logs_retention_in_days

  tags = var.tags
}
