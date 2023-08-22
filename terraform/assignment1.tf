provider "aws" {
  
  region  = "us-west-2"
}

// step-1 create VPC
resource "aws_vpc" "some_custom_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "Some Custom VPC"
  }
}

// create public subnet
resource "aws_subnet" "some_public_subnet" {
  vpc_id            = aws_vpc.some_custom_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "Some Public Subnet"
  }
}

//create private subnet
resource "aws_subnet" "some_private_subnet" {
  vpc_id            = aws_vpc.some_custom_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-west-2a"

  tags = {
    Name = "Some Private Subnet"
  }
}


// step-2 create ec2 instance
resource "aws_instance" "web_instance" {
  ami           = "ami-04e35eeae7a7c5883"
  instance_type = "t2.micro"
  subnet_id                   = aws_subnet.some_public_subnet.id
  vpc_security_group_ids      = [aws_security_group.web_sg.id]
  associate_public_ip_address = true
  
  root_block_device {
    volume_type = "gp2"
    encrypted = false
  }

  
  tags = {
    "purpose" : "Assignment"
     Name : "Assignment"
  }
}


// step-3 create security group
resource "aws_security_group" "web_sg" {
  name   = "SSH"
  vpc_id = aws_vpc.some_custom_vpc.id

  
  ingress {                // Inbound Rules
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {                 // Outbound Rules
    from_port   = 0
    to_port     = 0
    protocol    = -1
    cidr_blocks = ["0.0.0.0/0"]
  }
}



