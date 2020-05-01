CREATE VIEW [Products Characteristics Format] AS
SELECT name, species, varietal, provenance, toast, process, FORMATS
FROM PRODUCTS

CREATE VIEW [Products Format Reference] AS
SELECT product, format, barCode, pack, price, stock, min_stock, max_stock
FROM REFS

CREATE VIEW [Users Purchases] AS
SELECT usr, orderDate, payment
FROM PURCHASES_USR
