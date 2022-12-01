resource "aws_codepipeline" "pipeline" {
  name     = var.name
  role_arn = aws_iam_role.codepipeline.arn

  artifact_store {
    location = var.uri_bucket_pipelines
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["code"]
      region           = local.aws_region

      configuration = {
        ConnectionArn         = aws_codestarconnections_connection.devops-connect.arn
        FullRepositoryId      = "${var.github_repo_owner}/${var.github_repo_name}"
        BranchName            = var.github_branch_name
        DetectChanges         = "true"
        OutputArtifactFormat  = "CODE_ZIP"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["code"]
      output_artifacts = ["imagedefinitions"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.project.name
      }
    }
  }

  stage {
      name = "Production"

      action {
        name            = "Deploy"
        category        = "Deploy"
        owner           = "AWS"
        provider        = "ECS"
        input_artifacts = ["imagedefinitions"]
        version         = "1"

        configuration = {
          ClusterName = var.cluster_name
          ServiceName = var.app_service_name
          FileName    = "imagedefinitions.json"
        }
      }
    }

}

resource "aws_codestarconnections_connection" "devops-connect" {
  name          = "devops-${var.name}"
  provider_type = "GitHub"
}

