output "source_data_table_arn" {
  description = "Source data table ARN."
  value       = aws_dynamodb_table.source_data.arn
}

output "source_data_table_stream_arn" {
  description = "The ARN of the DynamoDB stream."
  value       = aws_dynamodb_table.source_data.stream_arn
}
