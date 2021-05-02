# Using inline credentials
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

# Used to filter AMIs and retrieve the AMI id
data "aws_ami" "amazon" {
  owners      = ["amazon"]
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.20210421.0-x86_64-gp2"]
  }
}

resource "aws_security_group" "server_sg" {
  name        = "server_sg"
  description = "A security group to server nedeed rules."

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH Rule"
    from_port   = 22
    protocol    = "tcp"
    to_port     = 22
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP Rule"
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "default_instance" {
  #   ami           = ami-048f6ed62451373d9 -> can be used this way
  ami           = data.aws_ami.amazon.id
  instance_type = "t3.micro"
  key_name      = "awskeypair"

  security_groups  = [aws_security_group.server_sg.name]
  user_data = fileexists("${path.module}/scripts/ec2-user-data.sh") ? file("${path.module}/scripts/ec2-user-data.sh") : local.ec2_user_data

  tags = {
    "name"           = "default_instance"
    "provisioned_by" = "terraform"
  }
}
