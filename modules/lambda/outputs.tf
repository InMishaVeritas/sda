output "lambda_function_arn" {
  description = "ARN of the main Lambda function"
  value       = aws_lambda_function.lambda_main.arn
}

output "lambda_function_name" {
  description = "Name of the main Lambda function"
  value       = aws_lambda_function.lambda_main.function_name
}

output "lambda_dezip_function_arn" {
  description = "ARN of the dezip Lambda function"
  value       = aws_lambda_function.lambda_dezip.arn
}

output "lambda_dezip_function_name" {
  description = "Name of the dezip Lambda function"
  value       = aws_lambda_function.lambda_dezip.function_name
}

output "lambda_declenchement_function_arn" {
  description = "ARN of the declenchement Lambda function"
  value       = aws_lambda_function.lambda_declenchement.arn
}

output "lambda_declenchement_function_name" {
  description = "Name of the declenchement Lambda function"
  value       = aws_lambda_function.lambda_declenchement.function_name
}

output "lambda_layer_arn" {
  description = "ARN of the Lambda layer"
  value       = aws_lambda_layer_version.lambda_layer.arn
}