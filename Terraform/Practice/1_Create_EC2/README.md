### To make your subnet public:
1. Create an Internet Gateway (IGW) and attach it to your VPC.
2. Create a route table with a route that points to the IGW.
3. Associate the route table with your subnet.

Yes, that's exactly the way to create a **public EC2 instance** in AWS! 🎯

### Here's a Quick Recap of the Steps You Need for a Public EC2 Instance:

1. **VPC** – Your virtual network in AWS.
2. **Subnet** – Define a range of IP addresses within your VPC.
3. **Internet Gateway (IGW)** – Allows traffic between your VPC and the internet.
4. **Route Table** – Adds a route to send outbound traffic to the IGW.
5. **Associate Route Table to Subnet** – Connect the public route to your subnet.
6. **EC2 Configuration**:
   - Ensure `associate_public_ip_address = true`.
   - Apply the right **Security Group** rules (e.g., allow SSH on port 22, HTTP on port 80).
7. **Elastic IP (Optional)** – For a static IP address.

---

### Visualizing the Setup:
```
VPC
 ├── Public Subnet
 │    ├── Route Table (0.0.0.0/0 -> IGW)
 │    ├── EC2 Instance (with public IP)
 └── Internet Gateway (Attached to VPC)
```

---

### Now, When Do You Create a Private EC2 Instance?

- **No Internet Gateway** attached.
- **No route to 0.0.0.0/0** (internet).
- The instance can **only communicate internally** within the VPC or via **NAT Gateway** for restricted outbound internet access.

---

If you follow these steps, you'll have a fully functional **public EC2 instance** that can be accessed over the internet. Let me know if you face any issues or need more help setting up! 🚀

```hcl
provider "aws" {
  region     = "us-east-1"
  profile    = "default"
  access_key = ""
  secret_key = ""
}

# Dedicated VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  tags = {
    Name = "${local.env}-vpc"
  }
}

# Subnet Block
resource "aws_subnet" "public_subnet" {
  count      = 1
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.public_subnet_cidr_blocks[count.index]
  tags = {
    Name = "${local.env}-public-subnet"
  }
}

# Create public and private Key
resource "tls_private_key" "terraform_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Generate key pair
resource "aws_key_pair" "generated_key" {
  key_name   = "${local.env}-terraform-key"
  public_key = tls_private_key.terraform_key.public_key_openssh
}

# Save File locally in directory
resource "local_file" "private_key" {
  content         = tls_private_key.terraform_key.private_key_pem
  filename        = "${path.module}/${local.env}-terraform-key.pem"
  file_permission = "0600"
}

# Elastic IP Address Allocation for EC2
resource "aws_eip" "ec2_ip" {
  tags = {
    Name = "${local.env}_my_eip_ec2"
  }
}

#Associate IP With Instances
resource "aws_eip_association" "terademo_eip_association" {
  instance_id   = aws_instance.terademo.id
  allocation_id = aws_eip.ec2_ip.id
}

# Security Group
resource "aws_security_group" "sg" {
  name        = "${local.env}-sg"
  description = "Security group for public ips"
  vpc_id      = aws_vpc.vpc.id
}

# Ingress Rules
resource "aws_security_group_rule" "allow_80" {
  security_group_id = aws_security_group.sg.id
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
}

resource "aws_security_group_rule" "allow_22" {
  security_group_id = aws_security_group.sg.id
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
}

resource "aws_security_group_rule" "allow_3000" {
  security_group_id = aws_security_group.sg.id
  type              = "ingress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 3000
  to_port           = 3000
  protocol          = "tcp"
}

#Egress Rules
resource "aws_security_group_rule" "allow_all" {
  security_group_id = aws_security_group.sg.id
  type              = "egress"
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
}

# Create Internet Gateway
resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "${local.env}_my_igw"
  }
}

# Route Table
resource "aws_route_table" "pub_rt" {
  vpc_id = aws_vpc.vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }
}

# Route Table assocation
resource "aws_route_table_association" "public" {
  route_table_id = aws_route_table.pub_rt.id
  subnet_id      = aws_subnet.public_subnet[0].id
}

#EC2 Instance 
resource "aws_instance" "terademo" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.public_subnet[0].id
  associate_public_ip_address = true
  key_name                    = aws_key_pair.generated_key.key_name
  security_groups             = [aws_security_group.sg.id]
  depends_on                  = [aws_key_pair.generated_key]
  tags = {
    Name = "${local.env}_tera_test"
  }
  provisioner "file" {
    source      = "D:/Codes/DevOps-Learning/Terraform/Practice/1_Create_EC2/README.md"
    destination = "/home/ubuntu/README.md"
  }
  connection {
    type        = "ssh"
    host        = self.public_ip
    user        = "ubuntu"
    private_key = tls_private_key.terraform_key.private_key_pem
    timeout = "10m"
  }
}
```



