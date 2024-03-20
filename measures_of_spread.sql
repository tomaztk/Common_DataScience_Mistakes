/*
Demo #1 SQLBits 2020
Tomaz Kastrun
*/



-- Simple Statistics - measure of spread and correlation
USE AdventureWorksDW2014;
GO


SELECT * FROM dbo.vTargetMail

--- Calculating simple pearson correlation
WITH 
	Corr AS (
				SELECT 
					 1.0*NumberCarsOwned as val1
					,AVG(1.0*NumberCarsOwned) OVER () AS mean1
					,1.0*YearlyIncome AS val2
					,AVG(1.0*YearlyIncome) OVER() AS mean2
				FROM dbo.vTargetMail
) 
SELECT
    (SUM((val1-mean1)*(val2-mean2)) / COUNT(*)) / (STDEVP(val1) * STDEVP(val2)) AS Correlation_between_YearlyIncome_Cars
FROM Corr; 
GO


--- chi-square
-- By Dejan Sarka
WITH
ObservedCombination_CTE AS (
SELECT EnglishOccupation AS OnRows, Gender AS OnCols,
COUNT(*) AS ObservedCombination FROM dbo.vTargetMail
GROUP BY EnglishOccupation, Gender
),
 
ExpectedCombination_CTE AS (
SELECT OnRows, OnCols, ObservedCombination
,SUM(ObservedCombination) OVER (PARTITION BY OnRows) AS ObservedOnRows
,SUM(ObservedCombination) OVER (PARTITION BY OnCols) AS ObservedOnCols
,SUM(ObservedCombination) OVER () AS ObservedTotal
,CAST(ROUND(SUM(1.0 * ObservedCombination) OVER (PARTITION BY OnRows) * SUM(1.0 * ObservedCombination) OVER (PARTITION BY OnCols) / SUM(1.0 * ObservedCombination) OVER (), 0) AS INT) AS ExpectedCombination
FROM ObservedCombination_CTE
)
SELECT 
	SUM(SQUARE(ObservedCombination - ExpectedCombination) / ExpectedCombination) AS ChiSquared,
	(COUNT(DISTINCT OnRows) - 1) * (COUNT(DISTINCT OnCols) - 1) AS DegreesOfFreedom
FROM ExpectedCombination_CTE



-- covariate / regression
-- By Dejan Sarka
WITH CoVarCTE AS (
SELECT 
	1.0*NumberCarsOwned as val1
	,AVG(1.0*NumberCarsOwned) OVER () AS mean1
	,1.0*YearlyIncome AS val2
	,AVG(1.0*YearlyIncome) OVER() AS mean2
FROM dbo.vTargetMail
)
SELECT 
	Slope1= SUM((val1 - mean1) * (val2 - mean2)) /SUM(SQUARE((val1 - mean1))),
	Intercept1= MIN(mean2) - MIN(mean1) * (SUM((val1 - mean1)*(val2 - mean2)) /SUM(SQUARE((val1 - mean1)))),
	Slope2= SUM((val1 - mean1) * (val2 - mean2)) /SUM(SQUARE((val2 - mean2))),
	Intercept2= MIN(mean1) - MIN(mean2) * (SUM((val1 - mean1)*(val2 - mean2)) /SUM(SQUARE((val2 - mean2)))) FROM CoVarCTE;




--- We can always compare or use the R/Python with: Example with Median

/*
SQLBits 2024
Author: Tomaz Kastrun

Description: Comparing database compatibility level 140 and 150 with Window function
envoking window aggregate operator in SQL Server Execution Plans.
Calculating Median.

*/

USE AdventureWorksDW2014;
GO

DROP TABLE IF EXISTS  t1;
GO

CREATE TABLE t1
(id INT IDENTITY(1,1) NOT NULL
,c1 INT
,c2 SMALLINT
,t VARCHAR(10) 
)

SET NOCOUNT ON;

INSERT INTO t1 (c1,c2,t)
SELECT 
	x.* FROM
(
	SELECT 
	ABS(CAST(NEWID() AS BINARY(6)) %1000) AS c1
	,ABS(CAST(NEWID() AS BINARY(6)) %1000) AS c2
	,'text' AS t
) AS x
	CROSS JOIN (SELECT number FROM master..spt_values) AS n
	CROSS JOIN (SELECT number FROM master..spt_values) AS n2
GO 2
-- duration 00:00:27
-- rows: 13.025.408          

SELECT TOP 10 * FROM t1


/*  results tests */

-- Itzik Solution
SELECT
(
 (SELECT MAX(c1) FROM
   (SELECT TOP 50 PERCENT c1 FROM t1 ORDER BY c1) AS BottomHalf)
 +
 (SELECT MIN(c1) FROM
   (SELECT TOP 50 PERCENT c1 FROM t1 ORDER BY c1 DESC) AS TopHalf)
) / 2 AS Median

-- Median: 500
-- Duration #1 00:00:58
-- Duration #2 00:01:02

/*

-- changing compatibility mode:
SELECT name, compatibility_level   
FROM sys.databases   
WHERE name = db_name();  
-- SQLRPY	120


SELECT DISTINCT
   PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY c1) OVER (PARTITION BY (SELECT 1)) AS MedianCont150
 FROM t1
-- median: 500
-- Duration #1: 00:00:01
-- Duration #2: 00:00:01


ALTER DATABASE AdventureWorksDW2014  
SET COMPATIBILITY_LEVEL = 140;  
GO  


SELECT DISTINCT
   PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY c1) OVER (PARTITION BY (SELECT 1)) AS MedianCont140
 FROM t1

-- Median: 500
-- Duration 00:01:16



ALTER DATABASE AdventureWorksDW2014  
SET COMPATIBILITY_LEVEL = 150;  
GO  

SELECT DISTINCT
   PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY c1) OVER (PARTITION BY (SELECT 1)) AS MedianCont140
 FROM t1

-- Median: 500
-- Duration 00:00:02
*/

/*
Setting back to 120
ALTER DATABASE AdventureWorksDW2014  
SET COMPATIBILITY_LEVEL = 120;  
GO

*/


EXECUTE sp_Execute_External_Script
	 @language = N'R'
	,@script = N'd <- InputDataSet
					  OutputDataSet <- data.frame(median(d$c1))'
	,@input_data_1 = N'select c1 from t1'

WITH RESULT SETS
(( Median_R VARCHAR(100) ));
GO
--- median: 500
-- Duration #1 00:00:05
-- Duration #2 00:00:06
-- Duration #3 00:00:03



EXECUTE sp_Execute_External_Script
	 @language = N'Python'
	,@script = N'
import pandas as pd
dd = pd.DataFrame(data=InputDataSet)
os2 = dd.median()[0]
OutputDataSet = pd.DataFrame({''a'':os2}, index=[0])'
	,@input_data_1 = N'select c1 from t1'
WITH RESULT SETS
(( Median_Python VARCHAR(100) ));
GO
-- Median: 500
-- Duration #1 00:00:03
-- Duration #2 00:00:04

