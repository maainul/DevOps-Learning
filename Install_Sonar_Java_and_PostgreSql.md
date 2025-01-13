# REFERENCE : https://baraqheart.medium.com/install-sonarqube-on-ubuntu-machine-1c1eb4002ab6

## STEP 1: Install dependencies: JAVA

	sudo apt update
	sudo apt install openjdk-17-jdk -y
	java --version

## STEP 2: Install database dependencies: PostgreSQL

	sudo sh -c 'echo "deb https://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
	wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo tee /etc/apt/trusted.gpg.d/pgdg.asc > /dev/null
	sudo apt update
	sudo apt install postgresql -y
	sudo systemctl status postgresql
	sudo systemctl enable postgresql

### Change Password

	sudo passwd postgres

### Switch to the PostgreSQL User

	sudo -i -u postgres
	
### Create sonar User

	createuser sonar
	
### Access the PostgreSQL Command Line Interface (CLI)

	psql
	
### Create a password for sonar user, .create a db with sonarqube name and assign sonar as the owner giving all permission and privileges to sonar.

	ALTER USER sonar WITH ENCRYPTED password 'set_your_password';
	#set password for sonar user

	CREATE DATABASE sonarqube OWNER sonar;
	#create db

	GRANT ALL PRIVILEGES ON DATABASE sonarqube to sonar;
	#grant privleges

### List All Databases and all Users and table name
	
	\l 
	\du
	\dt
	
### Describe a Table's Structure

	\d tablename

## STEP 3: Install and Configure SonarQube

	sudo apt update && sudo apt install wget unzip -y
	
	cd /opt/
	sudo wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.9.3.79811.zip
    sudo unzip sonarqube-9.9.3.79811.zip
	
	sudo groupadd sonar

	sudo usermod -aG sonar sonar
	sudo chown -R :sonar /opt/sonarqube

	sudo nano /opt/sonarqube/conf/sonar.properties
	
### Uncomment those lines:

	sonar.jdbc.username=sonar
	sonar.jdbc.password=your_password

### Add this line #RUN_AS_USER= and replace as below

	sudo nano /opt/sonarqube/bin/linux-x86-64/sonar.sh

	sudo nano /etc/systemd/system/sonar.service
	
#### Add these lines here:

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
	
	sudo systemctl daemon-reload

### SonarQube uses Elasticsearch to store its indices in an MMap FS directory. It requires some changes to the system defaults

	sudo sysctl -w vm.max_map_count=524288
	sudo sysctl -w fs.file-max=131072
	ulimit -n 131072
	ulimit -u 8192
	
	
# Docker 

## To install SonarQube and PostgreSQL using Docker, follow these steps:


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


'''yml


2. Start the Services


Run the following command to start SonarQube and PostgreSQL:

    docker-compose up -d

This will:

Pull the necessary Docker images (sonarqube:community and postgres:15).

Start the containers for both services.


---

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

