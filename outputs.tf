output "alb_security_group_id" {
  value = "${aws_security_group.alb_security_group.id}"
}

output "cloudwatch_log_group_arn" {
  value = "${aws_cloudwatch_log_group.cloudwatch_log_group.arn}"
}

output "cloudwatch_log_group_name" {
  value = "${aws_cloudwatch_log_group.cloudwatch_log_group.name}"
}

output "ec2_security_group_id" {
  value = "${aws_security_group.ec2_security_group.id}"
}

output "ecs_cluster_id" {
  value = "${aws_ecs_cluster.ecs_cluster.id}"
}

output "ecs_cluster_name" {
  value = "${aws_ecs_cluster.ecs_cluster.name}"
}

output "external_alb_arn" {
  value = "${aws_alb.external_alb.arn}"
}

output "external_alb_arn_suffix" {
  value = "${aws_alb.external_alb.arn_suffix}"
}

output "external_alb_dns_name" {
  value = "${aws_alb.external_alb.dns_name}"
}

output "external_alb_listener_arn" {
  value = "${aws_alb_listener.external_alb_listener.arn}"
}

output "external_alb_listener_id" {
  value = "${aws_alb_listener.external_alb_listener.id}"
}

output "external_alb_target_group_arn" {
  value = "${aws_alb_target_group.external_alb_target_group.arn}"
}

output "external_alb_target_group_arn_suffix" {
  value = "${aws_alb_target_group.external_alb_target_group.arn_suffix}"
}

output "external_alb_target_group_id" {
  value = "${aws_alb_target_group.external_alb_target_group.id}"
}

output "external_route53_record_fqdn" {
  value = "${aws_route53_record.external_route53_record.fqdn}"
}

output "external_alb_zone_id" {
  value = "${aws_alb.external_alb.zone_id}"
}

output "internal_alb_arn" {
  value = "${aws_alb.internal_alb.arn}"
}

output "internal_alb_arn_suffix" {
  value = "${aws_alb.internal_alb.arn_suffix}"
}

output "internal_alb_dns_name" {
  value = "${aws_alb.internal_alb.dns_name}"
}

output "internal_alb_listener_arn" {
  value = "${aws_alb_listener.internal_alb_listener.arn}"
}

output "internal_alb_listener_id" {
  value = "${aws_alb_listener.internal_alb_listener.id}"
}

output "internal_alb_target_group_arn" {
  value = "${aws_alb_target_group.internal_alb_target_group.arn}"
}

output "internal_alb_target_group_arn_suffix" {
  value = "${aws_alb_target_group.internal_alb_target_group.arn_suffix}"
}

output "internal_alb_target_group_id" {
  value = "${aws_alb_target_group.internal_alb_target_group.id}"
}

output "internal_alb_zone_id" {
  value = "${aws_alb.internal_alb.zone_id}"
}

output "internal_route53_record_fqdn" {
  value = "${aws_route53_record.internal_route53_record.fqdn}"
}

