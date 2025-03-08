data "aws_s3_bucket" "s3_bucket" {
  bucket = aws_s3_bucket.terraform_bucket.id
}