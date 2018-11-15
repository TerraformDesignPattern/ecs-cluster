resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.environment_name}-${var.uniq_id}ecs-cluster-${data.terraform_remote_state.vpc.aws_region_shortname}"
}
