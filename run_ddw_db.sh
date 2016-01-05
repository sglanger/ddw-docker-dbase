#!/bin/bash

###############################################
# Author: SG Langer Jan 2016
# Purpose: put all the Docker commands to build/run 
#	ddw-dbase in one easy place
#
##########################################

# first clean up if any running instance
# Comment out the rmi line if you really don't want to rebuild the docker
#sudo docker rmi -f ddw-dbase
sudo docker stop ddw-db
sudo docker rm ddw-db


# now build from clean. The DOcker run line uses "--net= " term to expose the docker
# on the Host's NIC. For better security, remove it
#sudo docker build --rm=true -t ddw-dbase .
sudo docker run --net="host" --name ddw-db -e POSTGRES_PASSWORD=postgres -d ddw-dbase
sleep 1
sudo docker ps
sleep 3
sudo docker exec  ddw-db /docker-entrypoint-initdb.d/service-start.sh



