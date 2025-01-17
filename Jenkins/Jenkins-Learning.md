# Jenkins learning plan

### **Day 1: Foundations of Jenkins**  
- **Learn**:  
  - What is Jenkins?  
  - Difference between CI and CD.  
  - Jenkins architecture (Master-Agent architecture).  
- **Tasks**:  
  1. Install Jenkins using Docker or natively (Linux/Windows).  
  2. Explore the Jenkins UI.  
  3. Set up a freestyle job that echoes "Hello, Jenkins!".  
- **Resources**:  
  - [Jenkins Installation Guide](https://www.jenkins.io/doc/book/installing/)  
  - [Jenkins Master-Agent Architecture](https://www.jenkins.io/doc/book/using/using-agents/)  

---

### **Day 2: Jenkins Jobs and Pipelines**  
- **Learn**:  
  - Freestyle Jobs vs. Pipeline Jobs.  
  - Jenkinsfile (Declarative and Scripted Pipelines).  
- **Tasks**:  
  1. Write a basic Jenkinsfile for a declarative pipeline.  
  2. Create a pipeline job to execute the Jenkinsfile.  
  3. Explore Jenkins pipeline stages (`checkout`, `build`, `test`, `deploy`).  
- **Resources**:  
  - [Jenkins Pipeline Syntax](https://www.jenkins.io/doc/book/pipeline/syntax/)  
  - [Pipeline Tutorials](https://www.jenkins.io/doc/tutorials/)  

---

### **Day 3: Jenkins Plugins and Integrations**  
- **Learn**:  
  - Importance of plugins and how to manage them.  
  - Integrating Jenkins with GitHub, SonarQube, and Docker.  
- **Tasks**:  
  1. Install and configure the following plugins:  
      - Git Plugin  
      - SonarQube Scanner Plugin  
      - Docker Pipeline Plugin  
  2. Clone a repository from GitHub and run a build.  
  3. Analyze code with SonarQube and see the results in Jenkins.  
- **Resources**:  
  - [Managing Plugins](https://www.jenkins.io/doc/book/managing/plugins/)  
  - [SonarQube Jenkins Integration](https://docs.sonarqube.org/latest/analysis/jenkins/)  

---

### **Day 4: Continuous Integration and Testing**  
- **Learn**:  
  - Automating unit tests and linting.  
  - Triggering builds automatically on code changes (Webhooks).  
- **Tasks**:  
  1. Set up GitHub Webhooks for Jenkins to trigger builds on push events.  
  2. Run unit tests in a pipeline using a testing framework (e.g., Jest for Node.js).  
  3. Generate test reports using the JUnit plugin.  
- **Resources**:  
  - [Triggering Jenkins Builds with Webhooks](https://docs.github.com/en/developers/webhooks-and-events/webhooks/creating-webhooks)  
  - [Testing in Pipelines](https://www.jenkins.io/doc/pipeline/tour/testing/)  

---

### **Day 5: Continuous Deployment with Jenkins**  
- **Learn**:  
  - Automating Docker builds and pushing images to a registry.  
  - Deploying apps to a server or Kubernetes.  
- **Tasks**:  
  1. Create a pipeline to:  
      - Build a Docker image.  
      - Push the image to Docker Hub or AWS ECR.  
  2. Deploy the Dockerized app to:  
      - An EC2 instance or  
      - A Kubernetes cluster (Minikube for local practice).  
- **Resources**:  
  - [Jenkins Docker Pipeline Plugin](https://plugins.jenkins.io/docker-workflow/)  
  - [Kubernetes Deployment Tutorial](https://kubernetes.io/docs/tutorials/)  

---

### **Day 6: Jenkins Security and Administration**  
- **Learn**:  
  - Securing Jenkins (RBAC, authentication, and authorization).  
  - Backup and restore Jenkins configurations.  
- **Tasks**:  
  1. Set up user roles and permissions using the Role-Based Authorization Strategy plugin.  
  2. Enable Jenkins backup using the ThinBackup plugin.  
  3. Configure HTTPS for Jenkins.  
- **Resources**:  
  - [Securing Jenkins Guide](https://www.jenkins.io/doc/book/security/)  
  - [ThinBackup Plugin](https://plugins.jenkins.io/thinbackup/)  

---

### **Day 7: Advanced Jenkins Usage**  
- **Learn**:  
  - Blue-Green Deployments and Rolling Updates.  
  - Parallel builds and pipeline optimizations.  
- **Tasks**:  
  1. Create a pipeline that deploys to two environments (staging and production).  
  2. Optimize your pipeline with parallel stages (e.g., run tests and builds concurrently).  
  3. Simulate a Blue-Green Deployment.  
- **Resources**:  
  - [Jenkins Parallel Stages](https://www.jenkins.io/doc/book/pipeline/syntax/#parallel)  
  - [Blue-Green Deployment Strategy](https://martinfowler.com/bliki/BlueGreenDeployment.html)  

---

### Final Project: Full CI/CD Pipeline  
Build a CI/CD pipeline for a real-world project:  
1. Pull code from GitHub.  
2. Run unit tests and SonarQube analysis.  
3. Build and push a Docker image.  
4. Deploy the app to Kubernetes or AWS EC2.

---
