terraform {
  source = "tfr:///terraform-aws-modules/lambda/aws?version=6.5.0"
}

include {
  path = find_in_parent_folders()
}

dependency "lambda_declenchement" {
  config_path = "../lambda_declenchement"
}

dependency "step_functions" {
  config_path = "../step_functions"
}

inputs = {
  create_function = false
  function_name   = dependency.lambda_declenchement.outputs.lambda_function_name
  
  # Only update environment variables
  update_environment_variables = true
  environment_variables = {
    REGION = dependency.lambda_declenchement.outputs.lambda_function_environment_variables["REGION"]
    STATE_MACHINE_ARN = dependency.step_functions.outputs.state_machine_arn
  }
}