#!/bin/bash
gpg_passphrase=Start1234567890
/usr/bin/gpg2 -d --batch --yes --passphrase ${gpg_passphrase} --cipher-algo AES256 -o - - 2>>/dev/null
