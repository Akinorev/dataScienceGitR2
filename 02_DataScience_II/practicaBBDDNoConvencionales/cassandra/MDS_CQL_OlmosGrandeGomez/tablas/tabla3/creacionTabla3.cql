CREATE TABLE practica.USERS_PURCHASES
(USR text,
ORDERDATE date,
BARCODE text,
PRICE text,
AMOUNT text,
PRIMARY KEY ((USR, ORDERDATE), BARCODE));
