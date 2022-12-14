variable "cluster_name" {
  description = "The cluster_name"
}


variable "vpc_id" {
  description = "The VPC id"
}

variable "availability_zones" {
  type        = list(string)
  description = "The azs to use"
}

variable "public_subnet_1a" {
  description = "Public Subnet on us-east-1a"
}

variable "public_subnet_1b" {
  description = "Public Subnet on us-east-1b"
}

variable "app_sg_id" {
  description = "App Security Group"
}

variable "alb_sg_id" {
  description = "Application Load Balancer Security Group"
}

variable "ecs_sg_id" {
  description = "ECS Security Group"
}

variable "security_groups_ids" {
  type        = list(string)
  description = "Security group lists"
}

variable "app_repository_name" {
  description = "Name of ECR Repository"
}

variable "alb_port" {
  description = "ALB listener port"
}

variable "container_port" {
  description = "ALB target port"
}

variable "target_group_sufix" {}

variable "alb_arn" {}

variable "cert_arn" {}