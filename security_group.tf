// CREATE ALB SECURITY GROUP
resource "aws_security_group" "alb_security_group" {
  name        = "${aws_ecs_cluster.ecs_cluster.name}-alb-sg-${data.terraform_remote_state.vpc.aws_region_shortname}"
  description = "ALB Allowed Ports"
  vpc_id      = "${data.terraform_remote_state.vpc.vpc_id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${aws_ecs_cluster.ecs_cluster.name}-alb-sg-${data.terraform_remote_state.vpc.aws_region_shortname}"
  }
}

// CREATE EC2 INSTANCE SECURITY GROUP
resource "aws_security_group" "ec2_security_group" {
  name        = "${aws_ecs_cluster.ecs_cluster.name}-ec2-sg-${data.terraform_remote_state.vpc.aws_region_shortname}"
  description = "Container Instance Allowed Ports"
  vpc_id      = "${data.terraform_remote_state.vpc.vpc_id}"

  ingress {
    from_port       = 1
    to_port         = 65535
    protocol        = "tcp"
    security_groups = ["${aws_security_group.alb_security_group.id}"]
    self            = true
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${data.terraform_remote_state.ops_vpc.vpc_cidr_block}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${aws_ecs_cluster.ecs_cluster.name}-ec2-sg-${data.terraform_remote_state.vpc.aws_region_shortname}"
  }
}
