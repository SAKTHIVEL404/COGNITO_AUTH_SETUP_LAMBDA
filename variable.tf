variable "region" {
  description = "The AWS region to deploy resources in"
  default     = "ap-south-1"
}

variable "lambda_function_name" {
  description = "The name of the Lambda function"
  default     = "my_auth_function"
}

variable "lambda_handler" {
  description = "The Lambda function handler"
  default     = "index.handler"
}

variable "lambda_runtime" {
  description = "The Lambda runtime environment"
  default     = "nodejs16.x"
}

variable "user_pool_name" {
  description = "The name of the Cognito user pool"
  default     = "sample_auth"
}

variable "user_pool_client_name" {
  description = "The name of the Cognito user pool client"
  default     = "auth_client"
}

variable "api_name" {
  description = "The name of the API"
  default     = "interface_api"
}
