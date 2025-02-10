# Docker

### Dockerize simple application:

https://tutorialedge.net/golang/go-docker-tutorial/

# Go lang app: https://github.com/mainul-codemen/Go-Rest-Api-Postgres-Booklist-Project

### Dockerfile

```dockerfile
FROM golang:1.16

LABEL Maintainer="Mainul Hasan <mainul080@gmail.com>"

WORKDIR /go/src/Go-Rest-Api-Postgres-Booklist-Project

COPY . .

RUN go get -d -v ./...
RUN go install -v ./...

# RUN go build -o Go-Rest-Api-Postgres-Booklist-Project .

CMD ["Go-Rest-Api-Postgres-Booklist-Project"]
```

docker build -t maainul/web-api

docker run maainul/web-api

docker run -p 8000:8000 maainul/web-api

## 1. Continers

1.  Run a container

        docker run hello_world : it will download a container and run if locally is not available

2.  Show the status of docker

        systemctl status docker

        systemctl start docker

3.  How to create a simple container from CMD:

        docker run -t -t --name "MY First Container" centos:latest /bin/bash

    - i = iteractive mode
    - t = terminal

    bin/bash = cmd or server to run in the container to use

    show the host file : hostname -f, top

(Now we are inside the container terminal)

    docker container ls : list of all containers

    docker container ls -a : list of all running container

## 2. Images

    docker image list

    docker pull ubuntu (hun.docker.com)

## 3. Docker file

Docker file is a simple text file contain list of instructions or steps to build new docker images.

Create a folder inside directory
mkdir dockerbuild
cd dockerbuild
vim Dockerbuild

```bash
FROM ubuntu:latest
MAINTAINER "Mainul Hasan"

RUN apt-get update
RUN apt-get install -y openssh-server

CMD["echo","Hello World........."]
```

type : esc + wq !

From this docker file we can build container

    docker build -t myubuntu:1.0

Run Docker :
docker run myubuntu:1.0

See running containers :
docker continer ls

See all containers :
docker container ls -a

## Remove Containers

    docker container rm containerID

## Create apache2 images and container

    mkdir apachedockerfolder

    cd apachedockerfolder

    vim Dockerfile

## Dockerfile.yaml

```
# This is test file for dockerfile for apache2 container and images

FROM ubuntu:latest
ARG DEBIAN_FRONTEND=noninteractive
MAINTAINER "mainul hasan"

RUN apt-get update
RUN apt-get install -y apache2

RUN mkdir -p /var/lock/apache2
RUN mkdir -p /var/run/apache2

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_LOG_DIR /var/log/apache2
ENV LANG C

CMD ["/usr/sbin/apache2","-D","FOREGROUND"]

EXPOSE 80


```

    docker run -t -d -P --name apache2Container apache2ubuntu

    -d = detachablemode

    -P = portmapping

## Docker Compose

We may have multiple continers we have to manage multiple containers.

Docker compose is a tools for defining and running multi-continer
docker application.

Use yaml file to configure applications

With single command we should be able to build and start containers

Terminationg containers also easy by executing single containers

    docker compose

    docker-compose up -d

    docker-compose down

## Create mysql and nginx

    mkdir docker-compose

    cd docker-compose

    vim docker-compose.yaml

```
version: '3'
services:
        mysql_database:
                image: "mysql:latest"
                environment:
                        - MYSQL_ROOT_PASSWORD="password"

        web_test :
                image : "nginx:latest"



```

### Create a container from compose

    docker-compose up

### for stop a container go to the docker compose directory and apply cmd

    docker-compose down

# Docker

## 1. Continers

1.  Run a container

        docker run hello_world : it will download a container and run if locally is not available

2.  Show the status of docker

        systemctl status docker

        systemctl start docker

3.  How to create a simple container from CMD:

        docker run -t -t --name "MY First Container" centos:latest /bin/bash

    - i = iteractive mode
    - t = terminal

    bin/bash = cmd or server to run in the container to use

    show the host file : hostname -f, top

