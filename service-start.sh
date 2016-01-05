#!/bin/bash

#service postgresql start 
/usr/lib/postgresql/9.4/bin/psql -U postgres -d purged_ddw < /docker-entrypoint-initdb.d/purged-ddw.sql
