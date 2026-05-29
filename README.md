# terraform-aws-poc

Production-style AWS infrastructure built with Terraform — VPC, EC2, ALB, Auto Scaling, remote state, and a GitHub Actions CI/CD pipeline.

> Built as a hands-on portfolio project to demonstrate real-world IaC practices: modular design, environment separation via `.tfvars`, remote backend with state locking, and automated validation on every push.

---

## What it deploys

| Resource | Details |
|---|---|
| VPC | Custom VPC with public + private subnets across 2 AZs |
| EC2 | Amazon Linux 2023, Nginx auto-installed via `user_data` |
| ALB | Application Load Balancer across both AZs |
| ASG | Auto Scaling Group (min 1 / max 3), health-checked by ALB |
| Launch Template | Versioned, `create_before_destroy` lifecycle |
| Security Groups | HTTP/HTTPS open, SSH locked to config |
| S3 + DynamoDB | Remote state backend with locking |


---

## Prerequisites

- Terraform >= 1.8
- AWS CLI v2, configured (`aws configure`)
- An AWS account (all resources are free-tier eligible in dev)

---

## Running it

**1. Clone and init**

```bash
git clone https://github.com/YOUR_USERNAME/terraform-aws-poc.git
cd terraform-aws-poc
terraform init
```

**2. Plan (preview changes — no resources created)**

```bash
terraform plan -var-file="envs/dev.tfvars"
```

**3. Apply (creates real AWS resources)**

```bash
terraform apply -var-file="envs/dev.tfvars"
```

After ~3 minutes, Terraform prints:

```
Outputs:
  alb_dns_name = "http://dev-web-alb-xxxx.ap-south-1.elb.amazonaws.com"
  vpc_id       = "vpc-0abc123..."
```

Open the `alb_dns_name` in your browser — you'll see the Nginx welcome page served through the load balancer.

**4. Tear down (avoid ongoing charges)**

```bash
terraform destroy -var-file="envs/dev.tfvars"
```

---

## Switching environments

Same code, different values. No workspaces, no code duplication.

```bash
# Deploy to dev
terraform apply -var-file="envs/dev.tfvars"

# Deploy to prod (different CIDR, larger instances, higher ASG capacity)
terraform apply -var-file="envs/prod.tfvars"
```

---

## CI/CD pipeline

Every push and pull request runs automatically:

| Step | Command | What it checks |
|---|---|---|
| Format | `terraform fmt -check` | Code style — fails if messy |
| Validate | `terraform validate` | Syntax and config correctness |
| Plan | `terraform plan -var-file="envs/dev.tfvars"` | Shows what would change |

`terraform apply` runs only on merge to `main`, gated by a manual approval step for `prod`.

Add these secrets to your GitHub repo (`Settings → Secrets → Actions`):

```
AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY
AWS_REGION
TF_BACKEND_BUCKET
```

---

## Key concepts demonstrated

- **Idempotency** — running `apply` twice with no code changes makes zero AWS calls
- **Dependency graph** — Terraform auto-orders resource creation from references (subnet needs VPC id → VPC is created first)
- **State locking** — DynamoDB prevents two concurrent `apply` runs from corrupting state
- **Drift detection** — manually change something in the AWS Console, then `terraform plan` to see it flagged
- **`create_before_destroy`** — Launch Template updates create the new version before deleting the old one (zero downtime)

---