## **Environment-based Terraform Setup (Dev, Staging, Production)**
You want to dynamically create AWS resources based on the selected environment (`dev`, `staging`, or `production`). I'll explain:
1. **How to configure Terraform for multiple environments**
2. **Whether you need separate VPCs, subnets, and keys**
3. **Best practices for structuring environments in Terraform**

---

## **1️⃣ Environment-Based Resource Creation**
You can define environments using **Terraform workspaces** or **variables**.

### **Approach 1: Using a `TF_VAR_env` variable**
Modify your **Terraform variables** to dynamically set the environment:

```hcl
variable "env" {
  description = "Deployment environment"
  type        = string
  default     = "staging"
}

locals {
  env = var.env
}
```

Now, all your resources will dynamically use `var.env` as the environment name.

---

## **2️⃣ Do You Need Separate VPCs, Subnets, and Keys?**
### **You Have Two Options:**
1. **Single VPC per Environment** (Recommended)  
   - Each environment (`dev`, `staging`, `prod`) gets its own VPC.
   - Each VPC has its own subnets, security groups, and key pairs.
   - This ensures complete isolation between environments.

2. **Shared VPC for All Environments**  
   - You create one VPC with different subnets for each environment.
   - This saves cost, but environments may interfere with each other.

---

### **3️⃣ What Resources Should Be Separate for Each Environment?**
| Resource                  | Separate for Each Env? | Reason |
|--------------------------|----------------------|--------|
| **VPC**                  | ✅ Yes (Recommended)  | Isolates network traffic |
| **Subnets**              | ✅ Yes                | Ensures environment separation |
| **Security Groups**      | ✅ Yes                | Different access rules per environment |
| **Key Pair**             | ✅ Yes                | Each environment should have its own SSH key for security |
| **Instances (EC2, RDS)** | ✅ Yes                | Dedicated instances for dev, staging, and production |
| **S3 Buckets**           | ✅ Yes                | Prevents data mixing |
| **IAM Roles**            | ✅ Yes                | Limits permissions per environment |

---

## **4️⃣ Implementing Environment-Specific Resources**
Modify resources to be **environment-aware**:

### **VPC**
```hcl
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_hostnames = true
  tags = {
    Name = "${local.env}-vpc"
    Environment = local.env
  }
}
```

### **Subnets**
```hcl
resource "aws_subnet" "public_subnet" {
  count      = 1
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.public_subnet_cidr_blocks[count.index]
  tags = {
    Name = "${local.env}-public-subnet"
  }
}
```

### **Key Pair**
```hcl
resource "aws_key_pair" "generated_key" {
  key_name   = "${local.env}-terraform-key"
  public_key = tls_private_key.terraform_key.public_key_openssh
}
```

### **EC2 Instance**
```hcl
resource "aws_instance" "terademo" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public_subnet[0].id
  key_name      = aws_key_pair.generated_key.key_name
  security_groups = [aws_security_group.sg.id]

  tags = {
    Name = "${local.env}_tera_test"
    Environment = local.env
  }
}
```

---

## **5️⃣ Deploying to Different Environments**
### **Option 1: Use `TF_VAR_env`**
Run Terraform with different environments:
```sh
terraform apply -var="env=dev"
terraform apply -var="env=staging"
terraform apply -var="env=production"
```

