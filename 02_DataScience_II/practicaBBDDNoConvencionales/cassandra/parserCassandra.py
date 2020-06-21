import sqlite3

fd = open('query3.sql', 'r')
sqlFile = fd.read()
fd.close()

sqlCommands = sqlFile.split(';')

#modify date to work with cassandra standards
for command in sqlCommands:
    #Insert into practica.USERS_PURCHASES(USR, ORDERDATE, BARCODE, PRICE, AMOUNT) values('aurora', toDate('17-09-09'), 'QQQ46115O274071', '2,8', '8');
    valuesCommand = command.split("values")
    valuesCommand.split("toDate")
