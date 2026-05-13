variable "root_domain" {
  description = "Apex domain name, e.g. example.com"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
}
