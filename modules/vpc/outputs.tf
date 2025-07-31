output "lambda_security_group_id" {
  description = "ID of the Lambda security group"
  value       = aws_security_group.lambda_security_group.id
}

output "services_security_group_id" {
  description = "ID of the services security group"
  value       = aws_security_group.services_security_group.id
}

output "s3_endpoint_id" {
  description = "ID of the S3 endpoint"
  value       = aws_vpc_endpoint.s3_endpoint.id
}

output "s3_endpoint_prefix_list_id" {
  description = "Prefix list ID of the S3 endpoint"
  value       = aws_vpc_endpoint.s3_endpoint.prefix_list_id
}

output "bedrock_runtime_endpoint_id" {
  description = "ID of the Bedrock runtime endpoint"
  value       = aws_vpc_endpoint.bedrock_runtime_endpoint.id
}

output "stepfunctions_endpoint_id" {
  description = "ID of the Step Functions endpoint"
  value       = aws_vpc_endpoint.stepfunctions_endpoint.id
}

output "lambda_endpoint_id" {
  description = "ID of the Lambda endpoint"
  value       = aws_vpc_endpoint.lambda_endpoint.id
}