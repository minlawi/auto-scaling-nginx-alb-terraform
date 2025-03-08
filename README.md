# System Architecture Workflow
![image alt](https://github.com/minlawi/auto-scaling-nginx-alb-terraform/blob/9f95b77985297c3e9e77602c896c895d2d9c9686/private-nginx-alb-workflow.drawio.png)

# Project Overview
* This mini-project demonstrates load balancing for a web server using an AWS Application Load Balancer (Internet-facing). 
* It distributes traffic across multiple instances, with an Auto Scaling Group dynamically adjusting the number of instances based on demand to improve availability and scalability.

# Technologies Used
 * Terraform for Infrastructure as Code (IaC)
 * AWS VPC, Subnets, Route Table, Internet Gateway, Public NAT Gateway, Elastic IP, Bastion (Jumphost), Auto Scaling Group, Launch Template and EC2.
 * AWS S3 bucket to store the terraform state file.
 * Bash Scripting (User data for EC2 setup)

 # Disclaimer: This content is for educational purposes only and should not be used in a production environment.