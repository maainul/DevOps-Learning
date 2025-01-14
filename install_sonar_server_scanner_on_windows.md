https://www.w3schools.com/postgresql/postgresql_install.php

### **System Requirements**
1. **Java**: SonarQube requires **Java 11 or Java 17** (OpenJDK or Oracle JDK).
2. **PostgreSQL**: Use PostgreSQL 10.x or later.
3. **Hardware**: Minimum 2GB RAM and 1GB disk space.

### **Step-by-Step Installation**

#### **Step 1: Install Java**
1. Download **OpenJDK 17**:
   - URL: [https://adoptium.net/](https://adoptium.net/)
2. Install the JDK and set the `JAVA_HOME` environment variable:
   - Right-click **My Computer** → Properties → Advanced System Settings → Environment Variables.
   - Add a new `System Variable`:
     - Name: `JAVA_HOME`
     - Value: Path to your JDK installation folder (e.g., `C:\Program Files\OpenJDK\jdk-17`).
   - Edit the `Path` variable and add: `%JAVA_HOME%\bin`.

3. Verify the installation:
   ```cmd
   java -version
   ```

#### **Step 2: Install PostgreSQL**
1. Download PostgreSQL:
   - URL: [https://www.enterprisedb.com/downloads/postgresql](https://www.enterprisedb.com/downloads/postgresql)
2. Install PostgreSQL:
   - Set a strong password for the `postgres` user.
   - Install pgAdmin if you want a GUI.
3. Configure PostgreSQL:
   - Open **SQL Shell (psql)** or connect via pgAdmin.
   - Create a user and database for SonarQube:
     ```sql
     CREATE USER sonar WITH ENCRYPTED PASSWORD 'your_password';
     CREATE DATABASE sonarqube OWNER sonar;
     GRANT ALL PRIVILEGES ON DATABASE sonarqube TO sonar;
     ```


#### **Step 3: Download SonarQube**
1. Download SonarQube:
   - URL: [https://www.sonarqube.org/downloads/](https://www.sonarqube.org/downloads/)
2. Extract the ZIP file to a directory, e.g., `C:\SonarQube`.


#### **Step 4: Configure SonarQube**
1. Open the `sonar.properties` file:
   ```text
   C:\SonarQube\conf\sonar.properties
   ```
2. Update the database settings:
   ```properties
   sonar.jdbc.username=sonar
   sonar.jdbc.password=your_password
   sonar.jdbc.url=jdbc:postgresql://localhost:5432/sonarqube
   ```
3. Set the memory limits:
   - Open `C:\SonarQube\bin\windows-x86-64\wrapper.conf`.
   - Find and adjust:
     ```properties
     wrapper.java.initmemory=2
     wrapper.java.maxmemory=4
     ```
     (Adjust based on your machine's memory.)


#### **Step 5: Start SonarQube**
1. Open a Command Prompt as **Administrator**.
2. Navigate to:
   ```cmd
   cd C:\SonarQube\bin\windows-x86-64
   ```
3. Start SonarQube:
   ```cmd
   StartSonar.bat
   ```

#### **Step 6: Access SonarQube**
1. Open your browser and go to:
   ```
   http://localhost:9000
   ```
2. Default login credentials:
   - Username: `admin`
   - Password: `admin`

3. Change the admin password when prompted.


### **Common Issues**
1. **Port Conflict**: If port 9000 is in use, change it in `sonar.properties`:
   ```properties
   sonar.web.port=9001
   ```
2. **Elasticsearch Fails**:
   - Increase the `vm.max_map_count` value by running this in Command Prompt as Admin:
     ```cmd
     sysctl -w vm.max_map_count=524288
     ```
Yes, you will need **Sonar Scanner** if you want to analyze code and send the results to your SonarQube server. SonarQube itself acts as the **server** for managing and visualizing the results, while the **Sonar Scanner** is the tool that performs the actual analysis of your codebase.


### **What is Sonar Scanner?**
- Sonar Scanner is a standalone tool used to analyze your source code and collect metrics such as bugs, vulnerabilities, code smells, and test coverage.
- It sends the analyzed data to your SonarQube server for visualization.


### **When Do You Need Sonar Scanner?**
1. **Standalone Analysis**:
   - If you’re running SonarQube locally or on a server, you’ll use Sonar Scanner to analyze your codebase and push the results to the server.

2. **Integration with CI/CD**:
   - If you want to integrate SonarQube into CI/CD pipelines (e.g., Jenkins, GitHub Actions), you’ll often use Sonar Scanner CLI or plugins specific to the CI tool.

3. **No IDE Plugins**:
   - If you don’t use IDE plugins for SonarQube (e.g., SonarLint), you need Sonar Scanner for manual code analysis.


### **How to Install Sonar Scanner on Windows 7**
1. **Download Sonar Scanner**:
   - URL: [Sonar Scanner Downloads](https://docs.sonarqube.org/latest/analysis/scan/sonarscanner/)
   - Download the ZIP file for Windows.

2. **Extract the Files**:
   - Extract the ZIP file to a directory, e.g., `C:\SonarScanner`.

3. **Configure Sonar Scanner**:
   - Open the `sonar-scanner.properties` file in the `conf` folder.
   - Add the URL of your SonarQube server:
     ```properties
     sonar.host.url=http://localhost:9000
     ```
   - Optional: Set default project properties like `sonar.projectKey` or authentication tokens.

4. **Add Sonar Scanner to PATH**:
   - Add the `bin` directory of Sonar Scanner to the system's PATH environment variable.
     Example: `C:\SonarScanner\bin`

5. **Verify Installation**:
   - Open Command Prompt and run:
     ```cmd
     sonar-scanner --version
     ```

### **How to Use Sonar Scanner**
1. Navigate to your project directory:
   ```cmd
   cd path/to/your/project
   ```

2. Run the Sonar Scanner command:
   ```cmd
   sonar-scanner -Dsonar.projectKey=my_project -Dsonar.sources=. -Dsonar.host.url=http://localhost:9000 -Dsonar.login=your_token
   ```
   - Replace `my_project` with your project key.
   - Replace `your_token` with your SonarQube authentication token (generated from the SonarQube UI).


### **Alternatives to Sonar Scanner**
- **IDE Plugins**:
  - Use **SonarLint** to analyze your code directly in your IDE (e.g., IntelliJ, VSCode).
  - SonarLint helps detect issues during development but doesn’t push data to the SonarQube server.

- **Build Tool Plugins**:
  - If you use Maven, Gradle, or other build tools, you can use their respective SonarQube plugins instead of the standalone scanner.
