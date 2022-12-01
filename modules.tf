
module "vpc" {
  source         = "./modules/vpc"
  cluster_name   = var.cluster_name
  alb_port       = var.alb_port
  container_port = var.container_port
}

module "s3" {
  source = "./modules/s3"
  s3_block_public_access = var.s3_block_public_access
  name = var.name
}


module "ecs" {
  source = "./modules/ecs"

  alb_port = var.alb_port

  app_repository_name = var.ecr_name

  cluster_name = var.cluster_name
  container_port = var.container_port

  vpc_id = module.vpc.vpc_id

  public_subnet_1a = module.vpc.public_subnet_1a
  public_subnet_1b = module.vpc.public_subnet_1b

  ecs_sg_id = module.vpc.ecs_sg_id
  app_sg_id = module.vpc.app_sg_id
  alb_sg_id = module.vpc.alb_sg_id

  security_groups_ids = [
    module.vpc.app_sg_id,
    module.vpc.alb_sg_id,
    module.vpc.ecs_sg_id
  ]

  availability_zones = concat(
    module.vpc.public_subnet_1a,
    module.vpc.public_subnet_1b
  )


  alb_arn            = module.ecs.alb_arn
  cert_arn           = var.cert_arn
  target_group_sufix = "df"
}


module "services" {

  for_each = var.project

  source = "./modules/ecs/service"

  alb_port            = var.alb_port

  app_repository_name = var.ecr_name

  cluster_name        = var.cluster_name
  container_port      = each.value.container_port

  vpc_id              = module.vpc.vpc_id

  public_subnet_1a    = module.vpc.public_subnet_1a
  public_subnet_1b    = module.vpc.public_subnet_1b

  ecs_sg_id           = module.vpc.ecs_sg_id
  app_sg_id           = module.vpc.app_sg_id
  alb_sg_id           = module.vpc.alb_sg_id

  security_groups_ids = [
    module.vpc.app_sg_id,
    module.vpc.alb_sg_id,
    module.vpc.ecs_sg_id
  ]

  availability_zones = concat(
    module.vpc.public_subnet_1a,
    module.vpc.public_subnet_1b,
#    module.vpc.private_subnet_1a
#    module.vpc.private_subnet_1b
  )

  alb_arn             = module.ecs.alb_arn
  cluster_id          = module.ecs.cluster_id
  container_name      = each.value.container_name
  cpu_to_scale_down   = each.value.cpu_to_scale_down
  cpu_to_scale_up     = each.value.cpu_to_scale_up
  cw_logs             = module.ecs.cw_logs
  desired_task_cpu    = each.value.desired_task_cpu
  desired_task_memory = each.value.desired_task_memory
  max_tasks           = each.value.max_tasks
  min_tasks           = each.value.min_tasks
  desired_tasks       = each.value.desired_tasks
  ecs_cluster_name    = var.cluster_name
  ecs_role            = module.ecs.ecs_role

  repository_url      = module.ecs.repository_url
  ssh_key_name        = var.ssh_key_name
  target_group_sufix  = each.value.target_group_sufix

  ec2_desired_tasks   = each.value.ec2_desired_tasks
  ec2_max_tasks       = each.value.ec2_max_tasks
  ec2_min_tasks       = each.value.ec2_min_tasks
  instance_type       = each.value.instance_type
  cert_arn            = var.cert_arn

  availability_zones_ecs_instance = concat(
    module.vpc.public_subnet_1b
  )

  name                = each.value.name
  domain_name         = each.value.domain_name
  app_service_name    = each.value.app_service_name
  listener_arn        = ""
  priority            = each.value.priority
}

module "apps_pipeline" {

  source = "./modules/pipeline"

  for_each = var.project

  name               = each.value.name
  github_repo_owner  = var.github_repo_owner
  github_repo_name   = each.value.github_repo_name
  github_oauth_token = var.github_oauth_token

  tags = {
    Environment = var.environment
  }

  # AWS CodeBuild
  deploy_type                                  = each.value.deploy_type
  privileged_mode                              = var.privileged_mode
  buildspec                                    = var.buildspec
  use_repo_access_github_token                 = var.use_repo_access_github_token
  svcs_account_github_token_aws_secret_arn     = var.svcs_account_github_token_aws_secret_arn
  svcs_account_github_token_aws_kms_cmk_arn    = var.svcs_account_github_token_aws_kms_cmk_arn
  s3_block_public_access                       = var.s3_block_public_access
  build_compute_type                           = var.build_compute_type
  codebuild_image                              = var.codebuild_image
  create_github_webhook                        = true
  ecr_name                                     = var.ecr_name
  github_branch_name                           = var.github_branch_name
  logs_retention_in_days                       = 30
  secret_arn                                   = each.value.secret_arn

  arn_bucket_pipelines                         = module.s3.arn_bucket_pipelines
  uri_bucket_pipelines                         = module.s3.uri_bucket_pipelines
  app_service_name                             = each.value.app_service_name
  cluster_name                                 = var.cluster_name
  container_name                               = each.value.container_name
  repository_url                               = module.ecs.repository_url
  subnet_ids                                   = concat(
    module.vpc.public_subnet_1a,
    module.vpc.public_subnet_1b
  )
  cluster_id                                   = module.ecs.cluster_id
}
