terraform {
  source = "tfr:///terraform-aws-modules/s3-bucket/aws?version=3.15.1"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  bucket = "scan-ia-gen"

  # S3 bucket-level Public Access Block configuration
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true

  # S3 Bucket Ownership Controls
  control_object_ownership = true
  object_ownership         = "BucketOwnerPreferred"

  # Create the folder structure
  # Note: S3 doesn't actually have folders, but we can create empty objects with trailing slashes
  # to simulate folders
  create_objects = {
    # Root level folders
    "config/" = {
      content = ""
    }
    "construction_pdf/" = {
      content = ""
    }
    "construction_pdf/images_CR/" = {
      content = ""
    }
    "construction_pdf/images_template/" = {
      content = ""
    }
    "construction_pdf/images_template/pages_chapitre/" = {
      content = ""
    }
    "few-shot/" = {
      content = ""
    }
    "few-shot/assistant_text/" = {
      content = ""
    }
    "few-shot/user_text/" = {
      content = ""
    }
    "few-shot/user_images/" = {
      content = ""
    }
    "pdf_CR_zip/" = {
      content = ""
    }
    "pdf_CR_dezip/" = {
      content = ""
    }
    "resume/" = {
      content = ""
    }
    "sortie/" = {
      content = ""
    }
  }

}
