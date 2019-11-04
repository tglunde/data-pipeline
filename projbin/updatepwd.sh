#!/bin/sh

[ -z "$SALT" ] && {  echo SALT not found in environemnt ; exit 1 ; }

# OLD_CRED_LINE=$(s3cmd get s3://$BUCKET/$SALT - | /projbin/dec.sh $SALT | grep ${SEU}\:${PROFILENAME})
NEW_CRED_LINE="${SEU}:${PROFILENAME}:${CREDUSER}:${CREDPWD}"


{ s3cmd get s3://$BUCKET/$SALT - | /projbin/dec.sh $SALT | grep -v ${SEU}\:${PROFILENAME} ;  echo $NEW_CRED_LINE ; } | /projbin/enc.sh > ${SALT}.new

s3cmd put ${SALT}.new s3://$BUCKET/$SALT 

# rm -f ${SALT}.new

