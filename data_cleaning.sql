USE health_care;
SELECT * FROM healthcare_dataset;

-- Step 1: Create a duplicate table with the same structure as the original dataset

CREATE TABLE healthcare
LIKE healthcare_dataset;

SELECT * FROM healthcare;

INSERT healthcare
SELECT * FROM healthcare_dataset;

-- DATA CLEANING--
-- 1. REMOVE DUPLICATES

-- find duplicates
WITH duplicate_data AS
 (
	SELECT *,
    ROW_NUMBER() OVER(
    PARTITION BY `Name`, Age, Gender, `Blood Type`, `Medical Condition`, `Date of Admission`, Doctor, Hospital, `Insurance Provider`,
    `Billing Amount`, `Room Number`, `Admission Type`, `Discharge Date`, Medication, `Test Results` ) AS row_nmb
    FROM healthcare
    )
SELECT * FROM duplicate_data 
WHERE row_nmb > 1;

SELECT * FROM health_care.healthcare
WHERE Age = 41;




-- create another table to remove duplicates

CREATE TABLE `healthcare2` (
  `Name` text,
  `Age` int DEFAULT NULL,
  `Gender` text,
  `Blood Type` text,
  `Medical Condition` text,
  `Date of Admission` text,
  `Doctor` text,
  `Hospital` text,
  `Insurance Provider` text,
  `Billing Amount` double DEFAULT NULL,
  `Room Number` int DEFAULT NULL,
  `Admission Type` text,
  `Discharge Date` text,
  `Medication` text,
  `Test Results` text,
  `row_nmb` INT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

SELECT * FROM healthcare2;


INSERT INTO healthcare2
SELECT *,
    ROW_NUMBER() OVER(
    PARTITION BY `Name`, Age, Gender, `Blood Type`, `Medical Condition`, `Date of Admission`, Doctor, Hospital, `Insurance Provider`,
    `Billing Amount`, `Room Number`, `Admission Type`, `Discharge Date`, Medication, `Test Results` ) AS row_nmb
    FROM healthcare;
    
    
-- Now we delete the duplicate rows

SELECT * FROM healthcare2
WHERE row_nmb > 1;

SET SQL_SAFE_UPDATES = 0;
DELETE 
FROM healthcare2 
WHERE row_nmb > 1;
SET SQL_SAFE_UPDATES = 1;


SELECT * FROM healthcare2;
    
    
-- 2. STANDARDIZE THE DATA

SELECT * FROM healthcare2;

-- Convert Name column to uppercase
SELECT DISTINCT(`Name`) FROM healthcare2;

SELECT UPPER(`Name`) FROM healthcare2;

UPDATE healthcare2
SET `Name` = UPPER(`Name`);

-- About 10%+ of Hospital values are incomplete or inconsistently formatted 
-- due to a source data issue (not something introduced during cleaning). 
-- These couldn't be reliably auto-fixed since some 'and'/comma patterns 
-- are valid names and others are truncation. Hospital-level results should be interpreted with this in mind.

SELECT * FROM healthcare2;

SELECT DISTINCT(Hospital) FROM healthcare2
ORDER BY 1;

SELECT Hospital FROM healthcare2 
WHERE Hospital LIKE 'and %';

SELECT COUNT(*) FROM healthcare2 
WHERE Hospital LIKE 'and %';

SELECT COUNT(*) FROM healthcare2;

SELECT DISTINCT Hospital
 FROM healthcare2 
WHERE Hospital NOT LIKE 'and %';

-- Convert 'Date of Admission' from text to DATE format
SELECT * FROM healthcare2;

SELECT `Date of Admission`,
STR_TO_DATE(`Date of Admission`, '%Y-%m-%d') AS new_date
 FROM healthcare2;
 
 UPDATE healthcare2
SET `Date of Admission` = STR_TO_DATE(`Date of Admission`, '%Y-%m-%d');


ALTER TABLE healthcare2
MODIFY COLUMN `Date of Admission` DATE;


-- Convert 'Discharge Date' from text to DATE format
SELECT * FROM healthcare2;

SELECT `Discharge Date`,
STR_TO_DATE(`Discharge Date`, '%Y-%m-%d') AS new_discharge_date
 FROM healthcare2;
 
 UPDATE healthcare2
SET `Discharge Date` = STR_TO_DATE(`Discharge Date`, '%Y-%m-%d');

ALTER TABLE healthcare2
MODIFY COLUMN `Discharge Date` DATE;


-- 3. NULL VALUES OR BLANK VALUES

-- checked all columns for NULL/blank values, none found

SELECT * FROM healthcare2;

SELECT *
FROM healthcare2 
WHERE `Date of Admission` IS NULL OR `Date of Admission` = ''; 


-- 4. REMOVE ANY COLUMNS

-- No fully empty column found to drop
 

SELECT * FROM healthcare2;

ALTER TABLE healthcare2
DROP COLUMN row_nmb;


