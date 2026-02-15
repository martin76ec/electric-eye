variable "table_name" {
  description = "Name for the source data table"
  type        = string
}

variable "env" {
  description = "The target environment e.g. prod, dev, staging"
  type        = string
}

variable "pipe_name" {
  type = string
}

variable "queue_arn" {
  type = string
}

variable "project" {
  type = string
}
