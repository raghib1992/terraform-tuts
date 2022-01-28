data "archive_file" "athena_query_file" {
  type        = "zip"
  source_file = "./lambda_athena_query.py"
  output_path = "./lambda_athena_query.zip"
}

resource "aws_lambda_function" "athena_query_function" {
  filename      = data.archive_file.athena_query_file.output_path
  function_name = "athena_query_function"
  role          = aws_iam_role.athena_query_role.arn
  handler       = "athena_query_function.lambda_handler"
  source_code_hash = data.archive_file.athena_query_file.output_base64sha256
  runtime = "python3.7"
  timeout = 63
}