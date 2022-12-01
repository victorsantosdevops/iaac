data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

data "template_file" "prod_buildspec" {
  template = "${file("${path.module}/templates/buildspec.yml")}"

  vars = {
    bucket_name       = var.bucket_website
    distribuition_id  = var.cf_distribuition_id
  }
}

locals {
  aws_region      = data.aws_region.current.name
  account_id      = data.aws_caller_identity.current.account_id
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

    environment_variable {
      name  = "S3_BUCKET_DESTINATION"
      value = var.s3_bucket_destination
    }

    environment_variable {
      name  = "region"
      value = local.aws_region
    }

    environment_variable {
      name  = "ENV"
      value = var.environment
    }
  }

  source {
    type      = "CODEPIPELINE"
  }

  tags = var.tags
}

resource "aws_codebuild_project" "prod_app_build" {

  name          = "${var.name}-${var.environment}-cdn"
  build_timeout = "80"
  service_role  = aws_iam_role.codebuild.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"

    // https://docs.aws.amazon.com/codebuild/latest/userguide/build-env-ref-available.html
    image           = "aws/codebuild/nodejs:8.11.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "${data.template_file.prod_buildspec.rendered}"
  }

}
