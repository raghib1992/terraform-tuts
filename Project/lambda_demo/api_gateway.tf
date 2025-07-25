#2 Create API Gateway
resource "aws_api_gateway_rest_api" "yt_api" {
  name        = "yt-api"
  description = "API for Demo"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_resource" "yt_api_resource" {
  count = 10
  parent_id   = aws_api_gateway_rest_api.yt_api.root_resource_id
  path_part   = "demo-path-${count.index}"
  rest_api_id = aws_api_gateway_rest_api.yt_api.id
}

resource "aws_api_gateway_method" "yt_method" {
  count = 10
  resource_id   = aws_api_gateway_resource.yt_api_resource[count.index].id
  rest_api_id   = aws_api_gateway_rest_api.yt_api.id
  http_method   = "POST"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda_integration" {
  count = 10
  http_method             = aws_api_gateway_method.yt_method[count.index].http_method
  resource_id             = aws_api_gateway_resource.yt_api_resource[count.index].id
  rest_api_id             = aws_api_gateway_rest_api.yt_api.id
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.yt_lambda_function[count.index].invoke_arn
}

resource "aws_api_gateway_deployment" "api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.yt_api.id

  # triggers = {
  #   redeployment = sha1(jsonencode([
  #     aws_api_gateway_resource.yt_api_resource.id,
  #     aws_api_gateway_method.yt_method.id,
  #     aws_api_gateway_integration.lambda_integration.id
  #   ]))
  # }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    aws_api_gateway_integration.lambda_integration
  ]
}

resource "aws_api_gateway_stage" "yt_dev_stage" {
  deployment_id = aws_api_gateway_deployment.api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.yt_api.id
  stage_name    = "dev"
}

resource "aws_lambda_permission" "apigw_lambda_permission" {
  count = 10
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.yt_lambda_function[count.index].function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.yt_api.execution_arn}/*/*/*"
}

output "invoke_url" {
  value = aws_api_gateway_stage.yt_dev_stage.invoke_url
  description = "The URL to invoke the API Gateway"
}