#!/bin/bash

source conf.sh

function init_planet {
	#Download the planet
	echo "Will start downloading the planet file at $(date)"
	echo "From: $PLANET_FILE"
	wget --quiet -c $PLANET_FILE
	echo "Planet file downloaded at $(date)"
}

space=`du -s $DBDIR | cut -f1`
if [ ! -e $DBDIR/nodes.bin ]; then
	#Database doesn't exist
	cd $DBDIR

	#Get actual last replication state
	wget -O /dev/shm/state.txt "$REPLICATE_SERVER/state.txt"
	
	for i in "${PLANET_FILES[@]}"; do
	    PLANET_FILE=$i
	    init_planet
	done

	#init the planet
	echo "Will init the import of the planet. Started at $(date)"
	files=(*.osm.bz2)
	for i in "${files[@]}"; do
	    echo "Load: $i"
	    $BINDIR/init_osm3s.sh $DBDIR/$i $DBDIR $EXECDIR --meta
	done
	echo "Import finished at $(date)"

	#Get 7 days of backwards history; we never know when was the planet.osm exported..
	NUM=`cat /dev/shm/state.txt | grep sequenceNumber | cut -d'=' -f2`

	#Write the replicate id, 7 days before
	echo $(($NUM - 1440*7)) > $DBDIR/replicate_id
fi

