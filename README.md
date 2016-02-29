# docker

## Docker Ubuntu 
Run interactive container: `docker run ubuntu /bin/echo 'Hello world'`

## Docker run container as a daemon 
`docker run -d ubuntu /bin/sh -c "while true; do echo hello world; sleep 1; done" <br>`
Look at logs: `docker logs "containername"` <br>

## Port mapping 
`0.0.0.0:49155->5000/tcp` : means that container port 5000 is mapped to VM/Host port 49155

`docker run -d -p 80:5000 training/webapp python app.py` maps container port 5000 to port 80 on VM / Host 

`docker port nostalgic_morse 5000` shows what port 5000 is mapped to publicly 

`$ docker inspect nostalgic_morse` Inspect docker container 

`$ docker rm nostalgic_morse` Remove docker containes

`gridfusion@ubuntu:~$ docker search selenium` Search for docker images

## Creating your own image
Pulling a new image: `$ docker pull training/sinatra`

Run in interactive mode: `$ docker run -t -i training/sinatra /bin/bash`
**Take note of the container ID at this point. You will need it later for the commit**

Edit the image: `root@0b2616b0e5a8:/# gem install json`

Commit the changes: `$ docker commit -m "Added json gem" -a "Kate Smith" 0b2616b0e5a8 palotas/sinatra:v2`

When running `docker images` you should see the `palotas/sinatra:v2` image

Run the new image: `$ docker run -t -i palotas/sinatra:v2 /bin/bash`

## Create new image with DOCKERFILE
    # This is a comment
    FROM ubuntu:14.04
    MAINTAINER Michael Palotas <michael.palotas@gridfusion.net>  
    RUN apt-get update && apt-get install -y ruby ruby-dev
    RUN gem install sinatra
    RUN apt-get install -y wget
    
Build new docker image: `$ docker build -t palotas/sinatra:v2 .`

##Push new docker image to docker hub
make sure you are logged in: `docker login`

`$ docker push palotas/sinatra`
