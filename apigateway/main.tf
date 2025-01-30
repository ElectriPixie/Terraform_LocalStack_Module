# API Gateway
module "wait_for_localstack" {
  source = "git::https://github.com/ElectriPixie/Terraform_LocalStack_Module.git//wait_for_localstack"
}

resource "aws_api_gateway_rest_api" "rest_api" {
  depends_on = [module.wait_for_localstack]
  # The name of the REST API.
  name        = "rest_api"
  description = "A REST API"
}

resource "aws_api_gateway_resource" "resource" {
  depends_on = [
    aws_api_gateway_rest_api.rest_api,
  ]
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id   = aws_api_gateway_rest_api.rest_api.root_resource_id
  path_part   = var.api_path
}

resource "aws_api_gateway_method" "method" {
  depends_on = [
    aws_api_gateway_rest_api.rest_api,
    aws_api_gateway_resource.resource
  ]
  # The ID of the REST API to associate with this method.
  rest_api_id = aws_api_gateway_rest_api.rest_api.id

  # The ID of the resource to associate with this method.
  resource_id = aws_api_gateway_resource.resource.id

  # The HTTP method (e.g., GET, POST, PUT, DELETE) to associate with this method.
  http_method = var.http_method

  # The authorization type for this method (e.g., NONE, AWS_IAM, etc.).
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "method_response" {
  depends_on = [
    aws_api_gateway_rest_api.rest_api,
    aws_api_gateway_resource.resource,
    aws_api_gateway_method.method
  ]
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.resource.id
  http_method = aws_api_gateway_method.method.http_method
  status_code = "200"

  response_parameters = {
    "Content-Type" = "application/json"
  }
}

data "aws_caller_identity" "current" {
}

resource "aws_api_gateway_integration" "integration" {
  depends_on = [
    aws_api_gateway_rest_api.rest_api,
    aws_api_gateway_resource.resource,
    aws_api_gateway_method.method
  ]
  rest_api_id             = aws_api_gateway_rest_api.rest_api.id
  resource_id             = aws_api_gateway_resource.resource.id
  http_method             = aws_api_gateway_method.method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:${data.aws_caller_identity.current.account_id}:function:${var.lambda_function}/invocations"
}

resource "aws_api_gateway_deployment" "deployment" {
  # This deployment depends on the completion of the integration.
  depends_on = [
    aws_api_gateway_integration.integration,
  ]
  # The ID of the REST API to associate with this deployment.
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
}

// Allow API Gateway to invoke our lambda function
resource "aws_lambda_permission" "apigw" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_function
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.rest_api.execution_arn}/*/*/*"
}
