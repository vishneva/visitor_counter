terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~>4.0"
    }
    ansible = {
      version = "~> 0.0.1"
      source  = "terraform-ansible.com/ansibleprovider/ansible"
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

resource "ansible_host" "ec2_inst" {
  name               = public_ip
  inventory_hostname = ""
  variables          = {
    ansible_user                 = "ansible",
    ansible_ssh_private_key_file = var.aws_key_pair_name,
    ansible_python_interpreter   = "/usr/bin/python3"
  }
}
