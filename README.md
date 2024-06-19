# Terraform_AWS

- ec2_create - simple standalone EC2 deployment with predifiend IP address and customized (volume type & volume size) root block device.
- ec2_instances - more complex conf file where you can launch 2 (or more) EC2 instances with predefined IP address, additional EBS volumes, which are attached to EC2
- vpc_routr_igw.tf - create a VPC with 2 subnets ( private and public) + internet gateway and attach it to a previously created VPC. Create a route table and define a new route to the internet gateway. Define a new security group with custom inbound and outbound ports/IPs
