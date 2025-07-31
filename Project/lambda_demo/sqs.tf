# SQS Dead Letter Queue
resource "aws_sqs_queue" "dlq" {
  name = "demo-dlq"
}

# Main SQS Queue with Redrive Policy
resource "aws_sqs_queue" "main_queue" {
  name = "demo-main-queue"

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dlq.arn
    maxReceiveCount     = 3
  })
}