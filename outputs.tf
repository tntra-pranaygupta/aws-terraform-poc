# outputs.tf
# Outputs are values Terraform prints after apply.
# Also used by other Terraform configs to reference this one's resources.

output "vpc_id" {
  description = "ID of the created VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = aws_subnet.public[*].id
}

output "ec2_public_ip" {
  description = "Public IP of the web server"
  value       = aws_instance.web.public_ip
}

output "website_url" {
  description = "URL to access the Nginx web server"
  value       = "http://${aws_instance.web.public_ip}"
}