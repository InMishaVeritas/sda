terraform {
  source = "tfr:///terraform-aws-modules/step-functions/aws?version=3.1.0"
}

include {
  path = find_in_parent_folders()
}

dependency "iam_roles" {
  config_path = "../iam_roles"
}

dependency "lambda_main" {
  config_path = "../lambda_main"
}

locals {
  account_id = get_aws_account_id()
  region     = get_aws_region_current_name()
}

inputs = {
  name     = "SCAN_IA_GEN_macro"
  role_arn = dependency.iam_roles.outputs.roles["StepFunctionsRoleForScanIAGen"].arn
  type     = "STANDARD"
  
  definition = jsonencode({
    Comment = "State machine for SCAN_IA_GEN project",
    StartAt = "ProcessCR",
    States = {
      ProcessCR = {
        Type = "Task",
        Resource = dependency.lambda_main.outputs.lambda_function_arn,
        End = true
      }
    }
  })
  
  logging_configuration = {
    include_execution_data = true
    level                  = "ALL"
  }
  
  tracing_configuration = {
    enabled = true
  }
}