@Library('Shared') _
pipeline {
    agent { label "mainul" }

    stages {
        stage('Code') {
            steps {
                script{
                    clone("https://github.com/maainul/jenkins-learning.git","master")
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