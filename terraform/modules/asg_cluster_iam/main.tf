# IAM roles for ECS
resource "aws_iam_role" "asg-vm-instance-role" {
  name               = "asg-vm-instance-role"
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
resource "aws_iam_role_policy" "asg_instance_role_policy" {
  name     = "asg_instance_role_policy"
  policy   = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
		{
			"Effect": "Allow",
			"Action": [
				"ec2:CreateNetworkInterface",
				"ec2:DescribeNetworkInterfaces",
				"ec2:DetachNetworkInterface",
				"ec2:DeleteNetworkInterface",
				"ec2:AttachNetworkInterface",
				"ec2:DescribeInstances",
				"autoscaling:CompleteLifecycleAction"
			],
			"Resource": "*"
		}
  ]
}
EOF
  role     = "${aws_iam_role.asg-vm-instance-role.id}"
}

# Instance profile for this role - to be attached to ECS instances
resource "aws_iam_instance_profile" "asg" {
  name = "asg-vm-instance-profile"
  path = "/"
  role = "${aws_iam_role.asg-vm-instance-role.name}"
}

output "asg_instance_profile_id" {
  value = "${aws_iam_instance_profile.asg.id}"
}
