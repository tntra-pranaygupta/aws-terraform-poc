# ─── EC2 Instance ─────────────────────────────────────────────────────────────
resource "aws_instance" "web" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]

  # user_data: shell script that runs when EC2 first boots
  # This installs Nginx automatically — no SSH needed
  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    yum install nginx -y
    systemctl start nginx
    systemctl enable nginx
    echo "<h1>Hello from ${var.environment} — Terraform POC</h1>" > /usr/share/nginx/html/index.html
  EOF

  tags = {
    Name = "${var.environment}-web-server"
  }
}