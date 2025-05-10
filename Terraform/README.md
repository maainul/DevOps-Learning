Sure! Here are **commonly used Terraform commands**, grouped by purpose:

---

### 🔧 **Basic Terraform Workflow**

1. **Initialize the working directory**

   ```bash
   terraform init
   ```

   > Downloads the provider plugins and sets up your working directory.

2. **Format configuration files**

   ```bash
   terraform fmt
   ```

   > Formats `.tf` files for readability and consistency.

3. **Validate configuration**

   ```bash
   terraform validate
   ```

   > Checks whether your `.tf` files are syntactically valid.

4. **Create execution plan**

   ```bash
   terraform plan
   ```

   > Shows what Terraform will do before making changes.

5. **Apply configuration**

   ```bash
   terraform apply
   ```

   > Applies the planned changes to the infrastructure.

6. **Destroy infrastructure**

   ```bash
   terraform destroy
   ```

   > Tears down all infrastructure managed by Terraform.

---

### 📦 **State Management**

1. **List resources in the state**

   ```bash
   terraform state list
   ```

2. **Show detailed info about a resource**

   ```bash
   terraform state show <resource_name>
   ```

3. **Remove a resource from state (without destroying it)**

   ```bash
   terraform state rm <resource_name>
   ```

4. **Import existing resource into state**

   ```bash
   terraform import <resource_name> <resource_id>
   ```

---

### 🔄 **Workspace Management**

1. **List all workspaces**

   ```bash
   terraform workspace list
   ```

2. **Create a new workspace**

   ```bash
   terraform workspace new <workspace_name>
   ```

3. **Switch to a workspace**

   ```bash
   terraform workspace select <workspace_name>
   ```

---

### 📁 **Modules**

1. **Get modules**

   ```bash
   terraform get
   ```

---

Would you like these in a PDF cheat sheet or want to know about commands for a specific provider (like AWS, Azure, GCP, etc.)?
