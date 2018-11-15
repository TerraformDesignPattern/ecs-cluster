variable "aws_account" {}

variable "aws_region" {}

variable "environment_name" {}

variable "service_name" {}

variable "version_number" {}

variable "tier" {}

variable "vpc_name" {}

variable "asg_desired_capacity" {
  default = "9"
}

variable "asg_max_size" {
  default = "10"
}

variable "asg_min_size" {
  default = "3"
}

variable "elb_access_logs_interval" {
  // Can only be 5 or 60
  default = 5
}

variable "image_id" {
  default = {
    us-east-1 = ""
  }
}

variable "instance_type" {
  default = "t2.medium"
}

variable "scaling_adjustment_down" {
  default = "-1"
}

variable "scaling_adjustment_down_cooldown" {
  default = "120"
}

variable "scaling_adjustment_up" {
  default = "2"
}

variable "scaling_adjustment_up_cooldown" {
  default = "120"
}

variable "uniq_id" {
  default = ""
}

locals {
  hostname = "${var.environment_name}-${var.service_name}-${data.terraform_remote_state.vpc.aws_region_shortname}"
  resource_prefix = "${var.environment_name}-${var.service_name}"
  common_tags = {
    aws_account      = "${var.aws_account}"
    aws_region       = "${var.aws_region}"
    environment_name = "${var.environment_name}"
    service_name     = "${var.service_name}"
  }
}
