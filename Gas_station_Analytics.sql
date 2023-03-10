
--Gas Station data Analytics--

ALTER TABLE [dbo].[Gas Station Fills]
ALTER COLUMN [Fill ID] NVARCHAR(50) NOT NULL;

ALTER TABLE [dbo].[Vehicles]
ALTER COLUMN [Vehicle ID] NVARCHAR(50) NOT NULL;

ALTER TABLE [dbo].[Gas Station Fills]
ALTER COLUMN [Vehicle ID] NVARCHAR(50) NOT NULL

ALTER TABLE[dbo].[Gas Station Fills]
ADD PRIMARY KEY ([Fill ID]);

ALTER TABLE [dbo].[Vehicles]
ADD PRIMARY KEY ([Vehicle ID]);

ALTER TABLE [dbo].[Gas Station Fills]
ADD FOREIGN KEY ([Vehicle ID])
REFERENCES [dbo].[Vehicles]([Vehicle ID])

select * from [Gas Station Fills]

SELECT A.[Fill ID]
,A.[Vehicle ID]
,B.[Vehicle Name]
,B.[Vehicle Type]
,B.[Vehicle Cost (£)]
,A.[Fuel Type]
,A.[Cost of Fill (£)]
,A.[Customer Membership]
INTO [Gas Station - Master]
FROM [dbo].[Gas Station Fills] AS A
LEFT JOIN [dbo].[Vehicles] AS B
ON a.[Vehicle ID] = b.[Vehicle ID]

SELECT * FROM [Gas Station - Master]
/*
The gas fill transactions for the cost and count of the
transactions can be reported based on the different vehicles
An aggregation is carried out to obtain the results. Note the data
conversion which has taken place before the calculation is
carried out*/

SELECT [Vehicle ID]
,[Vehicle Name]
,SUM( CAST([Cost of Fill (£)] AS INT) ) AS [Total Cost]
,COUNT(*) AS [Total Count]
FROM [dbo].[Gas Station - Master]
GROUP BY [Vehicle ID]
,[Vehicle Name]
ORDER BY SUM( CAST([Cost of Fill (£)] AS INT) ) DESC


--The transactions for the gas fills have been split out between customers who have a membership and customers that do not.

SELECT [Customer Membership]
,COUNT(*) AS [Customer Membership - Count]
FROM [dbo].[Gas Station - Master]
GROUP BY [Customer Membership]

--The type of fuel and the gas fill transactions associated to it are reported. Note the data conversion that has taken place.

SELECT [Fuel Type]
,SUM( CAST([Cost of Fill (£)] AS INT) ) AS [Total Fill Cost]
,COUNT(*) AS [Fill Count]
,AVG( CAST([Cost of Fill (£)] AS INT) ) AS [Average Fill Cost]
FROM [dbo].[Gas Station - Master]
GROUP BY [Fuel Type]

-- CTEs are used to show the ratio between the cost of the type of vehicle and the total amount for the fill transactions for that vehicle type.

WITH [CTE - Vehicle Type and Fill Ratio]
AS
(SELECT [Vehicle Type]
,SUM( CAST([Vehicle Cost (£)] AS INT) ) AS [Total Cost of Vehicle]
,SUM( CAST([Cost of Fill (£)] AS INT) ) AS [Total Cost of Fill]
FROM [dbo].[Gas Station - Master]
GROUP BY [Vehicle Type])
SELECT [Vehicle Type]
,[Total Cost of Vehicle]
,[Total Cost of Fill]
,[Total Cost of Vehicle]/[Total Cost of Fill] AS [Vehicle Type and Fill Ratio]
FROM [CTE - Vehicle Type and Fill Ratio]

-- CTEs are used to show the ratio between the cost of the vehicles and the total amount for the fill transactions for that vehicle type.

WITH [CTE - Vehicle and Fill Ratio]
AS
(SELECT [Vehicle ID]
,[Vehicle Name]
,[Vehicle Type]
,SUM( CAST([Vehicle Cost (£)] AS INT) ) AS [Total Cost of Vehicle]
,SUM( CAST([Cost of Fill (£)] AS INT) ) AS [Total Cost of Fill]
FROM [dbo].[Gas Station - Master]
GROUP BY [Vehicle ID]
,[Vehicle Name]
,[Vehicle Type])
SELECT [Vehicle ID]
,[Vehicle Name]
,[Vehicle Type]
,[Total Cost of Vehicle]
,[Total Cost of Fill]
,[Total Cost of Vehicle]/[Total Cost of Fill] AS [Vehicle and Fill Ratio]
FROM [CTE - Vehicle and Fill Ratio]

