data "aws_sns_topic" "example" {
  name = "yumSecurityUpdateFailedNotification"
}

resource "aws_sns_topic_subscription" "AccessKeyIdRotation" {
  topic_arn = data.aws_sns_topic.example.arn
  protocol  = "email"
  endpoint  = "raghib.nadim@folium.cloud"
}


output "sns_details" {
  value = data.aws_sns_topic.example
}