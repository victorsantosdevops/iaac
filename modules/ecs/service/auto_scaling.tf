data "aws_region" "current" {}

data "aws_ami" "ecs" {
  most_recent = true # get the latest version

  filter {
    name = "name"
    values = [
      "amzn2-ami-ecs-*"] # ECS optimized image
  }

  filter {
    name = "virtualization-type"
    values = [
      "hvm"]
  }

  owners = [
    "amazon" # Only official images
  ]
}

data "template_file" "user_data" {
  template = file("${path.module}/templates/user_data.config.tpl")
  vars = {
    ECS_CLUSTER = var.cluster_name
    EBS_REGION  = data.aws_region.current.name
  }
}
#
#
#resource "aws_launch_configuration" "ecs_launch_config" {
#    image_id             = data.aws_ami.ecs.id
#    iam_instance_profile = aws_iam_instance_profile.ecs_agent.name
#    security_groups      = [var.ecs_sg_id]
#    user_data = templatefile("${path.module}/templates/user-data.sh", {
#    cluster_name = var.cluster_name,
#      EBS_REGION = "${local.aws_region}b"
#  })
#    instance_type        = var.instance_type
#    key_name             = var.ssh_key_name
#
#    enable_monitoring           = true
##    ebs_optimized               = true
#
#    root_block_device {
#      volume_type                 = "standard"
#      volume_size                 = 100
#    }
#
#    lifecycle {
#      create_before_destroy = true
#    }
#
#
#}
#
#resource "aws_autoscaling_group" "failure_analysis_ecs_asg" {
#    name                      = "asg-${var.name}"
#    vpc_zone_identifier       = var.availability_zones_ecs_instance
#    launch_configuration      = aws_launch_configuration.ecs_launch_config.name
#
#    desired_capacity          = var.ec2_desired_tasks
#    min_size                  = var.ec2_min_tasks
#    max_size                  = var.ec2_max_tasks
#    health_check_grace_period = 300
#    health_check_type         = "EC2"
#
#    lifecycle {
#      create_before_destroy = true
#    }
#
#    tags = [
#      {
#        key                 = "Name",
#        value               = var.cluster_name,
#
#        # Make sure EC2 instances are tagged with this tag as well
#        propagate_at_launch = true
#      }
#    ]
#}


resource "aws_appautoscaling_target" "app_scale_target" {
  service_namespace  = "ecs"
  resource_id        = "service/${var.ecs_cluster_name}/${aws_ecs_service.web-server.name}"
  scalable_dimension = "ecs:service:DesiredCount"

  max_capacity       = var.max_tasks
  min_capacity       = var.min_tasks
}

// Trocar aqui
resource "aws_cloudwatch_metric_alarm" "cpu_utilization_high" {
  alarm_name          = "${var.cluster_name}-CPU-Utilization-High"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = var.cpu_to_scale_up

  dimensions = {
    ClusterName = var.ecs_cluster_name
    ServiceName = aws_ecs_service.web-server.name
  }

  alarm_actions = [aws_appautoscaling_policy.app_up.arn]
}

resource "aws_appautoscaling_policy" "app_up" {
  name               = "${var.cluster_name}-app-scale-up"
  service_namespace  = aws_appautoscaling_target.app_scale_target.service_namespace
  resource_id        = aws_appautoscaling_target.app_scale_target.resource_id
  scalable_dimension = aws_appautoscaling_target.app_scale_target.scalable_dimension

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 60
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_lower_bound = 0
      scaling_adjustment          = 1
    }
  }
}

resource "aws_cloudwatch_metric_alarm" "cpu_utilization_low" {
  alarm_name          = "${var.cluster_name}-CPU-Utilization-Low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "60"
  statistic           = "Average"
  threshold           = var.cpu_to_scale_down

  dimensions = {
    ClusterName = var.ecs_cluster_name
    ServiceName = aws_ecs_service.web-server.name
  }

  alarm_actions = [aws_appautoscaling_policy.app_down.arn]
}


resource "aws_appautoscaling_policy" "app_down" {
  name               = "${var.cluster_name}-scale-down"
  service_namespace  = aws_appautoscaling_target.app_scale_target.service_namespace
  resource_id        = aws_appautoscaling_target.app_scale_target.resource_id
  scalable_dimension = aws_appautoscaling_target.app_scale_target.scalable_dimension

  step_scaling_policy_configuration {
    adjustment_type         = "ChangeInCapacity"
    cooldown                = 300
    metric_aggregation_type = "Average"

    step_adjustment {
      metric_interval_upper_bound = 0
      scaling_adjustment          = -1
    }
  }
}

#------------------------------------------------------------------------------
# AWS Auto Scaling - Scaling Target
#------------------------------------------------------------------------------
resource "aws_appautoscaling_target" "scale_target" {
  service_namespace  = "ecs"
  resource_id        = aws_appautoscaling_target.app_scale_target.resource_id
  scalable_dimension = "ecs:service:DesiredCount"
  min_capacity       = var.min_tasks
  max_capacity       = var.max_tasks
}