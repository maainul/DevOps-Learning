# REFERENCE : https://baraqheart.medium.com/install-sonarqube-on-ubuntu-machine-1c1eb4002ab6
Here's a step-by-step guide to installing **SonarQube** and **PostgreSQL** on Ubuntu, along with creating a **`sonar`** user for SonarQube:

### **Step 1: Update Ubuntu and Install Dependencies**

1. **Update your system:**
   ```bash
   sudo apt update && sudo apt upgrade -y
   ```

2. **Install Java (OpenJDK 17):**
   SonarQube requires Java 11 or later, so we'll install OpenJDK 17.
   ```bash
   sudo apt install openjdk-17-jdk -y
   java -version
   ```

### **Step 2: Install and Configure PostgreSQL**

1. **Install PostgreSQL:**
   ```bash
   sudo sh -c 'echo "deb https://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
   wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo tee /etc/apt/trusted.gpg.d/pgdg.asc > /dev/null
   sudo apt update
   sudo apt install postgresql -y
   sudo systemctl status postgresql
   sudo systemctl enable postgresql
   ```

2. **Set the PostgreSQL `postgres` user password:**
   ```bash
   sudo passwd postgres
   ```

3. **Switch to the PostgreSQL user:**
   ```bash
   sudo -i -u postgres
   ```

4. **Access PostgreSQL command line:**
   ```bash
   psql
   ```

5. **Create the `sonar` database user:**
   ```sql
   CREATE USER sonar WITH ENCRYPTED PASSWORD 'your_password';
   ```

6. **Create the `sonarqube` database and assign ownership to the `sonar` user:**
   ```sql
   CREATE DATABASE sonarqube OWNER sonar;
   GRANT ALL PRIVILEGES ON DATABASE sonarqube TO sonar;
   ```

7. **Exit PostgreSQL CLI:**
   ```sql
   \q
   ```

8. **List databases and users (optional):**
   ```bash
   sudo -i -u postgres psql -c "\l"
   sudo -i -u postgres psql -c "\du"
   ```

---

### **Step 3: Install SonarQube**

1. **Install required tools:**
   ```bash
   sudo apt install wget unzip -y
   ```

2. **Download SonarQube:**
   Navigate to the `/opt/` directory and download SonarQube:
   ```bash
   cd /opt/
   sudo wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.9.3.79811.zip
   ```

3. **Extract SonarQube:**
   ```bash
   sudo unzip sonarqube-9.9.3.79811.zip
   sudo mv sonarqube-9.9.3.79811 sonarqube
   ```

---

### **Step 4: Create the `sonar` User and Group**

1. **Create a new system group for SonarQube:**
   ```bash
   sudo groupadd sonar
   ```

2. **Create a system user for SonarQube and add it to the `sonar` group:**
   ```bash
   sudo useradd -r -s /bin/bash -g sonar -d /opt/sonarqube sonar
   ```

3. **Set the ownership of the SonarQube directory to the `sonar` user:**
   ```bash
   sudo chown -R sonar:sonar /opt/sonarqube
   ```

---

### **Step 5: Configure SonarQube Database Connection**

1. **Edit SonarQube's configuration file:**
   ```bash
   sudo nano /opt/sonarqube/conf/sonar.properties
   ```

2. **Update the database connection settings:**
   Find the following lines and uncomment them, then configure as shown below:

   ```properties
   sonar.jdbc.url=jdbc:postgresql://localhost/sonarqube
   sonar.jdbc.username=sonar
   sonar.jdbc.password=your_password
   ```

   Replace `your_password` with the actual password you set for the `sonar` user in PostgreSQL.

3. **Save and close the file** (`Ctrl+O`, `Enter`, `Ctrl+X`).

---

### **Step 6: Configure SonarQube to Run as `sonar` User**

1. **Edit the `sonar.sh` script to set the user:**
   ```bash
   sudo nano /opt/sonarqube/bin/linux-x86-64/sonar.sh
   ```

2. **Find and modify the `RUN_AS_USER` line:**
   ```bash
   RUN_AS_USER=sonar
   ```

3. **Save and close the file** (`Ctrl+O`, `Enter`, `Ctrl+X`).

---

### **Step 7: Create a Systemd Service for SonarQube**

1. **Create the `sonar.service` file:**
   ```bash
   sudo nano /etc/systemd/system/sonar.service
   ```

2. **Add the following content:**
   ```ini
   [Unit]
   Description=SonarQube service
   After=syslog.target network.target

   [Service]
   Type=forking

   ExecStart=/opt/sonarqube/bin/linux-x86-64/sonar.sh start
   ExecStop=/opt/sonarqube/bin/linux-x86-64/sonar.sh stop

   User=sonar
   Group=sonar
   Restart=always

   LimitNOFILE=65536
   LimitNPROC=4096

   [Install]
   WantedBy=multi-user.target
   ```

