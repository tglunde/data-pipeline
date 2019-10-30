#!/bin/bash

[ -z "$SALT" ] && {  echo SALT not found in environemnt ; exit 1 ; }

gpg_passphrase=$(cat /.projenv/$SALT)
/usr/bin/gpg2 -c --batch --yes --passphrase ${gpg_passphrase} --cipher-algo AES256 -o - - 2>>/dev/null
