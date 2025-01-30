# Lambda Function
# This section defines the Lambda function.

resource "aws_lambda_function" "lambda" {
  filename      = var.filename
  function_name = var.function_name
  handler       = var.handler
  runtime       = var.runtime
  role          = aws_iam_role.lambda_exec.arn
  depends_on    = [aws_iam_role.lambda_exec]
}

resource "aws_iam_role" "lambda_exec" {
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
