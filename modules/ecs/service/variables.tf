variable "cluster_name" {
  description = "The cluster_name"
}

variable "container_name" {
  description = "Container name"
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

variable "desired_tasks" {
  description = "Number of containers desired to run the application task"
}

variable "desired_task_cpu" {
  description = "Task CPU Limit"
}

variable "desired_task_memory" {
  description = "Task Memory Limit"
}

variable "min_tasks" {
  description = "Minimum"
}

variable "max_tasks" {
  description = "Maximum"
}

variable "cpu_to_scale_up" {
  description = "CPU % to Scale Up the number of containers"
}

variable "cpu_to_scale_down" {
  description = "CPU % to Scale Down the number of containers"
}


variable "cluster_id" {}

variable "ecs_cluster_name" {}

variable "alb_arn" {}

variable "repository_url" {
}
variable "cw_logs" {
}
variable "ecs_role" {}
variable "ssh_key_name" {
}

variable "target_group_sufix" {}

variable "ec2_min_tasks" {
  description = "Minimum"
}

variable "ec2_max_tasks" {
  description = "Maximum"
}

variable "ec2_desired_tasks" {
  description = "Number of containers desired to run the application task"
}

variable "instance_type" {
}

variable "cert_arn" {}

variable "availability_zones_ecs_instance" {
  type        = list(string)
  description = "The azs to use"
}

variable "name" {}

variable "domain_name" {}
variable "app_service_name" {}

variable "listener_arn" {}
variable "priority" {}