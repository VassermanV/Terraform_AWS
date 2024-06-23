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

resource "aws_launch_template" "laun_temp" {                                                  # create a template 
  name_prefix = "tf-launch-template" 
  image_id = "ami-XXXXXXXXXXXX"
  instance_initiated_shutdown_behavior = "terminate"
  instance_type = "t2.micro"
  key_name = "XXXXXXXXXXXX"
  network_interfaces {
    associate_public_ip_address = false 
    subnet_id = "XXXXXXXXXXXX"
  }
  placement {
    availability_zone = "us-west-2a"
  }
  

}


resource "aws_autoscaling_group" "aut_scale" {                                              # create an auto scale group
  name = "tf-aut_scale"
  launch_template {
    id =  aws_launch_template.laun_temp.id
    version = "$Latest"
  }
  
  vpc_zone_identifier = [ "subnet-XXXXXXXXXXXX" ]
  #availability_zones = [ "eu-west-1a" ]
  
  min_size = 1                                                                             # min and max number of EC2 instances to be deployed 
  max_size = 2
  desired_capacity = 1
}
