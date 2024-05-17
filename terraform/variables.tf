variable "aws_region" {
  description = "The AWS region to deploy to"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidrs" {
  description = "List of CIDR blocks for the subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "container_port" {
  description = "The port on which the container will listen"
  type        = number
  default     = 3000
}

variable "desired_count" {
  description = "The desired number of ECS service tasks"
  type        = number
  default     = 1
}

variable "task_memory" {
  description = "The amount of memory (in MiB) to allocate for the ECS task"
  type        = string
  default     = "512"
}

variable "task_cpu" {
  description = "The amount of CPU units to allocate for the ECS task"
  type        = string
  default     = "256"
}

variable "ecs_cluster_name" {
  description = "The name of the ECS cluster"
  type        = string
  default     = "hello-world-cluster"
}

variable "ecs_service_name" {
  description = "The name of the ECS service"
  type        = string
  default     = "hello-world-service"
}

variable "ecr_repository_name" {
  description = "The name of the ECR repository"
  type        = string
  default     = "hello-world-repo"
}
