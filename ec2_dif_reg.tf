terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
      
    }
  }

 
}
provider "aws" {                          ## specifying the required region, where you need to deploy resources 
    region = "eu-west-1"
    alias = "Ireland"                     
    access_key = "XXXXXXXXXXXXXXXXX"
    secret_key = "XXXXXXXXXXXXXXXXX"
       
}
provider "aws" {
  region = "eu-central-1"
  alias = "Frankfurt"
  access_key = "XXXXXXXXXXXXXXXXX"
  secret_key = "XXXXXXXXXXXXXXXXX"
}

resource "aws_instance" "linux_server" {

  ami = "ami-XXXXXXXXXXXXXXXXX"
  key_name = "XXXXXXXXXXXXXXXXX"
  instance_type = "t2.micro"
  subnet_id = "subnet-XXXXXXXXXXXXXXXXX"
  associate_public_ip_address = false
  vpc_security_group_ids = [ "sg-XXXXXXXXXXXXXXXXX" ]
  provider = aws.Ireland                    ## to specify in which region to deploy the EC2 instance 

}

resource "aws_instance" "linux_server_frnk" {
  
  ami = "XXXXXXXXXXXXXXXXX"
  key_name = "XXXXXXXXXXXXXXXXX"
  instance_type = "t2.micro"
  subnet_id = "subnet-XXXXXXXXXXXXXXXXX"
  associate_public_ip_address = false
  vpc_security_group_ids = [ "sg-XXXXXXXXXXXXXXXXX" ]
  provider = aws.Frankfurt
  
}
