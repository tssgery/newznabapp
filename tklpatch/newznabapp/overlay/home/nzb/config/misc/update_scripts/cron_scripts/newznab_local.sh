#!/bin/sh
# call this script from within screen to get binaries and processes releases

set -e

export NEWZNAB_PATH="/home/nzb/newznab/misc/update_scripts"
export NEWZNAB_SLEEP_TIME="600" # in seconds
export NEWZNAB_SLEEP_NO_CONFIGPHP="300"

# make sure the config.php file exists
while true; do
    if [ -f "${NEWZNAB_PATH}/../../www/config.php" ]; then
       break
    fi
    echo "Waiting ${NEWZNAB_SLEEP_NO_CONFIGPHP} seconds for config.php to be created"
    sleep ${NEWZNAB_SLEEP_NO_CONFIGPHP}
done


LASTOPTIMIZE=`date +%s`

while :

 do
CURRTIME=`date +%s`
cd ${NEWZNAB_PATH}
/usr/bin/php5 ${NEWZNAB_PATH}/update_binaries.php
/usr/bin/php5 ${NEWZNAB_PATH}/update_releases.php

DIFF=$(($CURRTIME-$LASTOPTIMIZE))
if [ $DIFF -gt 86400 ]; then
	LASTOPTIMIZE=`date +%s`
	echo "Optimizing DB..."
	/usr/bin/php5 ${NEWZNAB_PATH}/optimise_db.php
fi

echo "waiting ${NEWZNAB_SLEEP_TIME} seconds..."
sleep ${NEWZNAB_SLEEP_TIME}

done
