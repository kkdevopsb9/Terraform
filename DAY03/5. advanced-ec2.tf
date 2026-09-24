# ==========================================
# Terraform - AWS EC2 Infrastructure
# ==========================================

# ------------------------------------------
# 1. Configure AWS Provider
# ------------------------------------------

provider "aws" {
  region = "ap-south-1"
}


# ------------------------------------------
# 2. Create Security Group
# ------------------------------------------

resource "aws_security_group" "web_sg" {
  name        = "terraform-web-sg"
  description = "Allow SSH, HTTP and HTTPS"

  # SSH
  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTPS
  ingress {
    description = "HTTPS"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-web-sg"
  }
}


# ------------------------------------------
# 3. Create EC2 Instance
# ------------------------------------------

resource "aws_instance" "webserver" {

  # Replace with valid AMI from ap-south-1
  ami = "ami-xxxxxxxxxxxxxxxxx"

  instance_type = "t2.micro"

  vpc_security_group_ids = [
    aws_security_group.web_sg.id
  ]

  # Root disk
  root_block_device {
    volume_size = 10
    volume_type = "gp3"

    tags = {
      Name = "WebServer-Root-Volume"
    }
  }

  tags = {
    Name        = "Terraform-WebServer"
    Environment = "Dev"
    Project     = "KK-FUNDA"
  }
}


# ------------------------------------------
# 4. Create Additional EBS Volume
# ------------------------------------------

resource "aws_ebs_volume" "data_volume" {

  availability_zone = aws_instance.webserver.availability_zone

  size = 10

  type = "gp3"

  tags = {
    Name = "Terraform-Data-Volume"
  }
}


# ------------------------------------------
# 5. Attach EBS Volume to EC2
# ------------------------------------------

resource "aws_volume_attachment" "ebs_attachment" {

  device_name = "/dev/sdf"

  volume_id = aws_ebs_volume.data_volume.id

  instance_id = aws_instance.webserver.id
}


# ------------------------------------------
# 6. Create Elastic IP
# ------------------------------------------

resource "aws_eip" "web_eip" {

  domain = "vpc"

  instance = aws_instance.webserver.id

  tags = {
    Name = "Terraform-Web-EIP"
  }
}


# ------------------------------------------
# 7. Outputs
# ------------------------------------------

output "instance_id" {
  description = "EC2 Instance ID"
  value       = aws_instance.webserver.id
}


output "private_ip" {
  description = "EC2 Private IP"
  value       = aws_instance.webserver.private_ip
}


output "elastic_ip" {
  description = "Elastic IP"
  value       = aws_eip.web_eip.public_ip
}


output "availability_zone" {
  description = "EC2 Availability Zone"
  value       = aws_instance.webserver.availability_zone
}
