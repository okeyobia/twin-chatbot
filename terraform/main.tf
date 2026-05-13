data "aws_caller_identity" "current" {}

locals {
  name_prefix = "${var.project_name}-${var.environment}"

  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
  }
}

module "s3" {
  source      = "./modules/s3"
  name_prefix = local.name_prefix
  account_id  = data.aws_caller_identity.current.account_id
  tags        = local.common_tags
}

# ACM certificate must live in us-east-1 for CloudFront to use it.
module "acm" {
  count  = var.use_custom_domain ? 1 : 0
  source = "./modules/acm"
  providers = {
    aws = aws.us_east_1
  }
  root_domain = var.root_domain
  tags        = local.common_tags
}

module "cloudfront" {
  source                    = "./modules/cloudfront"
  frontend_bucket_id        = module.s3.frontend_bucket_id
  frontend_website_endpoint = module.s3.frontend_website_endpoint
  acm_certificate_arn       = var.use_custom_domain ? module.acm[0].certificate_arn : null
  root_domain               = var.root_domain
  tags                      = local.common_tags
}

module "lambda" {
  source           = "./modules/lambda"
  name_prefix      = local.name_prefix
  tags             = local.common_tags
  memory_bucket_id = module.s3.memory_bucket_id
  bedrock_model_id = var.bedrock_model_id
  lambda_timeout   = var.lambda_timeout
  lambda_zip_path  = "${path.module}/../backend/lambda-deployment.zip"
  cors_origins     = var.use_custom_domain ? "https://${var.root_domain},https://www.${var.root_domain}" : "https://${module.cloudfront.domain_name}"
}

module "api_gateway" {
  source               = "./modules/api_gateway"
  name_prefix          = local.name_prefix
  tags                 = local.common_tags
  lambda_invoke_arn    = module.lambda.invoke_arn
  lambda_function_name = module.lambda.function_name
  throttle_burst_limit = var.api_throttle_burst_limit
  throttle_rate_limit  = var.api_throttle_rate_limit
}

module "dns" {
  count  = var.use_custom_domain ? 1 : 0
  source = "./modules/dns"
  root_domain            = var.root_domain
  cloudfront_domain_name = module.cloudfront.domain_name
  cloudfront_zone_id     = module.cloudfront.hosted_zone_id
  tags                   = local.common_tags
}
