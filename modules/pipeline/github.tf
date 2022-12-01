#resource "aws_codepipeline_webhook" "github" {
#  # Only create the webhook if create_github_webhook is set to true
#  count           = var.create_github_webhook == true ? 1 : 0
#  name            = var.name
#  authentication  = "GITHUB_HMAC"
#  target_action   = "Source"
#  target_pipeline = aws_codepipeline.pipeline.name
#
#  authentication_configuration {
#    secret_token = var.github_oauth_token
#  }
#
#  filter {
#    json_path    = "$.ref"
#    match_equals = "refs/heads/{Branch}"
#  }
#}
#


#resource "github_repository_webhook" "aws_codepipeline" {
#  count      = var.create_github_webhook == true ? 1 : 0
#
#  repository = var.github_repo_name
#
#  configuration {
#    url          = var.monorepo_webhook
#    content_type = "json"
#    secret       = var.github_oauth_token
#  }
#
#  events = ["push"]
#}