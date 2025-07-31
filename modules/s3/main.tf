# S3 Bucket and Folder Structure for scan-ia-gen project
data "aws_region" "current" {}

# Create the S3 bucket
resource "aws_s3_bucket" "bucket" {
  bucket = "${var.project_name}-${data.aws_region.current.name}"

  tags = {
    Name = var.project_name
  }
}

# Block public access to the bucket
resource "aws_s3_bucket_public_access_block" "bucket_access_block" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Create the folder structure
# config folder
resource "aws_s3_object" "config_folder" {
  bucket  = aws_s3_bucket.bucket.id
  key     = "config/"
  content_type = "application/x-directory"
}

# construction_pdf folder
resource "aws_s3_object" "construction_pdf_folder" {
  bucket  = aws_s3_bucket.bucket.id
  key     = "construction_pdf/"
  content_type = "application/x-directory"
}

# construction_pdf/images_CR folder
resource "aws_s3_object" "images_cr_folder" {
  bucket  = aws_s3_bucket.bucket.id
  key     = "construction_pdf/images_CR/"
  content_type = "application/x-directory"
}

# construction_pdf/images_template folder
resource "aws_s3_object" "images_template_folder" {
  bucket  = aws_s3_bucket.bucket.id
  key     = "construction_pdf/images_template/"
  content_type = "application/x-directory"
}

# construction_pdf/images_template/pages_chapitre folder
resource "aws_s3_object" "pages_chapitre_folder" {
  bucket  = aws_s3_bucket.bucket.id
  key     = "construction_pdf/images_template/pages_chapitre/"
  content_type = "application/x-directory"
}

# few-shot folder
resource "aws_s3_object" "few_shot_folder" {
  bucket  = aws_s3_bucket.bucket.id
  key     = "few-shot/"
  content_type = "application/x-directory"
}

# few-shot/assistant_text folder
resource "aws_s3_object" "assistant_text_folder" {
  bucket  = aws_s3_bucket.bucket.id
  key     = "few-shot/assistant_text/"
  content_type = "application/x-directory"
}

# few-shot/user_text folder
resource "aws_s3_object" "user_text_folder" {
  bucket  = aws_s3_bucket.bucket.id
  key     = "few-shot/user_text/"
  content_type = "application/x-directory"
}

# few-shot/user_images folder
resource "aws_s3_object" "user_images_folder" {
  bucket  = aws_s3_bucket.bucket.id
  key     = "few-shot/user_images/"
  content_type = "application/x-directory"
}

# pdf_CR_zip folder
resource "aws_s3_object" "pdf_cr_zip_folder" {
  bucket  = aws_s3_bucket.bucket.id
  key     = "pdf_CR_zip/"
  content_type = "application/x-directory"
}

# pdf_CR_dezip folder
resource "aws_s3_object" "pdf_cr_dezip_folder" {
  bucket  = aws_s3_bucket.bucket.id
  key     = "pdf_CR_dezip/"
  content_type = "application/x-directory"
}

# resume folder
resource "aws_s3_object" "resume_folder" {
  bucket  = aws_s3_bucket.bucket.id
  key     = "resume/"
  content_type = "application/x-directory"

  # Add lifecycle configuration to handle the case where the object might not exist
  lifecycle {
    prevent_destroy = false
    ignore_changes = [
      etag,
      metadata,
    ]
  }
}

# sortie folder
resource "aws_s3_object" "sortie_folder" {
  bucket  = aws_s3_bucket.bucket.id
  key     = "sortie/"
  content_type = "application/x-directory"
}

# Set up bucket versioning
resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Set up server-side encryption
resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_encryption" {
  bucket = aws_s3_bucket.bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
