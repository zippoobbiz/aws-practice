# # Backend cluster


# data "aws_ami" "asg" {
#   most_recent = true
#   owners = ["823861797682"]
#   filter {
#     name      = "name"
#     values    = ["tomcat-ami"]
#   }
# }
# module "asg_cluster_iam" {
#   source = "./modules/asg_cluster_iam"
# }
# data "template_file" "asg_user_data" {
#   template = <<EOF
# #!/bin/bash
# cat << EOF_CONFIG > /etc/asg/asg.config
# ASG_CLUSTER=${var.app_name}
# ASG_ENABLE_TASK_IAM_ROLE=true
# ASG_ENABLE_TASK_ENI=true
# ASG_DISABLE_PRIVILEGED=false
# ASG_AWSVPC_BLOCK_IMDS=false
# EOF_CONFIG
# EOF
# }


# module "asg" {
#   source                      = "./modules/asg"
#   name                        = "${var.app_name}-ASG-ASG"
#   image_id                    = "${data.aws_ami.asg.id}"
#   instance_type               = "${var.asg_cluster_instance_type}"
#   key_name                    = "${var.ssh_key_name}"

#   # Launch configuration
#   lc_name                     = "${var.app_name}-ASG-LC"
#   create_lc                   = true
#   associate_public_ip_address = false
#   iam_instance_profile        = "${module.asg_cluster_iam.asg_instance_profile_id}"
#   vpc_zone_identifier         = ["${module.vpc.private_subnets}"]
#   user_data                   = "${data.template_file.asg_user_data.rendered}"

#   security_groups = [
#     "${aws_security_group.asg_sg.id}",
#     "${aws_security_group.all_from_bastion.id}"
#   ]

#   # Auto scaling group
#   asg_name                    = "${var.app_name}-ASG-ASG"
#   health_check_type           = "EC2"
#   min_size                    = 1
#   max_size                    = 2
#   desired_capacity            = 1
#   wait_for_capacity_timeout   = 0
# }
# output "ami_id" {
#   value = "${data.aws_ami.asg.id}"
# }
