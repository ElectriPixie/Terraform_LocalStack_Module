variable "api_path" {
  type        = string
  default     = "lambda"
  description = "The path of the API"
}

variable "http_method" {
  type        = string
  default     = "GET"
  description = "The HTTP method for the API"
}

variable "lambda_function" {
  type        = string
  default     = "lambda"
  description = "The name of the Lambda function"
}

variable "region" {
  type        = string
  default     = "us-east-1"
  description = "The default region"
}
