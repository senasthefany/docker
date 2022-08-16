#!/bin/bash
sudo su
#Criando container
#docker run --name web-server -dt -p 80:80 --mount type=volume,src=app,dst=/app/ webdevops/php-apache:alpine-php7

#criando um cluster
docker swarm init

cd /var/lib/docker/volume/app/_data

token = 
ip =
#nas máquinas clones
docker swarm join --token $token $ip

#check nodes
docker node ls

#pra criar um serviço de containers
docker service create --name web-server --replicas 10 -dt -p 80:80 -- mount type=volume,src=app,dst=/app/ webdevops/php-apache:alpine-php7

#check the containers
docker service ps web-server

#replicando volume dentro do cluster
#apt install nfs-server -y #if it's not installed
#no cluster
#apt install nfs-common -y

#no docker principal
nano /etc/exports 
#include /var/lib/docker/volume/app/_data *(rw,sync,subtree_check) 
exportfs -ar

#nos clientes
mount -o v3 172.31.0.127:/var/lib/docker/volume/app/_data /var/lib/docker/volume/app/_data

#proxy interno
cd /
mkdir proxy
cd /proxy
#nginx.conf e dockerfile
docker build -t proxy-app .
docker container run --name my-proxy-app -dti -p 4500:4500 proxy-app

