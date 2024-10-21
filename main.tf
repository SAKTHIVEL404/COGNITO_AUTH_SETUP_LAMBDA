
provider "aws" {
  region = var.region
}

# IAM Role for Lambda Execution
resource "aws_iam_role" "lambda_exec_role" {
  name = "${var.lambda_function_name}_exec_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      Effect    = "Allow"
      Sid       = ""
    }]
  })
}

# IAM Policy for Logging
resource "aws_iam_policy" "lambda_logging" {
  name        = "${var.lambda_function_name}_logging"
  description = "IAM policy for Lambda logging"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
      Resource = "*"
    }]
  })
}

# Attach logging policy to Lambda role
resource "aws_iam_role_policy_attachment" "lambda_logging_attach" {
  policy_arn = aws_iam_policy.lambda_logging.arn
  role       = aws_iam_role.lambda_exec_role.name
}

# Lambda Function
resource "aws_lambda_function" "my_lambda" {
  function_name    = var.lambda_function_name
  role             = aws_iam_role.lambda_exec_role.arn
  handler          = var.lambda_handler
  runtime          = var.lambda_runtime
  filename         = "lambda.zip"  # Reference your local ZIP file
  source_code_hash = filebase64sha256("lambda.zip")
}

# Cognito User Pool
resource "aws_cognito_user_pool" "userpool" {
  name = var.user_pool_name

  alias_attributes       = ["email"]
  auto_verified_attributes = ["email"]

  lambda_config {
    post_confirmation = aws_lambda_function.my_lambda.arn  # Link to Lambda function for post-confirmation
  }
}

# Cognito User Pool Client
resource "aws_cognito_user_pool_client" "client" {
  name            = var.user_pool_client_name
  user_pool_id    = aws_cognito_user_pool.userpool.id
  generate_secret = false
}

# API Gateway
resource "aws_api_gateway_rest_api" "api" {
  name = var.api_name
}

# API Gateway Resource
resource "aws_api_gateway_resource" "resource" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "mylambda"  # Define the path for your resource
}

# API Gateway Method (GET)
resource "aws_api_gateway_method" "method" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.resource.id
  http_method   = "GET"  # Change to GET method
  authorization = "NONE"  # Change based on your authorization requirements
  api_key_required = false  # Adjust this based on your needs
}

# API Gateway Integration with Lambda
resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.resource.id
  http_method             = aws_api_gateway_method.method.http_method
  integration_http_method = "POST"  # The method to call on the Lambda (POST for AWS_PROXY)
  type                    = "AWS_PROXY"  # For direct integration with Lambda
  uri                     = aws_lambda_function.my_lambda.invoke_arn
}

# API Gateway Method Response
resource "aws_api_gateway_method_response" "response" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  resource_id = aws_api_gateway_resource.resource.id
  http_method = aws_api_gateway_method.method.http_method
  status_code = "200"  # Status code for successful responses
}

# API Gateway Deployment
resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = "prod"
  depends_on  = [aws_api_gateway_integration.integration]  # Ensure integration exists
}

# Lambda Permission to Allow API Gateway to Invoke the Lambda Function
resource "aws_lambda_permission" "allow_api_gateway" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.my_lambda.function_name
  principal     = "apigateway.amazonaws.com"

  # The source ARN specifies the API Gateway endpoint that can invoke the Lambda function
  source_arn = "${aws_api_gateway_rest_api.api.execution_arn}/*/*"  # Allows all methods and stages
}