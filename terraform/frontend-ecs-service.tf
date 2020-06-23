# ECS Service & Task Definition
locals {
  app_image     = "823861797682.dkr.ecr.ap-southeast-2.amazonaws.com/frontend:latest"
  app_name      = "companynews"
  port_http     = 80
}

resource "aws_ecs_task_definition" "companynews" {
  family                = "${local.app_name}"
  network_mode          = "awsvpc"
  container_definitions = <<EOF
[
  {
    "name": "${local.app_name}",
    "container_name": "${local.app_name}",
    "image": "${local.app_image}",
    "memoryReservation": ${var.container_memory_reservation},
    "portMappings": [
      {
        "ContainerPort": ${local.port_http},
        "Protocol": "tcp"
      }
    ]
  }
]
EOF
}
resource "aws_ecs_service" "companynews" {
  name                = "${local.app_name}"
  launch_type         = "EC2"
  cluster             = "${aws_ecs_cluster.main.id}"
  task_definition     = "${aws_ecs_task_definition.companynews.arn}"
  desired_count       = "${var.ecs_service_desired_count}"
  scheduling_strategy = "DAEMON"

  load_balancer {
    target_group_arn = "${aws_alb_target_group.frontend.arn}"
    container_name   = "${local.app_name}"
    container_port   = 80
  }

  service_registries {
    registry_arn      = "${aws_service_discovery_service.companynews.arn}"
    container_name    = "${local.app_name}"
  }

  network_configuration {
    subnets             = ["${module.vpc.private_subnets}"]
    assign_public_ip    = false
    security_groups     = ["${aws_security_group.ecs_service_companynews.id}"]
  }
}
resource "aws_service_discovery_service" "companynews" {
  name = "companynews"
  dns_config {
    namespace_id = "${aws_service_discovery_private_dns_namespace.main.id}"
    dns_records {
      ttl = 10
      type = "A"
    }
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}
resource "aws_security_group" "ecs_service_companynews" {
  name        = "${var.app_name}-ECS-SG-companynews"
  vpc_id      = "${module.vpc.vpc_id}"

  ingress = {
    description       = "all from bastion"
    from_port         = 0
    to_port           = 0
    protocol          = "-1"
    security_groups   = [
      "${aws_security_group.bastion.id}",
      "${module.frontend_alb_sg.this_security_group_id}"
    ]
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
      Name = "${var.app_name}-ECS-SG-companynews"
    }
  ]
}
