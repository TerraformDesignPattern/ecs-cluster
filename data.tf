// IMPORT ACCOUNT DATA
data "terraform_remote_state" "account" {
  backend = "s3"

  config {
    bucket = "${var.aws_account}-terraform-state"
    key    = "aws/terraform.tfstate"
    region = "us-east-1"
  }
}

// IMPORT VPC DATA
data "terraform_remote_state" "vpc" {
  backend = "s3"

  config {
    bucket = "${var.aws_account}-terraform-state"
    key    = "aws/${var.aws_region}/${var.vpc_name}/terraform.tfstate"
    region = "us-east-1"
  }
}

// IMPORT VPC DATA
data "terraform_remote_state" "ops_vpc" {
  backend = "s3"

  config {
    bucket = "${var.aws_account}-terraform-state"
    key    = "aws/${var.aws_region}/ops-vpc/terraform.tfstate"
    region = "us-east-1"
  }
}

// IMPORT REGISTRY
data "terraform_remote_state" "registry" {
  backend = "s3"

  config {
    bucket = "${var.aws_account}-terraform-state"
    key    = "aws/${var.aws_region}/${var.vpc_name}/ops/docker-registry/terraform.tfstate"
    region = "us-east-1"
  }
}
