variable "filename" {
  type        = string
  default     = "src/lambda/function.zip"
  description = "The filename of the Lambda function"
}

variable "function_name" {
  type        = string
  default     = "lambda"
  description = "The name of the Lambda function"
}

variable "handler" {
  type        = string
  default     = "lambda_function.lambda_handler"
  description = "The handler of the Lambda function"
}

variable "runtime" {
  type        = string
  default     = "python3.9"
  description = "The runtime of the Lambda function"
}

variable "role_name" {
  type        = string
  default     = "lambda_exec_role"
  description = "The name of the IAM role"
}
