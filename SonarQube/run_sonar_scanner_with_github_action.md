# GitHub Actions Configuration

1. Create a Workflow File:
   - Add a .github/workflows/sonarqube.yml file in your repository.

```yml
name: SonarQube Analysis

on:
  push:
    branches:
      - main
      - '**/feature/**'

jobs:
  sonarqube:
    runs-on: ubuntu-latest

    steps:
    - name: Checkout code
      uses: actions/checkout@v3

    - name: Set up Node.js
      uses: actions/setup-node@v3
      with:
        node-version: '20'

    - name: Install dependencies
      run: npm install

    - name: Run SonarQube Scanner
      env:
        SONAR_TOKEN: ${{ secrets.SONAR_TOKEN }}
      run: |
        npx sonar-scanner \
          -Dsonar.projectKey=my-project \
          -Dsonar.sources=src \
          -Dsonar.host.url=http://<YOUR_SONARQUBE_SERVER>:9000 \
          -Dsonar.login=$SONAR_TOKEN
```

# 2. Update Your Repository

- Add a sonar-project.properties file to your repository (if not already present).
Example for a Node.js/React project:
```yml
sonar.projectKey=my-project
sonar.projectName=My Project
sonar.projectVersion=1.0
sonar.sources=src
sonar.host.url=http://<YOUR_SONARQUBE_SERVER>:9000
sonar.login=<YOUR_SONARQUBE_TOKEN>

```

**Repository Secrets** unless you're working with multiple repositories that share the same secret and want to centralize management using **Environment Secrets**.


### **When to Use Repository Secrets**
- **If the secret (like your SonarQube token) is specific to a single repository**.
- For most cases, especially when setting up SonarQube for a single project, **use Repository Secrets**.

### **When to Use Environment Secrets**
- **If you have multiple repositories in your organization that use the same secret** (e.g., a shared SonarQube instance or a centralized CI/CD setup).
- You can create an **Environment**, such as "Staging" or "Production," and assign the secret to it.


### **Steps for Repository Secrets**
1. Go to your GitHub repository.
2. Navigate to **Settings > Secrets and Variables > Actions**.
3. Under the **Repository secrets** section, click **New repository secret**.
4. Name the secret `SONAR_TOKEN`.
5. Paste the token you generated in SonarQube.
6. Click **Add secret**.

### **Steps for Environment Secrets**
1. Go to your GitHub repository.
2. Navigate to **Settings > Environments**.
3. Create an Environment (e.g., "SonarQube").
4. Under the **Environment**, click **Add Secret**.
5. Name the secret `SONAR_TOKEN`.
6. Paste the token you generated in SonarQube.
7. Save the secret.


### **Which One to Use in the Workflow?**
In the workflow YAML:
- For **Repository Secrets**: Use `${{ secrets.SONAR_TOKEN }}`.
- For **Environment Secrets**: Use `${{ secrets.SONAR_TOKEN }}`, but you must specify the environment in the workflow.
