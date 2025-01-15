#  **SonarQube Analysis** stage With Nodejs


### Solution

#### 1. **Fix the SonarQube Scanner Path**
   Ensure the SonarQube scanner tool is properly configured in Jenkins under **Manage Jenkins > Global Tool Configuration > SonarQube Scanner**. Verify that the name is **SonarQube Scanner**, and it points to the correct installation.
   Pipeline Name : SCANNER_HOME = tool 'SonarQube Scanner'
#### 2. **Fix the SonarQube Server In Systm Path**
   Ensure the SonarQube scanner tool is properly configured in Jenkins under **Manage Jenkins > System > SonarQube servers**. Verify that the name is **SonarQube**, and it points to the correct installation.
   Pipeline Name :  SONARQUBE_SERVER = 'SonarQube'
#### 3. **Add Debugging**
   Add a step to check if `SONAR_SCANNER_HOME` is resolved correctly and points to the expected directory.

#### 4. **Fix the Nodejs Path**
   Ensure the SonarQube scanner tool is properly configured in Jenkins under **Manage Jenkins > Tool > node16**. Verify that the name is **node16**, and it points to the correct installation.
   tools Name :  nodejs 'node16'
### Updated Pipeline

```groovy
pipeline {
    agent any

    tools {
        jdk 'jdk17'
        nodejs 'node16'
    }

    environment {
        SONARQUBE_SERVER = 'SonarQube'
        SCANNER_HOME = tool 'SonarQube Scanner'
    }

    stages {
        stage('Git Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/maainul/multi-branch-pos-backend.git'
            }
        }

        stage('Install Dependencies') {
            steps {
                script {
                    // Install Node.js dependencies
                    sh "npm install"
                }
            }
        }

        stage('SonarQube Analysis') {
            steps {
                // Debug to verify scanner path
                script {
                    echo "SonarQube Scanner Path: ${SCANNER_HOME}"
                }

                withSonarQubeEnv("${SONARQUBE_SERVER}") {
                    sh """
                    ${SCANNER_HOME}/bin/sonar-scanner \
                      -Dsonar.projectKey="Point of Sell Node JS Backend" \
                      -Dsonar.projectName="Point Of Sell (Backend)" \
                      -Dsonar.projectVersion="1.0" \
                      -Dsonar.sources="." \
                      -Dsonar.exclusions="**/node_modules/**,**/dist/**,**/*.test.js,**/*.spec.js,**/coverage/**,**/logs/**" \
                      -Dsonar.javascript.lcov.reportPaths="coverage/lcov.info" \
                      -Dsonar.host.url="http://100.25.213.204:9000" \
                      -Dsonar.login="sqa_86faab3142f735e98b0814e4bb782cfbdd487fb3"
                    """
                }
            }
        }
    }
}
```
