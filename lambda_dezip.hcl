terraform {
  source = "tfr:///terraform-aws-modules/lambda/aws?version=6.5.0"
}

include {
  path = find_in_parent_folders()
}

dependency "vpc" {
  config_path = "../vpc"
}

dependency "lambda_sg" {
  config_path = "../security_group"
}

dependency "iam_roles" {
  config_path = "../iam_roles"
}

locals {
  region = get_aws_region_current_name()
}

inputs = {
  function_name = "SCAN_IA_GEN_lambda_dezip_py_3_12"
  description   = "Lambda function to unzip files from S3"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"
  architectures = ["x86_64"]
  memory_size   = 10240
  timeout       = 900 # 15 minutes
  role_arn      = dependency.iam_roles.outputs.roles["LambdaDezipRoleForScanIAGen"].arn
  
  vpc_subnet_ids         = [for s in dependency.vpc.outputs.private_subnets : s if can(regex("eu-west-3[ab]", s))]
  vpc_security_group_ids = [dependency.lambda_sg.outputs.security_group_id]
  
  environment_variables = {
    REGION = local.region
  }
  
  # Source code will be uploaded during deployment
  create_package = false
  local_existing_package = "lambda_code/lambda_dezip.zip"
}