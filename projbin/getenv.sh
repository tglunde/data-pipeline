#!/bin/sh

[ -z "$SALT" ] && {  echo SALT not found in environemnt ; exit 1 ; }

CRED_LINE=$(s3cmd get s3://tuid-dv01-s3-kampdb/$SALT - | /projbin/dec.sh $SALT | grep ${SEU}\:${PROFILENAME})

CREDUSER=$(echo $CRED_LINE | cut -d: -f 3)
CREDPWD=$(echo $CRED_LINE | cut -d: -f 4)

# after setting CREDUSER/PWD: both are empty, when exit 
[ -z "$CRED_LINE" ] && { echo ${SEU}\:${PROFILENAME} not found ;  exit 2 ; }

## TODO: extend here for setting other variables (host, port, dbanme, schemaname, etc.)

# generec
export CREDUSER
export CREDPWD

