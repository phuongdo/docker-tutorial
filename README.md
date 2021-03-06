# Dockerize your Java Application

This cookbook aims at providing for java developers a quick, easy way to build their own docker image
that can be used to create the containers needed for automatic builds.

### 1. Prerequisites

* Ubuntu 14.04, 16.04 16.10, CenOS 6.8, CenOS 7, Window 10, Window 7
* Docker, Docker-Compose (https://www.docker.com/)

### 2. Starting with Dockerfile

Docker builds images by reading instructions from a Dockerfile.
A Dockerfile is a simple text file that contains instructions that can be executed on the command line.
Using docker build, you can start a build that executes all of the command-line instructions contained in the Dockerfile.

See more https://docs.docker.com/engine/getstarted/step_four/#step-1-write-a-dockerfile
Common Dockerfile instructions start with RUN, ENV, FROM, MAINTAINER, ADD, and CMD, among others.

- FROM - Specifies the base image that the Dockerfile will use to build a new image. For this post, we are using phusion/baseimage as our base image because it is a minimal Ubuntu-based image modified for Docker friendliness.
- MAINTAINER - Specifies the Dockerfile Author Name and his/her email.
- RUN - Runs any UNIX command to build the image.
- ENV - Sets the environment variables. For this post, JAVA_HOME is the variable that is set.
- CMD - Provides the facility to run commands at the start of container. This can be overridden upon executing the docker run command.
- ADD - This instruction copies the new files, directories into the Docker container file system at specified destination.
- EXPOSE - This instruction exposes specified port to the host machine.

### 3. Build your own Dockerfile for Java Application

#### 3.1 Dockerfile without monitor tool (version 1.0)
See my  [Dockerfile](java/your-docker/Dockerfile) for an example
```Dockerfile
# download java:8 prebuild
FROM   pdoviet/oracle-java:8
# add your mantainer
MAINTAINER  Author Name <author@email.com>
#create apps directory
RUN mkdir apps
# copy your application to docker images
ADD java/java-app /apps/java-app
WORKDIR /apps/java-app
# run your application
# OPTION 1 : Run java application with dependencies
CMD ["java","-cp","Main.jar", "Main"]
# OPTION 2 : Run direct your application ( not recommended)
#CMD ["java","Main"]
```

#### 3.2 Dockerfile with monitor tool (version 2.0)
See my  [Dockerfile-V2](java/your-docker-v2/Dockerfile) for an example

First, you need to modify `bin/start-app.sh` for your own purpose. Eg
```bash
## sh bin/monitor-script <logfile> <sleeptime> <decaytime> <serviceid>
sh bin/monitor-script.sh /data/logs/foo.log 1m 1 bd2c77d8-0f97-11e7-96ff-0242ac110003 > monitor-agent.log 2>&1 &
##
java -Xms10M -Xmx10M -cp Main.jar Main
```

Second, use this template-v2 to build your image.

```Dockerfile
# download java:8 prebuild
FROM   pdoviet/oracle-java:8
# add your mantainer
MAINTAINER  Author Name <author@email.com>
RUN mkdir apps
# create logging directory ( just for demo)
RUN mkdir -p /data/logs/
RUN touch /data/logs/foo.error.log
# copy your application to docker images
ADD java/java-app /apps/java-app
ADD bin /apps/java-app/bin
WORKDIR /apps/java-app
# run your application
CMD ["sh","bin/start-app.sh"]


```

You can download my source code from [GitHub](https://github.com/phuongdo/docker-tutorial/)
### 4. Usage

```bash
git clone https://github.com/phuongdo/docker-tutorial.git
cd docker-tutorial
```

Build your docker image

```bash
docker build -f java/your-docker/Dockerfile -t <docker-hub-uri>/<your-namespace>/<your-image>:<version> .
#Example
docker build -f java/your-docker/Dockerfile -t ir.admicro.vn/pdoviet/your-docker-image:1 .
```
```***NOTE: Do not forget the .(dot) at the end of command; it specifies the context of the build. The .(dot) at the end of the command specifies the current directory. The files and directories of current directory will be sent to Docker daemon as a build artifact.```

This process will take a few minutes, then you can list your docker images in local machine

```bash
docker images
EPOSITORY                           TAG                 IMAGE ID            CREATED             SIZE
pdoviet/your-docker-image            1                   be0aa8633f16        9 seconds ago       667 MB
pdoviet/oracle-java                  8                   5fc2ac2d72c0        18 minutes ago      667 MB
```

You have built our own image successfully, now we need to test it using sample Java application.

```bash
docker run -it --rm  --name your-name ir.admicro.vn/pdoviet/your-docker-image:1
Hello World!
```
Some options are available:
- The -it flag starts the container in an interactive mode,
- The --rm flag cleans out the container after it shuts down,
- The --name dsp-inst names the container dsp-inst,
or
- The -d run on daemon mode


### 5. Docker Hub
Login to your DockerHub with your account (please create one if you don't have it)
```bash
docker login <docker-hub-uri>
```
pull to your images docker hub
```
docker pull <docker-hub-uri>/<your-namespace>/<your-image>:<version>
```

### 6. FAQ?

How do I list what is currently running?

```docker ps```

How do I stop and delete a running process?

```docker stop and docker rm```


