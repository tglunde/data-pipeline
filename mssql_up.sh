#!/bin/bash

setenv () {
  export pwd=$(cat /work/credential)
  export port=$1
  export host=$2
  export db=$3
  export user=$4
  export schema=$5
  export tableregex=$6
  export bucket=$7
  export env=UAT
}

mssql_up () {
  PIPEFILE=/tmp/$schema_$table
  fqn=$db_$schema_$table

  echo "Uploading table $fqn tmpdir is $PIPEFILE "

  if test -f "$PIPEFILE"; then
    rm $PIPEFILE
  fi
  mkdir -p /work/log
  mkfifo $PIPEFILE
  bcp "select * from $schema.$table" queryout $PIPEFILE -t"\t" -c -S $host,$port -d $db -U $user -P $pwd -a 65535 >/work/log/$fqn.msssql.log 2>&1 &
  pigz -c < $PIPEFILE | s3cmd put - s3://$bucket/$env/$db/$schema/$table.csv.gz >/work/log/$fqn.s3c.log 2>&1 
  rm $PIPEFILE
}

setenv "$@"
echo "Uploading tables from $db at $host:$port user $user from schema $schema into bucket $bucket"
export -f mssql_up
for t in $(sqlcmd -U $user -P $pwd -S $host,$port -d $db -W -w1024 -X1 -h -1 -Q "set nocount on ; select table_name from information_schema.views where TABLE_SCHEMA='dbo' and PATINDEX( '%$tableregex%', table_name) != 0")
do
    export table=$t
    SHELL=$(type -p bash) sem --will-cite -j +0 mssql_up 
done
sem --will-cite --wait
