output "arn" {
  value = aws_sqs_queue.evaluation_queue.arn
}

output "url" {
  value = aws_sqs_queue.evaluation_queue.id
}
