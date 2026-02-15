resource "aws_iam_role" "agent_evaluator_role" {
  name = "${var.project}-agent-evaluator-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Effect    = "Allow",
      Action    = "sts:AssumeRole",
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

resource "aws_iam_policy" "agent_evaluator_sqs_policy" {
  name = "${var.project}-agent-evaluator-sqs-policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "sqs:ReceiveMessage",
          "sqs:DeleteMessage",
          "sqs:GetQueueAttributes"
        ],
        Resource = var.queue_arn
      },
      {
        Effect = "Allow",
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

resource "aws_iam_policy" "agent_evaluator_data_policy" {
  name = "${var.project}-agent-evaluator-data-policy"
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "dynamodb:UpdateItem",
          "dynamodb:PutItem"
        ],
        Resource = var.table_arn
      },
      {
        Effect = "Allow",
        Action = ["s3:PutObject", "s3:GetObject", "s3:ListBucket"],
        Resource = [
          "${var.bucket_arn}/*",
          # "arn:aws:s3:::${var.document_bucket_arn}/*",
          "arn:aws:s3:::aws-native-evals",
          "arn:aws:s3:::aws-native-evals/*",
        ]
      },

    ]
  })
}

resource "aws_iam_policy" "agent_evaluator_bedrock_policy" {
  name        = "${var.project}-agent-evaluator-bedrock-policy"
  description = "Allows Lambda to invoke Claude Opus"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "bedrock:InvokeModel",
          "bedrock:InvokeModelWithResponseStream"
        ],
        Resource = [
          "arn:aws:bedrock:us-east-1::foundation-model/anthropic.claude-opus-4-1-20250805-v1:0",
          "arn:aws:bedrock:us-east-1::foundation-model/amazon.nova-micro-v1:0",
          "arn:aws:bedrock:us-east-1::foundation-model/amazon.titan-embed-text-v2:0"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "agent_evaluator_sqs_policy_attach" {
  role       = aws_iam_role.agent_evaluator_role.name
  policy_arn = aws_iam_policy.agent_evaluator_sqs_policy.arn
}

resource "aws_iam_role_policy_attachment" "agent_evaluator_data_policy_attach" {
  role       = aws_iam_role.agent_evaluator_role.name
  policy_arn = aws_iam_policy.agent_evaluator_data_policy.arn
}

resource "aws_iam_role_policy_attachment" "agent_evaluator_bedrock_policy_attach" {
  role       = aws_iam_role.agent_evaluator_role.name
  policy_arn = aws_iam_policy.agent_evaluator_bedrock_policy.arn
}
