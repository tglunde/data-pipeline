#!/bin/bash
set -a

[ -d /work ] && cd /work

#
[ ! -z "$AWS_CREDENTIAL_FILE" ] && [ -f "$AWS_CREDENTIAL_FILE" ] && {
       mkdir -p $HOME/.aws ;
       cat "$AWS_CREDENTIAL_FILE" > $HOME/.aws/config ;
}

# run user
#source /home/db2clnt/.profile 

#exec sudo -Eu db2clnt bash "$@"

#gosu db2clnt "$@"

