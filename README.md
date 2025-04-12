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

# Pre-requesities before creating the resources
<pre>profile        = "your-profile-name"
create_vpc     = true
cidr_block     = ["192.168.0.0/16"]
create_bastion = ture </pre>