variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "vpc_id" {
  description = "ID of the existing VPC"
  type        = string
}

variable "subnet_ids" {
  description = "IDs of the subnets in eu-west-3a and eu-west-3b"
  type        = list(string)
}

variable "account_id" {
  description = "AWS account ID"
  type        = string
}

variable "lambda_security_group_id" {
  description = "ID of the Lambda security group"
  type        = string
}

variable "lambda_role_arn" {
  description = "ARN of the Lambda role"
  type        = string
}

variable "lambda_dezip_role_arn" {
  description = "ARN of the Lambda dezip role"
  type        = string
}

variable "lambda_declenchement_role_arn" {
  description = "ARN of the Lambda declenchement role"
  type        = string
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}