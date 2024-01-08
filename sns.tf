resource "aws_sns_topic" "http_errors_sns_topic" {
  name = "HTTPErrorsTopic"
}

resource "aws_sns_topic_subscription" "http_errors_sns_subscription" {
  topic_arn = aws_sns_topic.http_errors_sns_topic.arn
  protocol  = "email"
  endpoint  = "admin@example.com"  
}
resource "aws_sns_topic" "user_updates" {
  name            = "user-updates-topic"
  delivery_policy = <<EOF
{
  "http": {
    "defaultHealthyRetryPolicy": {
      "minDelayTarget": 20,
      "maxDelayTarget": 20,
      "numRetries": 3,
      "numMaxDelayRetries": 0,
      "numNoDelayRetries": 0,
      "numMinDelayRetries": 0,
      "backoffFunction": "linear"
    },
    "disableSubscriptionOverrides": false,
    "defaultThrottlePolicy": {
      "maxReceivesPerSecond": 1
    }
  }
}
EOF
}