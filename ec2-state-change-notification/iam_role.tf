# resource "aws_iam_role" "iam_for_sns" {
#   name = "iam_for_sns"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Action = "sts:AssumeRole"
#         Effect = "Allow"
#         Sid    = ""
#         Principal = {
#           Service = "events.amazonaws.com"
#         }
#       }
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "test-attach" {
#   role       = aws_iam_role.iam_for_sns.name
#   policy_arn = aws_iam_policy.policy.arn
# }

# resource "aws_iam_policy" "policy" {
#   name        = "test-policy"
#   description = "A test policy"

#   policy = <<EOF
# {
#   "Version": "2012-10-17",
#   "Statement": [
#     {
#       "Action": [
#         "*"
#       ],
#       "Effect": "Allow",
#       "Resource": "*"
#     }
#   ]
# }
# EOF
# }