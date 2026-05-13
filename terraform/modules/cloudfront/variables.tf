variable "frontend_bucket_id" {
  description = "S3 frontend bucket ID used as origin"
  type        = string
}

variable "frontend_website_endpoint" {
  description = "S3 website endpoint for the frontend bucket"
  type        = string
}

variable "acm_certificate_arn" {
  description = "ARN of a validated ACM certificate (us-east-1). Null uses the default CloudFront cert."
  type        = string
  default     = null
}

variable "root_domain" {
  description = "Apex domain for CloudFront aliases (only used when acm_certificate_arn is set)"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
}
