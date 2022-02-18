module "eventbridge" {
  source     = "terraform-aws-modules/eventbridge/aws"
  create_bus = false
  # create_targets = false
  # bus_name       = false

  rules = {
    orders = {
      description   = "ec2 state change notification"
      event_pattern = jsonencode({ "source" : ["aws.ec2"], "detail-type" : ["EC2 Instance State-change Notification"] })
      enabled       = true
    }
  }

  targets = {
    orders = [
      {
        name = "sns-topic"
        arn  = aws_sns_topic.aws_logins.arn
        input_transformer = {
          input_paths    = { instance-id : "$.detail.instance-id", state : "$.detail.state", time : "$.time", region : "$.region", account : "$.account" }
          input_template = "\"At <time>, the status of your EC2 instance <instance-id> on account <account> in the AWS Region <region> has changed to <state>\""
        }
      }
    ]  
  }

  tags = {
    Name = "test-rule"
  }
}