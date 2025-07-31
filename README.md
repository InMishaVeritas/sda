# Scan-IA-Gen AWS Environment Setup

This Terraform project sets up the AWS environment for the Scan-IA-Gen project, which uses AI to augment scanning capabilities.

## Services Used

- **VPC**: Cloud isolation with endpoints and traffic control
- **S3**: Cloud data storage
- **Bedrock**: LLM library (including Claude 3.5 Sonnet)
- **Lambda**: Serverless code execution
- **Step Functions**: Orchestration
- **CloudWatch**: Log management
- **IAM**: Roles and policies for resource access control

## Prerequisites

1. An AWS account with appropriate permissions
2. Terraform installed (version >= 1.0.0)
3. AWS CLI configured with appropriate credentials
4. An existing VPC with subnets in eu-west-3a and eu-west-3b

## Important Notes

- **Bedrock Model Access**: Before using this Terraform configuration, you need to request access to the Claude 3.5 Sonnet model in the AWS Management Console. Go to the Bedrock service, then to "Model access" and request access to Claude 3.5 Sonnet.
- **Lambda Code**: This project creates dummy ZIP files for the Lambda functions and layer. In a real scenario, you would replace these with actual ZIP files containing the Lambda code and Python packages.
- **Variable Values**: Default placeholder values have been added to the variables.tf file to allow `terraform plan` to run without errors. However, for actual deployments, you should create a `terraform.tfvars` file with your real values as shown in the Usage section below.

## Usage

1. Clone this repository
2. Update the `terraform.tfvars` file with your specific values:
   ```hcl
   aws_region  = "eu-west-3"
   project_name = "scan-ia-gen"
   vpc_id      = "vpc-xxxxxxxxxxxxxxxxx"
   subnet_ids  = ["subnet-xxxxxxxxxxxxxxxxx", "subnet-yyyyyyyyyyyyyyyyy"]
   account_id  = "123456789012"
   ```
3. Initialize Terraform:
   ```bash
   terraform init
   ```
4. Plan the deployment:
   ```bash
   terraform plan
   ```
5. Apply the configuration:
   ```bash
   terraform apply
   ```

## Project Structure

- **VPC Module**: Creates security groups and endpoints for the services
- **IAM Module**: Sets up roles and policies for Lambda functions and Step Functions
- **S3 Module**: Creates the bucket and folder structure for storing data
- **Lambda Module**: Sets up the Lambda functions and layers
- **Step Functions Module**: Creates the state machine for orchestration

## Resources Created

### VPC
- Security groups for Lambda and services
- Endpoints for S3, Bedrock Runtime, Step Functions, and Lambda

### IAM
- Policies for Lambda functions and Step Functions
- Roles for Lambda functions and Step Functions

### S3
- Bucket with the following folder structure:
  - config
  - construction_pdf
    - images_CR
    - images_template
      - pages_chapitre
  - few-shot
    - assistant_text
    - user_text
    - user_images
  - pdf_CR_zip
  - pdf_CR_dezip
  - resume
  - sortie

### Lambda
- Lambda layer for Python packages
- Three Lambda functions:
  - Main Lambda function for processing CR
  - Lambda function for unzipping archives
  - Lambda function for triggering the Step Functions state machine

### Step Functions
- State machine for orchestrating the process
- CloudWatch Log Group for logging

## Outputs

The Terraform configuration outputs the following values:
- Security group IDs
- S3 bucket name
- Lambda function ARNs
- Step Functions state machine ARN

## Cleanup

To remove all resources created by this Terraform configuration:
```bash
terraform destroy
```

## Note

This Terraform configuration is designed to be used in a production environment. Make sure to review and adjust the configuration as needed for your specific requirements.
