#!/bin/sh

[ -z "$SALT" ] && {  echo SALT not found in environemnt ; exit 1 ; }

s3cmd get s3://$BUCKET/$SALT - | /projbin/dec.sh $SALT | grep ${SEU}\:${PROFILENAME} | cut -d: -f 4


