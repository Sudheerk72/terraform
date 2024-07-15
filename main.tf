provider "aws" {
  region = var.region
}

resource "aws_vpc" "example" {
  cidr_block = var.vpc_cidr

  tags = {
    Name = "ExampleVPC"
  }
}

resource "aws_subnet" "example" {
  vpc_id     = aws_vpc.example.id
  cidr_block = var.subnet_cidr

  tags = {
    Name = "ExampleSubnet"
  }
}

resource "aws_internet_gateway" "example" {
  vpc_id = aws_vpc.example.id

  tags = {
    Name = "ExampleInternetGateway"
  }
}

resource "aws_route_table" "example" {
  vpc_id = aws_vpc.example.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.example.id
  }

  tags = {
    Name = "ExampleRouteTable"
  }
}

resource "aws_route_table_association" "example" {
  subnet_id      = aws_subnet.example.id
  route_table_id = aws_route_table.example.id
}

resource "aws_security_group" "example" {
  vpc_id = aws_vpc.example.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ExampleSecurityGroup"
  }
}

resource "aws_instance" "example" {
  ami           = var.ec2_ami_id
  instance_type = var.ec2_instance_type
  subnet_id     = aws_subnet.example.id
  security_groups = [aws_security_group.example.id]

  tags = {
    Name = "ExampleInstance"
  }
}

resource "aws_s3_bucket" "example" {
  bucket = var.s3_bucket_name
  acl    = "private"

  tags = {
    Name = "ExampleS3Bucket"
  }
}

variable "region" {
  description = "The AWS region to create resources in"
  type        = string
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "subnet_cidr" {
  description = "The CIDR block for the subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "ec2_ami_id" {
  description = "The AMI ID for the EC2 instance"
  type        = string
}

variable "ec2_instance_type" {
  description = "The instance type for the EC2 instance"
  type        = string
  default     = "t2.micro"
}

variable "s3_bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

output "vpc_id" {
  value = aws_vpc.example.id
}

output "subnet_id" {
  value = aws_subnet.example.id
}

output "internet_gateway_id" {
  value = aws_internet_gateway.example.id
}

output "route_table_id" {
  value = aws_route_table.example.id
}

output "security_group_id" {
  value = aws_security_group.example.id
}

output "instance_id" {
  value = aws_instance.example.id
}

output "bucket_id" {
  value = aws_s3_bucket.example.id
}