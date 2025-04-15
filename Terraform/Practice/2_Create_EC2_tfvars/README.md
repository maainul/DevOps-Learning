terraform plan -var-file="terraform-dev.tfvars"

terraform plan -var-file="terraform-prod.tfvars"

terraform plan -var-file="terraform-staging.tfvars"


# 1. terraform init for DEV 

terraform init --var-file="terraform-dev.tfvars"

# 2. terraform plan for DEV 

terraform plan --var-file="terraform-dev.tfvars"

# 3. terraform apply for DEV 

terraform apply --var-file="terraform-dev.tfvars"


# 1. terraform init for QA 

terraform init --var-file="terraform-qa.tfvars"

# 2. terraform plan for QA 

terraform plan --var-file="terraform-qa.tfvars"

# 3. terraform apply for QA 

terraform apply --var-file="terraform-qa.tfvars"

# 1. terraform init for PROD 

terraform init --var-file="terraform-prod.tfvars"

# 2. terraform plan for PROD 

terraform plan --var-file="terraform-prod.tfvars"

# 3. terraform apply for PROD 

terraform apply --var-file="terraform-prod.tfvars"
