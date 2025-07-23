terraform {
  source = "tfr:///terraform-aws-modules/s3-bucket/aws//modules/notification?version=3.15.1"
}

include {
  path = find_in_parent_folders()
}

dependency "s3_bucket" {
  config_path = "../s3_bucket"
}

dependency "lambda_declenchement" {
  config_path = "../lambda_declenchement"
}

inputs = {
  bucket = dependency.s3_bucket.outputs.s3_bucket_id
  
  lambda_notifications = {
    lambda_declenchement = {
      function_arn  = dependency.lambda_declenchement.outputs.lambda_function_arn
      function_name = dependency.lambda_declenchement.outputs.lambda_function_name
      events        = ["s3:ObjectCreated:*"]
      filter_prefix = "pdf_CR_zip/"
      filter_suffix = ".zip"
    }
  }
}