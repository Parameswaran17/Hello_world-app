variable "vpc_id" {
  description = "The ID of the VPC where resources will be deployed."
  type        = string
}

variable "subnets" {
  description = "A list of subnet IDs where resources will be deployed."
  type        = list(string)
}

variable "security_groups" {
  description = "A list of security group IDs for the ECS tasks."
  type        = list(string)
}

variable "container_definitions" {
  description = "JSON encoded container definitions for ECS task."
  type        = string
}

variable "ecs_instance_type" {
  description = "EC2 instance type for ECS tasks."
  default     = "t2.micro"
}

variable "ecs_desired_count" {
  description = "Number of ECS tasks to run."
}

variable "ecs_min_capacity" {
  description = "Minimum number of ECS tasks to run."
}

variable "ecs_max_capacity" {
  description = "Maximum number of ECS tasks to run."
}

variable "container_port" {
  description = "Port on which the Docker container listens."
}

variable "lb_port" {
  description = "Port on which the load balancer listens."
}
