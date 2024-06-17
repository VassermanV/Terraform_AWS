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

resource "aws_instance" "linux_server" {              # define EC2 settings
  ami           = "ami-xxxxxxx" 
  key_name = "xxxxxxxxxxxx"
  instance_type = "t2.micro"
  subnet_id = "subnet-xxxxxxxxxxxxx"
  private_ip = "192.168.0.100"
  root_block_device {                                  # use this blok to customize root volume
    volume_size = "20"
    volume_type = "gp3"
  }
  tags = {
    Name = "tf-linux"
  }
}
