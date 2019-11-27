#!/bin/bash
set -a

# adjust group id
export NEWID=$(ls -dnu /work | cut -f3 -d' ' )
export CURRENTID=$(id -u)

if [ -n "$NEWID" -a "$CURRENT_ID" != "$NEWID" ]; then
    usermod -u ${NEWID} db2clnt
fi

#
export HOME=/home/db2clnt
source /home/db2clnt/.profile 

#exec sudo -Eu db2clnt bash "$@"

gosu db2clnt "$@"

