The issue you're facing occurs because **Terraform uses a single state file by default**, and when you switch between environments (e.g., `dev`, `staging`, `prod`), Terraform tries to reconcile the state, which results in destroying the previous resources and creating new ones.

To solve this problem, you need to **isolate the state files for each environment**. Here are the solutions:

---

### **Solution 1: Use Terraform Workspaces**

Terraform workspaces allow you to manage multiple environments (e.g., `dev`, `staging`, `prod`) within the same configuration, but each workspace has its own **isolated state file**.

#### Steps:

1. **Create Workspaces**:
   Create a workspace for each environment.

   ```bash
   terraform workspace new dev
   terraform workspace new staging
   terraform workspace new prod
   ```

2. **Switch Between Workspaces**:
   Switch to the desired workspace before applying changes.

   ```bash
   terraform workspace select dev
   ```

3. **Use Workspace-Specific Variables**:
   Use the `terraform.workspace` variable to dynamically adjust configurations based on the workspace.

   ##### Example:
   ```hcl
   variable "vpc_cidr_block" {
     description = "CIDR Block For VPC"
     type        = map(string)

     default = {
       dev     = "10.0.0.0/16"
       staging = "10.1.0.0/16"
       prod    = "10.2.0.0/16"
     }
   }

   resource "aws_vpc" "vpc" {
     cidr_block = var.vpc_cidr_block[terraform.workspace]
     tags = {
       Name        = "${terraform.workspace}-vpc"
       Environment = terraform.workspace
     }
   }
   ```

4. **Apply Configuration**:
   Apply the configuration for the selected workspace.

   ```bash
   terraform apply -var-file="dev.tfvars"
   ```

---

### **Solution 2: Use Separate `.tfvars` Files with Remote Backend**

If you want to use separate `.tfvars` files but still isolate the state files, you can configure a **remote backend** (e.g., AWS S3) and use **workspaces** or **separate state files** for each environment.

#### Steps:

1. **Configure Remote Backend**:
   Add a `backend` block to your `main.tf` file to store the state file in a remote location (e.g., AWS S3).

   ##### `main.tf`:
   ```hcl
   terraform {
     backend "s3" {
       bucket = "my-terraform-state-bucket"
       key    = "environments/${terraform.workspace}/terraform.tfstate"
       region = "us-east-1"
     }
   }
   ```

2. **Initialize the Backend**:
   Run `terraform init` to initialize the remote backend.

   ```bash
   terraform init
   ```

3. **Create Workspaces**:
   Create a workspace for each environment.

   ```bash
   terraform workspace new dev
   terraform workspace new staging
   terraform workspace new prod
   ```

4. **Apply Configuration**:
   Apply the configuration for each workspace.

   ```bash
   terraform workspace select dev
   terraform apply -var-file="dev.tfvars"

   terraform workspace select staging
   terraform apply -var-file="staging.tfvars"

   terraform workspace select prod
   terraform apply -var-file="prod.tfvars"
   ```

---

### **Solution 3: Use Separate Directories**

Another approach is to create **separate directories** for each environment. Each directory will have its own Terraform configuration and state file.

#### Steps:

1. **Create Directory Structure**:
   Create separate directories for `dev`, `staging`, and `prod`.

   ```
   terraform-project/
   ├── dev/
   │   ├── main.tf
   │   ├── variables.tf
   │   ├── dev.tfvars
   ├── staging/
   │   ├── main.tf
   │   ├── variables.tf
   │   ├── staging.tfvars
   ├── prod/
   │   ├── main.tf
   │   ├── variables.tf
   │   ├── prod.tfvars
   ```

2. **Initialize and Apply for Each Environment**:
   Navigate to each directory and run `terraform init` and `terraform apply`.

   ```bash
   cd dev
   terraform init
   terraform apply -var-file="dev.tfvars"

   cd ../staging
   terraform init
   terraform apply -var-file="staging.tfvars"

   cd ../prod
   terraform init
   terraform apply -var-file="prod.tfvars"
   ```

---

### **Solution 4: Use Modules with Separate State Files**

You can create a **reusable module** for your environment and call it multiple times with different variables for each environment. Each module call will have its own state file.

#### Steps:

1. **Create a Module**:
   Define a module for your environment.

   ##### `modules/environment/main.tf`:
   ```hcl
   variable "env" {
     description = "Environment (dev, staging, prod)"
     type        = string
   }

   variable "vpc_cidr_block" {
     description = "CIDR Block For VPC"
     type        = string
   }

   variable "public_subnets" {
     description = "Public subnet CIDR blocks"
     type        = list(string)
   }

   resource "aws_vpc" "vpc" {
     cidr_block = var.vpc_cidr_block
     tags = {
       Name        = "${var.env}-vpc"
       Environment = var.env
     }
   }

   resource "aws_subnet" "public_subnet" {
     count      = length(var.public_subnets)
     vpc_id     = aws_vpc.vpc.id
     cidr_block = var.public_subnets[count.index]
     tags = {
       Name = "${var.env}-public-subnet-${count.index + 1}"
     }
   }
   ```

2. **Call the Module for Each Environment**:
   Use the module in your root configuration.

   ##### `main.tf`:
   ```hcl
   module "dev" {
     source = "./modules/environment"

     env            = "dev"
     vpc_cidr_block = "10.0.0.0/16"
     public_subnets = ["10.0.1.0/24"]
   }

   module "staging" {
     source = "./modules/environment"

     env            = "staging"
     vpc_cidr_block = "10.1.0.0/16"
     public_subnets = ["10.1.1.0/24"]
   }

   module "prod" {
     source = "./modules/environment"

     env            = "prod"
     vpc_cidr_block = "10.2.0.0/16"
     public_subnets = ["10.2.1.0/24"]
   }
   ```

3. **Apply Configuration**:
   Apply the configuration to create resources for all environments.

   ```bash
   terraform apply
   ```

---

### **Recommendation**

- Use **Terraform workspaces** if you want to manage environments within the same configuration and state files.
- Use **separate directories** if you prefer to keep environments completely isolated.
- Use **modules** if you want to create reusable components for each environment.

---

Let me know if you need further clarification or assistance! 😊