# outputs.tf
# Outputs are values Terraform prints after apply.
# Also used by other Terraform configs to reference this one's resources.


output "alb_dns_name" {
  description = "Load balancer URL — use this instead of EC2 IP"
  value       = "http://${aws_lb.web.dns_name}"
}