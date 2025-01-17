pipeline {
    agent { label "agent-1" }

    tools {
        nodejs "NodeJS"
    }

    environment {
        SONAR_URL = "http://52.54.50.131:9000"
        SONAR_AUTH_TOKEN = "squ_47f2568a7ed72272174c06e5c61456c54d414961"
        SONAR_PROJECT_KEY = "webapp"
        SONAR_PROJECT_NAME = "webapp"
    }

    stages {
        stage('Checkout Code') {
            steps {
                echo "Cloning the code..."
                git url: "https://github.com/maainul/jenkins-learning.git", branch: "master"
                echo "Code cloned successfully!"
            }
        }

        stage('Install Dependencies') {
            steps {
                echo "Installing dependencies..."
                sh 'npm install'
                echo "Dependencies installed successfully!"
            }
        }

        stage('SonarQube Analysis') {
            steps {
                echo "Running SonarQube Analysis..."
                sh '''
                    npx sonar-scanner \
                        -Dsonar.projectKey=webapp \
                        -Dsonar.projectName=webapp \
                        -Dsonar.host.url=http://52.54.50.131:9000 \
                        -Dsonar.token=squ_47f2568a7ed72272174c06e5c61456c54d414961
                '''
                echo "SonarQube analysis completed successfully!"
            }
        }
    }
}
