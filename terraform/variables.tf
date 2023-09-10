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
