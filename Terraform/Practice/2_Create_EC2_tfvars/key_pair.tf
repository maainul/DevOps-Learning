
# Create public and private Key
resource "tls_private_key" "terraform_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

# Generate key pair
resource "aws_key_pair" "generated_key" {
  key_name   = "${var.env}-terraform-key"
  public_key = tls_private_key.terraform_key.public_key_openssh
}

# Save File locally in directory
resource "local_file" "private_key" {
  content         = tls_private_key.terraform_key.private_key_pem
  filename        = "${path.module}/${var.env}-terraform-key.pem"
  file_permission = "0600"
}