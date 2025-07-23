terraform {
  source = "tfr:///terraform-aws-modules/iam/aws//modules/iam-roles?version=5.30.0"
}

include {
  path = find_in_parent_folders()
}

dependency "iam_policies" {
  config_path = "../iam_policies"
}

inputs = {
  roles = {
    # Lambda dezip role
    LambdaDezipRoleForScanIAGen = {
      name        = "LambdaDezipRoleForScanIAGen"
      description = "Accorder les permissions minimales necessaires a la fonction Lambda de dezip pour executer ses taches."
      assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Effect    = "Allow"
            Principal = { Service = "lambda.amazonaws.com" }
            Action    = "sts:AssumeRole"
          }
        ]
      })
      policies = {
        LambdaDezipPolicies = {
          policy_arns = [
            dependency.iam_policies.outputs.policies_arns["lambda-dezip-group-policy-scan-ia-gen"],
            dependency.iam_policies.outputs.policies_arns["lambda-in-vpc-policy-scan-ia-gen"]
          ]
        }
      }
    }

    # Lambda declenchement role
    LambdaDeclenchementRoleForScanIAGen = {
      name        = "LambdaDeclenchementRoleForScanIAGen"
      description = "Accorder les permissions minimales necessaires a la fonction Lambda de declenchement pour executer ses taches."
      assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Effect    = "Allow"
            Principal = { Service = "lambda.amazonaws.com" }
            Action    = "sts:AssumeRole"
          }
        ]
      })
      policies = {
        LambdaDeclenchementPolicies = {
          policy_arns = [
            dependency.iam_policies.outputs.policies_arns["lambda-declenchement-group-policy-scan-ia-gen"],
            dependency.iam_policies.outputs.policies_arns["lambda-in-vpc-policy-scan-ia-gen"]
          ]
        }
      }
    }

    # Lambda main role
    LambdaRoleForScanIAGen = {
      name        = "LambdaRoleForScanIAGen"
      description = "Accorder les permissions minimales necessaires a la fonction Lambda principale pour executer ses taches."
      assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Effect    = "Allow"
            Principal = { Service = "lambda.amazonaws.com" }
            Action    = "sts:AssumeRole"
          }
        ]
      })
      policies = {
        LambdaMainPolicies = {
          policy_arns = [
            dependency.iam_policies.outputs.policies_arns["lambda-group-policy-scan-ia-gen"],
            dependency.iam_policies.outputs.policies_arns["lambda-in-vpc-policy-scan-ia-gen"]
          ]
        }
      }
    }

    # Step Functions role
    StepFunctionsRoleForScanIAGen = {
      name        = "StepFunctionsRoleForScanIAGen"
      description = "Accorder les permissions minimales necessaires a la machine d etat step functions pour executer ses taches."
      assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
          {
            Effect    = "Allow"
            Principal = { Service = "states.amazonaws.com" }
            Action    = "sts:AssumeRole"
          }
        ]
      })
      policies = {
        StepFunctionsPolicies = {
          policy_arns = [
            dependency.iam_policies.outputs.policies_arns["stepfunctions-group-policy-scan-ia-gen"]
          ]
        }
      }
    }
  }
}
