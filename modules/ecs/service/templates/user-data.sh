#!/bin/bash

# ECS config
{
  echo "ECS_CLUSTER=${cluster_name}"
} >> /etc/ecs/ecs.config

sysctl -w vm.max_map_count=262144
# install the Docker volume plugin
docker plugin install rexray/ebs REXRAY_PREEMPT=true EBS_REGION=${EBS_REGION} --grant-all-permissions
start ecs
echo "Done"