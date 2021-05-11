module "s3_metric_alarm" {
  source  = "terraform-aws-modules/cloudwatch/aws//modules/metric-alarm"
  version = "~> 2.0"

  alarm_name          = "S3-BytedDownloaded"
  alarm_description   = "A lot of BytesDownloaded"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  threshold           = 100000
  period              = 60
  unit                = "Bytes"

  namespace   = "AWS/S3"
  metric_name = "BytesDownloaded"
  statistic   = "Average"

  alarm_actions = ["arn:aws:sns:${var.aws_region}:${data.aws_caller_identity.current.account_id}:my-sns-queue"]
}

module "docdb_metric_alarm" {
  source  = "terraform-aws-modules/cloudwatch/aws//modules/metric-alarm"
  version = "~> 2.0"

  alarm_name          = "DocDB-NetworkTransmitThroughput"
  alarm_description   = "A lot of NetworkTransmitThroughput"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  threshold           = 1000
  period              = 60
  unit                = "Bytes/Second"

  namespace   = "AWS/DocDB"
  metric_name = "NetworkTransmitThroughput"
  statistic   = "Average"

  alarm_actions = ["arn:aws:sns:${var.aws_region}:${data.aws_caller_identity.current.account_id}:my-sns-queue"]
}