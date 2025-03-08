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

# Creating resources step-by-step
# 1. Create the AWS S3 bucket
   * git clone https://github.com/minlawi/auto-scaling-nginx-alb-terraform.git
   * cd auto-scaling-nginx-alb-terraform
   * cd backend
   * Replace your AWS profile 
   * terraform init
   * terraform apply -auto-approve
   * cd ..

# 2. Create the infrastructure resources
   * terraform init
     
   ![image alt](https://github.com/minlawi/auto-scaling-nginx-alb-terraform/blob/47351bcabf787f02211787526b918c7e1dc29ff2/terraform%20init.png)
   
   * terraform apply -auto-approve

# 3. Test Results
  * http://alb_dns_name

# Destroying resources step-by-step

# 1. Destroy the infrastructure resources
  * terraform destroy -auto-approve
# 2. Comment-out the backend block in the providers.tf file.
  * terraform init -migrate-state

  ![image alt](https://github.com/minlawi/auto-scaling-nginx-alb-terraform/blob/ce32100b5ea3470330b1d9825713adefacba7d9e/Screenshot%20from%202025-03-08%2019-40-57.png)

# 3. Destroy the S3 bucket
  * cd backend/
  * terraform destroy -auto-approve

 # Disclaimer: This content is for educational purposes only and should not be used in a production environment.
