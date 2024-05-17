vpc_id = "vpc-0ba26ad0411043707"  # Replace with your actual VPC ID

subnets = [
  "subnet-01383ac8604ad193e",  # Replace with your actual subnet IDs
  "subnet-0da1fb9f0be45dc7a"
]

security_groups = [
  "sg-087d049323fbd04b1"  # Replace with your actual security group IDs
]

container_definitions = <<EOF
[
  {
    "name": "my-nodejs-container",
    "image": "767397701106.dkr.ecr.us-east-1.amazonaws.com/my-nodejs-app",
    "cpu": 256,
    "memory": 512,
    "essential": true,
    "portMappings": [
      {
        "containerPort": 3000,
        "hostPort": 3000
      }
    ],
    "environment": [
      {
        "name": "NODE_ENV",
        "value": "production"
      }
    ]
  }
]
EOF

ecs_instance_type = "t2.micro"
ecs_desired_count = 1
ecs_min_capacity = 1
ecs_max_capacity = 2
container_port = 80
lb_port = 80

