---------------------------------------------------------------
--- Pivot using AdventureWorks2014 ---
---------------------------------------------------------------

--USE [AdventureWorks2014];  

SELECT DaysToManufacture, AVG(StandardCost) AS AverageCost   
FROM Production.Product  
GROUP BY DaysToManufacture; 

-- Pivot table with one row and five columns  
SELECT 'AverageCost' AS Cost_Sorted_By_Production_Days,   
[0], [1], [2], [3], [4]  
FROM  
(SELECT DaysToManufacture, StandardCost   
    FROM Production.Product) AS SourceTable  
PIVOT  
(  
AVG(StandardCost)  
FOR DaysToManufacture IN ([0], [1], [2], [3], [4]));


---------------------------------------------------------------
--- Pivot operator example ---
--------------------------------------------------------------

/*

Create table with code snip below first for below queries to run 



IF OBJECT_ID(N'Sales.MyOrders', N'V') IS NOT NULL DROP VIEW Sales.MyOrders;

-- In SQL Server 2016 use: DROP VIEW IF EXISTS Sales.MyOrders;

GO


CREATE VIEW Sales.MyOrders

AS


SELECT orderid, empid, YEAR(orderdate) AS orderyear, val, qty

FROM Sales.OrderValues

WHERE custid = 5;

GO


*/

---------------------------------------------------------------
-- Pivot operator with cte as input
---------------------------------------------------------------

--USE TSQLV4;

;WITH C AS

(

  SELECT empid, orderyear, val

  FROM Sales.MyOrders

) 

SELECT *

FROM C

  PIVOT( SUM(val)

FOR orderyear IN ([2014], [2015], [2016]) ) AS P;



---------------------------------------------------------------
--- Explicit grouped query method for pivot ---
---------------------------------------------------------------

SELECT empid,

  SUM(CASE WHEN orderyear = 2014 THEN val END) AS [2014],

  SUM(CASE WHEN orderyear = 2015 THEN val END) AS [2015],

  SUM(CASE WHEN orderyear = 2016 THEN val END) AS [2016]

FROM Sales.MyOrders

GROUP BY empid;



---------------------------------------------------------------
--- Dynamic method of pivot ---
---------------------------------------------------------------

 DECLARE @cols AS NVARCHAR(1000),

  @sql  AS NVARCHAR(4000);


SET @cols = STUFF(

(SELECT N',' + QUOTENAME(orderyear) AS [text()]

 FROM Sales.MyOrders

 GROUP BY orderyear

 ORDER BY orderyear

 FOR XML PATH(''), TYPE).value('.[1]', 'NVARCHAR(MAX)'), 1, 1, '');


SET @sql = N'WITH C AS

(

  SELECT empid, orderyear, val

  FROM Sales.MyOrders

) 

SELECT *

FROM C

  PIVOT( SUM(val)

FOR orderyear IN (' + @cols + N') ) AS P;';


EXEC sys.sp_executesql @stmt = @sql;