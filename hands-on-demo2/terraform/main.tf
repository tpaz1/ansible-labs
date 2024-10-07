# terraform {
#   backend "local" {
#     path = "../../hands-on-demo1/terraform/terraform.tfstate"  # Adjust path accordingly
#   }
# }

provider "aws" {
  region = "us-east-1"
}

resource "aws_security_group" "allow_http_ssh2" {
  name        = "allow_http_ssh2"
  description = "Allow HTTP and SSH inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allows SSH from anywhere
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Allows HTTP from anywhere
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"            # Allows all outbound traffic
    cidr_blocks = ["0.0.0.0/0"]   # Allows outbound to the internet
  }
}

# Nginx Load Balancer
resource "aws_instance" "nginx_lb" {
  ami               = "ami-0583d8c7a9c35822c"  # RHEL 9 AMI for us-east-1
  instance_type     = "t2.small"
  key_name          = "vockey"
  security_groups   = [aws_security_group.allow_http_ssh2.name]

  user_data = <<-EOF
              #!/bin/bash
              sudo dnf install nginx -y || { echo 'Nginx installation failed' > /tmp/nginx_install_error.log; exit 1; }
              EOF

  tags = {
    Name = "nginx-load-balancer"
  }
}
