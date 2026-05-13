variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
}

variable "lambda_invoke_arn" {
  description = "ARN used by API Gateway to invoke the Lambda function"
  type        = string
}

variable "lambda_function_name" {
  description = "Lambda function name for the permission resource"
  type        = string
}

variable "throttle_burst_limit" {
  description = "API Gateway throttle burst limit"
  type        = number
}

variable "throttle_rate_limit" {
  description = "API Gateway throttle rate limit"
  type        = number
}