### **Option 2: Use Terraform Workspaces (Better for Multi-Environments)**
Terraform workspaces allow you to manage different environments easily.

1️⃣ **Create a workspace for each environment:**
```sh
terraform workspace new dev
terraform workspace new staging
terraform workspace new production
```

2️⃣ **Switch between environments:**
```sh
terraform workspace select dev
terraform apply
```

---

## **6️⃣ Final Thoughts**
- **Use separate VPCs, subnets, and key pairs per environment for full isolation.**
- **Tag resources** (`Environment=dev`, `Environment=staging`) to distinguish them.
- **Use Terraform workspaces or `TF_VAR_env` for dynamic environment selection.**
- **Deploy using `terraform apply -var="env=dev"` for manual environment selection.**

Would you like me to structure your code for full multi-environment support? 🚀


### Option 2: Using Different Backend State Files

Alternatively, you can specify different state files manually:
```sh
terraform apply -var="env=dev" -state="terraform-dev.tfstate"
terraform apply -var="env=staging" -state="terraform-staging.tfstate"
terraform apply -var="env=production" -state="terraform-production.tfstate"
```


Yes, in your current configuration, each environment (`dev`, `staging`, `production`) is trying to create the same **VPC CIDR block** (`10.0.0.0/16`) and **subnet CIDR blocks** (`10.0.1.0/24`, `10.0.2.0/24`). This will lead to conflicts if all environments are deployed in the same AWS account and region.  

### **Problem: CIDR Conflict Between Environments**  
- If you deploy `dev`, `staging`, and `production` in the same AWS account and region, they all try to create a **VPC with `10.0.0.0/16`**, leading to errors.  
- Similarly, subnets (`10.0.1.0/24`, `10.0.2.0/24`) will also conflict across environments.  

---

### **Solution 1: Use Different CIDR Blocks for Each Environment**  
You can modify your `variables.tf` file to assign unique CIDR blocks for each environment dynamically.  

#### **Modify `variables.tf`**
```hcl
variable "env" {
  description = "Deployment environment"
  type        = string
}

variable "vpc_cidr_block" {
  description = "CIDR Block For VPC"
  type        = string

  default = {
    dev        = "10.0.0.0/16"
    staging    = "10.1.0.0/16"
    production = "10.2.0.0/16"
  }
}

variable "public_subnet_cidr_blocks" {
  description = "Public subnet CIDR blocks"
  type        = map(list(string))
  default = {
    dev        = ["10.0.1.0/24", "10.0.2.0/24"]
    staging    = ["10.1.1.0/24", "10.1.2.0/24"]
    production = ["10.2.1.0/24", "10.2.2.0/24"]
  }
}
```

#### **Update `main.tf`**
Modify the `cidr_block` for the VPC and subnets like this:

```hcl
resource "aws_vpc" "vpc" {
  cidr_block           = lookup(var.vpc_cidr_block, var.env)
  enable_dns_hostnames = true

  tags = {
    Name        = "${local.env}-vpc"
    Environment = local.env
  }
}

resource "aws_subnet" "public_subnet" {
  count      = 1
  vpc_id     = aws_vpc.vpc.id
  cidr_block = lookup(var.public_subnet_cidr_blocks, var.env)[count.index]

  tags = {
    Name = "${local.env}-public-subnet"
  }
}
```

#### **Run Terraform with Different Environments**
```sh
terraform apply -var="env=dev"
terraform apply -var="env=staging"
terraform apply -var="env=production"
```
Each environment will now have a **unique** VPC CIDR and subnet CIDR, preventing conflicts.

---

### **Solution 2: Use Separate AWS Accounts or Regions**
If you're running in **separate AWS accounts** or **different regions**, the CIDR blocks can remain the same because they won't overlap.

- **Different AWS accounts**: No conflict because they exist in different AWS accounts.  
- **Different AWS regions**: No conflict because networking is region-specific.  

