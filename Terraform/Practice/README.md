To create separate environments (e.g., `dev`, `staging`, `prod`) with dedicated VPCs and resources, you can use **Terraform workspaces** or **separate `.tfvars` files** for each environment. This approach ensures that each environment is isolated and managed independently.

Here’s how you can achieve this:

---

### **Option 1: Using Terraform Workspaces**

Terraform workspaces allow you to manage multiple environments (e.g., `dev`, `staging`, `prod`) within the same configuration. Each workspace has its own state file, so resources are isolated.

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
   terraform apply
   ```

---

### **Option 2: Using Separate `.tfvars` Files**

You can create separate `.tfvars` files for each environment (e.g., `dev.tfvars`, `staging.tfvars`, `prod.tfvars`) and use them to provide environment-specific values.

#### Steps:

1. **Create `.tfvars` Files**:
   Create a `.tfvars` file for each environment.

   ##### `dev.tfvars`:
   ```hcl
   env              = "dev"
   vpc_cidr_block   = "10.0.0.0/16"
   public_subnets   = ["10.0.1.0/24"]
   ```

   ##### `staging.tfvars`:
   ```hcl
   env              = "staging"
   vpc_cidr_block   = "10.1.0.0/16"
   public_subnets   = ["10.1.1.0/24"]
   ```

   ##### `prod.tfvars`:
   ```hcl
   env              = "prod"
   vpc_cidr_block   = "10.2.0.0/16"
   public_subnets   = ["10.2.1.0/24"]
   ```

2. **Use Variables in Configuration**:
   Reference the variables in your Terraform configuration.

   ##### Example:
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

3. **Apply Configuration with `.tfvars` Files**:
   Use the `-var-file` flag to specify the `.tfvars` file for each environment.

   ```bash
   terraform apply -var-file="dev.tfvars"
   terraform apply -var-file="staging.tfvars"
   terraform apply -var-file="prod.tfvars"
   ```

---

### **Option 3: Using Modules**

You can create a reusable module for your environment (e.g., VPC, subnets, EC2 instances) and call it multiple times with different variables for each environment.

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
- Use **separate `.tfvars` files** if you prefer to manage environments with distinct configuration files.
- Use **modules** if you want to create reusable components for each environment.

---

### **Example: Using Separate `.tfvars` Files**

Here’s a complete example using separate `.tfvars` files:

#### `dev.tfvars`:
```hcl
env              = "dev"
vpc_cidr_block   = "10.0.0.0/16"
public_subnets   = ["10.0.1.0/24"]
```

#### `staging.tfvars`:
```hcl
env              = "staging"
vpc_cidr_block   = "10.1.0.0/16"
public_subnets   = ["10.1.1.0/24"]
```

#### `prod.tfvars`:
```hcl
env              = "prod"
vpc_cidr_block   = "10.2.0.0/16"
public_subnets   = ["10.2.1.0/24"]
```

#### `main.tf`:
```hcl
provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

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

#### Apply Configuration:
```bash
terraform apply -var-file="dev.tfvars"
terraform apply -var-file="staging.tfvars"
terraform apply -var-file="prod.tfvars"
```

---

Let me know if you need further assistance! 😊