output "lambda_security_group_id" {
  description = "ID of the Lambda security group"
  value       = module.vpc.lambda_security_group_id
}

output "services_security_group_id" {
  description = "ID of the services security group"
  value       = module.vpc.services_security_group_id
}

output "s3_bucket_name" {
  description = "Name of the S3 bucket"
  value       = module.s3.bucket_name
}

output "lambda_function_arn" {
  description = "ARN of the main Lambda function"
  value       = module.lambda.lambda_function_arn
}

output "lambda_dezip_function_arn" {
  description = "ARN of the dezip Lambda function"
  value       = module.lambda.lambda_dezip_function_arn
}

output "lambda_declenchement_function_arn" {
  description = "ARN of the declenchement Lambda function"
  value       = module.lambda.lambda_declenchement_function_arn
}

output "step_functions_state_machine_arn" {
  description = "ARN of the Step Functions state machine"
  value       = module.step_functions.state_machine_arn
}