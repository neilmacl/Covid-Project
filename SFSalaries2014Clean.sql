--SQL SKILLS: Copying tables, Updating tables, Changing datatypes, Nested queries, Case statements

SELECT * 
FROM SFSalary..SFSalaries
ORDER BY Benefits DESC

-- deleting rows where all values are 'Not Provided'
DELETE FROM SFSalaries
WHERE Benefits = 'Not Provided'


-- Updating columns to proper data type
ALTER TABLE SFSalaries
ALTER COLUMN Benefits FLOAT 

ALTER TABLE SFSalaries
ALTER COLUMN BasePay FLOAT

ALTER TABLE SFSalaries
ALTER COLUMN OvertimePay FLOAT 

ALTER TABLE SFSalaries
ALTER COLUMN TotalPay FLOAT

ALTER TABLE SFSalaries
ALTER COLUMN OtherPay FLOAT

ALTER TABLE SFSalaries
ALTER COLUMN TotalPayBenefits FLOAT 

ALTER TABLE SFSalaries
ALTER COLUMN "Year" SMALLINT

-- Standardizing text strings
UPDATE SFSalaries
SET Jobtitle = LOWER(JobTitle)

UPDATE SFSalaries
SET EmployeeName = LOWER(EmployeeName)

-- removing periods
UPDATE SFSalaries
Set EmployeeName = REPLACE(EmployeeName, '.', ' ')

 -- Shows that the ID column is just an index and is not an employee ID number
SELECT *
FROM SFSalary..SFSalaries
ORDER BY EmployeeName

-- Removing any trailing or leading spaces from strings
UPDATE SFSalaries
SET EmployeeName = TRIM(EmployeeName)

UPDATE SFSalaries
SET JobTitle = TRIM(JobTitle)

--Checking negative pay values
SELECT *
FROM SFSalary..SFSalaries
WHERE BasePay < 0 OR
      OtherPay < 0 OR
	  Benefits < 0 OR
	  OvertimePay < 0 OR
	  TotalPay < 0 OR
	  TotalPayBenefits < 0

-- Referred to data to see if neagtive values were cases in which employees were owing money. No information found, therefore assuming negative values are keying errors. 
SELECT ABS(BasePay), ABS(OvertimePay), ABS(OtherPay), ABS(Benefits)
FROM SFSalary..SFSalaries
WHERE BasePay < 0 OR
      OtherPay < 0 OR
	  Benefits < 0 OR
	  OvertimePay < 0 OR
	  TotalPay < 0 OR
	  TotalPayBenefits < 0

UPDATE SFSalaries
SET BasePay = ABS(BasePay)

UPDATE SFSalaries
SET OvertimePay = ABS(OvertimePay)

UPDATE SFSalaries
SET OtherPay = ABS(OtherPay)

UPDATE SFSalaries
SET Benefits = ABS(Benefits)

-- Updating totalpay and totalpaybenefits to be calculated fields from other pay columns
SELECT *
FROM
	(
	SELECT BasePay, OtherPay, OvertimePay, Benefits, totalpay, totalpaybenefits, ROUND((BasePay+OvertimePay+OtherPay), 2) AS TotalPayCalc, ROUND((BasePay+OvertimePay+OtherPay+Benefits), 2) AS TotalPayBenefitsCalc
	FROM SFSalary..SFSalaries
	) CalculatedPay
WHERE totalpaybenefits != TotalPayBenefitsCalc OR
      totalpay != TotalPayCalc	

UPDATE SFSalaries
SET TotalPayBenefits = ROUND((BasePay+OvertimePay+OtherPay+Benefits), 2)

UPDATE SFSalaries
SET TotalPay = ROUND((BasePay+OvertimePay+OtherPay), 2)

SELECT *
FROM SFSalary..SFSalaries
WHERE BasePay < 0 OR
      OtherPay < 0 OR
	  Benefits < 0 OR
	  OvertimePay < 0 OR
	  TotalPay < 0 OR
	  TotalPayBenefits < 0

--Checking status of employees
SELECT "status", COUNT("status"), AVG("year")
FROM SFSalary..SFSalaries
GROUP BY "status"
ORDER BY "status"

SELECT DISTINCT "status", "year"
FROM SFSalary..SFSalaries
	--Looks like status was only used in 2014


--Making a table to only look at data from 2014
SELECT *
INTO SFSalaries2014
FROM SFSalary..SFSalaries
WHERE "year" = 2014


-- Looking at employees with basepay of 0
SELECT *
FROM SFSalary..SFSalaries2014
WHERE basepay = 0

SELECT *
FROM SFSalary..SFSalaries2014
WHERE basepay = 0 AND
	"status" = 'ft'
	--Looks like if basepay = 0 then the status must be pt

SELECT *
FROM SFSalary..SFSalaries2014
WHERE OtherPay = 0
	--Both FT and PT can have otherpay

-- Looking at employees with 0 pay, probably to be removed
SELECT *
FROM SFSalary..SFSalaries2014
ORDER BY TotalPayBenefits

--Looking at different jobtitles
SELECT DISTINCT jobtitle
FROM SFSalary..SFSalaries2014

--Standardize job title level eg. manager iv vs lieutenant 3
SELECT DISTINCT SUBSTRING(jobtitle, PATINDEX('%[0-9]%', jobtitle), 1)
FROM SFSalary..SFSalaries2014
WHERE jobtitle like '%[0-9]%'
	-- shows which numbers need to be replaced in jobtitles


Select *, 
	CASE	
		WHEN jobtitle like '%6%' THEN REPLACE(jobtitle, '6', 'vi')
		WHEN jobtitle like '%5%' THEN REPLACE(jobtitle, '5', 'v')
		WHEN jobtitle like '%4%' THEN REPLACE(jobtitle, '4', 'iv')
		WHEN jobtitle like '%3%' THEN REPLACE(jobtitle, '3', 'iii')
		WHEN jobtitle like '%2%' THEN REPLACE(jobtitle, '2', 'ii')
		WHEN jobtitle like '%1%' THEN REPLACE(jobtitle, '1', 'i')
		ELSE Jobtitle
	END AS JobTitleClean
FROM SFSalary..SFSalaries2014

ALTER TABLE SFSalaries2014
ADD JobTitleClean VARCHAR(255)

UPDATE SFSalaries2014
SET JobTitleClean = 
	CASE	
		WHEN jobtitle like '%6%' THEN REPLACE(jobtitle, '6', 'vi')
		WHEN jobtitle like '%5%' THEN REPLACE(jobtitle, '5', 'v')
		WHEN jobtitle like '%4%' THEN REPLACE(jobtitle, '4', 'iv')
		WHEN jobtitle like '%3%' THEN REPLACE(jobtitle, '3', 'iii')
		WHEN jobtitle like '%2%' THEN REPLACE(jobtitle, '2', 'ii')
		WHEN jobtitle like '%1%' THEN REPLACE(jobtitle, '1', 'i')
		ELSE Jobtitle
	END
FROM SFSalary..SFSalaries2014

--Dropping employees who were not paid in 2014
SELECT *
INTO SFSalaries2014Clean
FROM SFSalaries2014
WHERE Basepay = 0 AND
	  OverTimePay = 0 AND
	  Benefits = 0 AND
	  OtherPay = 0







