// CREATE INTERNAL ALB DNS ALIAS
resource "aws_route53_record" "internal_route53_record" {
  zone_id = "${data.terraform_remote_state.account.primary_zone_id}"
  name    = "${aws_ecs_cluster.ecs_cluster.name}-internal.${data.terraform_remote_state.account.domain_name}."
  type    = "A"

  alias {
    name                   = "${aws_alb.internal_alb.dns_name}"
    zone_id                = "${aws_alb.internal_alb.zone_id}"
    evaluate_target_health = false
  }
}

// CREATE EXTERNAL ALB DNS ALIAS
resource "aws_route53_record" "external_route53_record" {
  zone_id = "${data.terraform_remote_state.account.primary_zone_id}"
  name    = "${aws_ecs_cluster.ecs_cluster.name}-external.${data.terraform_remote_state.account.domain_name}."
  type    = "A"

  alias {
    name                   = "${aws_alb.external_alb.dns_name}"
    zone_id                = "${aws_alb.external_alb.zone_id}"
    evaluate_target_health = false
  }
}
