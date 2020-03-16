import jaydebeapi
import jpype
import csv
import sys
import os

### prepare context from parameter & environment
if "PIPEFILE" not in os.environ:
    print("Please set the environment variable PIPEFILE")
    sys.exit(1)
pipename = os.environ.get("PIPEFILE")

if "DB_USER" not in os.environ:
    print("Please set the environment variable DB_USER")
    sys.exit(1)
db_user = os.environ.get("DB_USER")
db_port = os.environ.get("DB_PORT")
db_db = os.environ.get("DB_DB")
db_host = os.environ.get("DB_HOST")
db_pwd = 'SECRET_PASSWORDS'

if len(sys.argv) < 2:
    print("need at least one parameter: schema.tablename")
    sys.exit(1)
dbtablename = sys.argv[1]

dbwhereclause = "1 = 1"
if len(sys.argv) > 2:
    dbwhereclause = sys.argv[2]
    if dbwhereclause is None:
        dbwhereclause = "1 = 1"
    if len( dbwhereclause ) == 0:
        dbwhereclause = "1 = 1"

if len(sys.argv) > 3:
    fetchno = sys.argv[3]
    if fetchno:
        dbwhereclause = dbwhereclause + " FETCH FIRST " + fetchno + " ROWS ONLY "

sql  = "SELECT * FROM " + dbtablename + " WHERE " + dbwhereclause + " for READ ONLY with UR "

# check
print("PIPENAME      = {}".format( pipename ))
print("TABLE         = {}".format( dbtablename ))
print("SQL           = {}".format( sql ))

jdbc_options = { 'user': db_user, 'password': db_pwd , 'other_property': "foobar"}

####   main starts here
with open(pipename,'ab',5) as pipeout:
    #^csv_out=csv.writer(pipeout, dialect='excel-tab', lineterminator='\n')
    csv_out=csv.writer(pipeout, delimiter='\t', quotechar='"', quoting=csv.QUOTE_NONNUMERIC, lineterminator='\n')
    conn = jaydebeapi.connect("com.ibm.db2.jcc.DB2Driver",
        "jdbc:db2://"+db_host+":"+db_port+"/"+db_db,
        jdbc_options,
        "/jdbc/db2jcc4_v4.26.jar",)

    curs = conn.cursor()
    curs.execute( sql )

    try:
        i = 0
        recordset = curs.fetchmany(10000)
        while ( len(resultset) > 0 ):
            for row in recordset:
                i += 1
                csv_out.writerow(row)
            recordset = curs.fetchmany(10000)
    except csv.Error as e:
        pipeout.close()
        print('csv error: {}'.format(e))
        sys.exit(1)
    print("ROWS_EXPORTED = %d" % i)
    curs.close()
    conn.close()
    pipeout.close()
sys.exit(0)

