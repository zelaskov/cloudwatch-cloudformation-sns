resource "aws_sns_topic" "sns-topic" {
  name = "cloudformation-stack-delete"
}

resource "aws_sns_topic_policy" "default" {
  arn    = aws_sns_topic.sns-topic.arn
  policy = data.aws_iam_policy_document.sns-topic-policy.json
}

resource "aws_sns_topic_subscription" "sns-mail-subscription" {
  topic_arn = aws_sns_topic.sns-topic.arn
  protocol  = "email"
  endpoint  = "marcin.zelasko@icloud.com"
}

data "aws_iam_policy_document" "sns-topic-policy" {
  statement {
    effect  = "Allow"
    actions = ["SNS:Publish"]

    principals {
      type        = "Service"
      identifiers = ["events.amazonaws.com"]
    }

    resources = [aws_sns_topic.sns-topic.arn]
  }
}
