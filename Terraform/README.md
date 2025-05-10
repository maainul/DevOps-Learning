# **Step-by-Step: Install Terraform on Windows**

1. **Download Terraform**
   - Go to the official Terraform downloads page:  
     👉 [https://developer.hashicorp.com/terraform/downloads](https://developer.hashicorp.com/terraform/downloads)
   - Select **Windows** > Choose the right **architecture** (e.g., `amd64` for 64-bit systems).
   - Download the `.zip` file.
![Image](https://github.com/user-attachments/assets/006e2a26-b584-4775-b945-bb1c8beb2634)

2. **Extract the ZIP**
   - Extract the ZIP file to a folder (e.g., `C:\terraform`).

3. **Add Terraform to System PATH**
   - Open **Start Menu** → search for **Environment Variables** → Click `Edit the system environment variables`.
   - In the System Properties window, click **Environment Variables**.
   - Under **System variables**, find and select `Path` → click **Edit**.
   - Click **New** and add the path to your Terraform folder (e.g., `C:\terraform`).
   - Click OK on all windows to save.

4. **Verify Installation**
   - Open **Command Prompt** or **PowerShell** and run:

     ```bash
     terraform version
     ```

   - You should see the installed Terraform version.

---
