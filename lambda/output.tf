output "api_id" {
  value = aws_api_gateway_rest_api.rest_api.id
}

output "root_resource_id" {
  value = aws_api_gateway_rest_api.resource.root_resource_id
}

output "lambda_invoke_arn" {
  value = aws_lambda_function.lambda.invoke_arn
}
