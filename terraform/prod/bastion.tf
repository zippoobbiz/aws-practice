data "aws_ami" "ubuntu" {
  most_recent = true
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["099720109477"] # Canonical
}

resource "aws_security_group" "bastion" {
  name        = "${var.app_name}-Bastion-SG"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress {
    description = "ssh"
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    description = "all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags {
    Name        = "${var.app_name}-Bastion-SG"
  }
}
data "template_file" "bastion_user_data" {
template = <<EOF
#!/bin/bash
cat << EOF_CONFIG >> /etc/ssh/sshd_config
AllowTcpForwarding yes
EOF_CONFIG
EOF
}
resource "aws_instance" "bastion" {
  ami                             = "${data.aws_ami.ubuntu.id}"
  instance_type                   = "${var.bastion_instance_class}"
  key_name                        = "${var.ssh_key_name}"
  vpc_security_group_ids          = ["${aws_security_group.bastion.id}"]
  subnet_id                       = "${module.vpc.public_subnets[0]}"
  associate_public_ip_address     = true
  user_data                       = "${data.template_file.bastion_user_data.rendered}"

  tags {
    Name = "Bastion"
  }
}
