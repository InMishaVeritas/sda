# Note: Before using this Terraform configuration, you need to request access to the Claude 3.5 Sonnet model
# in the AWS Management Console. Go to the Bedrock service, then to "Model access" and request access to Claude 3.5 Sonnet.

# VPC Security Groups and Endpoints
module "vpc" {
  source     = "./modules/vpc"
  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids
  project_name = var.project_name
  account_id = var.account_id
}

# IAM Roles and Policies
module "iam" {
  source       = "./modules/iam"
  project_name = var.project_name
  account_id   = var.account_id
  vpc_id       = var.vpc_id
}

# S3 Bucket and Folder Structure
module "s3" {
  source       = "./modules/s3"
  project_name = var.project_name
}

# Lambda Functions and Layers
module "lambda" {
  source       = "./modules/lambda"
  project_name = var.project_name
  vpc_id       = var.vpc_id
  subnet_ids   = var.subnet_ids
  account_id   = var.account_id

  lambda_security_group_id = module.vpc.lambda_security_group_id

  lambda_role_arn = module.iam.lambda_role_arn
  lambda_dezip_role_arn = module.iam.lambda_dezip_role_arn
  lambda_declenchement_role_arn = module.iam.lambda_declenchement_role_arn

  s3_bucket_name = module.s3.bucket_name

  depends_on = [module.vpc, module.iam, module.s3]
}

# Step Functions State Machine
module "step_functions" {
  source       = "./modules/step_functions"
  project_name = var.project_name
  account_id   = var.account_id

  step_functions_role_arn = module.iam.step_functions_role_arn
  lambda_function_arn = module.lambda.lambda_function_arn

  depends_on = [module.lambda]
}

# Update Lambda Declenchement with Step Functions ARN
resource "null_resource" "update_lambda_environment" {
  triggers = {
    state_machine_arn = module.step_functions.state_machine_arn
  }

  provisioner "local-exec" {
    command = <<EOF
      aws lambda update-function-configuration \
        --function-name ${module.lambda.lambda_declenchement_function_name} \
        --environment "Variables={STATE_MACHINE_ARN=${module.step_functions.state_machine_arn}}"
    EOF
  }

  depends_on = [module.lambda, module.step_functions]
}
