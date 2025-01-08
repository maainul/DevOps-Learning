@Library('Shared') _
pipeline {
    agent { label "agent-1" }
    tools { sonarScanner 'SonarScanner' } // Use the name configured in "Global Tool Configuration"
    environment {
        SONAR_HOST_URL = 'http://52.54.50.131:9000' // Replace with your SonarQube URL
        SONAR_AUTH_TOKEN = credentials('sonar-token') // Jenkins credential ID for the token
    }
    stages {
        stage('Code') {
            steps {
                script{
                    clone("https://github.com/maainul/jenkins-learning.git","master")
                }
            }
        }
        stage('SonarQube Analysis') {
            steps {
                withSonarQubeEnv('sq1') { // Use the name from "SonarQube servers" config
                    sh 'sonar-scanner \
                        -Dsonar.projectKey=webapp \
                        -Dsonar.sources=./src \
                        -Dsonar.host.url=$SONAR_HOST_URL \
                        -Dsonar.login=$SONAR_AUTH_TOKEN'
                }
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
