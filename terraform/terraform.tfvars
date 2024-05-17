aws_region         = "us-east-1"
vpc_cidr           = "10.0.0.0/16"
subnet_cidrs       = ["10.0.1.0/24", "10.0.2.0/24"]
container_port     = 3000
desired_count      = 1
task_memory        = "512"
task_cpu           = "256"
ecs_cluster_name   = "hello-world-cluster"
ecs_service_name   = "hello-world-service"
ecr_repository_name = "hello-world-repo"
