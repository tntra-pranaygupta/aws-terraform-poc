# main.tf
# This is the SINGLE main.tf your mentor described.
# All environments use this file — differences come from .tfvars only.

# Data source: reads available AZs in the region (no cost, no resources created)
data "aws_availability_zones" "available" {
  state = "available"
}

# We'll add VPC, EC2 etc. in Phase 1.
# For now, this lets 'terraform plan' succeed so the pipeline goes green.