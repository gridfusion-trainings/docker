# DOCKER

Run interactive container: `docker run ubuntu /bin/echo 'Hello world'`

List running docker containers: `docker ps`   
List all docker containers: `docker ps -a`   
Remove all docker container (incl. not running ones): `docker rm $(docker ps -aq)`   

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

Run the new image (creates a new container): `$ docker run -t -i palotas/sinatra:v2 /bin/bash`

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

## Name a container
`$ docker run -d -P --name gf_container1 training/webapp python app.py`

Stop and remove container:

    $ docker stop web
    gf_container1
    $ docker rm web
    gf_container1

# Networking
Find out which network a container is attached to: `docker inspect containername`   
**bridged** is always the standard network a container attaches to   

To create a new network: `$ docker network create -d bridge my-bridge-network`   

    $ docker network ls
    NETWORK ID          NAME                DRIVER
    7b369448dccb        bridge              bridge              
    615d565d498c        my-bridge-network   bridge              
    18a2866682b8        none                null                
    c288470c46f6        host                host
    
Start and add a container to a specific network: `$ docker run -d --net=my-bridge-network --name node1 training/web`   
Start a shell on a running container: `$ docker exec -it node1 bash`   

Connect container to a specific network (while it is running): `$ docker network connect my-bridge-network node1`
Disconnect running container from a network: `$ docker network disconnect my-bridge-network node1`  
Delete network: `docker network rm my_bridge_network`   

## File System 
Create a new data volume in a container: `docker run -d -P --name web -v /webapp training/webapp python app.py`   
A new container is created and started from the *training/webapp* image and a new data volume is created at */webapp*. The corresponding data on the host can be found with `docker inspect web`   

     Mounts": [
     {
        "Name": "fac362...80535",
        "Source": "/var/lib/docker/volumes/fac362...80535/_data",
        "Destination": "/webapp",
        "Driver": "local",
        "Mode": "",
        "RW": true,
        "Propagation": ""
     }
     ]
     ...
     
### Mount a host directory as a data volume
`docker run -d -P --name web -v /src/webapp:/opt/webapp training/webapp python app.py`   
This mounts the host directory */src/webapp* to */opt/webapp* on the newly created container *web*   

### OR Create a data volume container and use it as a base for new containers 
1. Create new data volume container: `docker create -v /dbdata --name dbstore training/webapp /bin/true`   
Creates a new data volume container called */dbdata* in the new container *dbstore* with *training/webapp* as a base

2. Mount the data volume container into a newly created container: `docker run -d --volumes-from dbstore --name db1 training/webapp`   
Creates a new container *db1* using *training/webapp* as a base image and mounts the */dbdata* volume from the *dbstore* data volume container into it.    
Now additional containers can be created with the same command just replacing *db1* with something else. 

     Currently I don't understand why the inheriting data container is allowed to make changes in the base container. I expect that the base container has persistent data as explained in http://www.computerweekly.com/feature/Docker-storage-101-How-storage-works-in-Docker. Currently checking this with Francois.    
