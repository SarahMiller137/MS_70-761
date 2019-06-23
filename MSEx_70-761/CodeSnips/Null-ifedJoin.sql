---------------------------------------------------------------
--- Dealing with a Null-ifed joins --- 
---------------------------------------------------------------

/*The left and inner join in Q1 have a nullifying effect */

SELECT C.custid, C.country, O.orderid, OD.productid, OD.qty, OD.unitprice

FROM Sales.Customers AS C

  LEFT OUTER JOIN Sales.Orders AS O

ON C.custid = O.custid

  INNER JOIN Sales.OrderDetails AS OD

ON O.orderid = OD.orderid;


---------------------------------------------------------------
/* To resolve this issue the query can be structured as follows or 
the inner join can be changed to another subsequant left*/
---------------------------------------------------------------

SELECT C.custid, C.country, O.orderid, OD.productid, OD.qty, OD.unitprice

FROM Sales.Customers AS C 

  LEFT OUTER JOIN

  ( Sales.Orders AS O

      INNER JOIN Sales.OrderDetails AS OD

    ON O.orderid = OD.orderid

    AND O.orderdate >= '20160101' )

ON C.custid = O.custid;

/*The above query uses this inner join in its subquery */

SELECT  O.orderid, OD.productid, OD.qty, OD.unitprice

FROM  Sales.Orders AS O

      INNER JOIN Sales.OrderDetails AS OD

    ON O.orderid = OD.orderid

    AND O.orderdate >= '20160101'

	