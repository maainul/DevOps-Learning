# Let's walk through your steps to analyze a project using **SonarQube Scanner**:

1. Clone the GitHub repository:
   ```bash
   git clone <repository-url>
   ```
   Replace `<repository-url>` with the URL of your GitHub repository.


### **2. Run SonarScanner on the Project**
#### **Step 2.1: Navigate to the Project Directory**
Move into the project directory:
```bash
cd <project-folder>
```

#### **Step 2.2: Create `sonar-project.properties`**
Create a `sonar-project.properties` file in the root directory of your project:
```bash
nano sonar-project.properties
```

Add the following content to the file (customized for your project):
```properties
# Project identification
sonar.projectKey=my_project_key
sonar.projectName=My Project
sonar.projectVersion=1.0

# Source code configuration
sonar.sources=.

# Exclusions (optional, e.g., for test files or build artifacts)
sonar.exclusions=**/node_modules/**,**/dist/**

# SonarQube server configuration
sonar.host.url=http://<sonarqube-server-ip>:9000
sonar.login=<sonarqube-token>
```

- Replace `my_project_key` with your project key.
- Replace `<sonarqube-server-ip>` with your server's IP or `localhost` (if the server is running locally).
- Replace `<sonarqube-token>` with your SonarQube authentication token. You can generate this in the **SonarQube UI**:  
  Go to **My Account → Security → Generate Token**.

Save and exit the file (`CTRL + O`, then `CTRL + X`).

#### **Step 2.3: Run the Scanner**
Run SonarScanner from the root of the project:
```bash
sonar-scanner
```

### **3. Open SonarQube Server to View the Report**
1. Open a browser and navigate to your SonarQube server:
   ```
   http://<sonarqube-server-ip>:9000
   ```
   Replace `<sonarqube-server-ip>` with the IP address or domain of your SonarQube server.

2. Log in to SonarQube using your admin credentials or the token if required.

3. Once the scanner completes, the project should appear in the dashboard. Click on the project to view the detailed analysis results.
