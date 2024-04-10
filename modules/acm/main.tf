module "acm" {
  source                    = "terraform-aws-modules/acm/aws"
  zone_id                   = var.cloudflare_zone_id
  domain_name               = var.domain_name
  subject_alternative_names = var.alternate_domain_name
  create_route53_records    = false
  wait_for_validation       = false
  validation_method         = "DNS"

  tags = {
    Name        = "${var.name}-${var.environment}-acm"
    Environment = var.environment
    Terraform   = "yes"
  }
}
