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

ALTER TABLE SFSalary..SFSalaries
ALTER COLUMN Id INT 

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

--Removing extra spaces added 
UPDATE SFSalaries
Set EmployeeName = REPLACE(EmployeeName, '  ', ' ')

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

-- Making sure totalpay and totalpaybenefits are equal to the sum of the other pay columns
SELECT *
FROM
	(
	SELECT BasePay, OtherPay, OvertimePay, Benefits, totalpay, totalpaybenefits, ROUND((BasePay+OvertimePay+OtherPay), 2) AS TotalPayCalc, ROUND((BasePay+OvertimePay+OtherPay+Benefits), 2) AS TotalPayBenefitsCalc
	FROM SFSalary..SFSalaries
	) CalculatedPay
WHERE totalpaybenefits != TotalPayBenefitsCalc OR
      totalpay != TotalPayCalc	

-- Updating totalpay and totalpaybenefits to be calculated fields from other pay columns

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

-- Looking at employees with basepay of 0
SELECT *
FROM SFSalary..SFSalaries
WHERE basepay = 0

SELECT *
FROM SFSalary..SFSalaries
WHERE basepay = 0 AND
	"status" = 'ft'
	--Looks like if basepay = 0 then the status must be pt

SELECT *
FROM SFSalary..SFSalaries
WHERE OtherPay = 0
	--Both FT and PT can have otherpay

-- Looking at employees with 0 pay, probably to be removed
SELECT *
FROM SFSalary..SFSalaries
ORDER BY TotalPayBenefits

DELETE FROM SFSalary..SFSalaries 
WHERE BasePay = 0 AND
	  OvertimePay = 0 AND
	  OtherPay = 0 AND
	  Benefits = 0

--Looking at different jobtitles
SELECT DISTINCT jobtitle
FROM SFSalary..SFSalaries

--Standardize job title level eg. manager iv vs manager 4
SELECT DISTINCT SUBSTRING(jobtitle, PATINDEX('%[0-9]%', jobtitle), 1)
FROM SFSalary..SFSalaries
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
FROM SFSalary..SFSalaries

ALTER TABLE SFSalary..SFSalaries
ADD JobTitleClean VARCHAR(255)

UPDATE SfSalary..SFSalaries
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
FROM SFSalary..SFSalaries

-- Filling status for previous years

-- First we will make 2 tables for the avg total salary for each jobtitle for both PT and FT status
--* 
Select Jobtitle, "status", AVG(TotalPayBenefits) AS AvgTotalPayBenefitsJobFT
INTO AvgTotalPayBenefitsJobFT
FROM SFSalary..SFSalaries
WHERE "year" = 2014 AND "status" = 'FT'
GROUP BY jobtitle, "status"

Select Jobtitle, "status", AVG(TotalPayBenefits) AS AvgTotalPayBenefitsJobPT
INTO AvgTotalPayBenefitsJobPT
FROM SFSalary..SFSalaries
WHERE "year" = 2014 AND "status" = 'PT'
GROUP BY jobtitle, "status"


--Creating a new table which includes the avgtotalpay columns with nulls replaced with 0. We are then making a newstatus column which generates PT or FT for the years prior to 2014. 
--Firstly, if the jobtitle exists in 2014 then it will compare the totalpaybenefits for that employee against the average totalpaybenefits for PT and FT. It will assign a value of PT or FT depending on which average it is closer to. 
--Next, if the jobtitle does not exist in 2014, it will do the same by comparing average totalpaybenefits for all jobtitles for FT and PT
Select *,
CASE
	WHEN "status" = 'PT' OR "status" = 'FT' THEN "status" 
	WHEN ABS(TotalPayBenefits - AvgTotalPayBenefitsJobPT) > ABS(TotalPayBenefits - AvgTotalPayBenefitsJobFT) AND AvgTotalPayBenefitsJobFT != 0 THEN 'FT'
	WHEN AvgTotalPayBenefitsJobFT = 0 AND AvgTotalPayBenefitsJobPT = 0 AND ABS((Select AVG(TotalPayBenefits) FROM SFSalaries WHERE "status" = 'FT') - TotalPayBenefits) < ABS((Select AVG(TotalPayBenefits) FROM SFSalaries WHERE "status" = 'PT') - totalpaybenefits) THEN 'FT'
	ELSE 'PT'
END AS PopulatedStatus
INTO SFSalaryFilled
FROM
(
SELECT a.*, ISNULL(AvgTotalPayBenefitsJobFT, 0) AS AvgTotalPayBenefitsJobFT, ISNULL(AvgTotalPayBenefitsJobPT, 0) AS AvgTotalPayBenefitsJobPT 
FROM SFSalary..SFSalaries a
LEFT JOIN AvgTotalPayBenefitsJobFT c ON c.jobtitle = a.jobtitle 
LEFT JOIN AvgTotalPayBenefitsJobPT d ON d.jobtitle = a.jobtitle
) AppendedColumns


--Setting status value equal to populatedstatus and jobtitle = jobtitleclean
UPDATE sfsalaryfilled
SET "status" = populatedstatus

UPDATE sfsalaryfilled
SET Jobtitle = JobTitleClean

--Dropping AvgTotalPayBenefitsJobPT, AvgTotalPayBenefitsJobFT, populated status and jobtitleclean
ALTER TABLE SFSalaryFilled
DROP COLUMN PopulatedStatus

ALTER TABLE SFSalaryFilled
DROP COLUMN AvgTotalPayBenefitsJobFT

ALTER TABLE SFSalaryFilled
DROP COLUMN AvgTotalPayBenefitsJobPT

ALTER TABLE SFSalaryFilled
DROP COLUMN jobtitleclean

Select *
FROM SFsalary..SFSalaryFilled



Select *
Into SFSalaryQueries
FROM SFSalaryFilled