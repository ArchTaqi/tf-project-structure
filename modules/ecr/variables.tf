variable "name" {}
variable "environment" {}
variable "repository_name" {}
variable "enabled" {}
variable "use_fullname" {}
variable "image_names" {}
variable "max_image_count" {}
variable "tag_mutability" {}
variable "scan_images_on_push" {}
variable "min_image_count" {}
variable "encryption_configuration" {
  type = object({
    encryption_type = string
    kms_key         = any
  })
  description = "ECR encryption configuration"
  default     = null
}
