resource "aws_cloudwatch_event_rule" "scheduleLambda" {
    name = "Schedule_Lambda_Function_key_Rotation"
    schedule_expression = "cron(0 4 1 * ? *)"
}

resource "aws_cloudwatch_event_target" "Lambda_Function" {
  rule      = aws_cloudwatch_event_rule.scheduleLambda.name
  target_id = "ScheduleLambdaFunction"
  arn       = aws_lambda_function.inactiveUserDisable.arn
}