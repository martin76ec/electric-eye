variable "env" {
  description = "The target environment e.g. prod, dev, staging"
  type        = string
}

variable "bucket_name" {
  description = "Name for the bucket"
  type        = string
}

variable "project" {
  type = string
}
