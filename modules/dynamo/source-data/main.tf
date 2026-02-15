resource "aws_dynamodb_table" "source_data" {
  name         = "${var.project}-${var.table_name}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  stream_enabled   = true
  stream_view_type = "NEW_IMAGE"

  tags = {
    Env     = var.env
    Project = var.project
    
  }
}

resource "aws_pipes_pipe" "source_data_sqs" {
  name     = "${var.project}-${var.pipe_name}"
  role_arn = aws_iam_role.pipe_role.arn
  source   = aws_dynamodb_table.source_data.stream_arn
  target   = var.queue_arn

  source_parameters {
    dynamodb_stream_parameters {
      starting_position = "LATEST"
      batch_size        = 10
    }
  }

  tags = {
    Env     = var.env
    Project = var.project
    
  }
}
