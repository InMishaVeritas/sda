variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "eu-west-3" # Paris region as specified in the requirements
}

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
