#!/bin/sh

[ -z "$SALT" ] && {  echo SALT not found in environemnt ; exit 1 ; }

echo ${SEU}:${PROFILENAME}
echo USER?
read CREDUSER
echo PWD?
read CREDPWD
NPWD="${SEU}:${PROFILENAME}:${CREDUSER}:${CREDPWD}"
echo $NPWD
echo $NPWD | /projbin/enc.sh > "${SALT}.new"



