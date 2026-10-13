# 🏥 Healthcare-Data-Cleaning-EDA-SQL

This project cleans and analyzes a healthcare dataset of about 55,000 patient records using MySQL. It covers duplicate removal, data standardization, and 10 business questions on cost, patient care, demographics, and hospital operations.

Tools: MySQL, MySQL Workbench
Skills: Data Cleaning, GROUP BY, CASE WHEN, Window Functions, Subqueries, CTEs, Date Functions

## 🧹 Data Cleaning Steps

- Removed duplicate rows using ROW_NUMBER() and PARTITION BY
- Standardized patient names to uppercase
- Converted Date of Admission and Discharge Date from text to DATE format
- Checked for NULL and blank values
- Dropped the helper column used for duplicate removal

## 🔍 Analysis Questions

- Which medical conditions cost the most on average?
- Does admission type affect billing amount?
- Which insurance providers have the highest average billing?
- What is the average length of stay per condition and admission type?
- How are test results split, and does this vary by condition?
- Which age groups are linked to which conditions?
- Is there a gender difference in billing or length of stay?
- Are admissions increasing, decreasing, or seasonal?
- Which doctors and hospitals handle the highest patient volume?

## 📌 Key Findings

- Most comparisons differed by under 3%, so no condition, admission type, or insurer stood out
- Test results were split about 33% each across all conditions
- Admissions were steady from 2020 to 2023 with no clear seasonal pattern
- The dataset appears synthetic (near-identical group averages and common surnames like Smith and Johnson)

## ⚠️ Data Quality Note

About 10% of Hospital values (5,698 rows) are truncated, for example, names starting with "and". The source table has the same issue, so it was not caused by cleaning. These values were documented rather than guessed.

## 📁 Files

- `data_cleaning.sql` – cleaning steps
- `eda_queries.sql` – 10 questions with queries and findings

## 📬 Contact

🔗 [LinkedIn – Maira Shahid](https://www.linkedin.com/in/maira-shahid-598bb1317/)

