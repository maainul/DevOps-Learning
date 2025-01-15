Here's a step-by-step guide to creating a CI/CD pipeline with Jenkins for your Flask project, integrating SonarQube scanning:

sudo apt update
sudo apt install python3.12-venv

### **Prerequisites**
1. **Jenkins installed and running**: Ensure Jenkins is installed on your server and accessible.
2. **SonarQube setup**: Have a running SonarQube server and an authentication token.
3. **Python installed**: Ensure Python is installed on the Jenkins machine.
4. **Jenkins Plugins**:
   - SonarQube Scanner
   - Pipeline

### **Steps**

#### 1. **Install SonarQube Scanner in Jenkins**
   - Go to **Jenkins Dashboard > Manage Jenkins > Plugins Manager**.
   - Search for **SonarQube Scanner** and install it.

#### 2. **Add SonarQube Server to Jenkins**
   - Go to **Manage Jenkins > Configure System > SonarQube servers**.
   - Click **Add SonarQube** and configure:
     - Name: `SonarQube`
     - Server URL: `http://<SonarQube_Server_IP>:9000`
     - Authentication Token: Add the token from your SonarQube server.

#### 3. **Configure Jenkins Pipeline**
   - Create a **Jenkinsfile** in your Flask project root directory.

#### 4. **Sample Jenkinsfile for Flask + SonarQube**
```groovy
pipeline {
    agent any

    environment {
        SONAR_SCANNER_HOME = tool 'SonarQube Scanner' // Ensure the tool is set in Jenkins
    }

    stages {
        stage('Clone Repository') {
            steps {
                git branch: 'main', url: 'https://github.com/<your-repo-url>.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                sh 'python3 -m venv venv'
                sh './venv/bin/pip install -r requirements.txt'
            }
        }

        stage('Run SonarQube Analysis') {
            steps {
                withSonarQubeEnv('SonarQube') {
                    sh '''
                    ${SONAR_SCANNER_HOME}/bin/sonar-scanner \
                    -Dsonar.projectKey=flask_project \
                    -Dsonar.sources=. \
                    -Dsonar.host.url=http://<SonarQube_Server_IP>:9000 \
                    -Dsonar.login=<Your_SonarQube_Token>
                    '''
                }
            }
        }

        stage('Quality Gate') {
            steps {
                script {
                    timeout(time: 2, unit: 'MINUTES') {
                        waitForQualityGate abortPipeline: true
                    }
                }
            }
        }
    }

    post {
        always {
            echo 'Pipeline completed.'
        }
    }
}
```


#### 5. **Add Jenkins Job**
   - Go to Jenkins and create a **Pipeline Job**.
   - Link it to your repository containing the `Jenkinsfile`.

#### 6. **Trigger the Pipeline**
   - Push changes to your repository.
   - Jenkins will pull the code, install dependencies, and run SonarQube analysis.


To avoid scanning unnecessary files and directories like the `venv` folder during a SonarQube scan, you can configure the `sonar-project.properties` file to exclude these paths. Here's how you can do it:

---

### **Update `sonar-project.properties`**
1. Open the `sonar-project.properties` file in your project directory.
2. Add the following lines to exclude the `venv` folder and other unwanted directories:
   ```properties
   # Specify the directories to exclude
   sonar.exclusions=venv/**, **/migrations/**, **/__pycache__/**

   # Optional: Exclude test files, if needed
   sonar.test.exclusions=tests/**, **/test_*.py
   ```

   - `venv/**`: Excludes all files and subdirectories in the `venv` folder.
   - `**/migrations/**`: Excludes Django migration files (if applicable).
   - `**/__pycache__/**`: Excludes Python's cache files.

---

### **Rescan the Project**
After updating the file:
1. Save the `sonar-project.properties` file.
2. Rerun the SonarQube scan in your pipeline:
   ```bash
   sonar-scanner
   ```

---

### **Alternative: Add Exclusions in SonarQube UI**
If you want to manage exclusions from the SonarQube dashboard:
1. Go to your project in the SonarQube web interface.
2. Navigate to **Administration > General Settings > Analysis Scope**.
3. Under **Source File Exclusions**, add:
   ```
   venv/**
   ```
4. Save the settings and reanalyze the project.

---

Here’s how you can exclude folders like `venv` directly in the **SonarQube UI** step by step:

---

### **Steps to Add Exclusions in the SonarQube UI**

1. **Login to SonarQube**  
   - Open your SonarQube dashboard in a browser.  
   - URL: `http://<your-sonarqube-server-ip>:9000`.  
   - Login with your SonarQube credentials.

2. **Go to the Project**  
   - In the SonarQube dashboard, click on the project you want to configure.

3. **Open Project Administration**  
   - On the left-hand side, click **Project Settings > General Settings**.

4. **Go to Analysis Scope**  
   - Under the **General Settings**, click on **Analysis Scope**.

5. **Add Exclusions**  
   - Find the section labeled **Source File Exclusions**.
   - Add the paths you want to exclude, e.g.:
     ```
     venv/**
     migrations/**
     __pycache__/**
     tests/**
     ```
     - `venv/**`: Excludes the virtual environment folder.  
     - `migrations/**`: Excludes migration files (if using Django or Flask with migrations).  
     - `__pycache__/**`: Excludes Python cache files.  
     - `tests/**`: Excludes test directories.

6. **Save the Changes**  
   - Scroll to the bottom of the page and click **Save**.

7. **Reanalyze Your Project**  
   - Trigger the pipeline or run the `sonar-scanner` command again:
     ```bash
     sonar-scanner
     ```



### **Verify the Results**
- Go back to the project dashboard after the scan is complete.
- Check the **Code Smells** and **Bugs** sections to ensure files from the excluded directories (e.g., `venv`) are no longer being analyzed.

---

Would you like additional help with any part of this process? 😊