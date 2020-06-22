variable "app_name" {
  default = "companyNews"
}
variable "region" {
  default = "ap-southeast-2"
}

variable "backend_port" {
  default = "8080"
}

variable "ssh_key_name" {
  default = "phil-macbook"
}

variable "bastion_instance_class" {
  default = "t2.micro"
}

variable "asg_cluster_instance_type" {
  default = "t2.micro"
}

# ASG

variable "asg_min_size" {
   default = 3
}

variable "asg_max_size" {
   default = 5
}

variable "cfn_stack_description" {
   default = "description"
}


variable "asg_desired_capacity" {
   default = 4
}

variable "cfn_signal_count" {
   default = 0
}

variable "cfn_stack_name" {
   default = "companyNews"
}

variable "launch_configuration_name" {
   default = "companyNews-ASG-LC-20200621012711916400000001"
}

# variable "ssm_parameter_name_prefix" {
#   default = "/dev/kong"
# }

# locals {
#   db_user = "${var.db_username}"
#   db_password = "${var.db_password}"
#   db_engine = "${var.db_engine}"
#   db_host = "${replace(module.rds.this_db_instance_endpoint, "/:.*/", "")}"
# }
 
# ECS
# variable "ecs_cluster_instance_type" {
#   default = "m5.xlarge"
# }
# variable "app_image" {
#   default = "0jas/kong:latest"
# }
# variable "ecs_service_desired_count" {
#   default = 1
# }
# variable "container_memory_reservation" {
#   default = 64
# }

# DB
# variable "db_name" {
#   default = "kong"
# }
# variable "db_username" {
#   default = "kong"
# }
# variable "db_password" {
#   default = "k0ng12er5"
# }
# variable "db_engine" {
#   default = "postgres"
# }
# variable "db_engine_version" {
#   default = "11"
# }
# variable "db_instance_class" {
#   default = "db.t2.micro"
# }

# variable "db_port" {
#   default = 5432
# }
# variable "db_maintenance_window" {
#   default = "Mon:00:00-Mon:03:00"
# }
# variable "db_backup_window" {
#   default = "03:00-06:00"
# }
# variable "db_allocated_storage_gb" {
#   default = 5
# }

# Kong
# variable "kong_port_admin" {
#   default = "8001"
# }
# variable "kong_port_http" {
#   default = 8000
# }
# variable "kong_port_https" {
#   default = 8443
# }