3. **Reload systemd to apply the service configuration:**
   ```bash
   sudo systemctl daemon-reload
   ```

---

### **Step 8: Increase System Limits for SonarQube (Elasticsearch)**

SonarQube uses Elasticsearch, which requires some system configuration changes.

1. **Increase system limits:**
   ```bash
   sudo sysctl -w vm.max_map_count=524288
   sudo sysctl -w fs.file-max=131072
   ```

2. **Persist these changes by adding them to `/etc/sysctl.conf`:**
   ```bash
   sudo nano /etc/sysctl.conf
   ```

   Add these lines at the end of the file:
   ```bash
   vm.max_map_count=524288
   fs.file-max=131072
   ```

3. **Apply the changes:**
   ```bash
   sudo sysctl -p
   ```

4. **Increase user limits (optional but recommended):**
   ```bash
   sudo ulimit -n 131072
   sudo ulimit -u 8192
   ```

---

### **Step 9: Start and Enable SonarQube Service**

1. **Start SonarQube service:**
   ```bash
   sudo systemctl start sonar
   ```

2. **Enable SonarQube to start on boot:**
   ```bash
   sudo systemctl enable sonar
   ```

3. **Check the status of SonarQube:**
   ```bash
   sudo systemctl status sonar
   ```

   You should see output indicating that SonarQube is running. If there are issues, you can check the logs in `/opt/sonarqube/logs/`.

---

### **Step 10: Access SonarQube**

1. Open your browser and navigate to:
   ```
   http://<your-server-ip>:9000
   ```

2. The default login is:
   - **Username:** `admin`
   - **Password:** `admin`

---

### **Troubleshooting**

- **Log Files:** If SonarQube isn't starting, check the logs for detailed errors:
  ```bash
  cat /opt/sonarqube/logs/sonar.log
  cat /opt/sonarqube/logs/web.log
  cat /opt/sonarqube/logs/es.log
  ```

- **Firewall Issues:** Ensure port 9000 is open if you are accessing SonarQube remotely:
  ```bash
  sudo ufw allow 9000
  ```

---

This should give you a working SonarQube installation on Ubuntu with PostgreSQL, running under the `sonar` user. Let me know if you encounter any issues during the setup!
Yes, to analyze code with SonarQube, you also need **SonarScanner** (or an equivalent scanner tool). Here's why:

---

### **Why Do You Need SonarScanner?**
- **SonarQube** is the server that stores and processes the analysis results.
- **SonarScanner** is the tool used to analyze your source code and send the analysis results to the SonarQube server.

Without a scanner, SonarQube will not receive code metrics or analysis data, and you won't be able to view reports on the dashboard.

---

### **How to Install SonarScanner on Ubuntu?**
Follow these steps to install and configure **SonarScanner** on your Ubuntu system:

#### **1. Download SonarScanner**
Run the following commands to download and extract SonarScanner:
```bash
cd /opt
sudo wget https://binaries.sonarsource.com/Distribution/sonar-scanner-cli/sonar-scanner-cli-5.0.1.3006-linux.zip
sudo unzip sonar-scanner-cli-5.0.1.3006-linux.zip
sudo mv sonar-scanner-5.0.1.3006-linux sonar-scanner
```

#### **2. Configure SonarScanner**
Edit the configuration file to set the `sonar.host.url` to point to your SonarQube server:
```bash
sudo nano /opt/sonar-scanner/conf/sonar-scanner.properties
```

Add or update the following line:
```properties
sonar.host.url=http://localhost:9000
```

Save and exit the file.

#### **3. Add SonarScanner to PATH**
Add SonarScanner to the system PATH to make it accessible from anywhere:
```bash
echo 'export PATH=$PATH:/opt/sonar-scanner/bin' >> ~/.bashrc
source ~/.bashrc
```

#### **4. Verify Installation**
Run the following command to verify that SonarScanner is installed correctly:
```bash
sonar-scanner --version
```

---

### **How to Use SonarScanner?**
1. Navigate to your project's root directory.
2. Create a `sonar-project.properties` file with your project configuration:
   ```properties
   sonar.projectKey=your_project_key
   sonar.projectName=Your Project Name
   sonar.projectVersion=1.0
   sonar.sources=.
   sonar.host.url=http://localhost:9000
   sonar.login=your_sonarqube_token
   ```
   Replace `your_project_key`, `your_project_name`, and `your_sonarqube_token` with your values.

3. Run the scanner:
   ```bash
   sonar-scanner
   ```
 
# Docker 

## To install SonarQube and PostgreSQL using Docker, follow these steps:

    sudo apt-get install docker.io
    sudo apt-get install docker-compose-v2 
    sudo usermod -aG docker $USER && newgrp docker 

1. Create a Docker Compose File

