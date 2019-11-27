#!/bin/bash
set -e

setenv () {
  export pwd=$(cat /work/credential)
  export port=$1
  export host=$2
  export db=$3
  export user=$4
  export schema=$5
  export tableregex=$6
  export bucket=$7
  export env=$8
  export MODULE_NAME="$9"
}

db2_init () {
  db2 catalog tcpip node MYNODE remote $host server $port
  db2 catalog db $db as $db at node MYNODE
  db2 connect to $db user $user using "$pwd"
}
db2_export () {
  db2 connect to $db user $user using "$pwd"
  db2 "export to $PIPEFILE of del modified by coldel, codepage=1208 select * from $schema.$table" >/work/log/$fqn.export.log 2>&1
  RS=$?
  [ $RS -ne 0 ] && echo "DB2 exit with $RT"  >>/work/log/$fqn.export.log
}
db2_select () {
  db2 connect to $db user $user using "$pwd" > /dev/null 2>&1
  db2 -x "select rtrim(tabname) from syscat.tables where tabschema = '$schema' and tabname like '%$tableregex%'"
}

mssql_init () {
  echo "noop" > /dev/null
}
mssql_export () {
  bcp "select * from $schema.$table" queryout $PIPEFILE -t"\t" -c -S $host,$port -d $db -U $user -P $pwd -a 65535 
}
mssql_select () {
  sqlcmd -U $user -P $pwd -S $host,$port -d $db -W -w1024 -X1 -h -1 -Q "set nocount on ; select table_name from information_schema.views where TABLE_SCHEMA='dbo' and PATINDEX( '%$tableregex%', table_name) != 0"
}

psql_init () {
  echo "noop" > /dev/null
}
psql_export () {
  psql -p $port -h $host -d $db -U $user -c "COPY $schema.$table TO $PIPEFILE (FORMAT CSV DELIMITER '\t' encoding 'UTF8') "
}
psql_select () {
  psql -p $port -h $host -d $db -U $user -c "select table_name from information_schema.tables where table_catalog='campaign' and table_schema='campaign_r' and table_name ilike '%$tableregex%'"
}

upload () {
  # paramter 1: s3 target dirname
  # paramter 2: s3 target filename 
  echo "upload: starting export for $schema.$table"
  export fqn=$env_$db_$schema_$table
  export PIPEFILE=/tmp/$fqn
  echo "Uploading table $fqn - tmpdir is $PIPEFILE"

  [ -f "$PIPEFILE" ] && rm $PIPEFILE

  mkdir -p /work/log
  mkfifo $PIPEFILE
  [ ! -p $PIPEFILE ] && { echo "creating namedpipe $PIPEFILE failed. aborting." ; exit 1; }

  ${MODULE_NAME}_export 2>&1 &
  #cat $PIPEFILE >> /dev/null &
  pigz -c < $PIPEFILE | s3cmd put - s3://$bucket/$env/${1}/${2} >/work/log/$fqn.s3c.log 2>&1 
  RS=$?
  [ $RS -ne 0 ] && echo "s3cmd exit with $RT"  >>/work/log/$fqn.s3c.log
  rm $PIPEFILE
}

