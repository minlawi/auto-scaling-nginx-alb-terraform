# System Architecture Workflow

![image alt](https://github.com/minlawi/auto-scaling-nginx-alb-terraform/blob/9f95b77985297c3e9e77602c896c895d2d9c9686/private-nginx-alb-workflow.drawio.png)

### 📘 Project Overview
This mini-project demonstrates the implementation of a 🚦 **Blue-Green Deployment strategy** on ☁️ **Amazon Web Services (AWS)** using 🔮 **Terraform** as the Infrastructure as Code (IaC) tool.

The project provisions and manages the following key 🛠️ components:

- 🔮 **Terraform** – Infrastructure as Code for provisioning and managing all AWS resources.

- 🖥️ **AWS EC2** – Virtual servers running the web app in Blue and Green environments.

- 📈 **AWS Auto Scaling Group (ASG)** – Dynamically scales instances based on demand.

- 🌐 **AWS Application Load Balancer (ALB)** – Routes traffic and enables seamless switching between Blue and Green environments.

- 🧾 **AWS Launch Template** – Defines instance configuration for Auto Scaling Groups.

- 🚦 **Blue-Green Deployment Strategy** – For zero-downtime deployments and instant rollback.

- 🌍 **Nginx** – Lightweight web server installed on eac🛠️h EC2 instance to serve app content.

- 🗂️ **Amazon S3** – Object storage for static assets, configuration files, or logs related to the web application.

- 🔒 **AWS Security Groups** – Control inbound/outbound traffic to EC2 and ALB.

- 📊 **Amazon CloudWatch** *(optional)* – For monitoring metrics and scaling triggers.

- 🧪 **Test/Staging Environment** – Used to validate Green environment before traffic switch.

This setup enables ⚙️ **zero-downtime deployments**, ♻️ **easy rollbacks**, and 📈 **high availability**. Once a new version of the application is fully tested in the Green environment, traffic is routed from Blue to Green through the ALB. In case of any failure, traffic can be quickly redirected back to the Blue environment, minimizing disruption.

This project showcases a practical and scalable deployment workflow, ideal for applications requiring continuous delivery and rapid recovery in production environments.

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

# Pre-requesities
* **1.** Clone this repo to your machine
<pre>git clone https://github.com/minlawi/auto-scaling-nginx-alb-terraform.git
cd auto-scaling-nginx-alb-terraform/</pre>

* **2.** Update the AWS profile in the **variables.tf** file and the bucket name in the **s3.tf** file located within the s3_bucket folder.

* **3.** After updating the profile and bucket name, proceed to create the S3 bucket, which will be used to store the Terraform state file.
<pre>cd s3_bucket/
terraform init
terraform validate
terraform plan
terraform apply -auto-approve</pre>

# Verfication

![image alt](https://github.com/minlawi/auto-scaling-nginx-alb-terraform/blob/66f032eab95df350de2cf7eeae5d2b4a97ef3b94/Screenshot%20from%202025-04-12%2012-31-23.png)

![image alt](https://github.com/minlawi/auto-scaling-nginx-alb-terraform/blob/66f032eab95df350de2cf7eeae5d2b4a97ef3b94/Screenshot%20from%202025-04-12%2012-34-39.png)

![image alt](https://github.com/minlawi/auto-scaling-nginx-alb-terraform/blob/66f032eab95df350de2cf7eeae5d2b4a97ef3b94/Screenshot%20from%202025-04-12%2012-34-01.png)

* **3.** Create a **terraform.tfvars** file and define the required variables within it, inside the **auto-scaling-nginx-alb-terraform** directory.
<pre>cd ..
profile        = "your-profile-name"
create_vpc     = true
cidr_block     = ["192.168.0.0/16"]
create_bastion = ture </pre>

* **4.** Update the **backend** block in the providers.tf inside the **auto-scaling-nginx-alb-terraform** directory.
<pre>terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.89.0"
    }
  }
  backend "s3" {
    bucket       = "your_bucket_name"
    key          = "state_file_name"
    region       = "your_region"
    encrypt      = true
    profile      = "your_profile"
    use_lockfile = true // Terrafrom version 1.10 and above locks the state file to prevent concurrent modifications
  }
}</pre>