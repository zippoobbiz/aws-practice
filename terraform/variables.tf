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

#################################### BACKEND ####################################
# ASG
variable "asg_min_size" {
   default = 1
}

variable "asg_max_size" {
   default = 2
}

variable "cfn_stack_description" {
   default = "description"
}

variable "asg_desired_capacity" {
   default = 1
}

variable "cfn_signal_count" {
   default = 0
}

variable "cfn_stack_name" {
   default = "companyNews"
}


#################################### FRONTEND ####################################

# ECS
variable "ecs_cluster_instance_type" {
  default = "t2.micro"
}

variable "ecs_service_desired_count" {
  default = 2
}

variable "ecs_service_min_size" {
   default = 1
}

variable "ecs_service_max_size" {
   default = 2
}

variable "container_memory_reservation" {
  default = 64
}

