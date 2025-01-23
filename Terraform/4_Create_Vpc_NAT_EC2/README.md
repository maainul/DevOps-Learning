### Lab #4: AWS NAT Gateway using Terraform | AWS Private Subnet using Terraform | Terraform Tutorial

Link : [https://www.youtube.com/watch?v=npLeXQD12SI&list=PLdsu0umqbb8NxoJUNup3PCb38RQpQtm9p&index=4]


### 0:00 What is Private Subnet and NAT Gateway in AWS
### 1:14 What is Private Subnet in AWS VPC
### 2:42 What is NAT Gateway in AWS VPC
### 6:18 Create VPC in AWS using terraform
### 8:24 Create Public and Private Subnet in AWS VPC using terraform
### 16:24 How to Connect(SSH) to EC2 Instances in the Private Subnet
1. Go to Public instance
2. Create new file suppose tera-key.pem  and paste public key to it
3. Now run ssh -i "keyname" username@ip  (ssh -i "tera-key.pem" ubuntu@20.0.2.232) to connect
4. Type ping google.com
5. Successfully connected to the internet


### 21:01 Create NAT Gateway in Public Subnet and add NAT Gateway in Private Subnet