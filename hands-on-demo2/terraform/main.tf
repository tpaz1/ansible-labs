# hands-on-demo2/terraform/main.tf

provider "aws" {
  region = "us-east-1"
}

# Nginx Load Balancer
resource "aws_instance" "nginx_lb" {
  ami               = "ami-0583d8c7a9c35822c"  # RHEL 9 AMI for us-east-1
  instance_type     = "t2.small"
  key_name          = "vockey"
  security_groups   = [aws_security_group.allow_http_ssh.name]

  user_data = <<-EOF
              #!/bin/bash
              sudo dnf install nginx -y || { echo 'Nginx installation failed' > /tmp/nginx_install_error.log; exit 1; }
              sudo systemctl start nginx
              sudo systemctl enable nginx
              EOF

  tags = {
    Name = "nginx-load-balancer"
  }
}

# Ansible Module (Include existing Ansible configuration)
module "demo" {
  source = "../../modules/demo"  # Path to the Ansible module
}