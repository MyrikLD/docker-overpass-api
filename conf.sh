#!/bin/bash

#===================================
#You can change the following params
#===================================

#Where to store the database (without using a docker volume) in your server:
OVERPASS_DB_DIR=/overpass_data

#On which server TCP port the API should be available ?
# i.e., the API will be accessible on http://YOUR_SERVER_IP:[PORT]/api
#Normally you want to have a proxy between the outside world and the API
SERVER_HTTP_PORT=5001


#What is your email ? So others can contact you in case
VHOST_EMAIL=a@rocketdata.io

#Your FQDN the server will be available on. Only for æsthetic purposes
VHOST_FQDN=overpass.rocketdata.io



#Which minute replication server should be used
REPLICATE_SERVER=http://planet.osm.org/replication/minute
#REPLICATE_SERVER=http://ftp.gwdg.de/pub/misc/openstreetmap/planet.openstreetmap.org/replication/minute/


#Where to fetch the planet file from ?
PLANET_FILES=( \
#"http://download.geofabrik.de/russia-latest.osm.bz2" \
"http://download.geofabrik.de/europe/belarus-latest.osm.bz2" \
)


#=====================================
#Don't change anything below this line
#=====================================

OPASS_MAIN=/Overpass-API
BINDIR=$OPASS_MAIN/src/bin
EXECDIR=$OPASS_MAIN/src
DBDIR=/overpass_DB

RULES_LOGFILE=$DBDIR/rules_loop.log

