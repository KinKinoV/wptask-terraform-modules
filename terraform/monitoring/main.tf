terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.52.0"
    }
  }
}

resource "aws_cloudwatch_dashboard" "wp-dashboard" {
  dashboard_name = "WordPress"

  dashboard_body = jsonencode({
    widgets = [
      {
        height = 10
        width = 10
        y = 0
        x = 0
        type = "metric"
        properties = {
          view = "timeSeries"
          stacked = false
          metrics = [
            [
              {
                expression = "SELECT AVG(CPUUtilization) FROM SCHEMA(\"AWS/EC2\", InstanceId)"
                label = "Query1"
                id = "q1"
              }
            ]
          ]
          region = var.region
          stat = "Average"
          period = 300
          title = "CPU across entire fleet"
        }
      },
      {
        height = 10
        width = 10
        y = 0
        x = 10
        type = "metric"
        properties = {
          view = "timeSeries"
          stacked = false
          metrics = [
            [
              {
                expression = "SELECT SUM(RequestCount) FROM SCHEMA(\"AWS/ApplicationELB\", LoadBalancer)"
                label = "Query2"
                id = "q2"
              }
            ]
          ]
          region = var.region
          stat = "Average"
          period = 300
          title = "Total Requests"
        }
      },
      {
        height = 10
        width = 10
        y = 10
        x = 0
        type = "metric"
        properties = {
          view = "timeSeries"
          stacked = false
          metrics = [
            [
              {
                expression = "SELECT MAX(ActiveConnectionCount) FROM SCHEMA(\"AWS/ApplicationELB\", LoadBalancer) GROUP BY LoadBalancer ORDER BY SUM() DESC LIMIT 10"
                label = "Query3"
                id = "q3"
              }
            ]
          ],
          region = var.region
          stat = "Average"
          period = 300
          title = "Active Connections Count"
        }
      },
      {
        height = 10
        width = 10
        y = 10
        x = 10
        type = "metric"
        properties = {
          view = "timeSeries"
          stacked = false
          metrics = [
            [
              {
                expression = "SELECT AVG(TotalRequestLatency) FROM SCHEMA(\"AWS/S3\", BucketName, FilterId) WHERE FilterId = 'EntireBucket' GROUP BY BucketName ORDER BY AVG() DESC"
                label = "Query4"
                id = "q4"
              }
            ]
          ]
          region = var.region
          stat = "Average"
          period = 300
          title = "Average latency by bucket"
        }
      }
    ]
  })
}