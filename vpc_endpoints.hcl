terraform {
  source = "tfr:///terraform-aws-modules/vpc/aws//modules/vpc-endpoints?version=5.1.2"
}

include {
  path = find_in_parent_folders()
}

locals {
  account_id = get_aws_account_id()
  region     = get_aws_region_current_name()
}

inputs = {
  vpc_id = dependency.vpc.outputs.vpc_id

  endpoints = {
    # Bedrock runtime endpoint
    bedrock-runtime = {
      service             = "bedrock-runtime"
      service_type        = "Interface"
      subnet_ids          = [for s in dependency.vpc.outputs.private_subnets : s if can(regex("eu-west-3[ab]", s))]
      security_group_ids  = [dependency.services_sg.outputs.security_group_id]
      private_dns_enabled = true
      tags                = { Name = "scan-ia-gen-bedrock-runtime-endpoint" }
      policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Effect    = "Allow"
            Principal = "*"
            Action    = [
              "bedrock:InvokeModel",
              "bedrock:InvokeModelWithResponseStream"
            ]
            Resource  = "*"
          }
        ]
      })
    }
    
    # S3 endpoint (Gateway type)
    s3 = {
      service             = "s3"
      service_type        = "Gateway"
      route_table_ids     = dependency.vpc.outputs.private_route_table_ids
      tags                = { Name = "scan-ia-gen-s3-endpoint" }
      policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Effect    = "Allow"
            Principal = "*"
            Action    = [
              "s3:GetObject",
              "s3:PutObject",
              "s3:ListBucket",
              "s3:DeleteObject"
            ]
            Resource  = [
              "arn:aws:s3:::scan-ia-gen",
              "arn:aws:s3:::scan-ia-gen/*"
            ]
          }
        ]
      })
    }
    
    # Step Functions endpoint
    states = {
      service             = "states"
      service_type        = "Interface"
      subnet_ids          = [for s in dependency.vpc.outputs.private_subnets : s if can(regex("eu-west-3[ab]", s))]
      security_group_ids  = [dependency.services_sg.outputs.security_group_id]
      private_dns_enabled = true
      tags                = { Name = "scan-ia-gen-stepfunctions-endpoint" }
      policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Effect    = "Allow"
            Principal = "*"
            Action    = [
              "states:StartExecution",
              "states:DescribeExecution"
            ]
            Resource  = "arn:aws:states:${local.region}:${local.account_id}:stateMachine:SCAN_IA_GEN_macro"
          }
        ]
      })
    }
    
    # Lambda endpoint
    lambda = {
      service             = "lambda"
      service_type        = "Interface"
      subnet_ids          = [for s in dependency.vpc.outputs.private_subnets : s if can(regex("eu-west-3[ab]", s))]
      security_group_ids  = [dependency.lambda_sg.outputs.security_group_id]
      private_dns_enabled = true
      tags                = { Name = "scan-ia-gen-lambda-endpoint" }
      policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Effect    = "Allow"
            Principal = "*"
            Action    = [
              "lambda:InvokeFunction"
            ]
            Resource  = [
              "arn:aws:lambda:${local.region}:${local.account_id}:function:SCAN_IA_GEN_lambda_py_3_12",
              "arn:aws:lambda:${local.region}:${local.account_id}:function:SCAN_IA_GEN_lambda_dezip_py_3_12",
              "arn:aws:lambda:${local.region}:${local.account_id}:function:SCAN_IA_GEN_lambda_declenchement_py_3_12"
            ]
          }
        ]
      })
    }
  }
}

# Dependency on VPC module
dependency "vpc" {
  config_path = "../vpc"
}

# Dependency on services security group module
dependency "services_sg" {
  config_path = "../services_security_group"
}

# Dependency on Lambda security group module
dependency "lambda_sg" {
  config_path = "../security_group"
}