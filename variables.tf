variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "eu-west-3" # Paris region as specified in the requirements

  # Allow overriding the region using an environment variable
  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]+$", var.aws_region))
    error_message = "The aws_region must be a valid AWS region format (e.g., eu-west-3)."
  }
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
  description = "IDs of the subnets in the selected region's availability zones"
  type        = list(string)
}

variable "account_id" {
  description = "AWS account ID"
  type        = string
}
