resource "aws_cloudwatch_event_rule" "event-rule" {
  name          = "cloudwatch-cloudformation-event"
  description   = "Capture CFN DeleteStack event"
  event_pattern = <<PATTERN
{
  "source": [
    "aws.cloudformation"
  ],
  "detail-type": [
    "AWS API Call via CloudTrail"
  ],
  "detail": {
    "eventSource": [
      "cloudformation.amazonaws.com"
    ],
    "eventName": [
      "DeleteStack"
    ]
  }
}
PATTERN
}

resource "aws_cloudwatch_event_target" "sns" {
  rule      = aws_cloudwatch_event_rule.event-rule.name
  target_id = "SendToSNS"
  arn       = aws_sns_topic.sns-topic.arn

  input_transformer {
    input_paths = {"stack":"$.detail.requestParameters.stackName","sourceIP":"$.detail.sourceIPAddress","eventTime":"$.detail.eventTime","userType":"$.detail.userIdentity.type","event":"$.detail.eventName","region":"$.detail.awsRegion","userName":"$.detail.userIdentity.userName"}
    input_template = <<TEMPLATE
    "Stack <stack> is processing event <event>. User that triggered event: <userType> <userName> at region <region>, IP <sourceIP> at <eventTime>."
    TEMPLATE
  }
}

