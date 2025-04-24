-- View: Total layoffs across all companies and years
CREATE VIEW total AS
SELECT SUM(total_laid_off) FROM layoffs;

-- View: Total layoffs by industry (Top 5 most affected industries)
CREATE VIEW industry_layoffs AS
SELECT 
    industry,
    SUM(total_laid_off)
FROM layoffs
GROUP BY industry
ORDER BY 2 DESC
LIMIT 5;

-- View: Total layoffs by country
CREATE VIEW total_per_country AS
SELECT 
    country,
    SUM(total_laid_off)
FROM layoffs
GROUP BY country
ORDER BY 2 DESC;

-- View: Total layoffs by year and month
CREATE VIEW year_month_layoffs AS 
SELECT 
    YEAR(formated_date) AS year,
    MONTH(formated_date) AS month,
    SUM(total_laid_off) 
FROM layoffs
WHERE formated_date IS NOT NULL
GROUP BY year, month
ORDER BY 1 ASC;

-- View: Rolling monthly sum of layoffs
CREATE VIEW rolling_sum AS
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

-- View: Top 5 companies with most layoffs per year
CREATE VIEW most_layoffs_annualy AS 
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

-- View: Average layoffs per company per year
CREATE VIEW avg_company_layoff AS 
WITH year_company_number_total AS (
  SELECT 		
    YEAR(formated_date) AS year,
    COUNT(DISTINCT company) AS num_comp,
    SUM(total_laid_off) AS total 
  FROM layoffs 
  WHERE YEAR(formated_date) IS NOT NULL
  GROUP BY year
)
SELECT
  year,
  (total * 1.0 / num_comp) AS average_layoff
FROM year_company_number_total;
