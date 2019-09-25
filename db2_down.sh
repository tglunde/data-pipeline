#!/bin/bash
. ./setenv.sh "$@"

SRCFILES=/tui/tufis/informatica/projekte/campaign_core/SrcFiles/campaign
rm $SRCFILES/*$schema_$table.csv*.gz
s3cmd -c s3cfg get s3://$bucket/out/*$table*csv*.gz $SRCFILES/

db2 connect to $db user $user using $pwd

mkfifo /tmp/pipe
cat $SRCFILES/$table.csv.gz000* | gunzip -c > /tmp/pipe &
db2 "load client from /tmp/pipe of del modified by coldel, replace into $schema.$table nonrecoverable"
rm /tmp/pipe