Modify `provider.tf` to specify regions:
```hcl
provider "aws" {
  region  = lookup(var.region_map, var.env)
  profile = "default"
}

variable "region_map" {
  type = map(string)
  default = {
    dev        = "us-east-1"
    staging    = "us-east-2"
    production = "us-west-1"
  }
}
```
Then run:
```sh
terraform apply -var="env=dev"
terraform apply -var="env=staging"
terraform apply -var="env=production"
```
Each environment is deployed in a different region.

---

### **Summary**
| Solution | How It Works | Pros | Cons |
|----------|-------------|------|------|
| **Unique CIDR Blocks per Environment (Solution 1)** | Assign different CIDR blocks dynamically in `variables.tf` | Works in the same AWS account & region | Needs CIDR planning |
| **Separate AWS Accounts or Regions (Solution 2)** | Deploy `dev`, `staging`, and `prod` in different AWS accounts or regions | Avoids CIDR conflicts, follows AWS best practices | Requires multi-account management |

🔹 **Recommendation:** If you are using a **single AWS account**, go with **Solution 1 (Unique CIDR Blocks per Environment)**.  
🔹 If you can deploy to **separate AWS accounts**, go with **Solution 2** for better isolation.

Let me know if you need further clarification! 🚀



There is an issue in your Terraform variable definitions:

### **Problems in Your Configuration**
1. **`vpc_cidr_block` and `public_subnet_cidr_blocks` are maps, but default values are incorrect in `public_subnet_cidr_blocks`.**
   - `public_subnet_cidr_blocks` is defined as a **list(string)**, but you assigned it a **map**.  
   - Terraform expects either a **map(string)** or a **list(string)**, not both.

2. **`private_subnet_cidr_blocks` is a list but lacks per-environment differentiation.**
   - If `public_subnet_cidr_blocks` is different per environment, `private_subnet_cidr_blocks` should also be mapped accordingly.

---

### **Fixed Configuration**

#### **Updated `variables.tf`**
```hcl
variable "env" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

locals {
  env = var.env
}

variable "ami" {
  description = "AMI Code"
  type        = string
  default     = "ami-04b4f1a9cf54c11d0"
}

variable "instance_type" {
  description = "Instance type"
  type        = string
  default     = "t2.micro"
}

variable "number_of_instance" {
  type    = number
  default = 1
}

# ✅ Fix: Use a map for per-environment CIDR blocks
variable "vpc_cidr_block" {
  description = "CIDR Block for VPC"
  type        = map(string)

  default = {
    dev     = "10.0.0.0/16"
    staging = "10.1.0.0/16"
    prod    = "10.2.0.0/16"
  }
}

# ✅ Fix: Ensure public_subnet_cidr_blocks is a map (not a list)
variable "public_subnet_cidr_blocks" {
  description = "Public subnet CIDR blocks"
  type        = map(list(string))

  default = {
    dev     = ["10.0.1.0/24", "10.0.2.0/24"]
    staging = ["10.1.1.0/24", "10.1.2.0/24"]
    prod    = ["10.2.1.0/24", "10.2.2.0/24"]
  }
}

# ✅ Fix: Define private_subnet_cidr_blocks per environment
variable "private_subnet_cidr_blocks" {
  description = "Private subnet CIDR blocks"
  type        = map(list(string))

  default = {
    dev     = ["10.0.4.0/24", "10.0.5.0/24"]
    staging = ["10.1.4.0/24", "10.1.5.0/24"]
    prod    = ["10.2.4.0/24", "10.2.5.0/24"]
  }
}
```
---

### **What Will Happen?**
- **`dev`**
  - VPC: `10.0.0.0/16`
  - Public subnets: `10.0.1.0/24`, `10.0.2.0/24`
  - Private subnets: `10.0.4.0/24`, `10.0.5.0/24`

- **`staging`**
  - VPC: `10.1.0.0/16`
  - Public subnets: `10.1.1.0/24`, `10.1.2.0/24`
  - Private subnets: `10.1.4.0/24`, `10.1.5.0/24`

- **`prod`**
  - VPC: `10.2.0.0/16`
  - Public subnets: `10.2.1.0/24`, `10.2.2.0/24`
  - Private subnets: `10.2.4.0/24`, `10.2.5.0/24`

---
