output "source_data_bucket_arn" {
  description = "Source data bucket ARN."
  value       = aws_s3_bucket.source_data_bucket.arn
}

output "source_data_bucket_name" {
  description = "Source data bucket ARN."
  value       = aws_s3_bucket.source_data_bucket.id
}
