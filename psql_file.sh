#!/bin/bash
export PGPASSWORD=`cat /work/credential`
export ROLE_ARN=arn:aws:iam::728448942690:role/tuid-dv01-iam-ai-tap-csw-kampdb-01
psql -p $DB_PORT -h $DB_HOST -d $DB_DB -U $DB_USER --variable=BUCKET=$bucket -f $DB_TABLE -L/work/log/$(basename $DB_TABLE).log 
