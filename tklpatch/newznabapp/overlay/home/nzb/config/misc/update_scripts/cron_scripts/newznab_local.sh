#!/bin/sh
# call this script from within screen to get binaries and processes releases

set -e

export NEWZNAB_PATH="/home/nzb/newznab/misc/update_scripts"
export NEWZNAB_SLEEP_TIME="3600" # on hour, in seconds
export NEWZNAB_SLEEP_NO_CONFIGPHP="300"
export NEWZNAB_LOG="/tmp/newznab_update.log"

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
   echo "======= Starting run ========" | tee $NEWZNAB_LOG
   date | tee -a $NEWZNAB_LOG
   CURRTIME=`date +%s`
   cd ${NEWZNAB_PATH}
   /usr/bin/php5 ${NEWZNAB_PATH}/update_binaries.php | tee -a $NEWZNAB_LOG
   /usr/bin/php5 ${NEWZNAB_PATH}/update_releases.php | tee -a $NEWZNAB_LOG

   DIFF=$(($CURRTIME-$LASTOPTIMIZE))
   if [ $DIFF -gt 86400 ]; then
	LASTOPTIMIZE=`date +%s`
	echo "Optimizing DB..." | tee -a $NEWZNAB_LOG
	/usr/bin/php5 ${NEWZNAB_PATH}/optimise_db.php | tee -a $NEWZNAB_LOG
   fi

   date | tee -a $NEWZNAB_LOG
   echo "=======  Ending run  ========" | tee -a $NEWZNAB_LOG

   echo "waiting ${NEWZNAB_SLEEP_TIME} seconds..."
   sleep ${NEWZNAB_SLEEP_TIME}

done


