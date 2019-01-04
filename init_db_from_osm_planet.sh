#!/bin/bash

source conf.sh

function init_planet {
	#Download the planet
	echo "Will start downloading the planet file at $(date)"
	echo "From: $PLANET_FILE"
	wget --quiet -O planet.osm.bz2 $PLANET_FILE
	echo "Planet file downloaded at $(date)"

	#init the planet
	echo "Will init the import of the planet. Started at $(date)"
	$BINDIR/init_osm3s.sh $DBDIR/planet.osm.bz2 $DBDIR $EXECDIR --meta
	echo "Import finished at $(date)"
}

space=`du -s $DBDIR | cut -f1`
if [ ! -e $DBDIR/nodes.bin ]; then
	#Database doesn't exist
	cd $DBDIR

	#Get actual last replication state
	wget -O /dev/shm/state.txt "$REPLICATE_SERVER/state.txt"
	
	init_planet

	#Get 7 days of backwards history; we never know when was the planet.osm exported..
	NUM=`cat /dev/shm/state.txt | grep sequenceNumber | cut -d'=' -f2`

	#Write the replicate id, 7 days before
	echo $(($NUM - 1440*7)) > $DBDIR/replicate_id
fi

