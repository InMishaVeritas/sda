# Step Functions State Machine for scan-ia-gen project

# Create the Step Functions State Machine
resource "aws_sfn_state_machine" "state_machine" {
  name     = "${var.project_name}-macro"
  role_arn = var.step_functions_role_arn
  
  definition = jsonencode({
    Comment = "State machine for scan-ia-gen project",
    StartAt = "ProcessCR",
    States = {
      ProcessCR = {
        Type = "Map",
        ItemsPath = "$.files",
        MaxConcurrency = 5,
        Iterator = {
          StartAt = "ProcessSingleCR",
          States = {
            ProcessSingleCR = {
              Type = "Task",
              Resource = var.lambda_function_arn,
              End = true
            }
          }
        },
        End = true
      }
    }
  })
  
  logging_configuration {
    log_destination        = "${aws_cloudwatch_log_group.step_functions_log_group.arn}:*"
    include_execution_data = true
    level                  = "ALL"
  }
  
  tracing_configuration {
    enabled = true
  }
  
  tags = {
    Name = "${var.project_name}-macro"
  }
}

# Create CloudWatch Log Group for Step Functions
resource "aws_cloudwatch_log_group" "step_functions_log_group" {
  name              = "/aws/states/${var.project_name}-macro"
  retention_in_days = 30
  
  tags = {
    Name = "/aws/states/${var.project_name}-macro"
  }
}