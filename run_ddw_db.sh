#!/bin/bash

# put all the Docker commands to build/run this in one easy place

# first clean up if any running
sudo docker stop ddw-db
sudo docker rmi -f ddw-dbase
sudo docker rm ddw-db


# now build from clean
sudo docker build --rm=true -t ddw-dbase .
sudo docker run --name ddw-db -e POSTGRES_PASSWORD=postgres -d ddw-dbase
sleep 1
sudo docker ps
sleep 3
sudo docker exec  ddw-db /docker-entrypoint-initdb.d/service-start.sh



