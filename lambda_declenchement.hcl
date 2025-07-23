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

dependency "s3_bucket" {
  config_path = "../s3_bucket"
}


locals {
  region = get_aws_region_current_name()
}

inputs = {
  function_name = "SCAN_IA_GEN_lambda_declenchement_py_3_12"
  description   = "Lambda function to trigger Step Functions on S3 event"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"
  architectures = ["x86_64"]
  memory_size   = 10240
  timeout       = 300 # 5 minutes
  role_arn      = dependency.iam_roles.outputs.roles["LambdaDeclenchementRoleForScanIAGen"].arn

  vpc_subnet_ids         = [for s in dependency.vpc.outputs.private_subnets : s if can(regex("eu-west-3[ab]", s))]
  vpc_security_group_ids = [dependency.lambda_sg.outputs.security_group_id]

  environment_variables = {
    REGION = local.region
  }

  # Source code will be uploaded during deployment
  create_package = false
  local_existing_package = "lambda_code/lambda_declenchement.zip"

  # S3 event trigger
  allowed_triggers = {
    S3Bucket = {
      principal  = "s3.amazonaws.com"
      source_arn = dependency.s3_bucket.outputs.s3_bucket_arn
    }
  }
}
