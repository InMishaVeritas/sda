# Lambda Functions and Layers for scan-ia-gen project
# Note: This module creates dummy ZIP files for the Lambda functions, but uses a proper ZIP file for the layer.
# The layer ZIP file contains a simple "Hello World" Python module that can be imported by Lambda functions.
# The dummy files for Lambda functions are created at the end of this file using the local_file resource.

# 1. Lambda Layers

# Custom Lambda Layer
resource "aws_lambda_layer_version" "lambda_layer" {
  layer_name = "${var.project_name}-lambda-layer-python-3-12"
  description = "librairies python externes aws nécessaires aux projets"

  compatible_runtimes = ["python3.12"]
  compatible_architectures = ["x86_64"]

  # Using a proper ZIP file with a "Hello World" module
  # The ZIP file contains a simple Python package that can be imported by Lambda functions
  filename = "${path.module}/lambda_layer.zip"
  source_code_hash = filebase64sha256("${path.module}/lambda_layer.zip")
}

# 2. Lambda Functions

# Lambda Dezip Function
resource "aws_lambda_function" "lambda_dezip" {
  function_name = "${upper(var.project_name)}_lambda_dezip_py_3_12"
  description   = "Lambda function to unzip and extract content from archive in S3"

  role          = var.lambda_dezip_role_arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"
  architectures = ["x86_64"]

  # Note: In a real scenario, you would provide the actual ZIP file with the Lambda code
  # For this example, we're creating an empty function
  filename      = "${path.module}/lambda_layer.zip"
  source_code_hash = filebase64sha256("${path.module}/lambda_layer.zip")

  memory_size   = 10240
  timeout       = 900 # 15 minutes

  # VPC configuration
  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = [var.lambda_security_group_id]
  }

  # Environment variables
  environment {
    variables = {
      BUCKET_NAME = var.s3_bucket_name
    }
  }

  # Attach AWS Lambda Powertools layer
  layers = [
    aws_lambda_layer_version.lambda_layer.arn,
    "arn:aws:lambda:${data.aws_region.current.name}:017000801446:layer:AWSLambdaPowertoolsPythonV2:46" # Latest version might differ
  ]

  depends_on = [aws_lambda_layer_version.lambda_layer]
}

# Lambda Declenchement Function
resource "aws_lambda_function" "lambda_declenchement" {
  function_name = "${upper(var.project_name)}_lambda_declenchement_py_3_12"
  description   = "Lambda function to trigger the Step Functions state machine"

  role          = var.lambda_declenchement_role_arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"
  architectures = ["x86_64"]

  # Note: In a real scenario, you would provide the actual ZIP file with the Lambda code
  # For this example, we're creating an empty function
  filename      = "${path.module}/lambda_layer.zip"
  source_code_hash = filebase64sha256("${path.module}/lambda_layer.zip")

  memory_size   = 10240
  timeout       = 300 # 5 minutes

  # VPC configuration
  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = [var.lambda_security_group_id]
  }

  # Environment variables will be set later after Step Functions creation

  depends_on = [aws_lambda_layer_version.lambda_layer]
}

# Lambda Main Function
resource "aws_lambda_function" "lambda_main" {
  function_name = "${upper(var.project_name)}_lambda_py_3_12"
  description   = "Main Lambda function for processing CR (graphics, text analysis, PDF construction)"

  role          = var.lambda_role_arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"
  architectures = ["x86_64"]

  # Note: In a real scenario, you would provide the actual ZIP file with the Lambda code
  # For this example, we're creating an empty function
  filename      = "${path.module}/lambda_layer.zip"
  source_code_hash = filebase64sha256("${path.module}/lambda_layer.zip")

  memory_size   = 10240
  timeout       = 900 # 15 minutes

  # VPC configuration
  vpc_config {
    subnet_ids         = var.subnet_ids
    security_group_ids = [var.lambda_security_group_id]
  }

  # Environment variables
  environment {
    variables = {
      BUCKET_NAME = var.s3_bucket_name
    }
  }

  # Attach AWS Lambda Powertools layer
  layers = [
    aws_lambda_layer_version.lambda_layer.arn,
    "arn:aws:lambda:${data.aws_region.current.name}:017000801446:layer:AWSLambdaPowertoolsPythonV2:46" # Latest version might differ
  ]

  depends_on = [aws_lambda_layer_version.lambda_layer]
}

# 3. S3 Event Trigger for Lambda Declenchement
resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = var.s3_bucket_name

  lambda_function {
    lambda_function_arn = aws_lambda_function.lambda_declenchement.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "pdf_CR_zip/"
    filter_suffix       = ".zip"
  }

  depends_on = [aws_lambda_permission.allow_bucket]
}

# 4. Lambda Permission for S3
resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_declenchement.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = "arn:aws:s3:::${var.s3_bucket_name}"
}

data "aws_region" "current" {}
