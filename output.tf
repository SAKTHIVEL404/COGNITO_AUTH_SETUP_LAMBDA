output "api_gateway_url" {
  description = "The URL of the API Gateway"
  value       = "${aws_api_gateway_rest_api.api.execution_arn}/${aws_api_gateway_resource.resource.path_part}"
}

output "lambda_function_arn" {
  description = "The ARN of the Lambda function"
  value       = aws_lambda_function.my_lambda.arn
}

output "user_pool_id" {
  description = "The ID of the Cognito User Pool"
  value       = aws_cognito_user_pool.userpool.id
}

output "user_pool_client_id" {
  description = "The Client ID of the Cognito User Pool Client"
  value       = aws_cognito_user_pool_client.client.id
}
