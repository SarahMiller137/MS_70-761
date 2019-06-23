USE [TSQLV4];
---------------------------------------------------------------
--- create pivoted table for query example ---
---------------------------------------------------------------

IF OBJECT_ID(N'Sales.MyPivotedOrders', N'U') IS NOT NULL 

DROP TABLE IF EXISTS Sales.MyPivotedOrders;
GO

WITH C AS
(
  SELECT empid, YEAR(orderdate) AS orderyear, val
  FROM Sales.OrderValues
  WHERE custid = 5
)  
SELECT *
INTO Sales.MyPivotedOrders
FROM C
  PIVOT( SUM(val)
    FOR orderyear IN ([2014], [2015], [2016]) ) AS P;

ALTER TABLE Sales.MyPivotedOrders
  ADD CONSTRAINT PK_MyPivotedOrders PRIMARY KEY(empid);

SELECT *
FROM Sales.MyPivotedOrders;


---------------------------------------------------------------
--- Alternative to the unpivot is to us the Cross Apply operator ---
---------------------------------------------------------------

SELECT empid, orderyear, val
FROM Sales.MyPivotedOrders
  CROSS APPLY ( VALUES(2014, [2014]),
          (2015, [2015]),
          (2016, [2016]) ) AS A(orderyear, val)
WHERE val IS NOT NULL;

---------------------------------------------------------------
/* Creates a second table to demo the cross apply solution of 
unpivoting with multiple columns/rows */
---------------------------------------------------------------

IF OBJECT_ID(N'Sales.MyPivotedOrders2', N'U') IS NOT NULL

DROP TABLE IF EXISTS Sales.MyPivotedOrders2;

GO

SELECT empid,

  SUM(CASE WHEN orderyear = 2014 THEN val END) AS val2014,

  SUM(CASE WHEN orderyear = 2015 THEN val END) AS val2015,

  SUM(CASE WHEN orderyear = 2016 THEN val END) AS val2016,

  SUM(CASE WHEN orderyear = 2014 THEN qty END) AS qty2014,

  SUM(CASE WHEN orderyear = 2015 THEN qty END) AS qty2015,

  SUM(CASE WHEN orderyear = 2016 THEN qty END) AS qty2016

INTO Sales.MyPivotedOrders2

FROM Sales.OrderValues

  CROSS APPLY ( VALUES(YEAR(orderdate)) ) AS A(orderyear)

WHERE custid = 5

GROUP BY empid;


ALTER TABLE Sales.MyPivotedOrders2

  ADD CONSTRAINT PK_MyPivotedOrders2 PRIMARY KEY(empid);

  SELECT * FROM Sales.MyPivotedOrders2


