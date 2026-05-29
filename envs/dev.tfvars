# envs/dev.tfvars
# VALUES for the dev environment
# This is what makes the same main.tf deploy differently per environment

environment = "dev"
aws_region  = "ap-south-1"

vpc_cidr             = "10.0.0.0/16"
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.10.0/24", "10.0.20.0/24"]

instance_type = "t2.micro" # Free tier