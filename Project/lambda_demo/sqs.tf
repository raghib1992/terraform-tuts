# SQS Dead Letter Queue
resource "aws_sqs_queue" "order_dlq" {
  name = "order-dlq"
}

# Main SQS Queue with Redrive Policy
resource "aws_sqs_queue" "order_sqs" {
  name = "order-sqs"

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.order_dlq.arn
    maxReceiveCount     = 3
  })
}

# SQS Dead Letter Queue
resource "aws_sqs_queue" "refund_dlq" {
  name = "refund-dlq"
}

# Main SQS Queue with Redrive Policy
resource "aws_sqs_queue" "refund_sqs" {
  name = "refund-sqs"

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.refund_dlq.arn
    maxReceiveCount     = 3
  })
}