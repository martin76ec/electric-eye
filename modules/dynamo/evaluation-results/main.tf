resource "aws_dynamodb_table" "evaluation_results" {
  name         = "${var.project}-${var.table_name}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "id"

  attribute {
    name = "id"
    type = "S"
  }

  tags = {
    Env     = var.env
    Project = var.project
    
  }
}
