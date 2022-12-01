data "aws_iam_policy_document" "codepipeline_assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codepipeline.amazonaws.com"]
    }
  }

  statement {
    sid     = "AllowAssumeByEcsTasks"
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "codepipeline" {
  name               = "codepipeline-${var.name}"
  assume_role_policy = data.aws_iam_policy_document.codepipeline_assume.json

  tags = var.tags
}


data "aws_iam_policy_document" "codepipeline_baseline" {
  statement {

    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl",
      "s3:GetObjectVersion",
      "s3:GetBucketVersioning",
      "s3:GetObject"
    ]

    resources = [
      var.arn_bucket_pipelines,
      "${var.arn_bucket_pipelines}/*"
    ]
  }

  statement {
    actions = [
      "codebuild:BatchGetBuilds",
      "codebuild:StartBuild"
    ]
    resources = [
      aws_codebuild_project.project.arn,
      aws_codebuild_project.prod_app_build.arn
    ]
  }

  statement {
    effect = "Allow"

    actions = [
      "codestar-connections:UseConnection"
    ]
    resources = [aws_codestarconnections_connection.devops-connect.arn]
  }

  statement {

    actions = [
      "codedeploy:CreateDeployment",
      "codedeploy:GetApplicationRevision",
      "codedeploy:GetApplication",
      "codedeploy:GetDeployment",
      "codedeploy:GetDeploymentConfig",
      "codedeploy:RegisterApplicationRevision",
      "ecs:*",
      "events:DescribeRule",
      "events:DeleteRule",
      "events:ListRuleNamesByTarget",
      "events:ListTargetsByRule",
      "events:PutRule",
      "events:PutTargets",
      "events:RemoveTargets",
      "iam:ListAttachedRolePolicies",
      "iam:ListInstanceProfiles",
      "iam:ListRoles",
      "logs:CreateLogGroup",
      "logs:DescribeLogGroups",
      "logs:FilterLogEvents"
    ]

    resources = [
      "*"
    ]
  }

  statement {
    sid = ""

    actions = [
      "ec2:*",
      "elasticloadbalancing:*",
      "autoscaling:*",
      "cloudwatch:*",
      "s3:*",
      "sns:*",
      "cloudformation:*",
      "rds:*",
      "sqs:*",
      "ecs:*",
      "iam:PassRole",
      "ecs:RegisterContainerInstance"
    ]

    resources = ["*"]
    effect    = "Allow"
  }


}
#
#resource "aws_iam_role" "codepipeline_role" {
#  name               = "codepipeline-${var.cluster_name}-role"
#  assume_role_policy = "${file("${path.module}/templates/policies/codepipeline_role.json")}"
#
#}
#
#data "template_file" "codepipeline_policy" {
#  template = "${file("${path.module}/templates/policies/codepipeline.json")}"
#
#  vars = {
#    aws_s3_bucket_arn = var.arn_bucket_pipelines
#    aws_codestarconnections_connection = aws_codestarconnections_connection.devops-ds.arn
#  }
#}

#resource "aws_iam_role_policy" "codepipeline_baseline" {
#  name   = "codepipeline-baseline-${var.name}"
#  role   = "${aws_iam_role.codepipeline_role.id}"
#  policy = "${data.template_file.codepipeline_policy.rendered}"
#}

resource "aws_iam_role_policy" "codepipeline_baseline" {
  name   = "codepipeline-baseline-${var.name}"
  role   = aws_iam_role.codepipeline.id
  policy = data.aws_iam_policy_document.codepipeline_baseline.json
}

data "aws_iam_policy_document" "codepipeline_lambda" {
  statement {
    actions   = ["lambda:InvokeFunction"]
    resources = ["arn:aws:lambda:${local.aws_region}:${local.account_id}:function:${var.deploy_function_name}"]
  }
}

resource "aws_iam_role_policy" "codepipeline_lambda" {
  name   = "codepipeline-lambda-${var.name}"
  role   = aws_iam_role.codepipeline.id
  policy = data.aws_iam_policy_document.codepipeline_lambda.json
}

// Code Build IAM

data "aws_iam_policy_document" "codebuild_assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "codebuild" {
  name               = "codebuild-${var.name}"
  assume_role_policy = data.aws_iam_policy_document.codebuild_assume.json

  tags = var.tags
}


data "aws_iam_policy_document" "codebuild_baseline" {
  statement {
    actions = [
      "logs:PutLogEvents",
      "logs:CreateLogStream",
      "logs:CreateLogGroup",
    ]
    resources = [
      "arn:aws:logs:${local.aws_region}:${local.account_id}:log-group:/aws/codebuild/${var.name}",
      "arn:aws:logs:${local.aws_region}:${local.account_id}:log-group:/aws/codebuild/${var.name}:*",
      "arn:aws:logs:${local.aws_region}:${local.account_id}:log-group:/aws/codebuild/${var.name}-${var.environment}-cdn",
      "arn:aws:logs:${local.aws_region}:${local.account_id}:log-group:/aws/codebuild/${var.name}-${var.environment}-cdn:*"
    ]
  }

  statement {
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:ListBucket",
      "s3:DeleteObject"
    ]
    effect  = "Allow"
    resources = [
      "${var.arn_bucket_pipelines}/*",
      "${var.arn_bucket_website}/*",
      var.arn_bucket_website
    ]
  }

  statement {
    actions = [
      "cloudfront:CreateInvalidation"
    ]
    resources = [
      var.arn_cloudfront
    ]
  }


  statement {
    actions = [
      "states:ListStateMachines",
      "states:StartExecution",
      "glue:GetTable",
      "glue:UpdateTable",
      "glue:GetPartition",
      "glue:GetPartitions"
    ]
    resources = [
      "*"
    ]
  }

  statement {
    actions = [
      "secretsmanager:GetSecretValue"
    ]
    resources = [
      var.secret_arn
    ]
  }
}

resource "aws_iam_role_policy" "codebuild_baseline" {
  name   = "codebuild-baseline-${var.name}"
  role   = aws_iam_role.codebuild.id
  policy = data.aws_iam_policy_document.codebuild_baseline.json
}

data "aws_iam_policy_document" "codebuild_secrets_manager" {
  count = var.use_repo_access_github_token ? 1 : 0
  statement {
    actions = [
      "secretsmanager:GetSecretValue"
    ]
    resources = [
      replace(var.svcs_account_github_token_aws_secret_arn, "/-.{6}$/", "-??????")
    ]
  }

  statement {
    actions = [
      "kms:Decrypt"
    ]
    resources = [
      var.svcs_account_github_token_aws_kms_cmk_arn
    ]
  }
}

resource "aws_iam_role_policy" "codebuild_secrets_manager" {
  count  = var.use_repo_access_github_token ? 1 : 0
  name   = "codebuild-secrets-manager-${var.name}"
  role   = aws_iam_role.codebuild.id
  policy = data.aws_iam_policy_document.codebuild_secrets_manager[0].json
}