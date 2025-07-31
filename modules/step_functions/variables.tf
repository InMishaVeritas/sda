variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "account_id" {
  description = "AWS account ID"
  type        = string
}

variable "step_functions_role_arn" {
  description = "ARN of the Step Functions role"
  type        = string
}

variable "lambda_function_arn" {
  description = "ARN of the main Lambda function"
  type        = string
}