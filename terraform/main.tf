terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~>4.0"
    }
  }
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"]
}

data "aws_key_pair" "selected" {
  key_name = var.aws_key_pair_name
  include_public_key = true
}

resource "aws_instance" "arc_instance" {
  ami = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  key_name = data.aws_key_pair.selected.key_name
  tags = {
    Name = var.instance_name
  }
}
