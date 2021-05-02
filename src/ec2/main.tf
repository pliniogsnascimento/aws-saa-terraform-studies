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
  owners      = ["137112412989"]
  most_recent = true

  filter {
    name   = "image-id"
    values = ["ami-048f6ed62451373d9"]
  }
}

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "A security group to allow ssh into instances"

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
}

resource "aws_instance" "default_instance" {
  #   ami           = ami-048f6ed62451373d9 -> can be used this way
  ami           = data.aws_ami.amazon.id
  instance_type = "t3.micro"
  key_name      = "awskeypair"

  security_groups  = [aws_security_group.allow_ssh.name]
  user_data = fileexists("${path.module}/scripts/ec2-user-data.sh") ? file("${path.module}/scripts/ec2-user-data.sh") : local.ec2_user_data

  tags = {
    "name"           = "default_instance"
    "provisioned_by" = "terraform"
  }
}
