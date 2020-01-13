SET NOCOUNT ON;
USE TSQLV4;
 SELECT custid
FROM Sales.Orders
GROUP BY custid
HAVING COUNT(DISTINCT empid) = (SELECT COUNT(*) FROM HR.Employees);

--- Inner subquery idependent of outer query

SELECT MAX(orderdate) AS lastdate
FROM Sales.Orders
GROUP BY YEAR(orderdate), MONTH(orderdate);

--- Subquery included with outer query
SELECT orderid, orderdate, custid, empid
FROM Sales.Orders
WHERE orderdate IN
  (SELECT MAX(orderdate)
   FROM Sales.Orders
   GROUP BY YEAR(orderdate), MONTH(orderdate));


-- correlated subquery 

SELECT orderid, orderdate, custid, empid
FROM Sales.Orders
WHERE orderdate IN
  (SELECT MAX(orderdate)
   FROM Sales.Orders
   GROUP BY custid);

SELECT orderid, orderdate, custid, empid
FROM Sales.Orders AS O1
WHERE orderdate IN
  (SELECT MAX(O2.orderdate)
   FROM Sales.Orders AS O2
   WHERE O2.custid = O1.custid
   GROUP BY custid);
 
 -- change to equality operator and remove group by
SELECT orderid, orderdate, custid, empid
FROM Sales.Orders AS O1
WHERE orderdate =
  (SELECT MAX(O2.orderdate)
   FROM Sales.Orders AS O2
   WHERE O2.custid = O1.custid);

   -- Top N per group task.

   SELECT orderid, orderdate, custid, empid
FROM Sales.Orders AS O1
WHERE orderid =
  (SELECT TOP (1) orderid
   FROM Sales.Orders AS O2
   WHERE O2.custid = O1.custid
   ORDER BY orderdate DESC, orderid DESC);



