#!/bin/bash
set -a

# adjust group id
[ -d /work ] && {
  NEWID=$(ls -dnu /work | cut -f3 -d' ' ) ;
  export NEWID=$NEWID ;
}
export CURRENTID=$(id -u)


if [ -n "$NEWID" -a "$CURRENT_ID" != "$NEWID" ]; then
    echo "setting ownership to $NEWID"
    usermod -u ${NEWID} db2clnt
fi

#
export HOME=/home/db2clnt
[ ! -z "$AWS_CREDENTIAL_FILE" ] && [ -f "$AWS_CREDENTIAL_FILE" ] && {
       mkdir -p $HOME/.aws ;
       cat "$AWS_CREDENTIAL_FILE" > $HOME/.aws/config ;
       chown -R db2clnt $HOME/.aws ;
}
source /home/db2clnt/.profile 

#exec sudo -Eu db2clnt bash "$@"

gosu db2clnt "$@"

