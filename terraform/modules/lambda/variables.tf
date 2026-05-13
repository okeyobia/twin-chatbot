variable "name_prefix" {
  description = "Prefix for resource names"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
}

variable "memory_bucket_id" {
  description = "S3 bucket ID used for conversation memory storage"
  type        = string
}

variable "bedrock_model_id" {
  description = "Bedrock model ID"
  type        = string
}

variable "lambda_timeout" {
  description = "Lambda function timeout in seconds"
  type        = number
}

variable "cors_origins" {
  description = "Comma-separated allowed CORS origins"
  type        = string
}

variable "lambda_zip_path" {
  description = "Absolute path to the Lambda deployment zip"
  type        = string
}
