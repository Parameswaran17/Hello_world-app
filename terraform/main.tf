provider "aws" {
  region = "us-east-1"  # Specify the AWS region
}

resource "aws_instance" "ecs_instance" {
  ami           = "ami-0bb84b8ffd87024d8"  # Specify your desired AMI ID
  instance_type = "t2.micro"      # Specify your desired instance type
  subnet_id     = "subnet-01383ac8604ad193e"  # Specify your subnet ID
  # Add other instance configuration as needed

  # Provisioner to install ECS agent and register instance with the ECS cluster
  provisioner "remote-exec" {
    inline = [
      "sudo yum install -y amazon-ecs-agent",  # Install ECS agent (example for Amazon Linux)
      "sudo start ecs",  # Start ECS agent
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"  # SSH user for the instance
      private_key = file("~/.ssh/id_rsa")  # Specify your SSH private key
      host        = self.public_ip  # Public IP address of the instance
    }
  }
}

# Define ECS Task Definition for the Node.js application
resource "aws_ecs_task_definition" "my_task_definition" {
  family                   = "my-task-family"
  cpu                      = "256"      # Specify CPU resources
  memory                   = "512"      # Specify memory resources
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  # Specify the ARN of the execution role
  execution_role_arn       = "arn:aws:iam::767397701106:role/ecsTaskExecutionRole"

  container_definitions = jsonencode([
    {
      name      = "my-nodejs-container"
      image     = "767397701106.dkr.ecr.us-east-1.amazonaws.com/my-nodejs-app"
      cpu       = 256         # CPU resources for the container
      memory    = 512         # Memory resources for the container
      essential = true
      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
        }
      ]
      environment = [
        {
          name  = "NODE_ENV"
          value = "production"
        }
      ]
    }
  ])
}

# Define ECS Service for the Node.js application
resource "aws_ecs_service" "nodejs_service" {
  name            = "nodejs-service"
  cluster         = aws_ecs_cluster.default.id
  task_definition = aws_ecs_task_definition.my_task_definition.arn  # Use correct reference to task definition
  desired_count   = 1

  network_configuration {
    subnets         = var.subnets  # Replace with your subnet IDs
    security_groups = var.security_groups  # Replace with your security group IDs
  }

  depends_on = [aws_ecs_task_definition.my_task_definition]  # Use correct reference to task definition
}

resource "aws_launch_configuration" "ecs_launch_config" {
  name          = "ecs-launch-config"
  image_id      = "ami-0bb84b8ffd87024d8"  # Specify your desired AMI ID
  instance_type = "t2.micro"      # Specify your desired instance type
  # Other configuration options for the launch configuration
}

resource "aws_autoscaling_group" "ecs_autoscaling_group" {
  name                 = "ecs-autoscaling-group"
  launch_configuration = aws_launch_configuration.ecs_launch_config.name
  min_size             = 1
  max_size             = 2
  desired_capacity     = 1
  vpc_zone_identifier  = ["subnet-01383ac8604ad193e", "subnet-0da1fb9f0be45dc7a"] # Specify your subnet IDs
}
# Define an ECS Cluster
resource "aws_ecs_cluster" "default" {
  name = "default"
}

# Define an Application Load Balancer (ALB)
resource "aws_lb" "ecs_alb" {
  name               = "nodejs-alb"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.subnets  # Replace with your subnet IDs
  security_groups    = var.security_groups  # Replace with your security group IDs
}

# Define ALB Target Group
resource "aws_lb_target_group" "nodejs_target_group" {
  name        = "nodejs-target-group"
  port        = 3000
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id  # Replace with your VPC ID
}

# Define ALB Listener
resource "aws_lb_listener" "nodejs_listener" {
  load_balancer_arn = aws_lb.ecs_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nodejs_target_group.arn
  }
}

# Outputs
output "load_balancer_url" {
  value = aws_lb.ecs_alb.dns_name  # Output the ALB DNS name for easy access
}


