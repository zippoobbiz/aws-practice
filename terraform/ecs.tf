# ECS Cluster
resource "aws_security_group" "ecs_sg" {
  name        = "${var.app_name}-ECS-SG"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress = {
    description       = "all from self + alb"
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
    security_groups   = ["${module.frontend_alb_sg.this_security_group_id}"]
    self              = true
  }
  egress = {
    description = "all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags  = [
    {
      Name = "${var.app_name}-ECS-SG"
    }
  ]
}



data "aws_ami" "ecs" {
  most_recent = true
  owners = ["amazon"]
  filter {
    name      = "owner-alias"
    values    = ["amazon"]
  }
  filter {
    name      = "name"
    values    = ["amzn-ami-*-amazon-ecs-optimized"]
  }
}
module "ecs_cluster_iam" {
  source = "./modules/ecs_cluster_iam"
}

data "template_file" "ecs_user_data" {
  template = <<EOF
#!/bin/bash
cat << EOF_CONFIG > /etc/ecs/ecs.config
ECS_CLUSTER=${var.app_name}
ECS_ENABLE_TASK_IAM_ROLE=true
ECS_ENABLE_TASK_ENI=true
ECS_DISABLE_PRIVILEGED=false
ECS_AWSVPC_BLOCK_IMDS=false
EOF_CONFIG
EOF
}

resource "aws_ecs_cluster" "main" {
  name = "${var.app_name}"
}

resource "aws_launch_configuration" "lc_ecs" {
  name          = "lc_ecs"
  image_id      = "${data.aws_ami.ecs.id}"
  instance_type = "${var.ecs_cluster_instance_type}"
  key_name                    = "${var.ssh_key_name}"
  security_groups             = [
    "${aws_security_group.ecs_sg.id}",
    "${aws_security_group.all_from_bastion.id}"
  ]
  associate_public_ip_address = false
  user_data = "${data.template_file.ecs_user_data.rendered}"
  enable_monitoring = true
  lifecycle {
    create_before_destroy = true
  }
  iam_instance_profile        = "${module.ecs_cluster_iam.ecs_instance_profile_id}"
}

resource "aws_autoscaling_group" "ecs_asg" {
  name                      = "${var.app_name}-FRONTEND-ECS-ASG"
  max_size                  = 2
  min_size                  = 1
  health_check_grace_period = 300
  health_check_type         = "ELB"
  desired_capacity          = 1
  force_delete              = true
  # placement_group           = "${aws_placement_group.test.id}"
  launch_configuration      = "${aws_launch_configuration.lc_ecs.name}"
  vpc_zone_identifier       = ["${module.vpc.private_subnets}"]
  wait_for_capacity_timeout   = 0
  # target_group_arns         = ["${aws_alb_target_group.frontend.arn}"]

#   initial_lifecycle_hook {
#     name                 = "foobar"
#     default_result       = "CONTINUE"
#     heartbeat_timeout    = 2000
#     lifecycle_transition = "autoscaling:EC2_INSTANCE_LAUNCHING"

#     notification_metadata = <<EOF
# {
#   "foo": "bar"
# }
# EOF

#     notification_target_arn = "arn:aws:sqs:us-east-1:444455556666:queue1*"
#     role_arn                = "arn:aws:iam::123456789012:role/S3Access"
#   }

  tag {
    key                 = "foo"
    value               = "bar"
    propagate_at_launch = true
  }

  timeouts {
    delete = "15m"
  }

  tag {
    key                 = "lorem"
    value               = "ipsum"
    propagate_at_launch = false
  }
}


output "ami_id" {
  value = "${data.aws_ami.ecs.id}"
}