# System Architecture Workflow

![image alt](https://github.com/minlawi/auto-scaling-nginx-alb-terraform/blob/9f95b77985297c3e9e77602c896c895d2d9c9686/private-nginx-alb-workflow.drawio.png)

# Project Overview
* This mini-project demonstrates load balancing for a web server using an AWS Application Load Balancer (Internet-facing). 
* It distributes traffic across multiple instances, with an Auto Scaling Group dynamically adjusting the number of instances based on demand to improve availability and scalability.

# Deploy blue-green enviroment
Blue-Green Deployment is a software release strategy that reduces downtime and risk by running two identical production environments—Blue and Green.

# How It Works:
* The Blue environment is the current live version.
* A new version is deployed to the Green environment.
* Once tested and verified, traffic is switched from Blue to Green (usually via load balancer or DNS).
* If something goes wrong, rollback is as simple as redirecting traffic back to Blue.

# 🏢 Real-World Example (e.g., E-commerce website)
Let's say your online store is running on Blue, version 1.0
* You develop version 1.1 with improved search
* You deploy 1.1 to Green, fully test it using staging/test data.
* Once confident, you switch live traffic to Green.
* If anything breaks—like a payment bug—you flip back to Blue instantly.
* Fix issues in Green, redeploy, and switch again.

# Benefits:
* Zero downtime deployments
* Easy rollback
* Environment parity (identical setups reduce "it works on my machine" issues)

# Considerations:
* Requires duplicate infrastructure (can be costly)
* Database changes need careful handling to be backward-compatible

### 🛠️ Technologies Used

- <img src="https://www.vectorlogo.zone/logos/terraformio/terraformio-icon.svg" width="20"/> **Terraform** – Infrastructure as Code for provisioning and managing all AWS resources.
- 🖥️ **AWS EC2** – Virtual servers running the web app in Blue and Green environments.
- 📈 **AWS Auto Scaling Group (ASG)** – Dynamically scales instances based on demand.
- 🌐 **AWS Application Load Balancer (ALB)** – Routes traffic and enables seamless switching between Blue and Green environments.
- 🧾 **AWS Launch Template** – Defines instance configuration for Auto Scaling Groups.
- 🚦 **Blue-Green Deployment Strategy** – For zero-downtime deployments and instant rollback.
- 🌍 **Nginx** – Lightweight web server installed on each EC2 instance to serve app content.
- 🔒 **AWS Security Groups** – Control inbound/outbound traffic to EC2 and ALB.
- 📊 **Amazon CloudWatch** *(optional)* – For monitoring metrics and scaling triggers.
- 🧪 **Test/Staging Environment** – Used to validate Green environment before traffic switch.


# Creating the resources step-by-step
# 1. Create the AWS S3 bucket
   * git clone https://github.com/minlawi/auto-scaling-nginx-alb-terraform.git
   * cd auto-scaling-nginx-alb-terraform
   * cd s3_bucket/
   * Replace with your AWS Profile in main.tf
   * Change the bucket name in s3.tf
   * terraform init
   * terraform apply -auto-approve
   * cd ..

# 2. Create the infrastructure resources
   * Replace the bucket name in the backend block of the providers.tf file
   * terraform init
     
   ![image alt](https://github.com/minlawi/auto-scaling-nginx-alb-terraform/blob/47351bcabf787f02211787526b918c7e1dc29ff2/terraform%20init.png)
   
   * terraform apply -auto-approve

# 3. How to Test
  * http://alb_dns_name

# Destroying the resources step-by-step

# 1. Destroy the infrastructure resources
  * terraform destroy -auto-approve
# 2. Comment-out the backend block in the providers.tf file
  * terraform init -migrate-state

  ![image alt](https://github.com/minlawi/auto-scaling-nginx-alb-terraform/blob/ce32100b5ea3470330b1d9825713adefacba7d9e/Screenshot%20from%202025-03-08%2019-40-57.png)

# 3. Destroy the S3 bucket
  * cd s3_bucket/
  * terraform destroy -auto-approve

 # Disclaimer: This content is for educational purposes only.