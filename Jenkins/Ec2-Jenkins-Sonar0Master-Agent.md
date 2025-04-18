# jenkins-learning

## Topics :
    
### 1. Install Jenkins on EC2
### 2. Associate New Elastic IP Address
### 3. Connect With MobaXtrem
### 4. Install Jenkins On EC2
### 5. Add 8080 Port in Security Group
### 6. Update Password
### 7. Create Pipeline Project 
### 8. Add Webhook
### 9. Create agent node 
### 10. Setting Up Agent Node in Jenkins
### 11. Add Dockerfile
### 12. Shared Library
### 13. Install and Integrate Sonarqube in Jenkins


### 1. Install Jenkins on EC2 :

Sometimes we need to install many things on master machine so 16GB RAM would be good .

![Screenshot](https://github.com/user-attachments/assets/1a4f552b-aa7a-4893-b56d-708f111e4d3a)
![Screenshot(1)](https://github.com/user-attachments/assets/5bc13dad-f09c-4db2-9f5f-4bf2a43ceacb)
![Screenshot(2)](https://github.com/user-attachments/assets/7628a23f-8610-42c2-a629-b3e5f0753576)
![Screenshot(3)](https://github.com/user-attachments/assets/412dcb3d-2491-48ed-a3e4-879665fb8cea)
![Screenshot(4)](https://github.com/user-attachments/assets/ad5bc026-8bcf-45e4-9381-a0bf4e19b4bd)
![Screenshot(5)](https://github.com/user-attachments/assets/b1a92357-288a-4f1a-975b-0de689f797ee)
![Screenshot(6)](https://github.com/user-attachments/assets/6cd31654-507f-432b-befc-8cb300fc4803)

### 2. Associate New Elastic IP Address:

Search on : Elastic Ip Address

![Screenshot(7)](https://github.com/user-attachments/assets/02d69750-2e44-4386-8565-9a5a70c272ba)
![Screenshot(8)](https://github.com/user-attachments/assets/fc996700-cc6e-4f10-8f6a-bb8e98606304)
![Screenshot(9)](https://github.com/user-attachments/assets/ddaa641d-457c-4699-a814-5803ab5b1917)
![Screenshot(10)](https://github.com/user-attachments/assets/27d4397d-9539-4e01-bd7a-5121bda5cc88)
![Screenshot(11)](https://github.com/user-attachments/assets/761e3a81-11ff-4773-a70b-5052c000ed0e)
![Screenshot(12)](https://github.com/user-attachments/assets/9a8a3eb5-750c-46d9-a894-ba63484b1b4d)
![Screenshot(13)](https://github.com/user-attachments/assets/17810aae-9d61-4e0f-bc71-fadf6f0e456a)
![Screenshot(14)](https://github.com/user-attachments/assets/1728e76f-f452-4345-a0e9-f1f7052d5ce6)
![Screenshot(15)](https://github.com/user-attachments/assets/9a94f156-fafe-4c99-aca1-6f99b6d3194c)

### 3. Connect With MobaXtrem
![Capture](https://github.com/user-attachments/assets/795e5dcb-b9af-481d-b6fb-c84217bfa3dc)
![Capture2](https://github.com/user-attachments/assets/19d4c8c9-373d-44de-9614-6615a322c8f6)
![Capture-3](https://github.com/user-attachments/assets/320cc9fc-04e3-4341-bd9a-a518cf46e8ea)
![Capture4](https://github.com/user-attachments/assets/df9ff0b6-fdda-4022-84b5-68520e35e575)


### 4. Install Jenkins On EC2


    sudo apt-get update

    sudo wget -O /usr/share/keyrings/jenkins-keyring.asc \
    https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
    echo "deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc]" \
    https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
    /etc/apt/sources.list.d/jenkins.list > /dev/null

    sudo apt-get update

    sudo apt-get install jenkins

    sudo apt update

    sudo apt install fontconfig openjdk-17-jre

    java -version

    sudo systemctl enable jenkins

    sudo systemctl status jenkins

    sudo systemctl start jenkins

### 5. Add 8080 Port in Security Group

![Screenshot(17)](https://github.com/user-attachments/assets/7196f2f3-af67-4893-9df1-7dd55f19b461)
![Screenshot(18)](https://github.com/user-attachments/assets/9369abd4-9015-42ee-a17c-138dc498757d)
![Screenshot(19)](https://github.com/user-attachments/assets/a3de313c-ae63-4c9d-88e8-42b375340433)
![Screenshot(20)](https://github.com/user-attachments/assets/0ab9484b-195a-4b10-bb47-17291aae1ed0)
![Screenshot(21)](https://github.com/user-attachments/assets/d621068d-9c4a-4d60-ac6d-c31613141d5c)


### 6. Update Password : http://52.55.158.56:8080/login?from=%2F

![Screenshot(22)](https://github.com/user-attachments/assets/e140db98-de37-4dfa-9905-bebf4cec059e)

    sudo cat /var/lib/jenkins/secrets/initialAdminPassword


Copy and paste 

![Screenshot(23)](https://github.com/user-attachments/assets/455a4686-d66c-4e6e-8282-73a2a5efd503)

### 7. Create Pipeline Project 

1. Create Project
2. Update Script
3. Add plugins

![Screenshot(24)](https://github.com/user-attachments/assets/cf3801f1-42c9-46d6-b711-2b702a84f0cf)
![Screenshot(25)](https://github.com/user-attachments/assets/3dbcd015-8459-4a0e-859d-bf052bd6e944)
![Screenshot(26)](https://github.com/user-attachments/assets/a4b4b378-fda8-4193-8bea-547c3feaaa40)
![Screenshot(27)](https://github.com/user-attachments/assets/4c72a5cd-3579-441a-93a7-1850ae4262b0)
![Screenshot(28)](https://github.com/user-attachments/assets/85decfb6-f955-4d8b-bb11-99790095cac2)
![Screenshot(29)](https://github.com/user-attachments/assets/e11d925e-ec7a-4c47-ad8f-93b2da9acddc)

```groovy
pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                echo 'Building..'
            }
        }
        stage('Test') {
            steps {
                echo 'Testing..'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying....'
            }
        }
    }
}
```
### 8. Add Webhook

![Screenshot(30)](https://github.com/user-attachments/assets/83abf3ea-96c7-4cc6-81df-c0bc0d12be57)
![Screenshot(31)](https://github.com/user-attachments/assets/346fcb8d-0229-4830-82c5-53a886203d7d)
![Screenshot(32)](https://github.com/user-attachments/assets/bc0a0262-d3d1-44d9-ae6b-7318fdbe789e)

#### Update pipeline syntax : This will allow create new Folder workspace/job-name and 
```groovy
pipeline {
    agent any

    stages {
        stage('Clone Repo') {
            steps {
                git url: 'https://github.com/your-username/your-repo.git', branch: 'main'
            }
        }
        stage('Build') {
            steps {
                echo 'Repository cloned. Listing files...'
                sh 'ls -la'
            }
        }
    }
}

```
![Image](https://github.com/user-attachments/assets/6e52dac1-af1d-491c-9158-816179c7b193)
![Image](https://github.com/user-attachments/assets/9b99c7be-cd7f-4207-a0df-f6ff06cbeff8)

**After Rebuild it create new folder in master** 


```
ubuntu@ip-172-31-95-119:/var/lib/jenkins/workspace/node-demo$ ls
README.md  index.js  package-lock.json  package.json
ubuntu@ip-172-31-95-119:/var/lib/jenkins/workspace/node-demo$
```

![Screenshot(33)](https://github.com/user-attachments/assets/b019a347-2d2c-4b7d-886c-e78beb3ab2bd)


### 9. Create agent node 

Create EC2 instance 

install following:

1. java
2. docker.io
3. docker-compose-v2


```
    sudo apt-get update
    sudo apt install fontconfig openjdk-17-jre
    sudo apt-get install docker.io
    sudo apt-get install docker-compose-v2 
    sudo usermod -aG docker $USER && newgrp docker 
```

### 10. Setting Up Agent Node in Jenkins
![Screenshot(35)](https://github.com/user-attachments/assets/b3a8ec06-c1a4-459c-bddc-ff502ade3c71)
![Screenshot(36)](https://github.com/user-attachments/assets/0d19084a-7fc9-4c4f-86cd-baa6aad2d6c6)

### 11. Create SSH Key in master

```
ubuntu@ip-172-31-95-119:~$ cd ~/.ssh
ubuntu@ip-172-31-95-119:~/.ssh$ ssh-keygen
ubuntu@ip-172-31-95-119:~/.ssh$ ls
authorized_keys  id_ed25519  id_ed25519.pub
```

Copy Private key in jenkins node

```
ubuntu@ip-172-31-95-119:~/.ssh$ cat id_ed25519
```
![Screenshot(37)](https://github.com/user-attachments/assets/317c5a78-1fa5-445d-a56f-93e3116c0db0)
![Screenshot(38)](https://github.com/user-attachments/assets/e847a6d8-5545-43db-bcb7-4e1b79366f5a)

Agent Mechine and Go to ===>> cd ~/.ssh folder

Copy public key in the authorized_keys

```
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDuD0Ynt0JGNd1tvLQJRpOd1AGOfpeZUDMTC81Vc90o5xcpsN86wxo2tlEg9WHZcaI2f6oBA/hcZlH05fQJEBaA9YZ4G2LOn4tKxjD+oPYHqjfaabzUYAW4JUNX3ByFBz8oR/swJnwwsTj9SgwCp+JxIJcE1hdn2AQLi5kA2Flt1ppDwpEklW/sNXKkJilr/44AHBjlk81lIOLt75lrSbdINw8RXPWA3321dOulJHX4P7chdtkug+HqU+CDa2rsSJ/7/QJCcOzaiSbhw+HlO88fc0nhPnQ5h0q6wxL/QvzTLzs0o+fitAuMivbolt3rJ9pLyCKDclOK4IL0EhobODyR jenkins-node-prom-graf

ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIuaTMgACMWOjvE6FhmYNo43Ex/dkaFRjz2PLtqcdbsq ubuntu@ip-172-31-95-119
```
Check Agent / relaunch agent :

![Screenshot(39)](https://github.com/user-attachments/assets/0f709e08-6c3e-47ff-81b1-d6e46f446f0a)

Rerun . It will create folder in agent.

```
ubuntu@ip-172-31-86-235:~$ ls
remoting  remoting.jar  workspace
```

### 11. Add Dockerfile
```Dockerfile
# Use the official Node.js image as the base image
FROM node:18-alpine

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install dependencies
RUN npm install --only=production

# Copy the rest of the application files to the working directory
COPY . .

# Expose the application's port
EXPOSE 8000

# Start the application
CMD ["node", "index.js"]
```

### docker-compose.yml

```yml
services:
  web:
    build:
      context: .
    image: "notes-demo:latest"
    ports:
      - 8000:8000
```
### Jenkins file :
```groovy
pipeline {
    agent { label "mainul" }

    stages {
        stage('Code') {
            steps {
                echo "Cloning the code..."
                git url: "https://github.com/maainul/jenkins-learning.git", branch: "master"
                echo "Code cloned successfully!"
            }
        }
        stage('Build') {
            steps {
                echo "Building the Docker image..."
                sh 'docker build -t notes-demo:latest .'
                echo "Docker image built successfully!"
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
```

### 12. Shared Library

![Screenshot(41)](https://github.com/user-attachments/assets/a30d82cb-ec47-42d9-8226-2c166667145f)
![Screenshot(42)](https://github.com/user-attachments/assets/1cdf5950-d6a7-4241-86b8-1488638d1ea1)

```groovy
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
```
### 13. Install and Integrate Sonarqube in Jenkins

Update docker-compose.yml File.
It will Create 2 container and 2 image
Port : 9000
1. sonarqube:latest
2. postgres:13

```yml
services:
  web:
    build:
      context: .
    image: "maainul/notes-demo:latest"
    ports:
      - "8000:8000"
  sonarqube:
    image: sonarqube:latest
    container_name: sonarqube
    ports:
      - "9000:9000"
    environment:
      SONAR_JDBC_URL: jdbc:postgresql://postgres:5432/sonarqube
      SONAR_JDBC_USERNAME: sonar
      SONAR_JDBC_PASSWORD: sonarpassword 
    #   SONAR_SEARCH_JAVAOPTS: "-Xms256m -Xmx256m" # only for memory limit . remove if you have memory
    # mem_limit: 700m # only for memory limit . remove if you have memory
    # mem_reservation: 500m # only for memory limit . remove if you have memory

    depends_on:
      - postgres
    volumes:
      - sonarqube_data:/opt/sonarqube/data
      - sonarqube_logs:/opt/sonarqube/logs
      - sonarqube_extensions:/opt/sonarqube/extensions

  postgres:
    image: postgres:13
    container_name: postgres
    environment:
      POSTGRES_USER: sonar
      POSTGRES_PASSWORD: sonarpassword
      POSTGRES_DB: sonarqube
    volumes:
      - postgres_data:/var/lib/postgresql/data

volumes:
  sonarqube_data:
  sonarqube_logs:
  sonarqube_extensions:
  postgres_data:
```
Create Local and Generate tokens.

![Screenshot(44)](https://github.com/user-attachments/assets/b3661b9d-2627-4c31-8281-5729b5ed5153)
![Screenshot(45)](https://github.com/user-attachments/assets/112e80bb-cf6e-4e73-99f3-a63805931bcb)
![Screenshot(46)](https://github.com/user-attachments/assets/2fe9accb-fc90-410e-8238-3a7b774ba05d)
![Screenshot(47)](https://github.com/user-attachments/assets/88f9225f-9880-4a9e-92de-fb05475e5959)
![Screenshot(48)](https://github.com/user-attachments/assets/8b46d8ed-5f70-47a1-a53e-ddf68017cda3)
![Screenshot(49)](https://github.com/user-attachments/assets/9bb226f6-1ab3-4ddb-aed1-0915ccb2745a)
![Screenshot(50)](https://github.com/user-attachments/assets/3b6ebf40-b0e7-458d-91d3-15f585729fff)

update Jenkinsfile

```groovy
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
```
Add plugins nodejs as well and global variable System.





