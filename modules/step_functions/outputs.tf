output "state_machine_arn" {
  description = "ARN of the Step Functions state machine"
  value       = aws_sfn_state_machine.state_machine.arn
}

output "state_machine_name" {
  description = "Name of the Step Functions state machine"
  value       = aws_sfn_state_machine.state_machine.name
}

output "cloudwatch_log_group_arn" {
  description = "ARN of the CloudWatch Log Group for Step Functions"
  value       = aws_cloudwatch_log_group.step_functions_log_group.arn
}