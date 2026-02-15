resource "aws_iam_role" "pipe_role" {
  name = "${var.project}-source-data-sqs-policy-pipe"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "pipes.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_policy" "pipe_policy" {
  name = "${var.project}-source-data-sqs-policy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "dynamodb:DescribeStream",
          "dynamodb:GetRecords",
          "dynamodb:GetShardIterator"
        ]
        Resource = aws_dynamodb_table.source_data.stream_arn
      },
      {
        Effect   = "Allow"
        Action   = "sqs:SendMessage"
        Resource = var.queue_arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "pipe_attach" {
  role       = aws_iam_role.pipe_role.name
  policy_arn = aws_iam_policy.pipe_policy.arn
}
