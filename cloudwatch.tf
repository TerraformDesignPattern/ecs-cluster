// CREATE CLOUDWATCH LOG GROUP
resource "aws_cloudwatch_log_group" "cloudwatch_log_group" {
  name              = "/aws/ecs/${aws_ecs_cluster.ecs_cluster.name}"
  retention_in_days = "7"
}

//// CREATE CLOUDWATCH LOG SUBSCRIPTION FILTER
//resource "aws_cloudwatch_log_subscription_filter" "cloudwatch_log_subscription_filter" {
//  name            = "${aws_ecs_cluster.ecs_cluster.name}-log-subscription-filter"
//  log_group_name  = "${aws_cloudwatch_log_group.cloudwatch_log_group.name}"
//  filter_pattern  = ""
//  destination_arn = "${aws_lambda_function.lambda_function.arn}"
//
//  depends_on = [
//    "aws_cloudwatch_log_group.cloudwatch_log_group",
//    "aws_lambda_permission.lambda_permission",
//  ]
//}

// CREATE SCALE UP CLOUDWATCH METRIC ALARM
resource "aws_cloudwatch_metric_alarm" "scale_up_cloudwatch_metric_alarm" {
  alarm_actions       = ["${aws_autoscaling_policy.scale_up_autoscaling_policy.arn}"]
  alarm_description   = "This metric monitors ${aws_ecs_cluster.ecs_cluster.name} ECS CPU reservation usage"
  alarm_name          = "${aws_ecs_cluster.ecs_cluster.name}-cpu-reservation-usage-high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUReservation"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 70

  dimensions {
    ClusterName = "${aws_ecs_cluster.ecs_cluster.name}"
  }

  depends_on = [
    "aws_autoscaling_policy.scale_up_autoscaling_policy",
  ]
}

// CREATE SCALE DOWN CLOUDWATCH METRIC ALARM
resource "aws_cloudwatch_metric_alarm" "scale_down_cloudwatch_metric_alarm" {
  alarm_actions       = ["${aws_autoscaling_policy.scale_down_autoscaling_policy.arn}"]
  alarm_description   = "This metric monitors ${aws_ecs_cluster.ecs_cluster.name} ECS CPU reservation usage"
  alarm_name          = "${aws_ecs_cluster.ecs_cluster.name}-cpu-reservation-usage-low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 1
  metric_name         = "CPUReservation"
  namespace           = "AWS/ECS"
  period              = 60
  statistic           = "Average"
  threshold           = 10

  dimensions {
    ClusterName = "${aws_ecs_cluster.ecs_cluster.name}"
  }

  depends_on = [
    "aws_autoscaling_policy.scale_down_autoscaling_policy",
  ]
}

// MONITOR CLUSTER VIA CLOUDWATCH EVENTS
//  - WORKED MANUALLY HAVING IAM ISSUES.
//  - LOTS OF EVENTS.
//// CREATE CLOUDWATCH EVENT RULE
//resource "aws_cloudwatch_event_rule" "cloudwatch_event_rule" {
//  name        = "${aws_ecs_cluster.ecs_cluster.name}-events"
//  description = "Capture each ${aws_ecs_cluster.ecs_cluster.name} event"
//
//  event_pattern = <<PATTERN
//{
//  "source": [
//    "aws.ecs"
//  ]
//}
//PATTERN
//}
//
//// CREATE CLOUDWATCH EVENT TARGET
//resource "aws_cloudwatch_event_target" "cloudwatch_event_target" {
//  rule      = "${aws_cloudwatch_event_rule.cloudwatch_event_rule.name}"
//  target_id = "${aws_ecs_cluster.ecs_cluster.name}-event-stream"
//  arn       = "${aws_lambda_function.ecs_events_lambda_function.arn}"
//}