(Now we are inside the container terminal)

    docker container ls : list of all containers

    docker container ls -a : list of all running container

## 2. Images

    docker image list

    docker pull ubuntu (hun.docker.com)

## 3. Docker file

Docker file is a simple text file contain list of instructions or steps to build new docker images.

Create a folder inside directory
mkdir dockerbuild
cd dockerbuild
vim Dockerbuild

```bash
FROM ubuntu:latest
MAINTAINER "Mainul Hasan"

RUN apt-get update
RUN apt-get install -y openssh-server

CMD["echo","Hello World........."]
```

type : esc + wq !

From this docker file we can build container

    docker build -t myubuntu:1.0

Run Docker :
docker run myubuntu:1.0

See running containers :
docker continer ls

See all containers :
docker container ls -a

## Remove Containers

    docker container rm containerID

## Create apache2 images and container

    mkdir apachedockerfolder

    cd apachedockerfolder

    vim Dockerfile

## Dockerfile.yaml

```
# This is test file for dockerfile for apache2 container and images

FROM ubuntu:latest
ARG DEBIAN_FRONTEND=noninteractive
MAINTAINER "mainul hasan"

RUN apt-get update
RUN apt-get install -y apache2

RUN mkdir -p /var/lock/apache2
RUN mkdir -p /var/run/apache2

ENV APACHE_RUN_USER www-data
ENV APACHE_RUN_GROUP www-data
ENV APACHE_PID_FILE /var/run/apache2.pid
ENV APACHE_RUN_DIR /var/run/apache2
ENV APACHE_LOCK_DIR /var/lock/apache2
ENV APACHE_LOG_DIR /var/log/apache2
ENV LANG C

CMD ["/usr/sbin/apache2","-D","FOREGROUND"]

EXPOSE 80


```

    docker run -t -d -P --name apache2Container apache2ubuntu

    -d = detachablemode

    -P = portmapping

## Docker Compose

We may have multiple continers we have to manage multiple containers.

Docker compose is a tools for defining and running multi-continer
docker application.

Use yaml file to configure applications

With single command we should be able to build and start containers

Terminationg containers also easy by executing single containers

    docker compose

    docker-compose up -d

    docker-compose down

## Create mysql and nginx

    mkdir docker-compose

    cd docker-compose

    vim docker-compose.yaml

```
version: '3'
services:
        mysql_database:
                image: "mysql:latest"
                environment:
                        - MYSQL_ROOT_PASSWORD="password"

        web_test :
                image : "nginx:latest"



```

### Create a container from compose

    docker-compose up

### for stop a container go to the docker compose directory and apply cmd

    docker-compose down

# -------------------------DOCKER---------------------------------------------

