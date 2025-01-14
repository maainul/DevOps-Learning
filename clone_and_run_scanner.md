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



# Run Node Js 

To analyze a Node.js project using SonarQube, follow these steps:

---

### **1. Prerequisites**
Ensure the following are installed:
- SonarQube server is running and accessible.
- SonarScanner is installed on your system.
- Node.js and your project dependencies are installed.

---

### **2. Navigate to Your Node.js Project**
Change to the directory of your Node.js project:
```bash
cd /path/to/your/node-project
```

---

### **3. Install the `sonar-scanner` Globally (Optional)**
If `sonar-scanner` is not already installed or accessible, you can install it:
```bash
sudo npm install -g sonar-scanner
```

---

### **4. Create a `sonar-project.properties` File**
Inside your project directory, create a `sonar-project.properties` file:
```bash
nano sonar-project.properties
```

Add the following content, customizing it to your project:
```properties
# Required project metadata
sonar.projectKey=my-nodejs-project
sonar.projectName=My Node.js Project
sonar.projectVersion=1.0

# SonarQube server URL
sonar.host.url=http://<your_sonarqube_server>:9000

# Authentication token
sonar.login=<your_sonar_token>

# Project source files
sonar.sources=.
sonar.exclusions=node_modules/**,dist/**

# Language-specific properties (JavaScript/Node.js)
sonar.language=js
sonar.javascript.lcov.reportPaths=coverage/lcov.info
```

**Key Points:**
- Replace `<your_sonarqube_server>` with your SonarQube server's IP or hostname.
- Replace `<your_sonar_token>` with the authentication token generated in SonarQube.
- Exclude folders like `node_modules` or `dist` to avoid analyzing unnecessary files.

---

### **5. Generate Code Coverage (Optional but Recommended)**
SonarQube benefits from code coverage information. To generate a coverage report:
1. Install a test runner like Jest or Mocha if not already installed:
   ```bash
   npm install --save-dev jest
   ```
2. Update the `package.json` to include a script for coverage:
   ```json
   "scripts": {
     "test": "jest --coverage"
   }
   ```
3. Run the tests to generate a coverage report:
   ```bash
   npm test
   ```
4. Verify that the `coverage/lcov.info` file is generated.


### **6. Run the SonarScanner**
Execute the SonarScanner in your project directory:
```bash
sonar-scanner
```

### **7. View Results in SonarQube**
1. Open your browser.
2. Navigate to your SonarQube server (`http://<your_sonarqube_server>:9000`).
3. Log in and search for your project (`my-nodejs-project`) in the dashboard.


### **Example Directory Structure**
```plaintext
my-node-project/
├── sonar-project.properties
├── package.json
├── node_modules/
├── src/
├── tests/
└── coverage/
    └── lcov.info
```

