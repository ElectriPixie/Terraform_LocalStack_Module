# Lambda Function
# This section defines the Lambda function.
module "wait_for_localstack" {
  source = "git::https://github.com/ElectriPixie/Terraform_LocalStack_Module.git//wait_for_localstack"
}

resource "aws_lambda_function" "lambda" {
  filename      = var.filename
  function_name = var.lambda_function
  handler       = var.handler
  runtime       = var.runtime
  role          = aws_iam_role.lambda_exec.arn
  depends_on    = [aws_iam_role.lambda_exec]
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "lambda_exec" {
  depends_on         = [module.wait_for_localstack, data.aws_iam_policy_document.assume_role]
  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role
}
