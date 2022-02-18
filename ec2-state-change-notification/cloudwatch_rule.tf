# resource "aws_cloudwatch_event_rule" "console" {
#   name        = "test"
#   description = "EC2 Instance State Change Notification"
#   role_arn    = aws_iam_role.iam_for_sns.arn
#   event_pattern = <<EOF
# {
#   "detail-type": [
#     "EC2 Instance State-change Notification"
#   ],
#   "source": [
#       "aws:ec2"
#   ]
# }
# EOF
# }

# resource "aws_cloudwatch_event_target" "sns" {
#   rule      = aws_cloudwatch_event_rule.console.name
#   target_id = aws_sns_topic.aws_logins.name
#   arn       = aws_sns_topic.aws_logins.arn
# }