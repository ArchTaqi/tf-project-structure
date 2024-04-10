variable "name" {}
variable "environment" {}
variable "vpc_id" {}
variable "alb_name" {}
variable "security_group_ids" {
  type = list(string)
}
variable "public_subnet_ids" {}
variable "alb_tls_cert_arn" {}
variable "health_check_url" {}
variable "enable_deletion_protection" {
  type    = bool
  default = false
}
variable "additional_certs" {
  type        = list(string)
  description = "A list of additonal certs to add to the https listerner"
  default     = []
}
