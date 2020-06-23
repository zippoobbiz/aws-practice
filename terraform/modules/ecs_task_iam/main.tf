

data "template_file" "ecs_task_role_policy" {
  template   = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ssm:GetParameter"
      ],
      "Resource": "*"
    },
    {
      "Sid": "AllowPushPull",
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "arn:aws:iam::123456789012:user/push-pull-user-1",
          "arn:aws:iam::123456789012:user/push-pull-user-2"
        ]
      },
      "Action": [
        "ecr:GetDownloadUrlForLayer",
        "ecr:BatchGetImage",
        "ecr:BatchCheckLayerAvailability",
        "ecr:PutImage",
        "ecr:InitiateLayerUpload",
        "ecr:UploadLayerPart",
        "ecr:CompleteLayerUpload"
      ],
      "Resource": "*"
    }
  ]
}
EOF
  vars {
    account_id                  = "${var.account_id}"
    region                      = "${var.region}"
    ssm_parameter_name_prefix   = "${var.ssm_parameter_name_prefix}"
  }
}


data "aws_iam_policy_document" "ecs-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }

    Effect = "Allow"
    Sid = ""
  }
}

# IAM roles for ECS
resource "aws_iam_role" "ecs_task" {
  name               = "ecs-task-role"
  assume_role_policy = "${data.aws_iam_policy_document.ecs-assume-role-policy.json}"
}

resource "aws_iam_role_policy" "ecs_task" {
  name      = "ecs_task_role_policy"
  role      = "${aws_iam_role.ecs_task.id}"
  policy    = "${data.template_file.ecs_task_role_policy.rendered}"
}
