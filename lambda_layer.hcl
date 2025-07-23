terraform {
  source = "tfr:///terraform-aws-modules/lambda/aws//modules/lambda-layer?version=6.5.0"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  layer_name          = "SCAN_IA_GEN_lambda-lambda-layer-python-3-12"
  description         = "librairies python externes aws nécessaires aux projets"
  compatible_runtimes = ["python3.12"]
  compatible_architectures = ["x86_64"]
  
  # Layer code will be uploaded during deployment
  create_layer_package = false
  local_existing_package = "lambda_code/lambda_layer.zip"
}