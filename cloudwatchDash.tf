# =========================================================
# CLOUDWATCH DASHBOARD
# =========================================================

resource "aws_cloudwatch_dashboard" "cris_utilidades" {
  dashboard_name = "cris-utilidades-dashboard"

  dashboard_body = jsonencode({
    widgets = [

      # ---------------- CPU ----------------

      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6

        properties = {
          title  = "CPU - Webservers"
          region = "us-east-1"

          metrics = [
            ["AWS/EC2", "CPUUtilization", "InstanceId", aws_instance.webserver01.id],
            ["AWS/EC2", "CPUUtilization", "InstanceId", aws_instance.webserver02.id]
          ]

          period = 300
          stat   = "Average"
          view   = "timeSeries"
        }
      },

      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6

        properties = {
          title  = "CPU - Backends"
          region = "us-east-1"

          metrics = [
            ["AWS/EC2", "CPUUtilization", "InstanceId", aws_instance.backend01.id],
            ["AWS/EC2", "CPUUtilization", "InstanceId", aws_instance.backend02.id]
          ]

          period = 300
          stat   = "Average"
          view   = "timeSeries"
        }
      },

      {
        type   = "metric"
        x      = 0
        y      = 6
        width  = 12
        height = 6

        properties = {
          title  = "CPU - Database"
          region = "us-east-1"

          metrics = [
            ["AWS/EC2", "CPUUtilization", "InstanceId", aws_instance.database01.id]
          ]

          period = 300
          stat   = "Average"
          view   = "timeSeries"
        }
      },

      # ---------------- STATUS CHECK ----------------

      {
        type   = "metric"
        x      = 12
        y      = 6
        width  = 12
        height = 6

        properties = {
          title  = "EC2 Status Checks"
          region = "us-east-1"

          metrics = [
            ["AWS/EC2", "StatusCheckFailed", "InstanceId", aws_instance.webserver01.id],
            ["AWS/EC2", "StatusCheckFailed", "InstanceId", aws_instance.webserver02.id],
            ["AWS/EC2", "StatusCheckFailed", "InstanceId", aws_instance.backend01.id],
            ["AWS/EC2", "StatusCheckFailed", "InstanceId", aws_instance.backend02.id],
            ["AWS/EC2", "StatusCheckFailed", "InstanceId", aws_instance.database01.id]
          ]

          period = 300
          stat   = "Maximum"
          view   = "timeSeries"
        }
      }
    ]
  })
}
