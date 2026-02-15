variable "function_name" {
  description = "Name of the function."
  type        = string
}

variable "queue_arn" {
  type = string
}

variable "bucket_name" {
  type = string
}

variable "bucket_arn" {
  type = string
}

variable "document_bucket_arn" {
  type    = string
  default = "aws-native-evals"
}

variable "table_name" {
  type = string
}

variable "table_arn" {
  type = string
}

variable "ecr_url" {
  type = string
}

variable "ecr_repo" {
  type = string
}

variable "lambda_agent_img_tag" {
  type = string
}

variable "env" {
  type = string
}

variable "project" {
  type = string
}
