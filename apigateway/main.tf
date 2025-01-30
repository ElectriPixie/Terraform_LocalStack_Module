# API Gateway
resource "aws_api_gateway_rest_api" "rest_api" {
  depends_on = [aws_lambda_function.hello_world]
  # The name of the REST API.
  name        = "rest_api"
  description = "A REST API"
  #tags = {
  #  "_custom_id_" = "rest_api"
  #}
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
  ]
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.resource.id
  http_method = aws_api_gateway_method.method.http_method
  status_code = "200"

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
  integration_http_method = aws_api_gateway_method.method.http_method
  type                    = "AWS"
  uri                     = "arn:aws:apigateway:us-east-1:lambda:path/2015-03-31/functions/arn:aws:lambda:us-east-1:${data.aws_caller_identity.current.account_id}:function:hello_world/invocations"
}

resource "aws_api_gateway_deployment" "deployment" {
  # This deployment depends on the completion of the integration.
  depends_on = [
    aws_api_gateway_integration.integration
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
  source_arn    = "${aws_api_gateway_rest_api.rest_api.execution_arn}/local/${var.http_method}/${var.api_path}"
}
