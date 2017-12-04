#!/bin/bash

host=$1
port=$2
CATALINA_HOME=/usr/local/tomcat

while true; do 
	if ! pg_isready -h "$host" -p "$port" &> /dev/null; then 
		echo 'waiting for connection'
	else 
		echo 'connected successfully'
		break
	fi 
	sleep 3
done

if [ ! -d "$CATALINA_HOME/webapps/ssp-platform" ]; then
	echo 'DEPLOYING SSP PLATFORM FOR THE FIRST TIME'
	PGPASSWORD=sspadmin psql -h postgresssp -U sspadmin -d ssp -c "grant all privileges on database ssp to sspadmin;"
	PGPASSWORD=sspadmin psql -h postgresssp -U sspadmin -d ssp -c "CREATE USER ssp with ENCRYPTED PASSWORD 'ssp';"
	PGPASSWORD=sspadmin psql -h postgresssp -U sspadmin -d ssp -c "grant all privileges on database ssp to ssp;"
	echo 'GRANTED PERMISSIONS TO sspadmin USER'
	sleep 5
	# cd /usr/local/ssp/platform-src && SSP_CONFIGDIR=/usr/local/ssp/ssp-local ant -Dmaven.test.skip=true clean initportal
	cd /usr/local/ssp/platform-src && SSP_CONFIGDIR=/usr/local/ssp/ssp-local ant -Dmaven.test.skip=true clean initdb
	cd /usr/local/ssp/platform-src && SSP_CONFIGDIR=/usr/local/ssp/ssp-local ant -Dmaven.test.skip=true clean deploy-ear

fi

sh "$CATALINA_HOME/bin/catalina.sh" run