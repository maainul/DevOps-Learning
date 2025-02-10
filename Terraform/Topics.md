
### 01 Install Terraform on Windows 10
### 02 Download VS code for Windows
### 03 Install Terraform extension in VS code
### 04 Download and Install AWS CLI 
### 05 Create IAM user in AWS
### 06 configure IAM user in VS Code
### 07 Creating EC2 Instance using Terraform
### 08 Terminate EC2 Instance using Terraform
### 09 AWS VPC Components
### 10 create vpc using terraform AWS
### 11 Run AWS VPC Terraform code

---

## 01 Install Terraform on Windows 10

1. Follow this link : https://developer.hashicorp.com/terraform/install
2. environment variable set : https://stackoverflow.com/questions/1618280/where-can-i-set-path-to-make-exe-on-windows


## 04 Download and Install AWS CLI :

```bash
sudo apt-get update.
sudo apt-get install python3-pip.
sudo pip install awscli.
aws --version.
aws configure.
aws s3 ls.
aws ec2 describe-instances.
aws iam list-users.
```
## 05 Create IAM user in AWS

1. Create user and Give Permission > AdminAccess > Access Key

## 06 configure IAM user in VS Code / Terminal

1. Type > aws configure

## 07 Creating EC2 Instance using Terraform

```tf
provider "aws" {
    region = "us-east-1"
}
resource "aws_instance" "terademo" {
    ami = "ami-0e1bed4f06a3b463d"
    instance_type = "t2.micro"
    key_name = "tera-key"
    tags = {
      Name="Tera-Test"
    }
  
}
```
```bash
terraform init
terraform validate
terraform plan
terraform apply
```

## 08 Terminate EC2 Instance using Terraform
```bash
terraform destroy
```
### 09 AWS VPC Components
### 10 create vpc using terraform AWS
### 11 Run AWS VPC Terraform code