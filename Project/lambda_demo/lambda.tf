# Create Lambda Function
data "archive_file" "lambda_zip_file" {
  type        = "zip"
  source_dir = "${path.module}/lambda"
  output_path = "${path.module}/lambda.zip"
}

data "aws_lambda_layer_version" "shared_layer" {
  layer_name         = "lambda_layer_aws_sdk"
  compatible_runtime = "nodejs18.x"
}

resource "aws_iam_role" "lambda_role" {
  name               = "lambda_role"
  assume_role_policy = file("lambda-policy.json")
}

# resource "aws_iam_role_policy_attachment" "lambda_exec_role_attachment" {
#   role       = aws_iam_role.lambda_role.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
# }

# IAM Policy for Lambda to access SQS and logs
resource "aws_iam_role_policy" "lambda_policy" {
  name = "lambda-policy"
  role = aws_iam_role.lambda_role.id
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action   = ["sqs:SendMessage"],
        Effect   = "Allow",
        Resource = aws_sqs_queue.main_queue.arn
      },
      {
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}


resource "aws_lambda_function" "yt_lambda_function" {
  # count            = 10
  filename = data.archive_file.lambda_zip_file.output_path
  # function_name    = "DemoLambdaFunction-${count.index}"
  function_name    = "DemoLambdaFunction"
  role             = aws_iam_role.lambda_role.arn
  handler          = "index.handler"
  runtime          = "nodejs18.x"
  timeout          = 30
  source_code_hash = data.archive_file.lambda_zip_file.output_base64sha256
  layers = [data.aws_lambda_layer_version.shared_layer.arn]

  environment {
    variables = {
      VIDEO_NAME = "Lambda Terraform Demo"
      QUEUE_URL  = aws_sqs_queue.main_queue.url
    }
  }
}
