terraform {
  source = "tfr:///terraform-aws-modules/iam/aws//modules/iam-policies?version=5.30.0"
}

include {
  path = find_in_parent_folders()
}

locals {
  account_id = get_aws_account_id()
  region     = get_aws_region_current_name()
}

inputs = {
  policies = {
    # Lambda dezip policy
    lambda-dezip-group-policy-scan-ia-gen = {
      description = "Contient toutes les actions minimales et necessaires pour les services utilisees par la fonction lambda de dezip"
      policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Effect = "Allow"
            Action = [
              "s3:GetObject",
              "s3:PutObject",
              "s3:ListBucket",
              "s3:DeleteObject"
            ]
            Resource = [
              "arn:aws:s3:::scan-ia-gen",
              "arn:aws:s3:::scan-ia-gen/*"
            ]
          },
          {
            Effect = "Allow"
            Action = [
              "logs:CreateLogGroup",
              "logs:CreateLogStream",
              "logs:PutLogEvents"
            ]
            Resource = "arn:aws:logs:${local.region}:${local.account_id}:log-group:/aws/lambda/SCAN_IA_GEN_lambda_dezip_py_3_12:*"
          }
        ]
      })
    }

    # Lambda declenchement policy
    lambda-declenchement-group-policy-scan-ia-gen = {
      description = "Contient toutes les actions minimales et necessaires pour les services utilisees par la fonction lambda de declenchement"
      policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Effect = "Allow"
            Action = [
              "states:StartExecution"
            ]
            Resource = "arn:aws:states:${local.region}:${local.account_id}:stateMachine:SCAN_IA_GEN_macro"
          },
          {
            Effect = "Allow"
            Action = [
              "logs:CreateLogGroup",
              "logs:CreateLogStream",
              "logs:PutLogEvents"
            ]
            Resource = "arn:aws:logs:${local.region}:${local.account_id}:log-group:/aws/lambda/SCAN_IA_GEN_lambda_declenchement_py_3_12:*"
          }
        ]
      })
    }

    # Lambda main policy
    lambda-group-policy-scan-ia-gen = {
      description = "Contient toutes les actions minimales et necessaires pour les services utilisees par la fonction lambda principale"
      policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Effect = "Allow"
            Action = [
              "s3:GetObject",
              "s3:PutObject",
              "s3:ListBucket",
              "s3:DeleteObject"
            ]
            Resource = [
              "arn:aws:s3:::scan-ia-gen",
              "arn:aws:s3:::scan-ia-gen/*"
            ]
          },
          {
            Effect = "Allow"
            Action = [
              "bedrock:InvokeModel",
              "bedrock:InvokeModelWithResponseStream"
            ]
            Resource = "*"
          },
          {
            Effect = "Allow"
            Action = [
              "logs:CreateLogGroup",
              "logs:CreateLogStream",
              "logs:PutLogEvents"
            ]
            Resource = "arn:aws:logs:${local.region}:${local.account_id}:log-group:/aws/lambda/SCAN_IA_GEN_lambda_py_3_12:*"
          },
          {
            Effect = "Allow"
            Action = [
              "xray:PutTraceSegments",
              "xray:PutTelemetryRecords",
              "xray:GetSamplingRules",
              "xray:GetSamplingTargets",
              "xray:GetSamplingStatisticSummaries"
            ]
            Resource = "*"
          }
        ]
      })
    }

    # Lambda VPC policy (for all Lambda functions)
    lambda-in-vpc-policy-scan-ia-gen = {
      description = "Contient toutes les actions minimales et necessaires pour que la fonction lambda puisse s executer dans un vpc"
      policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Effect = "Allow"
            Action = [
              "ec2:CreateNetworkInterface",
              "ec2:DescribeNetworkInterfaces",
              "ec2:DeleteNetworkInterface",
              "ec2:AssignPrivateIpAddresses",
              "ec2:UnassignPrivateIpAddresses"
            ]
            Resource = "*"
          }
        ]
      })
    }

    # Step Functions policy
    stepfunctions-group-policy-scan-ia-gen = {
      description = "Contient toutes les actions minimales et necessaires pour les services utilisees par la machine d etats stepfunctions"
      policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Effect = "Allow"
            Action = [
              "lambda:InvokeFunction"
            ]
            Resource = [
              "arn:aws:lambda:${local.region}:${local.account_id}:function:SCAN_IA_GEN_lambda_py_3_12"
            ]
          },
          {
            Effect = "Allow"
            Action = [
              "xray:PutTraceSegments",
              "xray:PutTelemetryRecords",
              "xray:GetSamplingRules",
              "xray:GetSamplingTargets"
            ]
            Resource = "*"
          }
        ]
      })
    }
  }
}
