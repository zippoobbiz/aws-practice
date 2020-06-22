resource "aws_security_group" "asg_sg" {
  name        = "${var.app_name}-ASG-SG"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress = {
    description       = "all from self + alb"
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
    security_groups   = ["${module.alb_sg.this_security_group_id}"]
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
      Name = "${var.app_name}-ASG-SG"
    }
  ]
}

resource "aws_security_group" "all_from_bastion" {
  name        = "${var.app_name}-From-Bastion-SG"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress = {
    description       = "all from bastion"
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
    security_groups   = ["${aws_security_group.bastion.id}"]
  }
}

data "template_file" "asg_user_data" {
  template = <<EOF
#!/bin/bash
cat << EOF_CONFIG > /etc/asg/asg.config
ASG_CLUSTER=${var.app_name}
ASG_ENABLE_TASK_IAM_ROLE=true
ASG_ENABLE_TASK_ENI=true
ASG_DISABLE_PRIVILEGED=false
ASG_AWSVPC_BLOCK_IMDS=false
EOF_CONFIG
EOF
}

data "aws_ami" "tomcat_ami" {
  most_recent = true
  owners = ["823861797682"]
  filter {
    name      = "name"
    values    = ["tomcat-ami"]
  }
}

data "aws_ami" "springboot_ami" {
  most_recent = true
  owners = ["823861797682"]
  filter {
    name      = "name"
    values    = ["springboot-ami"]
  }
}

resource "aws_launch_configuration" "lc_green" {
  name          = "lc_green"
  image_id      = "${data.aws_ami.tomcat_ami.id}"
  instance_type = "t2.micro"
  key_name                    = "${var.ssh_key_name}"
  security_groups             = [
    "${aws_security_group.asg_sg.id}",
    "${aws_security_group.all_from_bastion.id}"
  ]
  associate_public_ip_address = false
  user_data = "${data.template_file.asg_user_data.rendered}"
  enable_monitoring = true
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_launch_configuration" "lc_blue" {
  name          = "lc_blue"
  image_id      = "${data.aws_ami.tomcat_ami.id}"
  instance_type = "t2.micro"
  key_name                    = "${var.ssh_key_name}"
  security_groups             = [
    "${aws_security_group.asg_sg.id}",
    "${aws_security_group.all_from_bastion.id}"
  ]
  associate_public_ip_address = false
  user_data = "${data.template_file.asg_user_data.rendered}"
  enable_monitoring = true
  lifecycle {
    create_before_destroy = true
  }
}

# resource "aws_launch_configuration" "this" {
#   # count = "${var.create_lc}"

#   # name_prefix                 = "${coalesce(var.lc_name, var.name)}-"
#   # image_id                    = "${var.image_id}"
#   # instance_type               = "${var.instance_type}"
#   iam_instance_profile        = "${var.iam_instance_profile}"
#   # key_name                    = "${var.key_name}"
#   # security_groups             = ["${var.security_groups}"]
#   # associate_public_ip_address = "${var.associate_public_ip_address}"
#   # user_data                   = "${var.user_data}"
#   enable_monitoring           = "${var.enable_monitoring}"
#   spot_price                  = "${var.spot_price}"
#   placement_tenancy           = "${var.spot_price == "" ? var.placement_tenancy : ""}"
#   ebs_optimized               = "${var.ebs_optimized}"
#   ebs_block_device            = "${var.ebs_block_device}"
#   ephemeral_block_device      = "${var.ephemeral_block_device}"
#   root_block_device           = "${var.root_block_device}"

#   lifecycle {
#     create_before_destroy = true
#   }
# }

resource "aws_cloudformation_stack" "autoscaling_group" {
  name = "${var.cfn_stack_name}"
  template_body = <<EOF
Description: "${var.cfn_stack_description}"
Resources:
  ASG:
    Type: AWS::AutoScaling::AutoScalingGroup
    Properties:
      VPCZoneIdentifier: ["${join("\",\"", module.vpc.private_subnets)}"]
      AvailabilityZones: ["${join("\",\"", data.aws_availability_zones.available.names)}"]
      LaunchConfigurationName: "${aws_launch_configuration.lc_blue.name}"
      MinSize: "${var.asg_min_size}"
      MaxSize: "${var.asg_max_size}"
      DesiredCapacity: "${var.asg_desired_capacity}"
      HealthCheckType: EC2
    UpdatePolicy:
      AutoScalingScheduledAction:
        IgnoreUnmodifiedGroupSizeProperties: 'true'
      AutoScalingRollingUpdate:
        MinInstancesInService: '2'
        MaxBatchSize: '1'
        WaitOnResourceSignals: 'false'
        PauseTime: PT1M
EOF
}