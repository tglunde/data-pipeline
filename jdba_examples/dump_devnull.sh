#/bin/bash

PNAME=$(basename "$0")

echo -n "===============  starting: $PNAME" 
date -Iseconds 
mkdir -p log


cat dump_worklist.txt | grep BACE | sed '/^#/d;/^$/d'  |  \
while read DB_ENV DB_SCHEMA DB_TABLE DB_PREDICATE
do
  echo "====== $DB_ENV $DB_SCHEMA $DB_TABLE"

  case $DB_ENV in
    BLUP)
    export DB_HOST=rs104a.tui.de DB_DB=BLUP DB_PORT=59800 DB_USER=tufisla
    ;;
    UDBP)
    export DB_HOST=udbp.udb.tui.de.insite DB_DB=UDBP DB_PORT=50000 DB_USER=tufisla
    ;;
    UDBM)
    ;;
    *)
    unset DB_HOST DB_DB DB_PORT DB_USER
  esac
  export DB_SCHEMA DB_TABLE

 export PIPEFILE=/dev/null
 python jdbaexportv1.py $DB_SCHEMA.$DB_TABLE "$DB_PREDICATE"
done

wait

echo -n "===============  finished: $PNAME" 
date -Iseconds 