![5 docker-system](https://user-images.githubusercontent.com/85335954/129874163-39b7d83c-c281-4e2a-8c17-d3b9f9e4a501.png)

## Docker Ecosystem

![1 docker-ecosystem](https://user-images.githubusercontent.com/85335954/129873377-9a8e6448-a72d-491b-ae70-bf3be8d28be6.png)

## Docker Cli and Daemon intraction

![2 Dockerclianddockerdaemon](https://user-images.githubusercontent.com/85335954/129873530-7380bfab-c1b8-4d77-8e7a-4c4947bb2599.png)

1. Create and Run a container

![3 dokcer-run-with-dockerhub](https://user-images.githubusercontent.com/85335954/129873683-8ab8d95f-a7a5-40de-b2a7-564580432e90.png)

    docker run busybox echo Hi there

## Image and Container

![4 docker-image and container](https://user-images.githubusercontent.com/85335954/129874030-909a2104-6612-4271-9971-133199f59c39.png)

2.Run a container

![6 docker-run](https://user-images.githubusercontent.com/85335954/129874227-b2c5739f-5c38-4b07-bb36-a66f64090572.png)

    docker run busybox ls

3.List of all container

    docker ps

4.Run a container with google ping

    docker run busybox ping google.com

5.List of all container

    docker ps -a

## Create and Run

![7 create-run](https://user-images.githubusercontent.com/85335954/129874270-1e661931-b172-4c54-9fa0-7790178eeee5.png)

6.Just create a project

    docker create hello-world

7.Start and execute project

    docker start -a 987aeb324b54i0

8.It will only start a project not execute

    docker start 987aeb324b54i0

9.Remove all container(Caution)

    docker system prune

10. Logs of docker container

![8 logs](https://user-images.githubusercontent.com/85335954/129874358-d3501d46-af5e-46f1-9740-e3592dc712b2.png)

    docker logs 98pef4g464 (containerId)

11. Stopping a Continer

![10 stop-and-kill](https://user-images.githubusercontent.com/85335954/129874437-1524350e-cab1-47b8-8b66-e29903681588.png)

Little bit time to stop.10 sec need to stop a container

    docker stop 98pef4g464

You have to shutdown now.No time needed

    docker kill 98pef4g464

## Install Redis image

12.Create and run redis db

    docker run redis

It will show an error.Because our redis-cli is not in the docker container.So we have to integrate this with docker container

    redis-cli

13. Execute commands in Running containers.

![additionalcommand](https://user-images.githubusercontent.com/85335954/129874509-b0ed44ef-febd-46a4-b8ac-b8ffffc20dce.png)

By Using the exec cmd we can run a second running program inside out container.
docker exec -it 98pef4g464 redis-cli

interactive with terminal

    docker exec -t 98pef4g464 sh

14.starting with a shell

    docker run -it busybox sh

## DOCKER FILE

15. create docker filet to install redis-server

![file-1](https://user-images.githubusercontent.com/85335954/129885460-edb1ea25-5ef8-446a-8798-a9f9821d8917.png)

    docker build .

![file2](https://user-images.githubusercontent.com/85335954/129890758-41626c21-c740-4844-8a8e-6c700a0a4dd6.png)
![file-3](https://user-images.githubusercontent.com/85335954/129890762-c468defe-6cd5-4b62-ac73-ec288f4d0171.png)

16.

## Install Docker Container From Dockerfile Node

17. Project Flow
    ![steps](https://user-images.githubusercontent.com/85335954/130178039-578378cf-c5f6-48e0-b569-123af38cbdb9.png)

18. Project Structure
    ![nodef1](https://user-images.githubusercontent.com/85335954/130178100-52add70e-3ce2-414b-ad3a-caf520aac458.png)

19. Index.js
    ![node-2](https://user-images.githubusercontent.com/85335954/130178197-98ea4b74-bdf6-4a95-93a4-b6de0aff2bad.png)

20. Dockerfile
    ![node-dockerfile](https://user-images.githubusercontent.com/85335954/130178156-332574ae-0985-4e7c-a264-5dc2daaf6241.png)

#### Run CMD :

    docker build .

Error will happend

### LET'S Fix the issue

Update Dockerfile

![nextnode](https://user-images.githubusercontent.com/85335954/130180642-c2513e0b-fef4-45a2-851d-b452fbe07a94.png)

    docker build .

Now it is fixed.

## COPY file to the container

    COPY ./ ./

```
    # Specify a base image
    FROM node:alpine

    COPY ./ ./
    # Install some dependencies
    RUN npm install

    # Default command
    CMD ["npm","start"]
```

## Run cmd with tag

    docker build -t maainul/simpleweb

    docker run maainul/simpleweb

    docker run -p 8080:8080 maainul/simpleweb

### Let's test in the web browser

    localhost:8080

Not working .... PORT MAPPING

## Port Mapping

![portmapping](https://user-images.githubusercontent.com/85335954/130363208-c887de9d-22bc-467e-89f4-d48284a6fd8a.png)

![portmapping-2](https://user-images.githubusercontent.com/85335954/130363238-79395163-0f90-4e7c-9345-4577bca45838.png)

![portmapping-3](https://user-images.githubusercontent.com/85335954/130363244-bff85d06-989c-4e17-928d-100c07e2c9ca.png)

Host port and docker container port can be different

    Let's try

    docker run -p 5000:8080 maainul/simpleweb

    localhost:5000

## Question : Can I change the port of container ?

Yes.

    docker run -p 5000:6000 maainul/simpleweb

But wait a minute change port number from the project

Before :

```node
app.listen(8080, () => {
  console.log("Listen on port 8080");
});
```

After :

```node
app.listen(6000, () => {
  console.log("Listen on port 8080");
});
```

## Update the dockrfile

Update the dockerfile because all file is in the root directory of container

![-itflag](https://user-images.githubusercontent.com/85335954/130363414-c8c11d27-a4bf-467e-9d2a-4c24fbcbaef6.png)

It can be conflict so let's update docker file...

# Where project will be saved

WORKDIR /usr/app

## Full Dockerfile

```
# Specify a base image
FROM node:alpine

# Where project will be saved
WORKDIR /usr/app

COPY ./ ./
# Install some dependencies
RUN npm install

# Default command
CMD ["npm","start"]
```

    docker build -t maainul/simpleweb .

    docker run -p 8080:8080 maainul/simpleweb

    docker ps

    docker exec -it idofcaontainer sh

    ls
    cd /

## --------------------------------------------- NEW APP ------------------------------------------------------------

## Our App may look like this.

![nodeappr1](https://user-images.githubusercontent.com/85335954/130395082-ef498e96-3519-4cea-9a4e-b4e7b376b109.png)

### There will be a container with node app and connected with redis

![ndoeredis2](https://user-images.githubusercontent.com/85335954/130395058-e604adc4-888e-4d85-9216-ea450fd89e0e.png)

### We can think about this

![noderedis3](https://user-images.githubusercontent.com/85335954/130394978-9c6d46d3-106a-4f76-9d02-e356e084961f.png)

### But this will be better

![nodereids-4](https://user-images.githubusercontent.com/85335954/130394984-4bff02af-bdea-4b77-be27-026df9a34df3.png)

### One App container and one redis container and communicate with other

![noderedis-5](https://user-images.githubusercontent.com/85335954/130394981-c124448d-5684-4aa1-9e13-77b938d027a9.png)

## Connect with Multiple Containers : Node app and REDIS

1. Create index.js

```
const express = require("express");
const redis = require("redis");

const app = express();

const client = redis.createClient({
  host: "redis-server", // same as container name in the docker-compose.yaml file
  port: 6379, // redis default port
});

client.set("visits", 0);

app.get("/", (req, res) => {
  client.get("visits", (err, visits) => {
    res.send("Number of visits is " + visits);
    client.set("visits", parseInt(visits) +1);
  });
});

app.listen(4001, () => {
  console.log("Listen on port 4001.......");
});

```

2. Create package.json

```json
{
  "dependencies": {
    "express": "*",
    "redis": "2.8.0"
  },
  "scripts": {
    "start": "node index.js"
  }
}
```

3. Dockerfile

```Dockerfile
FROM node:alpine

WORKDIR '/app'

COPY package.json .

RUN npm install

COPY . .

CMD ["npm","start"]

```

4. docker-compose.yml

```yml
version: "3"
services:
  redis-server:
    image: "redis"
  node-app:
    build: .
    ports: - "40001:8081"
```

    docker-compose up

    docker run -d redis

    dokcer-compose up -d

    docker ps

    docker-compose up --build

## Connection between two container

![ndr-3](https://user-images.githubusercontent.com/85335954/130423998-4beebef8-091a-4fb7-af8d-95896ecf3a2b.png)

## What is docker compose ??

![ndr-4](https://user-images.githubusercontent.com/85335954/130424005-b311a0b3-5969-485a-ae13-77ee6da0ef55.png)

## Project compose file overview

![ndr-6](https://user-images.githubusercontent.com/85335954/130424021-4d5c9f7f-43bd-4721-a45c-810f0decc64c.png)

![ndr-5](https://user-images.githubusercontent.com/85335954/130424009-d2163671-c95d-49a4-9686-c71cfa17dc50.png)

## Docker up

![rd-7](https://user-images.githubusercontent.com/85335954/130424031-4640e6dd-f20b-4b0f-bda6-91ea87f81eff.png)

## All files together

![all](https://user-images.githubusercontent.com/85335954/130425668-c50d1265-bc86-4df4-bc45-f460d828d4d9.png)

## Now Build project

    1. Run redis first

## Docker up and down

![ndr-7](https://user-images.githubusercontent.com/85335954/130424023-07f4a1c4-94a8-408d-b6e2-9cddeff620e2.png)

    docker compose up

    docker compose up --build

    http://localhost:8081/

## DOCKERIZE REACT APP

### Project and docker work flow of Industry

![workflow](https://user-images.githubusercontent.com/85335954/130448462-4533cdc3-06ab-45bf-b4bc-dfb040c3d941.png)

### React app

    mkdir react-app-with-docker

    cd react-app-with-docker

    sudo npm install -g create-react-app

    create-react-app frontend

    cd frontend

    yarn start

### Run in the localhost

    http://127.0.0.1:3000/

### Add Dockerfile.dev in the pwd

```Dockerfile
FROM node:alpine

WORKDIR '/app'

COPY package.json .

RUN npm install

COPY . .

CMD ["npm","run","start"]

```

    docker build -f Dockerfile.dev .

    docker run containerID

    docker run -p 3000:3000 containerID

## DOCKER VOLUME

docker run -p 3000:3000 -v /app/node_modules -v $(pwd):/app containerID

![volume-create](https://user-images.githubusercontent.com/85335954/130448727-a4cde89d-4ff5-4fa9-bc4e-e03673325df3.png)

## Docker with test

## Update docker-compose.yml

```yml
version: "3"
services:
  web:
    build:
      context: .
      dockerfile: Dockerfile.dev
    ports:
      - "3004:3000"
    volumes:
      - /app/node_modules
      - .:/app
  tests:
    build:
      context: .
      dockerfile: Dockerfile.dev
    volumes:
      - /app/node_modules
      - .:/app
    command: ["npm", "run", "test"]
```

## Run command

    docker-compose up --build

## It will throw an error

    Because we are not volume clearly.. so discard volumes

```yml
version: "3"
services:
  web:
    build:
      context: .
      dockerfile: Dockerfile.dev
    ports:
      - "3004:3000"
    # volumes:
    #   - /app/node_modules
    #   - .:/app
  tests:
    build:
      context: .
      dockerfile: Dockerfile.dev
    # volumes:
    #   - /app/node_modules
    #   - .:/app
    command: ["npm", "run", "test"]
```

## Nginx and react

1. Servers
   ![dev1](https://user-images.githubusercontent.com/85335954/130668804-8d234327-866c-491f-93d5-fa97c9ffaabf.png)

2. Prod servers
   ![dev3](https://user-images.githubusercontent.com/85335954/130668812-93a7fd38-93b1-452c-ae7d-1fe7509912ec.png)

3. Docker flow
   ![dev4](https://user-images.githubusercontent.com/85335954/130668814-2a80424c-2fdb-43e4-82be-505542bc6137.png)

```dockerfile
FROM node:alpine as builder

WORKDIR '/app'

COPY package.json .

RUN npm install

COPY . .

CMD ["npm","start"]


FROM nginx

COPY --from=builder /app/build /usr/share/nginx/html



```

in the app directory file should be ---> app/build

No other file will be added.

### RUN cmd

    docker build .

    docker run -p 8080:80(80 - default port of nginx)

    localhost:8080
