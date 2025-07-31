# IAM Roles and Policies for scan-ia-gen project

# 1. IAM Policies

# Lambda Dezip Group Policy
resource "aws_iam_policy" "lambda_dezip_group_policy" {
  name        = "lambda-dezip-group-policy-${var.project_name}"
  description = "Contient toutes les actions minimales et necessaires pour les services utilisees par la fonction lambda de dezip"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket",
          "s3:DeleteObject"
        ]
        Effect   = "Allow"
        Resource = [
          "arn:aws:s3:::${var.project_name}",
          "arn:aws:s3:::${var.project_name}/*"
        ]
      },
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:logs:*:${var.account_id}:log-group:/aws/lambda/*"
      }
    ]
  })
}

# Lambda Declenchement Group Policy
resource "aws_iam_policy" "lambda_declenchement_group_policy" {
  name        = "lambda-declenchement-group-policy-${var.project_name}"
  description = "Contient toutes les actions minimales et necessaires pour les services utilisees par la fonction lambda de declenchement"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "states:StartExecution"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:states:*:${var.account_id}:stateMachine:${var.project_name}-macro"
      },
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:logs:*:${var.account_id}:log-group:/aws/lambda/*"
      }
    ]
  })
}

# Lambda Group Policy
resource "aws_iam_policy" "lambda_group_policy" {
  name        = "lambda-group-policy-${var.project_name}"
  description = "Contient toutes les actions minimales et necessaires pour les services utilisees par la fonction lambda principale"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket",
          "s3:DeleteObject"
        ]
        Effect   = "Allow"
        Resource = [
          "arn:aws:s3:::${var.project_name}",
          "arn:aws:s3:::${var.project_name}/*"
        ]
      },
      {
        Action = [
          "bedrock:InvokeModel",
          "bedrock:InvokeModelWithResponseStream"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:logs:*:${var.account_id}:log-group:/aws/lambda/*"
      },
      {
        Action = [
          "xray:PutTraceSegments",
          "xray:PutTelemetryRecords"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

# Lambda in VPC Policy
resource "aws_iam_policy" "lambda_in_vpc_policy" {
  name        = "lambda-in-vpc-policy-${var.project_name}"
  description = "Contient toutes les actions minimales et necessaires pour que la fonction lambda puisse s executer dans un vpc"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:CreateNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DeleteNetworkInterface",
          "ec2:AssignPrivateIpAddresses",
          "ec2:UnassignPrivateIpAddresses"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

# Step Functions Group Policy
resource "aws_iam_policy" "stepfunctions_group_policy" {
  name        = "stepfunctions-group-policy-${var.project_name}"
  description = "Contient toutes les actions minimales et necessaires pour les services utilisees par la machine d etats stepfunctions"
  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "lambda:InvokeFunction"
        ]
        Effect   = "Allow"
        Resource = "arn:aws:lambda:*:${var.account_id}:function:*"
      },
      {
        Action = [
          "s3:GetObject",
          "s3:ListBucket"
        ]
        Effect   = "Allow"
        Resource = [
          "arn:aws:s3:::${var.project_name}",
          "arn:aws:s3:::${var.project_name}/*"
        ]
      },
      {
        Action = [
          "xray:PutTraceSegments",
          "xray:PutTelemetryRecords",
          "xray:GetSamplingRules",
          "xray:GetSamplingTargets"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}

# 2. IAM Roles

# Lambda Declenchement Role
resource "aws_iam_role" "lambda_declenchement_role" {
  name = "LambdaDeclenchementRoleFor${title(var.project_name)}"
  description = "Accorder les permissions minimales necessaires a la fonction Lambda de declenchement pour executer ses taches."
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Attach policies to Lambda Declenchement Role
resource "aws_iam_role_policy_attachment" "lambda_declenchement_policy_attachment" {
  role       = aws_iam_role.lambda_declenchement_role.name
  policy_arn = aws_iam_policy.lambda_declenchement_group_policy.arn
}

resource "aws_iam_role_policy_attachment" "lambda_declenchement_vpc_policy_attachment" {
  role       = aws_iam_role.lambda_declenchement_role.name
  policy_arn = aws_iam_policy.lambda_in_vpc_policy.arn
}

# Lambda Dezip Role
resource "aws_iam_role" "lambda_dezip_role" {
  name = "LambdaDezipRoleFor${title(var.project_name)}"
  description = "Accorder les permissions minimales necessaires a la fonction Lambda de dezip pour executer ses taches."
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Attach policies to Lambda Dezip Role
resource "aws_iam_role_policy_attachment" "lambda_dezip_policy_attachment" {
  role       = aws_iam_role.lambda_dezip_role.name
  policy_arn = aws_iam_policy.lambda_dezip_group_policy.arn
}

resource "aws_iam_role_policy_attachment" "lambda_dezip_vpc_policy_attachment" {
  role       = aws_iam_role.lambda_dezip_role.name
  policy_arn = aws_iam_policy.lambda_in_vpc_policy.arn
}

# Lambda Main Role
resource "aws_iam_role" "lambda_role" {
  name = "LambdaRoleFor${title(var.project_name)}"
  description = "Accorder les permissions minimales necessaires a la fonction Lambda principale pour executer ses taches."
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# Attach policies to Lambda Main Role
resource "aws_iam_role_policy_attachment" "lambda_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_group_policy.arn
}

resource "aws_iam_role_policy_attachment" "lambda_vpc_policy_attachment" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_in_vpc_policy.arn
}

# Step Functions Role
resource "aws_iam_role" "step_functions_role" {
  name = "StepFunctionsRoleFor${title(var.project_name)}"
  description = "Accorder les permissions minimales necessaires a la machine d etat step functions pour executer ses taches."
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "states.amazonaws.com"
        }
      }
    ]
  })
}

# Attach policy to Step Functions Role
resource "aws_iam_role_policy_attachment" "step_functions_policy_attachment" {
  role       = aws_iam_role.step_functions_role.name
  policy_arn = aws_iam_policy.stepfunctions_group_policy.arn
}