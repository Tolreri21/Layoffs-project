-- EDA PROJECT: Layoffs Dataset

-- View the entire dataset (raw look at all records)
SELECT * FROM portfolio_project.layoffs;

-- Total layoffs across all companies and years
SELECT SUM(total_laid_off) FROM layoffs;

-- Get max number of layoffs and max percentage laid off in the dataset
SELECT 
	MAX(total_laid_off),
	MAX(percentage_laid_off) 
FROM layoffs;

-- Find all companies where 100% of employees were laid off
SELECT * 
FROM layoffs
WHERE percentage_laid_off = 1;

-- Same as above, but sorted by highest funds raised (who had the most funding but still laid off everyone)
SELECT * 
FROM layoffs
WHERE percentage_laid_off = 1 
ORDER BY funds_raised_millions DESC;

-- Total layoffs per company (identify biggest contributors to layoffs)
SELECT 
	company,
	SUM(total_Laid_off) 
FROM layoffs
GROUP BY company 
ORDER BY 2 DESC;

-- Find earliest and latest layoff dates in the dataset
SELECT 
	MIN(formated_date),
	MAX(Formated_date)
FROM layoffs;

-- Total layoffs by industry (find the most affected industries)
SELECT 
	industry,
	SUM(total_laid_off)
FROM layoffs
GROUP BY industry
ORDER BY 2 DESC; 

-- Total layoffs by country (most affected countries)
SELECT 
	country,
	SUM(total_laid_off)
FROM layoffs
GROUP BY country
ORDER BY 2 DESC; 
-- The United States has the highest total layoffs: 256,365 people.
-- India follows with 35,993 layoffs, a distant second.

-- Total layoffs by year (yearly trend)
SELECT 
	YEAR(formated_date),
	SUM(total_laid_off)
FROM layoffs
WHERE YEAR(formated_date) IS NOT NULL
GROUP BY YEAR(formated_date);

-- Monthly layoff totals (more detailed trend view)
SELECT 
	YEAR(formated_date) AS year,
    MONTH(formated_date) AS month,
	SUM(total_laid_off) 
FROM layoffs
WHERE formated_date IS NOT NULL
GROUP BY year, month
ORDER BY 1 ASC;

-- January 2023 had the highest number of layoffs overall, with 84,714 people laid off.
-- This shows a major peak in layoffs, possibly due to post-pandemic economic corrections or tech industry shifts.

-- Monthly rolling sum of layoffs (cumulative trend over time)
WITH rolling_sum AS (
  SELECT 
    YEAR(formated_date) AS year,
    MONTH(formated_date) AS month,
    SUM(total_laid_off) AS tlo
  FROM layoffs
  WHERE formated_date IS NOT NULL
  GROUP BY year, month
  ORDER BY 1 ASC
)
SELECT 
  year,
  month,
  tlo AS total_laid_off, 
  SUM(tlo) OVER(ORDER BY year, month) AS rolling_total 
FROM rolling_sum;

-- Yearly layoffs per company, sorted by highest layoffs
SELECT 
	company,
	YEAR(formated_date),
	SUM(total_laid_off)
FROM layoffs 
GROUP BY company, YEAR(formated_date)
ORDER BY 3 DESC;

-- Top 5 companies with most layoffs for each year
WITH company_layoffs AS (
  SELECT 
    company,
    YEAR(formated_date) AS year,
    SUM(total_laid_off) AS total_laid_off
  FROM layoffs
  WHERE formated_date IS NOT NULL
  GROUP BY company, YEAR(formated_date)
),
ranked_companies AS (
  SELECT 
    company,
    year,
    total_laid_off,
    DENSE_RANK() OVER (
      PARTITION BY year 
      ORDER BY total_laid_off DESC
    ) AS ranking
  FROM company_layoffs
)
SELECT * 
FROM ranked_companies
WHERE ranking <= 5
ORDER BY year, ranking;

-- Compare total layoffs per year with previous year (to see year-to-year change)
WITH year_layoffs AS (
  SELECT 
    YEAR(formated_date) AS year,
    SUM(total_laid_off) AS tlo
  FROM layoffs
  WHERE formated_date IS NOT NULL
  GROUP BY YEAR(formated_date)
)
SELECT 
	year,
	tlo,
	LAG(tlo) OVER (ORDER BY year) AS prev_year_laid_off
FROM year_layoffs;

-- Calculate average layoffs per company per year
WITH year_company_number_total AS (
  SELECT 		
    YEAR(formated_date) AS year,
    COUNT(DISTINCT company) AS num_comp,
    SUM(total_laid_off) AS total 
  FROM layoffs 
  WHERE YEAR(formated_date) IS NOT NULL
  GROUP BY year
)
-- Example: In 2022, 900 companies laid off employees; in 2021, only 34 did
SELECT
  year,
  (total * 1.0 / num_comp) AS average_layoff
FROM year_company_number_total;

-- Finding that 2022 had most company layoffs in total, but 2021 had a higher average per company
-- 2022 had the highest number of companies reporting layoffs (900 companies),
-- but the average number of layoffs per company that year was one of the lowest — second from the bottom.