Create a docker-compose.yml file in your project directory with the following content:

```yml

services:
  postgres:
    image: postgres:15
    container_name: sonarqube-postgres
    environment:
      POSTGRES_USER: sonarqube
      POSTGRES_PASSWORD: sonarqube
      POSTGRES_DB: sonarqube
    volumes:
      - sonarqube_db_data:/var/lib/postgresql/data
    networks:
      - sonarqube-network

  sonarqube:
    image: sonarqube:community
    container_name: sonarqube
    depends_on:
      - postgres
    ports:
      - "9000:9000"
    environment:
      SONAR_JDBC_URL: jdbc:postgresql://postgres:5432/sonarqube
      SONAR_JDBC_USERNAME: sonarqube
      SONAR_JDBC_PASSWORD: sonarqube
    volumes:
      - sonarqube_data:/opt/sonarqube/data
      - sonarqube_logs:/opt/sonarqube/logs
      - sonarqube_extensions:/opt/sonarqube/extensions
    networks:
      - sonarqube-network

volumes:
  sonarqube_db_data:
  sonarqube_data:
  sonarqube_logs:
  sonarqube_extensions:

networks:
  sonarqube-network:

```

2. Start the Services

Run the following command to start SonarQube and PostgreSQL:

    docker-compose up -d

This will:

Pull the necessary Docker images (sonarqube:community and postgres:15).

Start the containers for both services.

3. Access SonarQube

1. Open your browser and navigate to http://localhost:9000.

2. The default credentials are:

Username: admin

Password: admin



4. Verify Everything Works

Ensure both containers (sonarqube and sonarqube-postgres) are running:

	docker ps -a

Check logs for troubleshooting:

	docker logs sonarqube
	docker logs sonarqube-postgres

5. Persist Data

The volumes (sonarqube_db_data, sonarqube_data, etc.) ensure that data persists even if containers are restarted or removed.


# For Windows How to Download in local Machine:

https://www.sonarsource.com/products/sonarqube/downloads/

https://docs.sonarsource.com/sonarqube-server/10.4/analyzing-source-code/scanners/sonarscanner/

https://docs.sonarsource.com/sonarqube-server/9.9/analyzing-source-code/scanners/sonarscanner/

https://www.openlogic.com/openjdk-downloads?field_java_parent_version_target_id=807&field_operating_system_target_id=436&field_architecture_target_id=391&field_java_package_target_id=396

### downloads and unzip folder

https://github.com/maainul/java-sonarqube-helloworld-src.git

## Clone Code 

	git clone https://github.com/maainul/java-sonarqube-helloworld-src.git
	
	
## Scanner link 


0. Update sonar-scanner property \sonar.properties file

	E:\sonar-scanner\conf\sonar-scanner
	
	sonar.host.url=http://192.168.0.104:9000


1. Run Sonar Server :

	E:/bin/windows-x86-64 > StartSonar.bat start
	
2. Run Sonar Scanner:
    
	Go this location :  E:\java-sonarqube-helloworld-src 
	
3. and paste this
	
	E:\sonar-scanner\bin\sonar-scanner.bat

4. After success. Projects is available. : http://192.168.0.104:9000/projects


## Create Own Rules :

Go to Quality Gate and Create New.
We can give rules based on team requirements.

## Create User and Role :
User Creation : Administration > Security > Users

## How to Use maven and Gradle

### How to analysis with maven

1. Need this code in the pom.xml
	
2. pom.xml

	Udpage property file
	
	   <properties>
			<project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
			<project.reporting.outputEncoding>UTF-8</project.reporting.outputEncoding>
			<maven.compiler.release>11</maven.compiler.release>
			<!-- <sonar.projectKey>your_project_key</sonar.projectKey> -->
			<sonar.host.url>http://192.168.124.21:9000</sonar.host.url>
			<sonar.login>admin</sonar.login> <!-- Replace with your username -->
		</properties>


update plugin if not given

        <plugin>
          <groupId>org.sonarsource.scanner.maven</groupId>
          <artifactId>sonar-maven-plugin</artifactId>
          <version>3.10.0.2594</version>
        </plugin>

Test Coverage :

        <plugin>
          <groupId>org.jacoco</groupId>
          <artifactId>jacoco-maven-plugin</artifactId>
          <version>0.8.11</version>
        </plugin>
	
	mvn clean verify sonar:sonar -Dsonar.token=myAuthenticationToken
	
	mvn clean verify sonar:sonar -Dsonar.login=admin -Dsonar.password=123

	mvn sonar:sonar -Dsonar.login=<your-token>

	mvn sonar:sonar -Dsonar.login=admin -Dsonar.password=123

	mvn clean verify sonar:sonar


### How to analysis with Gradle

	gradle task --all

	gradle sonarqube

	gradle -v


### How to analysis with jenkins

