

#####################################
# Local
#####################################
resource "random_password" "random_password" {
  count       = 5
  length      = 24
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
  numeric     = true
  special     = false
}

resource "random_password" "random_keys" {
  length      = 36
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
  numeric     = true
  special     = true
}

resource "random_string" "rnd" {
  length      = 8
  min_numeric = 4
  special     = false
  lower       = true
}

locals {
  postgres_db_name            = "${var.name}_${var.environment}_db"
  postgres_db_username        = "secret_user"
  postgres_db_password        = random_password.random_password[1].result
  postgres_db_master_password = random_password.random_password[2].result
  postgres_db_port            = 5432
  logs_retention_in_days      = 3
  bastion_ssh_user            = "ubuntu"
}

#####################################
# VPC & Subnets
#####################################
module "network" {
  source = "../../modules/network"

  name        = var.name
  environment = var.environment

  # VPC vars
  cidr_block                                = var.cidr_block
  default_security_group_deny_all           = var.default_security_group_deny_all
  dns_hostnames_enabled                     = var.dns_hostnames_enabled
  dns_support_enabled                       = var.dns_support_enabled
  instance_tenancy                          = var.instance_tenancy
  internet_gateway_enabled                  = var.internet_gateway_enabled
  ipv6_egress_only_internet_gateway_enabled = var.ipv6_egress_only_internet_gateway_enabled
  ipv6_enabled                              = var.ipv6_enabled
  vpc_logs_retention_in_days                = local.logs_retention_in_days

  # Subnets vars
  availability_zones      = var.availability_zones
  map_public_ip_on_launch = var.map_public_ip_on_launch
  max_nats                = var.max_nats
  nat_elastic_ips         = var.nat_elastic_ips
  nat_gateway_enabled     = var.nat_gateway_enabled
  nat_instance_enabled    = var.nat_instance_enabled
  nat_instance_type       = var.nat_instance_type
}
