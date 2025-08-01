variable "project_name" {
  description = "Name of the project"
  type        = string
}

variable "subnet_ids" {
  description = "IDs of the subnets in the selected region's availability zones"
  type        = list(string)
  default     = []
}
