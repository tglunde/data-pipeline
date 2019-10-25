#!/bin/bash
export PGPASSWORD=`cat /work/credential`
psql -p $DB_PORT -h $DB_HOST -d $DB_DB -U $DB_USER -c "$DB_TABLE" 
