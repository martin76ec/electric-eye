variable "aws_region" {
  description = "The region to deploy in aws"
  type        = string
}

variable "env" {
  description = "The target environment e.g. prod, dev, staging"
  type        = string
}

# DynamoDB Vars

variable "source_data_table_name" {
  description = "The name of the source data table"
  type        = string
  default     = "source-data"
}

variable "evaluation_results_table_name" {
  description = "Name for evaluation results table"
  type        = string
  default     = "evaluation-results"
}

# S3 Vars

variable "source_data_bucket_name" {
  description = "The name of the source data bucket."
  type        = string
  default     = "source-data"
}

# Lambda Vars

variable "agent_evaluator_function_name" {
  description = "The name of the agent evaluator lambda function."
  type        = string
  default     = "agent-evaluator"
}

# SQS Vars

variable "source_data_queue_name" {
  type    = string
  default = "evaluation-queue"
}


variable "ecr_container_name" {
  type    = string
  default = "evaluation-ecr"
}

variable "project" {
  type = string
}

variable "source_data_pipe_name" {
  type    = string
  default = "source-data-pipe"
}

variable "agent_evaluator_img" {
  type    = string
  default = "aiops-agent-evaluator"
}
