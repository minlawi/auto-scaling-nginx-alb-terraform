# System Architecture Workflow

![image alt](https://github.com/minlawi/auto-scaling-nginx-alb-terraform/blob/75ede3560c273533e98bdb1de13a2c91d23cce3f/nginx-alb-terraform-Page-5.drawio(1).png)

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

# Pre-requesities and Step-by-Step Guides
* **1.** Clone this repo to your machine
```
git clone https://github.com/minlawi/auto-scaling-nginx-alb-terraform.git
cd auto-scaling-nginx-alb-terraform/
```

* **2.** Update the AWS profile in the **variables.tf** file and the bucket name in the **s3.tf** file located within the s3_bucket folder.

* **3.** After updating the profile and bucket name, proceed to create the S3 bucket, which will be used to store the Terraform state file.

```
cd s3_bucket/
terraform init
terraform validate
terraform plan
terraform apply -auto-approve
```

# Verfication S3 Bucket
### 🛠️ Running terraform init will initialize the Terraform configuration and set up the S3 backend.
![image alt](https://github.com/minlawi/auto-scaling-nginx-alb-terraform/blob/66f032eab95df350de2cf7eeae5d2b4a97ef3b94/Screenshot%20from%202025-04-12%2012-31-23.png)

### 🛠️ Running terraform plan followed by terraform apply -auto-approve will generate and execute an execution plan, applying the proposed changes to the infrastructure without requiring manual approval.
![image alt](https://github.com/minlawi/auto-scaling-nginx-alb-terraform/blob/66f032eab95df350de2cf7eeae5d2b4a97ef3b94/Screenshot%20from%202025-04-12%2012-34-39.png)

### 🛠️ Go to AWS Web UI and check the created S3 bucket
![image alt](https://github.com/minlawi/auto-scaling-nginx-alb-terraform/blob/66f032eab95df350de2cf7eeae5d2b4a97ef3b94/Screenshot%20from%202025-04-12%2012-34-01.png)

* **3.** Create a **terraform.tfvars** file and define the required variables within it, inside the **auto-scaling-nginx-alb-terraform** directory.
```
cd ..
touch terraform.tfvars
vi terraform.tfvars

profile        = "your-profile-name"
create_vpc     = true
cidr_block     = ["192.168.0.0/16"]
create_bastion = ture
```

* **4.** Update the **backend block** in the **providers.tf** file located within the **auto-scaling-nginx-alb-terraform** directory.
```
terraform {
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
}
```

* **5.** After updating the profile name and backend block in the providers.tf file located in the auto-scaling-nginx-alb-terraform directory, 
proceed with building the blue environment.

```terraform init
terraform validate
terraform plan
terrafrom apply -auto-approve
```

# Verification Blue Environment
### 🛠️ terraform init will initialize the Terraform configuration and set up the blue environment.
![image alt](https://github.com/minlawi/auto-scaling-nginx-alb-terraform/blob/a6c016b86abb054c9c757d61d312f21f4e850170/blue1.png)

### 🛠️ terraform validate will check the configuration files for syntax errors and verify that they are syntactically valid and internally consistent.
![image alt](https://github.com/minlawi/auto-scaling-nginx-alb-terraform/blob/a6c016b86abb054c9c757d61d312f21f4e850170/blue2.png)

### 🛠️ terraform plan prompts for active_environment; user selects blue for blue-green deployment.
![image alt](https://github.com/minlawi/auto-scaling-nginx-alb-terraform/blob/a6c016b86abb054c9c757d61d312f21f4e850170/blue3.png)

![image alt](https://github.com/minlawi/auto-scaling-nginx-alb-terraform/blob/a6c016b86abb054c9c757d61d312f21f4e850170/blue4.png)

### 🛠️ terraform apply -auto-approve still prompts for active_environment. User picks blue for blue-green deployment.
![image alt](https://github.com/minlawi/auto-scaling-nginx-alb-terraform/blob/a6c016b86abb054c9c757d61d312f21f4e850170/blue5.png)

![image alt](https://github.com/minlawi/auto-scaling-nginx-alb-terraform/blob/a6c016b86abb054c9c757d61d312f21f4e850170/blue6.png)

### 🖥️ Instances
![image alt](https://github.com/minlawi/auto-scaling-nginx-alb-terraform/blob/a6c016b86abb054c9c757d61d312f21f4e850170/instances.png)

### 🛠️ Target Groups for Blue (Active)
![image alt](https://github.com/minlawi/auto-scaling-nginx-alb-terraform/blob/a6c016b86abb054c9c757d61d312f21f4e850170/blue7.png)

### 🛠️ Target Groups for Green (Standby)
![image alt](https://github.com/minlawi/auto-scaling-nginx-alb-terraform/blob/a6c016b86abb054c9c757d61d312f21f4e850170/blue8.png)

### 🌍 Accessing the Blue instances via ALB DNS
![image alt](https://github.com/minlawi/auto-scaling-nginx-alb-terraform/blob/a6c016b86abb054c9c757d61d312f21f4e850170/blue9.png)

![image alt](https://github.com/minlawi/auto-scaling-nginx-alb-terraform/blob/a6c016b86abb054c9c757d61d312f21f4e850170/blue10.png)

# Verification Green Environment
### 🛠️ terraform apply -auto-approve shift for active_environment as green. User picks green for blue-green deployment.
![image alt](https://github.com/minlawi/auto-scaling-nginx-alb-terraform/blob/4b86f5a8a8a7ccc926f89f16e6b4e726b456e8b2/green1.png)

![image alt](https://github.com/minlawi/auto-scaling-nginx-alb-terraform/blob/4b86f5a8a8a7ccc926f89f16e6b4e726b456e8b2/green2.png)

### 🛠️ Target Groups for Green (Active)
![image alt](https://github.com/minlawi/auto-scaling-nginx-alb-terraform/blob/4b86f5a8a8a7ccc926f89f16e6b4e726b456e8b2/green3.png)

### 🛠️ Target Groups for Blue (Standby)
![image alt](https://github.com/minlawi/auto-scaling-nginx-alb-terraform/blob/4b86f5a8a8a7ccc926f89f16e6b4e726b456e8b2/green4.png)

### 🌍 Accessing the Green instances via ALB DNS
![image alt](https://github.com/minlawi/auto-scaling-nginx-alb-terraform/blob/2bccac0d1532a6c737efcd6f8820b4a0c799b289/Screenshot%20from%202025-04-12%2014-31-49.png)

![image alt](https://github.com/minlawi/auto-scaling-nginx-alb-terraform/blob/2bccac0d1532a6c737efcd6f8820b4a0c799b289/Screenshot%20from%202025-04-12%2014-31-54.png)

### 🗂️ Ensure terraform state file is stored in the S3 bucket
![image alt](https://github.com/minlawi/auto-scaling-nginx-alb-terraform/blob/4288b6377474823a8fc9255ca1dc2c97ebed3e9f/Screenshot%20from%202025-04-12%2014-29-30.png)

# Destroy the whole infrastructure
```
terraform destroy -auto-approve
```

![image alt](https://github.com/minlawi/auto-scaling-nginx-alb-terraform/blob/e4ed087a516c8ff7ee1858b11842c4d5ee8745b5/Screenshot%20from%202025-04-12%2014-48-49.png)

![image alt](https://github.com/minlawi/auto-scaling-nginx-alb-terraform/blob/2a762d6c1b5924eed073f05330385b520ecf10c9/Screenshot%20from%202025-04-12%2014-57-26.png)

# Migrating terraform.state in S3 bucket to Local and Delete the S3 bucket
* **1.** Comment out **backend block** in the **providers.tf** file located within the **auto-scaling-nginx-alb-terraform** directory.
```terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.89.0"
    }
  }
  # backend "s3" {
  #   bucket       = "lawi-bucket"
  #   key          = "terraform.tfstate"
  #   region       = "ap-southeast-1"
  #   encrypt      = true
  #   profile      = "master-programmatic-admin"
  #   use_lockfile = true // Terrafrom version 1.10 and above locks the state file to prevent concurrent modifications
  # }
}
```


* **2.** Run **terraform init -force-copy**
```
terraform init -force-copy
```

![image alt](https://github.com/minlawi/auto-scaling-nginx-alb-terraform/blob/e4ed087a516c8ff7ee1858b11842c4d5ee8745b5/Screenshot%20from%202025-04-12%2014-46-00.png)

* **3.** Destroy the S3 bucket
```
cd s3_bucket/
terraform destroy -auto-approve
```

![image alt](https://github.com/minlawi/auto-scaling-nginx-alb-terraform/blob/2e40cc5c8c7f2cb3b126c6d2842473562f54b0dd/Screenshot%20from%202025-04-12%2015-07-51.png)

![image alt](https://github.com/minlawi/auto-scaling-nginx-alb-terraform/blob/2e40cc5c8c7f2cb3b126c6d2842473562f54b0dd/Screenshot%20from%202025-04-12%2015-08-04.png)
