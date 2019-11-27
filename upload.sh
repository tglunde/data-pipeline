#!/bin/bash
set -e

. /home/db2clnt/upload_func.sh

setenv "$@"
echo "Uploading tables from $db at $host:$port user $user from schema $schema into bucket $bucket using $MODULE_NAME in $env"
${MODULE_NAME}_init
export -f upload
export -f ${MODULE_NAME}_export
TABLENAME_LIST=$(${MODULE_NAME}_select)
echo $TABLENAME_LIST
for t in $TABLENAME_LIST
do
  export table=$t
  echo "starting upload for $schema.$table" ; date
  SHELL=$(type -p bash) sem --will-cite -j +0 upload "$db/$schema" "$table".csv.gz
done
echo waiting for all uploads to finish
sem --will-cite --wait

