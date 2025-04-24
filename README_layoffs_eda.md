
# 📊 Layoffs Dataset - Exploratory Data Analysis (EDA) using SQL

This repository contains a comprehensive SQL-based exploratory data analysis (EDA) of a dataset containing company layoffs. The analysis is performed entirely in **MySQL Workbench**, focusing on trends over time, industry impact, geographical distribution, and company-specific insights.

## 🧰 Tools Used

- **MySQL Workbench**: Used for writing and executing SQL queries
- **SQL (MySQL dialect)**: The language used for data manipulation and analysis

---

## 📂 Dataset Overview

The dataset includes information on company layoffs such as:
- Company name
- Industry
- Location 
- Country
- Date of layoffs
- Total employees laid off
- Percentage of workforce laid off
- Funds raised by the company (in millions)
- Company Stage 
---

## 🔍 Key Questions Answered

- What is the total number of layoffs across all years?
- Which companies laid off the most employees?
- Which industries and countries were most affected?
- What are the trends in layoffs over time (yearly/monthly)?
- Were there any companies that laid off 100% of their workforce?
- Which companies received large funding but still laid off employees?
- What is the average layoff per company per year?

---

## 📈 SQL Analysis Highlights

### ✅ Dataset Overview
```sql
SELECT * FROM portfolio_project.layoffs;
```

### 🔢 Total Layoffs Overall
```sql
SELECT SUM(total_laid_off) FROM layoffs;
```

### 🏢 Top Layoffs by Company
```sql
SELECT company, SUM(total_laid_off) 
FROM layoffs 
GROUP BY company 
ORDER BY 2 DESC;
```

### 🌍 Most Affected Countries
```sql
SELECT country, SUM(total_laid_off) 
FROM layoffs 
GROUP BY country 
ORDER BY 2 DESC;
```

### 🗓️ Yearly and Monthly Trends
```sql
-- Total by year
SELECT YEAR(formated_date), SUM(total_laid_off) 
FROM layoffs 
GROUP BY YEAR(formated_date);

-- Monthly trend with rolling total
WITH rolling_sum AS (
  SELECT YEAR(formated_date) AS year, MONTH(formated_date) AS month, SUM(total_laid_off) AS tlo
  FROM layoffs
  GROUP BY year, month
)
SELECT year, month, tlo, 
  SUM(tlo) OVER(ORDER BY year, month) AS rolling_total 
FROM rolling_sum;
```

### 🏆 Top 5 Companies with Most Layoffs Each Year
```sql
-- Ranking companies per year
WITH company_layoffs AS (
  SELECT company, YEAR(formated_date) AS year, SUM(total_laid_off) AS total_laid_off
  FROM layoffs
  GROUP BY company, YEAR(formated_date)
),
ranked_companies AS (
  SELECT *, DENSE_RANK() OVER (PARTITION BY year ORDER BY total_laid_off DESC) AS ranking
  FROM company_layoffs
)
SELECT * 
FROM ranked_companies 
WHERE ranking <= 5;
```

---

## 📌 Interesting Insights

- **The United States** had the highest total layoffs: **256,365**.
- **India** followed with **35,993** layoffs.
- **January 2023** was the peak month with **84,714** layoffs.
- In **2022**, over **900 companies** reported layoffs—the highest number in the dataset.
- Some companies with high **funding levels still laid off 100%** of their staff.

---

## 🧠 Learnings & Takeaways

- Used advanced SQL functions such as `WINDOW FUNCTIONS`, `COMMON TABLE EXPRESSIONS (CTEs)`, `GROUP BY`, `RANK` and `LAG`  
- Explored time-series trends using cumulative sums and rolling totals.
- Interpreted real-world labor market shifts using only SQL — no BI tools involved.

---


## 🙌 Credits

- **Analysis** by: Anatolii Perederii

---

## 🪄 How to Use

1. Clone this repository.
2. Open the `layoffs_eda.sql` file in MySQL Workbench.
3. Connect to your local MySQL database and run the queries sequentially.
4. Explore insights and modify queries to suit your specific analysis goals.

---

## 📬 Contact

For feedback or collaboration opportunities, feel free to reach out on [LinkedIn](www.linkedin.com/in/anatoli21) or by email: anatoliiperederii21@icloud.com.

---
