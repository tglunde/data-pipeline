import jaydebeapi
import jpype

##args='-Djava.class.path=%s' % jar
#args=' -DconvertStrings=False'
#jvm = jpype.getDefaultJVMPath()
#jpype.startJVM(jvm, args )



##### hardcoded connect
jdbc_options = { 'user': "db2inst1", 'password': "MEIN_STRENG_GEHEIMES_PASSWORT", 'other_property': "foobar"}
# ibm options
# https://www.ibm.com/support/knowledgecenter/SSEPGG_11.5.0/com.ibm.db2.luw.apdv.java.doc/src/tpc/imjcc_r0052075.html

# ibm jdbc url https://www.ibm.com/support/knowledgecenter/SSEPEK_12.0.0/java/src/tpc/imjcc_r0052341.html
conn = jaydebeapi.connect("com.ibm.db2.jcc.DB2Driver",
    "jdbc:db2://172.17.0.2:50000/sample",
    jdbc_options,
    "/jdbc/db2jcc4_v4.26.jar",)
curs = conn.cursor()
curs.execute('create table CUSTOMER'
    '("CUST_ID" INTEGER not null,'
    ' "NAME" VARCHAR not null,'
    ' primary key ("CUST_ID"))'
)
curs.execute("insert into CUSTOMER values (1, 'John')")
curs.execute("select * from CUSTOMER")
curs.fetchall()
# [(1, u'John')]
curs.close()
conn.close()

