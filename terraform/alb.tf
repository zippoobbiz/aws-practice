module "alb_sg" {
  source      = "./modules/sg"
  name        = "${var.app_name}-ALB-SG"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress_cidr_blocks = ["0.0.0.0/0"]

  ingress_with_cidr_blocks = [
    {
      description = "http"
      protocol    = "tcp"
      from_port   = 80,
      to_port     = 80,
      cidr_blocks = "0.0.0.0/0"
    },
    {
      description = "https"
      protocol    = "tcp"
      from_port   = 443,
      to_port     = 443,
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  egress_with_cidr_blocks = [
    {
      description = "all outbound"
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
}

resource "aws_alb" "main" {
  name              = "${var.app_name}-ALB"
  subnets           = ["${module.vpc.public_subnets}"]
  security_groups   = ["${module.alb_sg.this_security_group_id}"]
}
resource "aws_alb_listener" "http" {
  load_balancer_arn = "${aws_alb.main.arn}"
  port              = 80
  protocol          = "HTTP"
  default_action {
    target_group_arn  = "${aws_alb_target_group.main.arn}"
    type              = "forward"
  }
}

resource "aws_alb_target_group" "main" {
  name              = "${var.app_name}-TG-HTTP"
  port              = 8080
  protocol          = "HTTP"
  vpc_id            = "${module.vpc.vpc_id}"
  target_type       = "instance"
  stickiness {
    type            = "lb_cookie"
  }
  health_check {
    path            = "/"
    matcher         = "200,404"
  }
}

output "alb_dns_name" {
  value = "${aws_alb.main.dns_name}"
}

output "alb_zone_id" {
  value = "${aws_alb.main.zone_id}"
}




# resource "aws_lb_target_group_attachment" "backend" {
#   target_group_arn = "${aws_alb_target_group.main.arn}"
#   target_id        = "${aws_instance.test.id}"
#   port             = 8080
# }

# Create a new ALB Target Group attachment
resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = "companyNews-ASG-1LRIN3PUU75L8"
  alb_target_group_arn   = "${aws_alb_target_group.main.arn}"
}