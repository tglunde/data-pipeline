#!/bin/bash
export BUCKET=tuid-dv01-s3-kampdb
export ENV=UAT
export SMB_HOST=hajas001cdcs.tuid.msds.insite
export SMB_USER="tuid\service_codiac"
export SMB_PWD=prod4codiac
export SMB_PATH=campaign
export FILE=delta

s3cmd get s3://$BUCKET/$ENV/$FILE*
pigz -d *gz
for f in $(ls $FILE*) do
do
  curl -T $f -u "$SMB_USER:$SMB_PWD" smb://$SMB_HOST/$SMB_PATH/
done

rm $FILE*
