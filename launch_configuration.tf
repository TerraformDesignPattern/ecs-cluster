// POPULATE USER DATA TEMPLATE
data "template_file" "user_data" {
  template = "${file("${path.module}/user_data.sh.tpl")}"

  vars {
    ecs_cluster_name = "${aws_ecs_cluster.ecs_cluster.name}"
    docker_auth      = "${data.terraform_remote_state.account.docker_auth}"
  }
}

// CREATE LAUNCH CONFIGURATION
resource "aws_launch_configuration" "launch_configuration" {
  name_prefix          = "${aws_ecs_cluster.ecs_cluster.name}-launch-config-${data.terraform_remote_state.vpc.aws_region_shortname}-"
  iam_instance_profile = "${aws_iam_instance_profile.iam_instance_profile.name}"
  image_id             = "${lookup(var.image_id, var.aws_region)}"
  instance_type        = "${var.instance_type}"
  key_name             = "${data.terraform_remote_state.account.key_pair_name}"
  security_groups      = ["${aws_security_group.ec2_security_group.id}"]
  user_data            = "${data.template_file.user_data.rendered}"

  lifecycle {
    create_before_destroy = true
  }
}
