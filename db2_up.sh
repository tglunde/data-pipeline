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
}

db2_up () {
  PIPEFILE=/tmp/$schema_$table
  fqn=$db_$schema_$table

  db2 connect to $db user $user using $pwd

  echo "Uploading table $fqn tmpdir is $PIPEFILE "

  if test -f "$PIPEFILE"; then
    rm $PIPEFILE
  fi
  mkdir -p /work/log
  mkfifo $PIPEFILE
  db2 "export to $PIPEFILE of del modified by coldel, codepage=1208 select * from $schema.$table " >/work/log/$fqn.db2.log 2>&1 &
  gzip -c < $PIPEFILE | s3cmd put - s3://$bucket/$db/$schema/$table.csv.gz >/work/log/$fqn.s3c.log 2>&1 
  rm $PIPEFILE
}

setenv "$@"
echo "Uploading tables from $db at $host:$port user $user from schema $schema into bucket $bucket"
db2 catalog tcpip node MYNODE remote $host server $port 
db2 catalog db $db as $db at node MYNODE
db2 connect to $db user $user using $pwd

export -f db2_up
for t in $(db2 -x "select rtrim(tabname) from syscat.tables where tabschema = '$schema' and type='T' and regexp_like(tabname,'$tableregex')")
do
  export table=$t
  SHELL=$(type -p bash) sem --will-cite -j +0 db2_up
done
sem --will-cite --wait

