#!/bin/sh

[ -z "$SALT" ] && {  echo SALT not found in environemnt ; exit 1 ; }

echo ${SEU}:${PROJNAME}
echo PWD?
read PWD
NPWD="${SEU}:${PROJNAME}:${PWD}"
echo $NPWD
echo $NPWD | /projbin/enc.sh > t



