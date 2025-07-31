output "lambda_role_arn" {
  description = "ARN of the Lambda role"
  value       = aws_iam_role.lambda_role.arn
}

output "lambda_dezip_role_arn" {
  description = "ARN of the Lambda dezip role"
  value       = aws_iam_role.lambda_dezip_role.arn
}

output "lambda_declenchement_role_arn" {
  description = "ARN of the Lambda declenchement role"
  value       = aws_iam_role.lambda_declenchement_role.arn
}

output "step_functions_role_arn" {
  description = "ARN of the Step Functions role"
  value       = aws_iam_role.step_functions_role.arn
}

output "lambda_dezip_policy_arn" {
  description = "ARN of the Lambda dezip policy"
  value       = aws_iam_policy.lambda_dezip_group_policy.arn
}

output "lambda_declenchement_policy_arn" {
  description = "ARN of the Lambda declenchement policy"
  value       = aws_iam_policy.lambda_declenchement_group_policy.arn
}

output "lambda_policy_arn" {
  description = "ARN of the Lambda policy"
  value       = aws_iam_policy.lambda_group_policy.arn
}

output "lambda_in_vpc_policy_arn" {
  description = "ARN of the Lambda in VPC policy"
  value       = aws_iam_policy.lambda_in_vpc_policy.arn
}

output "stepfunctions_policy_arn" {
  description = "ARN of the Step Functions policy"
  value       = aws_iam_policy.stepfunctions_group_policy.arn
}