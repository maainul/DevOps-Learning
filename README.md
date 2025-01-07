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
![Screenshot(34)](https://github.com/user-attachments/assets/055204b9-f9ca-44f1-b68b-797fa000ae92)

After Reduild it create new folder in master 
```
ubuntu@ip-172-31-95-119:/var/lib/jenkins/workspace/node-demo$ ls
README.md  index.js  package-lock.json  package.json
ubuntu@ip-172-31-95-119:/var/lib/jenkins/workspace/node-demo$
```

![Screenshot(33)](https://github.com/user-attachments/assets/b019a347-2d2c-4b7d-886c-e78beb3ab2bd)
