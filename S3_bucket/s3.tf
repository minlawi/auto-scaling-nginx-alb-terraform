# S3 Bucket for State Storage // Bucket's name must be "Unique"
resource "aws_s3_bucket" "terraform_bucket" {
  bucket        = "lawi-bucket"
  force_destroy = true
}


# Enable versioning on the bucket
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.terraform_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

#Encrypt the state file using customer-managed keys (SSE-KMS)
resource "aws_s3_bucket_server_side_encryption_configuration" "bucket_encryption" {
  bucket = aws_s3_bucket.terraform_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

#Ensure the bucket is not public accessible
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.terraform_bucket.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}