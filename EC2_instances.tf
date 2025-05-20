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

variable "private_ip" {                                   # if you want to launch a couple of instances with specific IP addresses 
  default = [
    "192.168.0.100",
    "192.168.0.101",
    
  ]
}
resource "aws_instance" "linux_server" {
  ami           = "ami-xxxxxxxxxxxxxxxxxxxx" 
  key_name = "xxxxxxxxxxxx"
  instance_type = "t2.micro"
  subnet_id = "subnet-xxxxxxxxxxxxxxxxx"
  count = 2                                              # number of instances to be launched (accordingly you need to add more IP addresses) 
  private_ip = var.private_ip[count.index]               # if you launch 1 instance, specify only true or false 
  vpc_security_group_ids = [ "sg-xxxxxxxxxxxxxx" ]
    
  root_block_device {
    volume_size = "20"
    volume_type = "gp3"
  }
  
}
resource "aws_ebs_volume" "ebs_volume" {                 # additional EBS 
  count = 2                                              
  availability_zone = "eu-west-1a"
  size              = 20
  type = "gp3" 
  
}

resource "aws_volume_attachment" "ebs_attach" {
    count = 2
    device_name = "/dev/sdh"
    volume_id = aws_ebs_volume.ebs_volume[count.index].id          # attaching previously created volumes 
    instance_id = aws_instance.linux_server[count.index].id        # to earlier created instances 
    
    
}
