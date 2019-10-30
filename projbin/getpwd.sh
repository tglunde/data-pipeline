#!/bin/sh

[ -z "$SALT" ] && {  echo SALT not found in environemnt ; exit 1 ; }

s3cmd get s3://tuid-dv01-s3-kampdb/$SALT - | /projbin/dec.sh $SALT | grep ${SEU}\:${PROJNAME} | cut -d: -f 3


