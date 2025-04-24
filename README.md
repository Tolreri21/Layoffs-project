# 📊 **Global Layoff Dashboard**

This project is a comprehensive data visualization dashboard created using **Power BI**, aimed at analyzing global layoff trends across **regions**, **industries**, and **companies** from 2020 to 2023.

![Dashboard Preview](58b6e522-24f1-483f-819c-1ccda60940d8.png)

---

## 🔍 **Overview**

The **Global Layoff Dashboard** provides insights into:

- Total layoffs globally over time  
- Top industries and companies with the most layoffs  
- Regional heatmaps based on layoff severity  
- Year-over-year comparisons of layoffs (total and average per company)  
- Cumulative trends with rolling sums  

All data was sourced from a **MySQL database** and processed through custom **SQL views** to optimize performance and interactivity in Power BI.

---

## 🛠️ **Technologies Used**

- **Power BI** – For creating the dashboard  
- **MySQL** – For storing and querying the data  
- **SQL Views** – For preprocessing and simplifying data analysis  

---

## 📁 **Key SQL Views**

### 1. `total`  
> **Total layoffs across all years**
```sql
SELECT SUM(total_laid_off) FROM layoffs;
```

---

### 2. `industry_layoffs`  
> **Top 5 industries with the highest layoffs**
```sql
SELECT industry, SUM(total_laid_off)
FROM layoffs
GROUP BY industry
ORDER BY 2 DESC
LIMIT 5;
```

---

### 3. `total_per_country`  
> **Layoffs by country**
```sql
SELECT country, SUM(total_laid_off)
FROM layoffs
GROUP BY country
ORDER BY 2 DESC;
```

---

### 4. `year_month_layoffs`  
> **Layoffs by year and month**
```sql
SELECT YEAR(formated_date) AS year,
       MONTH(formated_date) AS month,
       SUM(total_laid_off) AS total
FROM layoffs
GROUP BY year, month;
```

---

### 5. `rolling_sum`  
> **Monthly rolling sum of layoffs**
```sql
-- Uses SUM(...) OVER(ORDER BY formated_date ROWS BETWEEN 5 PRECEDING AND CURRENT ROW)
```

---

### 6. `most_layoffs_annualy`  
> **Top 5 companies with most layoffs per year**
```sql
-- Uses DENSE_RANK() OVER(PARTITION BY year ORDER BY total_laid_off DESC)
```

---

### 7. `ycmt`  
> **Yearly average layoffs per company**
```sql
-- Calculates average layoffs = total layoffs / number of companies
```

---

## 📈 **Key Insights**

- **2022** had the highest total layoffs (~160,000), while **2021** had the lowest (~16,000), but the **highest average layoffs per company**.
- **Bytedance** had the most layoffs in a single year.
- The **Consumer** and **Retail** industries were the most affected.

---

## 🚀 **How to Use**

1. Clone this repository.
2. Set up a MySQL database and import the dataset.
3. Open the Power BI file and connect it to your database.
4. Refresh the visuals and explore insights!

---

## 📬 **Feedback**

Feel free to open issues or contribute if you want to improve the analysis or dashboard!