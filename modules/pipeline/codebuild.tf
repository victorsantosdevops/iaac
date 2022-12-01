data "aws_region" "current" {}
data "aws_caller_identity" "current" {}



data "template_file" "buildspec" {
  template = "${file("${path.module}/templates/buildspec.yml")}"

  vars = {
    repository_url = var.repository_url
    region         = local.aws_region
    cluster_name   = var.cluster_name
    container_name = var.container_name

    # subnet_id          = "${var.run_task_subnet_id}"
    security_group_ids = "${join(",",var.subnet_ids)}"
  }
}



locals {
  aws_region      = data.aws_region.current.name
  account_id      = data.aws_caller_identity.current.account_id
  privileged_mode = var.deploy_type == "ecr" || var.deploy_type == "ecs" || var.privileged_mode == "true" ? true : false
}

resource "aws_codebuild_project" "project" {
  name          = var.name
  build_timeout = 60
  service_role  = aws_iam_role.codebuild.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type    = var.build_compute_type
    image           = var.codebuild_image
    type            = "LINUX_CONTAINER"
    privileged_mode = true

    dynamic "environment_variable" {
      for_each = var.ecr_name == null ? [] : [var.env_repo_name]
      content {
        name  = "IMAGE_REPO_NAME"
        value = var.ecr_name
      }
    }

    dynamic "environment_variable" {
      for_each = var.use_docker_credentials == true ? [1] : []
      content {
        name  = "DOCKERHUB_USER"
        value = "/dockerhub/user"
        type  = "PARAMETER_STORE"
      }
    }

    dynamic "environment_variable" {
      for_each = var.use_docker_credentials == true ? [1] : []
      content {
        name  = "DOCKERHUB_PASS"
        value = "/dockerhub/pass"
        type  = "PARAMETER_STORE"
      }
    }

    dynamic "environment_variable" {
      for_each = var.use_repo_access_github_token ? [1] : []
      content {
        name  = "REPO_ACCESS_GITHUB_TOKEN_SECRETS_ID"
        value = var.svcs_account_github_token_aws_secret_arn
        type = "SECRETS_MANAGER"
      }
    }

    dynamic "environment_variable" {
      for_each = var.use_repo_access_github_token ? [1] : []
      content {
        name  = "REPO_ACCESS_GITHUB_TOKEN_SECRETS_ID"
        value = var.svcs_account_github_token_aws_secret_arn
        type = "SECRETS_MANAGER"
      }
    }

    environment_variable {
      name  = "repository_url"
      value = var.repository_url
    }

    environment_variable {
      name  = "region"
      value = local.aws_region
    }

    environment_variable {
      name  = "container_name"
      value = var.container_name
    }

  }


#  source {
#    type      = "CODEPIPELINE"
#    buildspec = var.buildspec
#  }
  source {
    type      = "CODEPIPELINE"
#    buildspec = "${data.template_file.buildspec.rendered}"
  }

  tags = var.tags
}