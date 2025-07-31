# VPC Security Groups and Endpoints for scan-ia-gen project

# 1. Security Groups
# Lambda Security Group
resource "aws_security_group" "lambda_security_group" {
  name        = "${var.project_name}-lambda-security-group"
  description = "Gere l acces sur le endpoint de la lambda"
  vpc_id      = var.vpc_id

  # No inbound rules initially
  
  # Outbound rule for S3
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    prefix_list_ids = [aws_vpc_endpoint.s3_endpoint.prefix_list_id]
    description = "Trafic sortant de lambda vers s3"
  }

  tags = {
    Name = "${var.project_name}-lambda-security-group"
  }
}

# Services Security Group
resource "aws_security_group" "services_security_group" {
  name        = "${var.project_name}-services-security-group"
  description = "Gere l acces sur les endpoints des services utilises par les lambdas"
  vpc_id      = var.vpc_id

  # Inbound rule from Lambda Security Group
  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [aws_security_group.lambda_security_group.id]
    description     = "Trafic entrant de lambda vers les services utilises"
  }

  # No outbound rules

  tags = {
    Name = "${var.project_name}-services-security-group"
  }
}

# Add outbound rule to Lambda Security Group for services
resource "aws_security_group_rule" "lambda_to_services" {
  security_group_id        = aws_security_group.lambda_security_group.id
  type                     = "egress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.services_security_group.id
  description              = "Trafic sortant de lambda vers les services utilises"
}

# 2. VPC Endpoints
# S3 Gateway Endpoint
resource "aws_vpc_endpoint" "s3_endpoint" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${data.aws_region.current.name}.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = data.aws_route_tables.vpc_route_tables.ids
  
  tags = {
    Name = "${var.project_name}-s3-endpoint"
  }

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
        Effect = "Allow"
        Principal = "*"
        Resource = [
          "arn:aws:s3:::${var.project_name}",
          "arn:aws:s3:::${var.project_name}/*"
        ]
      }
    ]
  })
}

# Bedrock Runtime Interface Endpoint
resource "aws_vpc_endpoint" "bedrock_runtime_endpoint" {
  vpc_id             = var.vpc_id
  service_name       = "com.amazonaws.${data.aws_region.current.name}.bedrock-runtime"
  vpc_endpoint_type  = "Interface"
  subnet_ids         = var.subnet_ids
  security_group_ids = [aws_security_group.services_security_group.id]
  private_dns_enabled = true
  
  tags = {
    Name = "${var.project_name}-bedrock-runtime-endpoint"
  }

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "bedrock:InvokeModel",
          "bedrock:InvokeModelWithResponseStream"
        ]
        Effect = "Allow"
        Principal = "*"
        Resource = "*"
      }
    ]
  })
}

# Step Functions Interface Endpoint
resource "aws_vpc_endpoint" "stepfunctions_endpoint" {
  vpc_id             = var.vpc_id
  service_name       = "com.amazonaws.${data.aws_region.current.name}.states"
  vpc_endpoint_type  = "Interface"
  subnet_ids         = var.subnet_ids
  security_group_ids = [aws_security_group.services_security_group.id]
  private_dns_enabled = true
  
  tags = {
    Name = "${var.project_name}-stepfunctions-endpoint"
  }

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "states:StartExecution",
          "states:DescribeExecution",
          "states:GetExecutionHistory"
        ]
        Effect = "Allow"
        Principal = "*"
        Resource = "arn:aws:states:${data.aws_region.current.name}:${var.account_id}:stateMachine:${var.project_name}-macro"
      }
    ]
  })
}

# Lambda Interface Endpoint
resource "aws_vpc_endpoint" "lambda_endpoint" {
  vpc_id             = var.vpc_id
  service_name       = "com.amazonaws.${data.aws_region.current.name}.lambda"
  vpc_endpoint_type  = "Interface"
  subnet_ids         = var.subnet_ids
  security_group_ids = [aws_security_group.lambda_security_group.id]
  private_dns_enabled = true
  
  tags = {
    Name = "${var.project_name}-lambda-endpoint"
  }

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "lambda:InvokeFunction"
        ]
        Effect = "Allow"
        Principal = "*"
        Resource = "arn:aws:lambda:${data.aws_region.current.name}:${var.account_id}:function:*"
      }
    ]
  })
}

# Data sources
data "aws_region" "current" {}

data "aws_route_tables" "vpc_route_tables" {
  vpc_id = var.vpc_id
  
  filter {
    name   = "association.subnet-id"
    values = var.subnet_ids
  }
}