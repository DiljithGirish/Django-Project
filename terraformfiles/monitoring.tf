# SNS Topic for CloudWatch Alarms
resource "aws_sns_topic" "alerts" {
  name = "${var.project_name}-alert-topic"
}

resource "aws_sns_topic_subscription" "email_alerts" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = "diljithgirish10@gmail.com"
}

# Local map for backend and frontend service names
locals {
  services = [
    {
      name  = var.backend_service_name
      label = "Backend"
    },
    {
      name  = var.frontend_service_name
      label = "Frontend"
    }
  ]
}

# CPU and Memory Utilization Alarms
resource "aws_cloudwatch_metric_alarm" "cpu_utilization" {
  for_each            = { for s in local.services : s.name => s }

  alarm_name          = "${each.value.label}-CPU-High"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  threshold           = 80
  alarm_description   = "${each.value.label} CPU usage > 80%"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  dimensions = {
    ClusterName = var.ecs_cluster_name
    ServiceName = each.value.name
  }
  alarm_actions = [aws_sns_topic.alerts.arn]
}

resource "aws_cloudwatch_metric_alarm" "memory_utilization" {
  for_each            = { for s in local.services : s.name => s }

  alarm_name          = "${each.value.label}-Memory-High"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  threshold           = 80
  alarm_description   = "${each.value.label} Memory usage > 80%"
  metric_name         = "MemoryUtilization"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  dimensions = {
    ClusterName = var.ecs_cluster_name
    ServiceName = each.value.name
  }
  alarm_actions = [aws_sns_topic.alerts.arn]
}

# Downtime Alert - RunningTaskCount < 1
resource "aws_cloudwatch_metric_alarm" "running_tasks_low" {
  for_each            = { for s in local.services : s.name => s }

  alarm_name          = "${each.value.label}-Tasks-Down"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  threshold           = 1
  alarm_description   = "${each.value.label} running tasks < 1 (possible downtime)"
  metric_name         = "RunningTaskCount"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  dimensions = {
    ClusterName = var.ecs_cluster_name
    ServiceName = each.value.name
  }
  alarm_actions = [aws_sns_topic.alerts.arn]
}

# CloudWatch Dashboard
resource "aws_cloudwatch_dashboard" "ecs_dashboard" {
  dashboard_name = "${var.project_name}-ecs-dashboard"

  dashboard_body = jsonencode({
    widgets = flatten([
      for svc in local.services : [
        {
          type = "metric",
          x    = 0,
          y    = 0,
          width = 12,
          height = 6,
          properties = {
            title = "${svc.label} - CPU & Memory",
            metrics = [
              [ "AWS/ECS", "CPUUtilization", "ClusterName", var.ecs_cluster_name, "ServiceName", svc.name ],
              [ ".", "MemoryUtilization", ".", ".", ".", "." ]
            ],
            view     = "timeSeries",
            stacked  = false,
            region   = "us-east-1",
            stat     = "Average",
            period   = 60
          }
        },
        {
          type = "metric",
          x    = 12,
          y    = 0,
          width = 12,
          height = 6,
          properties = {
            title = "${svc.label} - Running Tasks",
            metrics = [
              [ "AWS/ECS", "RunningTaskCount", "ClusterName", var.ecs_cluster_name, "ServiceName", svc.name ]
            ],
            view     = "timeSeries",
            stacked  = false,
            region   = "us-east-1",
            stat     = "Average",
            period   = 60
          }
        }
      ]
    ])
  })
}

