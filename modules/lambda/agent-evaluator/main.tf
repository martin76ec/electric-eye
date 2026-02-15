data "aws_ecr_image" "agent_image" {
  repository_name = var.ecr_repo
  image_tag       = var.lambda_agent_img_tag
}

resource "aws_lambda_function" "agent_evaluator" {
  function_name = "${var.project}-${var.function_name}"
  role          = aws_iam_role.agent_evaluator_role.arn
  package_type  = "Image"
  image_uri     = "${var.ecr_url}@${data.aws_ecr_image.agent_image.id}"
  memory_size   = 1024
  timeout       = 30


  environment {
    variables = {
      S3_BUCKET_NAME          = var.bucket_name
      S3_DOCUMENT_BUCKET      = var.document_bucket_arn
      DYNAMO_RESULTS_TABLE    = var.table_name
      BEDROCK_LLM_ID          = "amazon.nova-micro-v1:0"
      BEDROCK_LLM_TEMPERATURE = "0.4"
      BEDROCK_EMBEDDING_ID    = "amazon.titan-embed-text-v2:0"
    }
  }

  tags = {
    Env     = var.env
    Project = var.project
    
  }
}

resource "aws_lambda_event_source_mapping" "agent_evaluator_sqs_trigger" {
  event_source_arn = var.queue_arn
  function_name    = aws_lambda_function.agent_evaluator.arn
  batch_size       = 1

  tags = {
    Env     = var.env
    Project = var.project
    
  }
}
