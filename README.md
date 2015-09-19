ddw-postgres
============

Docker container for central ddw potgres dbase that  accepts remote 
connections from Docker IPs - all 172.17.0.1/16 IP addresses.


In addition, now sets up database according to environment variables:  
DB_NAME database  
DB_USER admin  
DB_PASS password  

To use:
-----
`docker run -d -e DB_NAME=db -e DB_USER=admin -e DB_PASS=password macadmins/postgres`
