resource "aws_s3_bucket" "source_data_bucket" {
  bucket = "${var.project}-${var.bucket_name}"

  tags = {
    Env     = var.env
    Project = var.project
    
  }
}

resource "aws_s3_bucket_public_access_block" "source_data_bucket_pab" {
  bucket = aws_s3_bucket.source_data_bucket.id

  block_public_acls       = true
  ignore_public_acls      = true
  block_public_policy     = true
  restrict_public_buckets = true
}
