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
                git branch: 'master', url: 'https://github.com/maainul/multi-branch-pos-frontend.git'
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
                      -Dsonar.projectKey="Point_of_Sell_React_JS_Backend" \
                      -Dsonar.projectName="Point Of Sell (Frontend)" \
                      -Dsonar.projectVersion="1.0" \
                      -Dsonar.sources="src" \
                      -Dsonar.exclusions="**/node_modules/**,**/dist/**,**/*.test.js,**/*.spec.js,**/coverage/**,**/logs/**" \
                      -Dsonar.javascript.lcov.reportPaths="coverage/lcov.info" \
                      -Dsonar.host.url="http://54.82.119.254:9000" \
                      -Dsonar.login="sqa_86faab3142f735e98b0814e4bb782cfbdd487fb3"
                    """
                }
            }
        }
    }
}
