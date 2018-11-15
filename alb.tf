// CREATE EXTERNAL ALB
resource "aws_alb" "external_alb" {
  name            = "${local.resource_prefix}-external-alb-${data.terraform_remote_state.vpc.aws_region_shortname}"
  internal        = false
  security_groups = ["${aws_security_group.alb_security_group.id}"]
  subnets         = ["${data.terraform_remote_state.vpc.public_subnet_ids}"]

  access_logs {
    bucket = "${var.aws_account}-logs"
    prefix = "${var.environment_name}/ecs/external-alb"
    enabled = true
  }

  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${local.resource_prefix}-external-alb-${data.terraform_remote_state.vpc.aws_region_shortname}",
      "name", "${local.resource_prefix}-external-alb-${data.terraform_remote_state.vpc.aws_region_shortname}"
    )
  )}"
}

// CREATE INTERNAL ALB
resource "aws_alb" "internal_alb" {
  name            = "${local.resource_prefix}-interal-alb-${data.terraform_remote_state.vpc.aws_region_shortname}"
  internal        = true
  security_groups = ["${aws_security_group.alb_security_group.id}"]
  subnets         = ["${data.terraform_remote_state.vpc.private_subnet_ids}"]

  access_logs {
    bucket = "${var.aws_account}-logs"
    prefix = "${var.environment_name}/ecs/internal-alb"
    enabled = true
  }

  tags = "${merge(
    local.common_tags,
    map(
      "Name", "${local.resource_prefix}-internal-alb-${data.terraform_remote_state.vpc.aws_region_shortname}",
      "name", "${local.resource_prefix}-internal-alb-${data.terraform_remote_state.vpc.aws_region_shortname}"
    )
  )}"
}

// CREATE EXTERNAL ALB TARGET GROUP
resource "aws_alb_target_group" "external_alb_target_group" {
  name     = "${local.resource_prefix}-external-alb-tg-${data.terraform_remote_state.vpc.aws_region_shortname}"
  port     = 443
  protocol = "HTTPS"
  vpc_id   = "${data.terraform_remote_state.vpc.vpc_id}"

  health_check {
    port     = "traffic-port"
    protocol = "HTTP"

    matcher = 200
    path    = "/"

    timeout             = 2
    interval            = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
}

// CREATE INTERNAL ALB TARGET GROUP
resource "aws_alb_target_group" "internal_alb_target_group" {
  name     = "${local.resource_prefix}-internal-alb-tg-${data.terraform_remote_state.vpc.aws_region_shortname}"
  port     = 443
  protocol = "HTTPS"
  vpc_id   = "${data.terraform_remote_state.vpc.vpc_id}"

  health_check {
    port     = "traffic-port"
    protocol = "HTTP"

    matcher = 200
    path    = "/"

    timeout             = 2
    interval            = 5
    healthy_threshold   = 5
    unhealthy_threshold = 2
  }
}

// CREATE EXTERNAL ALB LISTENER
resource "aws_alb_listener" "external_alb_listener" {
  load_balancer_arn = "${aws_alb.external_alb.arn}"
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = "${data.terraform_remote_state.account.ssl_arn}"

  default_action {
    target_group_arn = "${aws_alb_target_group.external_alb_target_group.arn}"
    type             = "forward"
  }
}

// CREATE INTERNAL ALB LISTENER
resource "aws_alb_listener" "internal_alb_listener" {
  load_balancer_arn = "${aws_alb.internal_alb.arn}"
  port              = "443"
  protocol          = "HTTPS"
  certificate_arn   = "${data.terraform_remote_state.account.ssl_arn}"

  default_action {
    target_group_arn = "${aws_alb_target_group.internal_alb_target_group.arn}"
    type             = "forward"
  }
}
