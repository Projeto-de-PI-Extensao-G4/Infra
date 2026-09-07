
# ALARM - WEBSERVER 01
resource "aws_cloudwatch_metric_alarm" "webserver01_cpu" {

  alarm_name          = "webserver01-high-cpu"
  alarm_description   = "CPU acima de 80% no webserver01"

  namespace           = "AWS/EC2"
  metric_name         = "CPUUtilization"

  dimensions = {
    InstanceId = aws_instance.webserver01.id
  }

  statistic           = "Average"
  period              = 300
  evaluation_periods  = 2

  threshold           = 80
  comparison_operator = "GreaterThanThreshold"

  alarm_actions = [
    aws_sns_topic.alerts.arn
  ]
}

# ALARM - WEBSERVER 02
resource "aws_cloudwatch_metric_alarm" "webserver02_cpu" {

  alarm_name        = "webserver02-high-cpu"
  alarm_description = "CPU acima de 80% no webserver02"

  namespace   = "AWS/EC2"
  metric_name = "CPUUtilization"

  dimensions = {
    InstanceId = aws_instance.webserver02.id
  }

  statistic          = "Average"
  period             = 300
  evaluation_periods = 2

  threshold           = 80
  comparison_operator = "GreaterThanThreshold"

  alarm_actions = [
    aws_sns_topic.alerts.arn
  ]
}

# ALARM - BACKEND 01
resource "aws_cloudwatch_metric_alarm" "backend01_cpu" {

  alarm_name        = "backend01-high-cpu"
  alarm_description = "CPU acima de 80% no backend01"

  namespace   = "AWS/EC2"
  metric_name = "CPUUtilization"

  dimensions = {
    InstanceId = aws_instance.backend01.id
  }

  statistic          = "Average"
  period             = 300
  evaluation_periods = 2

  threshold           = 80
  comparison_operator = "GreaterThanThreshold"

  alarm_actions = [
    aws_sns_topic.alerts.arn
  ]
}

# ALARM - BACKEND 02
resource "aws_cloudwatch_metric_alarm" "backend02_cpu" {

  alarm_name        = "backend02-high-cpu"
  alarm_description = "CPU acima de 80% no backend02"

  namespace   = "AWS/EC2"
  metric_name = "CPUUtilization"

  dimensions = {
    InstanceId = aws_instance.backend02.id
  }

  statistic          = "Average"
  period             = 300
  evaluation_periods = 2

  threshold           = 80
  comparison_operator = "GreaterThanThreshold"

  alarm_actions = [
    aws_sns_topic.alerts.arn
  ]
}

# ALARM - DATABASE 01
resource "aws_cloudwatch_metric_alarm" "database01_cpu" {

  alarm_name        = "database01-high-cpu"
  alarm_description = "CPU acima de 80% no database01"

  namespace   = "AWS/EC2"
  metric_name = "CPUUtilization"

  dimensions = {
    InstanceId = aws_instance.database01.id
  }

  statistic          = "Average"
  period             = 300
  evaluation_periods = 2

  threshold           = 80
  comparison_operator = "GreaterThanThreshold"

  alarm_actions = [
    aws_sns_topic.alerts.arn
  ]
}