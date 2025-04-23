SELECT * FROM portfolio_project.layoffs;

SELECT 
	MAX(total_laid_off),
	MAX(percentage_laid_off) 
FROM layoffs;

SELECT * 
FROM layoffs
WHERE percentage_laid_off = 1;

SELECT * 
FROM layoffs
WHERE percentage_laid_off = 1 
ORDER BY funds_raised_millions DESC;

SELECT 
	company,
	SUM(total_Laid_off) 
FROM layoffs
GROUP BY company 
ORDER BY 2 desc;

SELECT 
	MIN(formated_date),
	MAX(Formated_date)
FROM layoffs;

SELECT 
	industry,
	SUM(total_laid_off)
FROM layoffs
GROUP BY industry
ORDER BY 2 desc; 

SELECT 
	country,
	SUM(total_laid_off)
FROM layoffs
GROUP BY country
ORDER BY 2 desc; 

SELECT 
	YEAR(formated_date),
	SUM(total_laid_off)
FROM layoffs
GROUP BY YEAR(formated_date);

SELECT 
	YEAR(formated_date)as year,MONTH(formated_date) as month,
	SUM(total_laid_off) 
FROM layoffs
WHERE formated_date IS NOT NULL
GROUP BY year, month
ORDER BY 1 ASC;

WITH rolling_sum AS (
SELECT 
	YEAR(formated_date)as year,MONTH(formated_date) as month,
	SUM(total_laid_off) as tlo
FROM layoffs
WHERE formated_date IS NOT NULL
GROUP BY year, month
ORDER BY 1 ASC)
SELECT year,month, sum(tlo) over(ORDER BY year,month) as rolling_total from rolling_sum;

