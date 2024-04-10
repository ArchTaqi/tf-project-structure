variable "name" {
  type        = string
  description = "Solution name, which could be your organization name, e.g. 'eg' or 'cp'"
}
variable "environment" {
  type        = string
  description = "Stage, e.g. 'prod', 'staging', 'dev', or 'test'"
}
variable "cluster_name" {}
variable "app_name" {}
variable "family" {}
variable "ecs_service_name" {}
variable "fargate_cpu" {}
variable "fargate_memory" {}
variable "region" {}
variable "app_port" {}
variable "ecr_repository_url" {}
variable "target_group_arn" {}
variable "security_group_ids" {}
variable "private_subnet_ids" {}
variable "logs_retention_in_days" {}
