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