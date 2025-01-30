# Lambda Function
# This section defines the Lambda function.

resource "aws_lambda_function" "hello_world" {
  filename      = var.filename
  function_name = var.function_name
  handler       = var.handler
  runtime       = var.runtime
  role          = aws_iam_role.lambda_exec.arn
  depends_on    = [null_resource.wait_for_lambda]
}

resource "aws_iam_role" "lambda_exec" {
  depends_on = [
    null_resource.wait_for_lambda,
  ]
  name = var.role_name

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}
