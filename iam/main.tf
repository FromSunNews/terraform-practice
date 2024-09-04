provider "aws" {}

resource "aws_iam_user" "user_tf" {
  name = "TestUserTF"
}

resource "aws_iam_policy" "policy_ec2_tf" {
  name = "AccessToEverythingEC2"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "Statement1",
        "Effect" : "Allow",
        "Action" : [
          "ec2:*"
        ],
        "Resource" : "*"
      }
    ]
  })
}

resource "aws_iam_policy_attachment" "attach_policy_tf" {
  name       = "attachment"
  users      = [aws_iam_user.user_tf.name]
  policy_arn = aws_iam_policy.policy_ec2_tf.arn
}
