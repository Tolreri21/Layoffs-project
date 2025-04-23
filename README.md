# Layoffs Data Cleaning Project

This SQL project focuses on cleaning a raw layoffs dataset to make it more suitable for analysis. The cleaning process includes handling missing values, correcting data types, removing duplicates, standardizing text values, and formatting dates. All operations are performed using **MySQL**.

---

## Dataset

The dataset includes various layoff-related information, such as:
- Layoff dates  
- Company details (name, location, industry, stage)  
- Layoff details (total laid off, percentage laid off)  
- Country  

---

## Cleaning Tasks and Solutions

### 1. **Previewing the Data**
- **Function used**: `SELECT *`
- **Purpose**: Understand the structure and contents of the dataset.

### 2. **Fixing Date Format**
- **Functions used**: `STR_TO_DATE()`, `ALTER TABLE`, `UPDATE`  
- **Problem solved**: Converted inconsistent date strings into a standardized SQL `DATE` format by creating a new `formated_date` column.

### 3. **Creating an ID Column**
- **Function used**: `ALTER TABLE`, `AUTO_INCREMENT`  
- **Problem solved**: Added an `id` column to uniquely identify each row and assist with removing duplicates.

### 4. **Removing Duplicate Rows**
- **Functions used**: `ROW_NUMBER()`, `CTE (Common Table Expression)`, `DELETE`  
- **Problem solved**: Removed exact duplicates based on columns such as `company`, `location`, `industry`, and `formated_date`.

### 5. **Trimming White Spaces**
- **Function used**: `TRIM()`, `UPDATE`  
- **Problem solved**: Removed leading/trailing spaces from text fields like `company` and `country`.

### 6. **Standardizing Industry Values**
- **Functions used**: `CASE`, `UPDATE`  
- **Problem solved**: Corrected inconsistent or duplicate entries in the `industry` column (e.g., different forms of "Crypto").

### 7. **Standardizing Country Names**
- **Function used**: `TRIM(TRAILING '.')`, `UPDATE`  
- **Problem solved**: Standardized entries like `"United States."` to `"United States"`.

### 8. **Deleting Rows with Missing Critical Data**
- **Function used**: `DELETE`  
- **Problem solved**: Removed rows where both `total_laid_off` and `percentage_laid_off` were missing.

### 9. **Filling Missing Industry Values**
- **Functions used**: `JOIN`, `UPDATE`  
- **Problem solved**: Filled in null `industry` values using values from other rows with the same `company`.

### 10. **Dropping Unnecessary Columns**
- **Function used**: `ALTER TABLE ... DROP COLUMN`  
- **Problem solved**: Dropped the temporary `id` column after it was used for duplicate removal.

---

## Final Output

The final dataset is:
- Cleaned and standardized  
- Free of duplicates and unnecessary white spaces  
- Standardized in terms of formatting and labels  
- Free of rows with missing essential values  
- Ready for further analysis or export to BI tools like **Power BI** or **Tableau**

---

## Tools Used

- **MySQL** for writing and executing SQL queries  
- SQL functions used:  
  ```sql
  SELECT, UPDATE, ALTER TABLE, JOIN, 
  ROW_NUMBER(), CASE, DELETE, 
  CTE, STR_TO_DATE(), TRIM()
