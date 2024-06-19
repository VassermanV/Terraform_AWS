terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
      
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
    region = "${var.region}"
    access_key = "${var.access_key}"
    secret_key = "${var.secret_key}"
    
}

resource "aws_vpc" "vpc" {                                  # creating a new VPC with required CIDR 
  cidr_block = "192.168.0.0/20"
  
  tags = {
    Name = "terraform_vpc"
  }
}

resource "aws_subnet" "tf_pub_subnet" {                     # create a public subnet in preiously created VPC 
  vpc_id = aws_vpc.vpc.id
  cidr_block = "192.168.0.0/24"
  availability_zone = "eu-west-1a"
  tags = {
    Name = "tf_public"
  }
  
}

resource "aws_subnet" "tf_priv_subnet" {
  vpc_id = aws_vpc.vpc.id
  cidr_block = "192.168.1.0/24"
  availability_zone = "eu-west-1a"
  tags = {
    Name = "tf_private"
  }
  
}

resource "aws_internet_gateway" "igw" {                    # create internet gateway for internet access 
  vpc_id = aws_vpc.vpc.id                                  # attaching IG to previously created VPC
  tags = {
    Name = "tf-igw"
  }
}

  resource "aws_route_table" "routetable" {                 # create a new route table for a new VPC
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "tf-route"
  }
  
}

resource "aws_route" "route_to_igw" {               # define a route to previously created IGW
  route_table_id = aws_route_table.routetable.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id = aws_internet_gateway.igw.id
}

resource "aws_route_table_association" "rt_assoc" {                               # assosiate a new route table to the previously created public subnet
  subnet_id = aws_subnet.tf_pub_subnet.id
  route_table_id = aws_route_table.routetable.id 
  
}
resource "aws_security_group" "tf_sg" {                                             # create a security group 
  name = "tf_sec_gr"
  vpc_id = aws_vpc.vpc.id 
  ingress {                                                                         # define inbound and outbound rules 
    from_port = "0"                      # for test purposes I opened access for all IPs and port range from 0 to 3000
    to_port = "3000"
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = "0"
    to_port = "0"
    protocol = "-1"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}
