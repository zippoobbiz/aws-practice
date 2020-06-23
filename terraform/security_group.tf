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