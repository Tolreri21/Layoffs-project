-- At the beginning of this project, I researched and applied best practices for writing clean, well-structured SQL code.
-- The formatting conventions used are inspired by expert guidance from resources like this video: https://www.youtube.com/watch?v=3OD0_hb1C38

USE portfolio_project;

-- The dataset was imported using the Data Import Wizard. Some columns have issues related to data types and formatting.

SELECT * 
FROM portfolio_project.layoffs;

-- First, let's examine the format of the date values and apply transformation in a SELECT query.

SELECT 
	date,
	str_to_date(date, '%m/%d/%Y') 
FROM layoffs;

-- Next, create a new column to store the transformed date values in proper DATE format.

ALTER TABLE layoffs
ADD COLUMN formated_date date 
AFTER date;

-- Populate the newly added column with formatted date values.

SET SQL_SAFE_UPDATES = 0;

UPDATE layoffs 
SET formated_date = str_to_date(date, '%m/%d/%Y');

-- To identify and remove duplicate rows, an ID column will be added for reference.

ALTER TABLE layoffs 
ADD COLUMN id INT AUTO_INCREMENT PRIMARY KEY;

WITH dupes
AS (SELECT *,
	 ROW_NUMBER() 
	 OVER(PARTITION BY location,company,industry,formated_date,stage,country 
	 ORDER BY id) AS rn 
 FROM Layoffs)
SELECT * FROM dupes WHERE rn>1; -- 11 duplicate rows detected

WITH dupes
AS (SELECT *,
	 ROW_NUMBER() 
	 OVER(PARTITION BY location,company,industry,formated_date,stage,country 
	 ORDER BY id) AS rn 
 FROM Layoffs)
DELETE FROM layoffs 
WHERE id IN (SELECT id 
FROM dupes
WHERE rn > 1);

-- Some values contain unnecessary leading or trailing spaces. These need to be removed.

SELECT 
	company, 
	TRIM(company) 
FROM layoffs ;

-- Clean up the company names by trimming whitespace.

UPDATE layoffs 
SET company = TRIM(company);

-- Inspect distinct industry values to identify inconsistencies.

SELECT 
	DISTINCT industry 
FROM layoffs
ORDER BY 1;

-- Investigate inconsistent entries related to the crypto industry.

SELECT 
	industry 
    FROM layoffs 
    WHERE industry LIKE 'crypto%';

-- Most entries reference 'Crypto'. Standardize all related values accordingly.

SELECT 
industry, 
CASE WHEN industry LIKE '%Crypto%' THEN 'Crypto' END 
FROM layoffs 
WHERE industry LIKE 'crypto%';
 
UPDATE layoffs 
SET industry = CASE
	WHEN industry LIKE '%Crypto%' THEN 'Crypto' 
	ELSE industry 
END;

-- Review distinct values in the country column to identify inconsistencies such as trailing punctuation.

SELECT 
	DISTINCT country 
FROM layoffs;

-- Standardize country names by removing trailing periods.

SELECT 
    DISTINCT country,
    TRIM(TRAILING '.' FROM country) 
FROM layoffs;

UPDATE layoffs
SET country = TRIM(TRAILING '.' FROM country);

-- Identify rows where both 'total_laid_off' and 'percentage_laid_off' are null.

SELECT * 
FROM layoffs 
WHERE total_laid_off IS NULL
AND Percentage_laid_off IS NULL; 

-- These rows lack essential data for analysis, so they will be removed.

DELETE 
FROM layoffs
WHERE total_laid_off IS NULL
AND Percentage_laid_off IS NULL; 

-- Identify missing values in the 'industry' column.

SELECT * 
FROM layoffs 
WHERE industry IS NULL 
OR industry = '';

-- Attempt to populate missing 'industry' values using company name matches from other records.

SELECT 
	l1.company,
	l1.industry,
	l2.industry
FROM layoffs AS l1
JOIN layoffs AS l2 
ON l2.company = l1.company
WHERE (l1.industry IS NULL OR l1.industry = '')
  AND l2.industry IS NOT NULL
  AND l2.industry != '';
  
UPDATE layoffs AS l1
JOIN layoffs AS l2
ON l2.company = l1.company
SET l1.industry = l2.industry
WHERE (l1.industry IS NULL OR l1.industry = '')
	AND l2.industry IS NOT NULL
    AND l2.industry != '';
  
-- Perform a final review of the dataset.

SELECT * FROM Layoffs;

-- The 'id' column was only necessary for duplicate detection and will now be removed.

ALTER TABLE layoffs 
DROP COLUMN ID;

-- Dropping the raw 'date' column after formatting is complete

ALTER TABLE layoffs 
DROP COLUMN date;

-- End of data cleaning part
