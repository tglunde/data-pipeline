#!/bin/bash
export BUCKET=tuid-dv01-s3-kampdb
export ENV=UAT_delta
export SMB_HOST=hajas001cdcs.tuid.msds.insite
export SMB_USER="tuid\service_codiac"
export SMB_PWD=
export SMB_PATH=campaign
export FILE=Codiac_kamp/dbo/CMP_

s3cmd get s3://$BUCKET/$ENV/$FILE*
pigz -d *gz
for f in $(ls $FILE*) do
do
  curl -T $f -u "$SMB_USER:$SMB_PWD" smb://$SMB_HOST/$SMB_PATH/
done

rm $FILE*
