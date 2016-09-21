#!/bin/bash

###############################################
# Author: SG Langer Jan 2016
# Purpose: put all the Docker commands to build/run 
#	ddw-dbase in one easy place
#
##########################################


############## main ###############
# Purpose: Based on command line arg either
#		a) build all Docker from scratch or
#		b) kill running docker or
#		c) start Docker or
#		d) restart
# Caller: user
###############################
clear
host="127.0.0.1"

case "$1" in
	build)
		# first clean up if any running instance
		# Comment out the rmi line if you really don't want to rebuild the docker
		sudo docker stop ddw-db
		sudo docker rmi -f ddw-dbase
		sudo docker rm ddw-db

		# now build from clean. The DOcker run line uses --net="host" term to expose the docker
		# on the Host's NIC. For better security, remove it
		sudo docker build --rm=true -t ddw-dbase .
		# WHen both this and the ddw-gw DOcker use HOST, their Postgres instances collide in namespace
		# but we no longer expose the gway Postgres
		sudo docker run --net="host" --name ddw-db -e POSTGRES_PASSWORD=postgres -d ddw-dbase
		sleep 3
		sudo docker ps
		sudo docker exec  ddw-db /docker-entrypoint-initdb.d/service-start.sh
	;;

	conn)
		sudo docker exec -it ddw-db /bin/bash 
	;;


	conn_r)
		sudo docker exec -u root -it ddw-db /bin/bash
	;;

	status)
		sudo docker ps; echo
		sudo docker images 
	;;

	stop)
		# stops but does not remove image from DOcker engine
		sudo docker stop ddw-db
		sudo docker rm ddw-db
	;;

	start)
		sudo docker run --net="host" --name ddw-db -e POSTGRES_PASSWORD=postgres -d ddw-dbase
		sleep 3
		sudo docker ps
		sudo docker exec  ddw-db /docker-entrypoint-initdb.d/service-start.sh
	;;

	*)
		echo "invalid option"
		echo "valid options: build/start/stop/status/conn"
		exit
	;;
esac
