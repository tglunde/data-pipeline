#!/bin/bash
runuser -l db2clnt -c 'db2 /work/catalog'
runuser -l db2clnt -c '/db2_up.sh "$@"'


