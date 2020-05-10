SELECT b.usr, b.orderDate, b.payment, b.barCode, c.price, b.amount
FROM LINES_USR b, REFS c WHERE b.barCode = c.barCode
