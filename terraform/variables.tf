variable "instance_name" {
  description = "Name of the instance"
  type = string
  default = "EC2_instance"
}

variable "instance_type"{
  description = "Instance type"
  type = string
  default = "t2.micro"
}

variable "instance_ami"{
  description = "Ubuntu AMI ID"
  type = string
  default = "ami-0f5ee92e2d63afc18"
}

variable "aws_region" {
  description = "AWS region"
  type = string
  default = "us-east-1"
}

variable "aws_secret_key" {
  description = "AWS secret key"
  type = string
  default = ""
}

variable "aws_access_key"{
  description = "AWS access key"
  type = string
  default = ""
}
