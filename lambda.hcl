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
  for_each = {
    # Lambda dezip function
    dezip = {
      function_name = "SCAN_IA_GEN_lambda_dezip_py_3_12"
      description   = "Lambda function to unzip files from S3"
      handler       = "lambda_function.lambda_handler"
      runtime       = "python3.12"
      architectures = ["x86_64"]
      memory_size   = 10240
      timeout       = 900 # 15 minutes
      role_arn      = dependency.iam_roles.outputs.roles["LambdaDezipRoleForScanIAGen"].arn
      vpc_config = {
        subnet_ids         = [for s in dependency.vpc.outputs.private_subnets : s if can(regex("eu-west-3[ab]", s))]
        security_group_ids = [dependency.lambda_sg.outputs.security_group_id]
      }
      environment_variables = {
        REGION = local.region
      }
    }
    
    # Lambda declenchement function
    declenchement = {
      function_name = "SCAN_IA_GEN_lambda_declenchement_py_3_12"
      description   = "Lambda function to trigger Step Functions on S3 event"
      handler       = "lambda_function.lambda_handler"
      runtime       = "python3.12"
      architectures = ["x86_64"]
      memory_size   = 10240
      timeout       = 300 # 5 minutes
      role_arn      = dependency.iam_roles.outputs.roles["LambdaDeclenchementRoleForScanIAGen"].arn
      vpc_config = {
        subnet_ids         = [for s in dependency.vpc.outputs.private_subnets : s if can(regex("eu-west-3[ab]", s))]
        security_group_ids = [dependency.lambda_sg.outputs.security_group_id]
      }
      environment_variables = {
        REGION = local.region
        # STATE_MACHINE_ARN will be added later after Step Functions creation
      }
    }
    
    # Lambda main function
    main = {
      function_name = "SCAN_IA_GEN_lambda_py_3_12"
      description   = "Main Lambda function for processing CR"
      handler       = "lambda_function.lambda_handler"
      runtime       = "python3.12"
      architectures = ["x86_64"]
      memory_size   = 10240
      timeout       = 900 # 15 minutes
      role_arn      = dependency.iam_roles.outputs.roles["LambdaRoleForScanIAGen"].arn
      vpc_config = {
        subnet_ids         = [for s in dependency.vpc.outputs.private_subnets : s if can(regex("eu-west-3[ab]", s))]
        security_group_ids = [dependency.lambda_sg.outputs.security_group_id]
      }
      environment_variables = {
        REGION = local.region
      }
      layers = [
        "arn:aws:lambda:${local.region}:017000801446:layer:AWSLambdaPowertoolsPythonV2:46", # Latest version at time of writing
        dependency.lambda_layer.outputs.lambda_layer_arn
      ]
    }
  }
}

# Lambda layer for main function
dependency "lambda_layer" {
  config_path = "../lambda_layer"
}