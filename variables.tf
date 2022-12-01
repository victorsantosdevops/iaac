variable "project" {
  description = "Map of project names to configuration"
  type        = map(any)
  default = {
    project-tcc-api    = {
      github_repo_name    = "tccapp"
      name                = "tcc-api"
      deploy_type         = "ECR"
      app_service_name    = "tcc-api"
      container_name      = "tcc-api"
      target_group_sufix  = "ka"
      container_port      = 8080
      desired_task_cpu    = 256
      desired_task_memory = 512
      max_tasks           = 3
      min_tasks           = 1
      desired_tasks       = 1
      cpu_to_scale_up     = 80
      cpu_to_scale_down   = 40
      ec2_desired_tasks   = 1
      ec2_max_tasks       = 10
      ec2_min_tasks       = 1
      instance_type       = "t3.large"
      secret_arn          = ""
      domain_name         = "tcc-api.apps.test.com"
      region              = "us-west-2"
      priority            = 100
    },
    project-tcc-api-lambda    = {
      github_repo_name    = "tccapp"
      name                = "tcc-api"
      deploy_type         = "ECR"
      app_service_name    = "tcc-api"
      container_name      = "tcc-api"
      target_group_sufix  = "ka"
      container_port      = 8080
      desired_task_cpu    = 256
      desired_task_memory = 512
      max_tasks           = 3
      min_tasks           = 1
      desired_tasks       = 1
      cpu_to_scale_up     = 80
      cpu_to_scale_down   = 40
      ec2_desired_tasks   = 1
      ec2_max_tasks       = 10
      ec2_min_tasks       = 1
      instance_type       = "t3.large"
      secret_arn          = ""
      domain_name         = "tcc-api.apps.test.com"
      region              = "us-west-2"
      priority            = 100
    }
  }
}


variable "name" {
  type        = string
  description = "(Required) The name of the codebuild project and artifact bucket"
}

variable "ecr_name" {
  type        = string
  description = "(Optional) The name of the ECR repo. Required if var.deploy_type is ecr or ecs"
}

variable "codebuild_image" {
  type        = string
  description = "(Optional) The codebuild image to use"
}

variable "build_compute_type" {
  type        = string
  description = "(Optional) build environment compute type"
}

variable "buildspec" {
  type        = string
  description = "build spec file other than buildspec.yml"
  default     = "buildspec.yml"
}

variable "logs_retention_in_days" {
  type        = number
  description = "(Optional) Days to keep the cloudwatch logs for this codebuild project"
}

variable "use_docker_credentials" {
  type        = bool
  description = "(Optional) Use dockerhub credentals stored in parameter store"

}
variable "env_repo_name" {
  type = object({
    variables = map(string)
  })
  default = null
}

variable "privileged_mode" {
  description = "set privileged_mode flag for docker container use"

}
variable "tags" {
  type        = map
  description = "(Optional) A mapping of tags to assign to the resource"
  default     = {}
}


variable "s3_block_public_access" {
  type = bool
  description = "(Optional) Enable the S3 block public access setting for the artifact bucket."

}


variable "github_repo_owner" {
  type        = string
  description = "The owner of the GitHub repo"
}

variable "github_oauth_token" {
  type        = string
  description = "GitHub oauth token"
}

variable "environment" {
  type =  string
}

variable "github_branch_name" {
}

variable "cluster_name" {}
variable "alb_port" {}
variable "ssh_key_name" {
}



variable "cert_arn" {}
variable "use_repo_access_github_token" {
  type        = bool
  description = <<EOT
                (Optional) Allow the AWS codebuild IAM role read access to the REPO_ACCESS_GITHUB_TOKEN secrets manager secret in the shared service account.
                Defaults to false.
                EOT

}
variable "svcs_account_github_token_aws_secret_arn" {
  type        = string
  description = <<EOT
                (Optional) The AWS secret ARN for the repo access Github token.
                The secret is created in the shared service account.
                Required if var.use_repo_access_github_token is true.
                EOT

}

variable "svcs_account_github_token_aws_kms_cmk_arn" {
  type        = string
  description = <<EOT
                (Optional) The us-east-1 region AWS KMS customer managed key ARN for encrypting the repo access Github token AWS secret.
                The key is created in the shared service account.
                Required if var.use_repo_access_github_token is true.
                EOT

}
variable "container_port" {}