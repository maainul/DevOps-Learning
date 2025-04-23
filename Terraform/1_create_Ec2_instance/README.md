
---

## 🚀 Provision an EC2 Instance on AWS Using Terraform

This Terraform script provisions a **t2.micro EC2 instance** in the **us-east-1** region using a specific AMI, key pair, and subnet.

### 📄 Terraform Configuration Overview

```hcl
provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "terademo" {
  ami           = "ami-0f9de6e2d2f067fca"     # Amazon Machine Image (Ubuntu/Other)
  instance_type = "t2.micro"                  # Free tier eligible instance type
  key_name      = "nodejs-test-pair"          # Your existing key pair name in AWS
  subnet_id     = "subnet-04871572f8266f19a"  # Subnet ID where instance will be launched

  tags = {
    Name = "Tera-Test"                        # Tag for identifying the instance
  }
}
```

### 🔑 Prerequisites

- Terraform installed ([Install Terraform](https://developer.hashicorp.com/terraform/downloads))
- AWS credentials set up (via `~/.aws/credentials`, environment variables, or `provider` block)
- A valid EC2 key pair named `nodejs-test-pair`
- A subnet in your default or custom VPC
- login to aws cli : `aws configure`
### 🧪 Commands to Deploy

```bash
# Step 1: Initialize the Terraform project
terraform init

# Step 2: See the execution plan
terraform plan

# Step 3: Apply the changes (type 'yes' when prompted)
terraform apply
```

### 🧹 To Destroy the Instance

```bash
terraform destroy
```

> ⚠️ Warning: This will terminate the EC2 instance and remove all associated resources defined in this config.

---

Let me know if you'd like to extend this with security groups, elastic IPs, or auto-start scripts!
