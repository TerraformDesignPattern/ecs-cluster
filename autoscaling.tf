// CREATE AUTOSCALING GROUP
resource "aws_autoscaling_group" "autoscaling_group" {
  name                 = "${aws_ecs_cluster.ecs_cluster.name}-${var.version_number}-asg"
  desired_capacity     = "${var.asg_desired_capacity}"
  health_check_type    = "EC2"
  launch_configuration = "${aws_launch_configuration.launch_configuration.name}"
  max_size             = "${var.asg_max_size}"
  min_size             = "${var.asg_min_size}"
  vpc_zone_identifier  = ["${data.terraform_remote_state.vpc.private_subnet_ids}"]

  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "${aws_ecs_cluster.ecs_cluster.name}-asg"
    propagate_at_launch = true
  }

  tag {
    key                 = "name"
    value               = "${aws_ecs_cluster.ecs_cluster.name}-asg"
    propagate_at_launch = true
  }

  tag {
    key                 = "description"
    value               = "${var.environment_name}-ecs-cluster"
    propagate_at_launch = true
  }

  tag {
    key                 = "environment_name"
    value               = "${var.environment_name}"
    propagate_at_launch = true
  }

  tag {
    key                 = "service_name"
    value               = "ecs"
    propagate_at_launch = true
  }

  tag {
    key                 = "tier"
    value               = "${var.tier}"
    propagate_at_launch = true
  }

  tag {
    key                 = "service_name"
    value               = "ecs"
    propagate_at_launch = true
  }
}

// CREATE AUTOSCALING DOWN POLICY
resource "aws_autoscaling_policy" "scale_down_autoscaling_policy" {
  name                   = "${aws_ecs_cluster.ecs_cluster.name}-asg-down"
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = "${aws_autoscaling_group.autoscaling_group.name}"
  cooldown               = "${var.scaling_adjustment_down_cooldown}"
  scaling_adjustment     = "${var.scaling_adjustment_down}"

  depends_on = [
    "aws_autoscaling_group.autoscaling_group",
  ]
}

// CREATE AUTOSCALING UP POLICY
resource "aws_autoscaling_policy" "scale_up_autoscaling_policy" {
  name                   = "${aws_ecs_cluster.ecs_cluster.name}-asg-up"
  adjustment_type        = "ChangeInCapacity"
  autoscaling_group_name = "${aws_autoscaling_group.autoscaling_group.name}"
  cooldown               = "${var.scaling_adjustment_up_cooldown}"
  scaling_adjustment     = "${var.scaling_adjustment_up}"

  depends_on = [
    "aws_autoscaling_group.autoscaling_group",
  ]
}
