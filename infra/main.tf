module "dynamo_source_data" {
  source     = "../modules/dynamo/source-data"
  table_name = var.source_data_table_name
  queue_arn  = module.sqs_evaluation_queue.arn
  pipe_name  = var.source_data_pipe_name

  project = var.project
  env     = var.env
}

module "s3_source_data" {
  source      = "../modules/s3/source-data"
  bucket_name = var.source_data_bucket_name

  project = var.project
  env     = var.env
}

module "sqs_evaluation_queue" {
  source     = "../modules/sqs"
  queue_name = var.source_data_queue_name

  project = var.project
  env     = var.env
}

module "ecr_lambda_images" {
  source             = "../modules/ecr"
  ecr_container_name = var.ecr_container_name

  project = var.project
  env     = var.env
}

module "lambda_agent_evaluator" {
  source               = "../modules/lambda/agent-evaluator"
  function_name        = var.agent_evaluator_function_name
  queue_arn            = module.sqs_evaluation_queue.arn
  bucket_name          = module.s3_source_data.source_data_bucket_name
  bucket_arn           = module.s3_source_data.source_data_bucket_arn
  table_name           = module.dynamo_evaluation_results.id
  table_arn            = module.dynamo_evaluation_results.arn
  ecr_url              = module.ecr_lambda_images.url
  ecr_repo             = module.ecr_lambda_images.name
  lambda_agent_img_tag = var.agent_evaluator_img

  project = var.project
  env     = var.env
}

module "dynamo_evaluation_results" {
  source     = "../modules/dynamo/evaluation-results"
  table_name = var.evaluation_results_table_name

  project = var.project
  env     = var.env
}
