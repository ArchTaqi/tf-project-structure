output "acm_certificate_arn" {
  description = "The ARN of the certificate."
  value       = module.acm.acm_certificate_arn
}

output "acm_certificate_domain_validation_options" {
  description = "A list of attributes to feed into other resources to complete certificate validation. Can have more than one element, e.g. if SANs are defined. Only set if DNS-validation was used."
  value       = module.acm.acm_certificate_domain_validation_options
}

output "acm_certificate_status" {
  description = "Status of the certificate."
  value       = module.acm.acm_certificate_status
}

output "distinct_domain_names" {
  description = "List of distinct domain names used for the validation."
  value       = module.acm.distinct_domain_names
}
