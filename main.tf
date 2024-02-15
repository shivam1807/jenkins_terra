terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    } 
  }
}
# Configure the AWS Provider
provider "aws" {
  region = "eu-west-1"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  key_name= "user10_deployer-key"
  count=3
  tags = {
      Name="user10-instance-${count.index}",
       role=count.index==0?"user10-lb": (count.index<3?"user10-web":"user10-backend")
  }
  
  }
  
    output "ips"{
      value = aws_instance.instance.*.public_ip
}
