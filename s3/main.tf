# Create S3 bucket
resource "aws_s3_bucket" "clops_s3_bucket" {
  bucket = var.bucket_name
}

# Block public access settings
resource "aws_s3_bucket_public_access_block" "block_public_access" {
  bucket = aws_s3_bucket.clops_s3_bucket.id

  block_public_acls   = true
  block_public_policy = true
  ignore_public_acls  = true
  restrict_public_buckets = true
}
