FROM postgres:9.4 

MAINTAINER Steve Langer <sglanger@fastmail.COM>
##################################################
# Purpose: SGL extensions to postgresql for DDW
#         inspired by 	https://docs.docker.com/engine/examples/postgresql_service/
#         and 			https://hub.docker.com/_/postgres/
#
# External dependencies: ddw-docker-gway
#
# Build with  "sudo docker build --rm=true -t ddw-dbase . "
# Run it with "sudo docker run --name ddw-db -e POSTGRES_PASSWORD=postgres -d ddw-dbase "
# Connect to the above instance with "sudo docker exec -it ddw-db /bin/bash"
# get IP of instance with "sudo docker inspect ddw-db "
############################################################

ADD purged-ddw.sql /docker-entrypoint-initdb.d/purged-ddw.sql
ADD service-start.sh /docker-entrypoint-initdb.d/service-start.sh
RUN chmod 777 /docker-entrypoint-initdb.d/purged-ddw.sql
RUN chmod 777 /docker-entrypoint-initdb.d/service-start.sh
RUN apt-get update && apt-get install nano

########### Create a POstgresql cluster as ROOT
RUN pg_createcluster -u postgres 9.4 main

# Run the rest of the commands as the ``postgres`` user 
USER postgres

# Create a PostgreSQL role named ``postgres`` with ``postgres`` as the password and
# then create a database `ddw` owned by the ``postgres`` role.
# Note: here we use ``&&\`` to run commands one after the other - the ``\``
#       allows the RUN command to span multiple lines.
RUN    /etc/init.d/postgresql start &&\
 	createdb -O postgres purged_ddw

# Adjust PostgreSQL configuration so that remote connections to the
# database are possible.
RUN echo "host all  all    0.0.0.0/0  trust" >> /etc/postgresql/9.4/main/pg_hba.conf 
RUN echo "host all  all    127.0.0.1/32 trust" >> /etc/postgresql/9.4/main/pg_hba.conf

# STEP 21: And add ``listen_addresses`` to ``/etc/postgresql/9.4/main/postgresql.conf``
RUN echo "listen_addresses = '*'" >> /etc/postgresql/9.4/main/postgresql.conf

# STEP 22: Expose the PostgreSQL port
EXPOSE 5432

# STEP 22: Add VOLUMEs to allow backup of config, logs and databases
VOLUME  ["/etc/postgresql", "/var/log/postgresql", "/var/lib/postgresql"]


# STEP 23: Set the default command to run when starting the container
CMD ["/usr/lib/postgresql/9.4/bin/postgres", "-D", "/var/lib/postgresql/9.4/main", "-c", "config_file=/etc/postgresql/9.4/main/postgresql.conf"]

# When I run below the Docker starts, then dies
#   CMD /docker-entrypoint-initdb.d/service-start.sh
# so we have to use the CMD [ ] line above, then manually load DDW schema after it's running thus
# "sudo docker exec  ddw-db /docker-entrypoint-initdb.d/service-start.sh "



