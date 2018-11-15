// CREATE IAM INSTANCE PROFILE
resource "aws_iam_instance_profile" "iam_instance_profile" {
  name = "${aws_ecs_cluster.ecs_cluster.name}-instance-profile"
  role = "${aws_iam_role.iam_role.name}"
}

// CREATE IAM ROLE
resource "aws_iam_role" "iam_role" {
  name = "${aws_ecs_cluster.ecs_cluster.name}-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

// CREATE IAM ROLE POLICY
resource "aws_iam_role_policy" "iam_role_policy" {
  name = "${aws_ecs_cluster.ecs_cluster.name}-policy"
  role = "${aws_iam_role.iam_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ecr:BatchCheckLayerAvailability",
        "ecr:BatchGetImage",
        "ecs:CreateCluster",
        "ecs:DeregisterContainerInstance",
        "ecs:DiscoverPollEndpoint",
        "ecr:GetAuthorizationToken",
        "ecr:GetDownloadUrlForLayer",
        "ecs:Poll",
        "ecs:RegisterContainerInstance",
        "ecs:StartTask",
        "ecs:StartTelemetrySession",
        "ecs:Submit*"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": "logs:*",
      "Resource": "*"
    },
    {
      "Sid": "SsmGetParamsj",
      "Effect": "Allow",
      "Action": [
        "ssm:GetParameter",
        "ssm:GetParameters",
        "ssm:GetParameterHistory",
        "ssm:GetParametersByPath"
      ],
      "Resource": "arn:aws:ssm:${var.aws_region}:${data.terraform_remote_state.account.aws_account_id}:parameter/ops-ci-docker-hub-*"
    },
    {
      "Sid": "SsmDescribeParams",
      "Effect":"Allow",
      "Action": [
        "ssm:DescribeParameters"
      ],
      "Resource": [
        "*"
      ]
    },
    {
      "Sid": "KmsDecryptSecret",
      "Effect":"Allow",
      "Action": [
        "kms:*"
      ],
      "Resource": [
        "arn:aws:kms:${var.aws_region}:${data.terraform_remote_state.account.aws_account_id}:key/alias/aws/ssm"
      ]
    }
  ]
}
EOF
}
