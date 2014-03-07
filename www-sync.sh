#!/bin/bash

#
# rsync option
# Refer man rsync
#

OPTION="-azvv --progress --delete -e ssh"

#
# ssh authentication 
#
USER="user"
HOST="10.2.0.101"

#
# Server Setting
#

## Production Server
SOURCE="/var/www/"

## Local Server
DESTINATION="/home/local/web/"

## Exclude File
## Split file by <space>
## Comment EXCLUDE_FILE to sync all
EXCLUDE_FILE[0]="configuration.php"
#EXCLUDE_FILE[1]="smnd/index.php"

#
# Log
#
LOGS="/var/log/www-sync/"
## date format ##
NOW=$(date +"%F")
NOWT=$(date +"%H%M")


#
# @method logging script activity 
#

function logging() {
    # Still on development
    if [ -d $LOGS ]; then
        cat /dev/null >  $LOGS"log-"$NOW-$NOWT".log"
    else
        mkdir -p $LOGS
        logging
    fi
}

#
# @method to sync directory and file
#

function st_sync() {
    if [ ${#EXCLUDE_FILE[@]} -eq 0 ]; then
        EXCLUDE=""
    else
        for FILE in "${EXCLUDE_FILE[@]}"
        do
            :
            EXCLUDE=$EXCLUDE"--exclude $FILE "
        done 
    fi

    rsync $OPTION $EXCLUDE $USER@$HOST:$SOURCE $DESTINATION
}

st_sync
#logging
