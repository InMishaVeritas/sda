terraform {
  source = "tfr:///terraform-aws-modules/security-group/aws?version=4.17.2"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  name        = "scan-ia-gen-services-security-group"
  description = "Gerelaccesurlesendpointsdesservicesutilisesparleslamdas"
  vpc_id      = dependency.vpc.outputs.vpc_id

  # Inbound rule from Lambda security group
  computed_ingress_with_source_security_group_id = [
    {
      rule        = "https-443-tcp"
      description = "Traficentrantdelambdaverslesservicesutilises"
      source_security_group_id = dependency.lambda_sg.outputs.security_group_id
    }
  ]
  
  # No outbound rules as specified
  egress_rules = []
  egress_with_cidr_blocks = []

  tags = {
    Name = "scan-ia-gen-services-security-group"
  }
}

# Dependency on VPC module
dependency "vpc" {
  config_path = "../vpc"
}

# Dependency on Lambda security group module
dependency "lambda_sg" {
  config_path = "../security_group"
}