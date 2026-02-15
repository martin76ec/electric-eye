output "url" {
  value = aws_ecr_repository.ecr_lambda_images.repository_url
}

output "name" {
  value = aws_ecr_repository.ecr_lambda_images.name
}
