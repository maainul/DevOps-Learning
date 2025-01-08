@Library('Shared') _
pipeline {
    agent { label "agent-1" }
    
    tools {
        nodejs "NodeJS"
    }

    stages {
        stage('Code') {
            steps {
                script{
                    clone("https://github.com/maainul/jenkins-learning.git","master")
                }
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
        stage('Build') {
            steps {
                 script{
                   docker_build("maainul","notes-demo","latest")
               }
            }
        }
        stage('Test') {
            steps {
                echo "Running tests..."
                // Add test commands here if required
                echo "Tests completed!"
            }
        }
        stage('Deploy') {
            steps {
               echo "Stopping and removing existing containers..."
                sh '''
                    # Stop all running containers
                    docker ps -q | xargs -r docker stop
                    # Remove all stopped containers
                    docker ps -aq | xargs -r docker rm
                '''
                echo "Existing containers stopped and removed."

                echo "Deploying the application..."
                sh 'docker compose up -d'
                echo "Application deployed successfully!"
            }
        }
    }
}
