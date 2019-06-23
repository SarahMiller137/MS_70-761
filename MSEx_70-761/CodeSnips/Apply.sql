--USE [TSQLV4];

/* Create the following index first for this section

CREATE INDEX idx_poc

  ON Sales.Orders(custid, orderdate DESC, orderid DESC)

  INCLUDE(empid);

*/


---------------------------------------------------------------
--- A lengthly work around for a subquery only returning one value ---
---------------------------------------------------------------


SELECT C.custid, C.companyname,

  ( SELECT TOP (1) O.orderid

FROM Sales.Orders AS O

WHERE O.custid = C.custid

ORDER BY O.orderdate DESC, O.orderid DESC ) AS orderid,

  ( SELECT TOP (1) O.orderdate

FROM Sales.Orders AS O

WHERE O.custid = C.custid

ORDER BY O.orderdate DESC, O.orderid DESC ) AS orderdate,

  ( SELECT TOP (1) O.empid

FROM Sales.Orders AS O

WHERE O.custid = C.custid

ORDER BY O.orderdate DESC, O.orderid DESC ) AS empid

FROM Sales.Customers AS C;


---------------------------------------------------------------
--- The APPLY operator ---
---------------------------------------------------------------

--- Outer APPLY ---

SELECT C.custid, C.companyname, O.orderid, O.orderdate, O.empid
FROM Sales.Customers AS C
  CROSS APPLY ( SELECT TOP (3) O.orderid, O.orderdate, O.empid
        FROM Sales.Orders AS O
        WHERE O.custid = C.custid
        ORDER BY O.orderdate DESC, O.orderid DESC ) AS O;


--- Cross APPLY --- 

SELECT C.custid, C.companyname, O.orderid, O.orderdate, O.empid

FROM Sales.Customers AS C

  OUTER APPLY ( SELECT TOP (3) O.orderid, O.orderdate, O.empid

        FROM Sales.Orders AS O

        WHERE O.custid = C.custid

        ORDER BY O.orderdate DESC, O.orderid DESC ) AS O;


/* Create table Valued function to simplfy query 

CREATE FUNCTION Sales.GetTopOrders(@custid AS INT, @n AS BIGINT) RETURNS TABLE

AS

RETURN

  SELECT TOP (@n) O.orderid, O.orderdate, O.empid

  FROM Sales.Orders AS O

  WHERE O.custid = @custid

  ORDER BY O.orderdate DESC, O.orderid DESC;

  --- and then run ---

SELECT C.custid, C.companyname, O.orderid, O.orderdate, O.empid

FROM Sales.Customers AS C

CROSS APPLY Sales.GetTopOrders( C.custid, 3 ) AS O;

GO
*/

---------------------------------------------------------------

SELECT orderyear, ordermonth, COUNT(*) AS numorders

FROM Sales.Orders

  CROSS APPLY ( VALUES( YEAR(orderdate), MONTH(orderdate) ) )

AS A(orderyear, ordermonth)

GROUP BY orderyear, ordermonth;

---------------------------------------------------------------


SELECT orderyear, ordermonth, COUNT(*) AS numorders

FROM Sales.Orders

  CROSS APPLY ( VALUES( YEAR(orderdate), MONTH(orderdate) ) )

AS A1(orderyear, ordermonth)

  CROSS APPLY ( VALUES( DATEFROMPARTS(orderyear, 12, 31) ) )

AS A2(endofyear)

WHERE orderdate <> endofyear

GROUP BY orderyear, ordermonth;

