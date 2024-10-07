provider "aws" {
  region = "us-east-1"
}

# Security group for allowing SSH and HTTP traffic
resource "aws_security_group" "allow_http_ssh" {
  name        = "allow_http_ssh"
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

# Ansible Controller
resource "aws_instance" "ansible_controller" {
  ami               = "ami-0583d8c7a9c35822c"  # RHEL 9 AMI for us-east-1
  instance_type     = "t2.small"
  key_name          = "vockey"
  security_groups   = [aws_security_group.allow_http_ssh.name]

  user_data = <<-EOF
              #!/bin/bash
              sudo dnf install ansible-core -y || { echo 'Ansible installation failed' > /tmp/ansible_install_error.log; exit 1; }
              sudo dnf install -y git || { echo 'Git installation failed' > /tmp/git_install_error.log; exit 1; }
              git clone https://github.com/tpaz1/ansible-labs.git /home/ec2-user/ansible-labs || { echo 'Git clone failed' > /tmp/git_clone_error.log; exit 1; }
              EOF

  tags = {
    Name = "ansible-controller"
  }
}

# Ansible Workers
resource "aws_instance" "ansible_workers" {
  count             = 3
  ami               = "ami-0583d8c7a9c35822c"  # CentOS 7 AMI for us-east-1
  instance_type     = "t2.small"
  key_name          = "vockey"
  security_groups   = [aws_security_group.allow_http_ssh.name]

  tags = {
    Name = "ansible-worker-${count.index + 1}"
  }
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
