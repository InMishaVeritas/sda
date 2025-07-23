terraform {
  source = "tfr:///terraform-aws-modules/security-group/aws?version=4.17.2"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  name        = "scan-ia-gen-lambda-security-group"
  description = "Gerelaccessurlendpointdelalambda"
  vpc_id      = dependency.vpc.outputs.vpc_id

  # No inbound rules as specified
  ingress_rules = []

  # Outbound rules
  egress_with_cidr_blocks = []
  egress_with_source_prefix_list_ids = [
    {
      rule        = "https-443-tcp"
      description = "Traficsortantdelambdaverss3"
      prefix_list_ids = ["pl-23ad484a"]  # S3 prefix list for eu-west-3
    }
  ]

  # Outbound rule to services security group
  computed_egress_with_source_security_group_id = [
    {
      rule        = "https-443-tcp"
      description = "Traficsortantdelambdaverslesservicesutilises"
      source_security_group_id = dependency.services_sg.outputs.security_group_id
    }
  ]

  tags = {
    Name = "scan-ia-gen-lambda-security-group"
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
