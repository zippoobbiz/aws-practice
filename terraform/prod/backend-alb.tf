module "backend_alb_sg" {
  source      = "./modules/sg"
  name        = "${var.app_name}-BACKEND-ALB-SG"
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

resource "aws_alb" "backend_main" {
  name              = "${var.app_name}-BACKEND-ALB"
  subnets           = ["${module.vpc.public_subnets}"]
  security_groups   = ["${module.backend_alb_sg.this_security_group_id}"]
}
resource "aws_alb_listener" "backend_http" {
  load_balancer_arn = "${aws_alb.backend_main.arn}"
  port              = 80
  protocol          = "HTTP"
  default_action {
    target_group_arn  = "${aws_alb_target_group.backend.arn}"
    type              = "forward"
  }
}

resource "aws_alb_target_group" "backend" {
  name              = "${var.app_name}-BACKEND-TG-HTTP"
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

output "backend_alb_dns_name" {
  value = "${aws_alb.backend_main.dns_name}"
}

output "backend_alb_zone_id" {
  value = "${aws_alb.backend_main.zone_id}"
}

# data "aws_autoscaling_groups" "backend_asg" {
#   filter {
#     name   = "Key"
#     values = ["environment"]
#   }

#   filter {
#     name   = "Value"
#     values = ["backend"]
#   }
# }


# resource "aws_lb_target_group_attachment" "backend" {
#   target_group_arn = "${aws_alb_target_group.main.arn}"
#   target_id        = "${aws_instance.test.id}"
#   port             = 8080
# }

# Create a new ALB Target Group attachment
# resource "aws_autoscaling_attachment" "asg_attachment_bar" {
#   autoscaling_group_name = "${element(data.aws_autoscaling_groups.backend_asg.names, 0)}"
#   alb_target_group_arn   = "${aws_alb_target_group.main.arn}"
# }