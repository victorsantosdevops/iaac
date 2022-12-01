output "codepipeline_id" {
  value = aws_codepipeline.pipeline.id
}

output "codepipeline_arn" {
  value = aws_codepipeline.pipeline.arn
}

output "codebuild_project_id" {
  value = aws_codebuild_project.project.id
}

output "codebuild_project_arn" {
  value = aws_codebuild_project.project.arn
}
