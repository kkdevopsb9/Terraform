# ==========================================
# Terraform - Create AWS EC2 Instance
# ==========================================

# 1. Configure AWS Provider
provider "aws" {
  region = "ap-south-1"
}


# 2. Create EC2 Instance
resource "aws_instance" "webserver" {

  # Replace with a valid AMI ID from your AWS account/region
  ami = "ami-xxxxxxxxxxxxxxxxx"

  instance_type = "t2.micro"

  tags = {
    Name        = "Terraform-WebServer"
    Environment = "Dev"
  }
}
