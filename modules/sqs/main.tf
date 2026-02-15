resource "aws_sqs_queue" "evaluation_queue" {
  name                      = "${var.project}-${var.queue_name}"
  delay_seconds             = 0
  max_message_size          = 262144
  message_retention_seconds = 86400
  receive_wait_time_seconds = 0
  sqs_managed_sse_enabled   = false

  tags = {
    Env     = var.env
    Project = var.project
    
  }
}
