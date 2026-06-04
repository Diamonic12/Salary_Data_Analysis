# Salary Data Analysis — SQL Server

Exploratory data analysis on a salary dataset (~22,000 records) 
using Microsoft SQL Server (SSMS).

## Dataset

| Column | Description |
|---|---|
| Company_Name | Name of the company |
| Job_Title | Specific job title |
| Job_Roles | Broader job role category |
| Salary | Annual salary |
| Rating | Company rating (out of 5) |
| Location | City/region |
| Employment_Status | Full Time, Part Time, etc. |
| Salaries_Reported | Number of salaries reported |

**Source:** [Add your dataset source/link here]

## Tools Used
- Microsoft SQL Server (SSMS)
- Window Functions (PARTITION BY, PERCENTILE_CONT)

## Analysis Summary

| # | Analysis | Key Finding |
|---|---|---|
| 1 | Basic Exploration | ~22,000 salary records across companies |
| 2 | Most Common Companies | Identifies which companies have the most entries |
| 3 | Avg vs Median by Company | Avg consistently higher than Median — right-skewed distribution due to high earners |
| 4 | Salary by Job Role | Identifies highest and lowest paying roles |
| 5 | Salary by Location | Reveals geographic salary differences |
| 6 | Salary by Employment Status | Compares Full Time vs Part Time etc. |
| 7 | Rating vs Salary | Explores if higher-rated companies pay more |
| 8 | Top Paying Job Titles | Top 10 titles with 10+ records |
| 9 | Best Companies | Highest rating + highest salary (20+ records) |
| 10 | Location + Job Role | Best paying location-role combinations |

## Key Insights

- **Avg > Median** across all companies indicates salary data is 
  right-skewed. A few executives/senior roles inflate the average.
  Median is the more reliable measure of a typical employee's salary.

- **BIGINT casting** was required on `AVG(Salary)` to prevent 
  arithmetic overflow from large intermediate sums.

- **Window functions** (`PARTITION BY`) were used instead of `GROUP BY` 
  throughout to support `PERCENTILE_CONT` for median calculations.

## How to Run

1. Import `dataset/Salary_Dataset.csv` into SQL Server as `Salary_Dataset`
   under the `projectportfolio` database
2. Open `salary_analysis.sql` in SSMS
3. Run queries individually or all at once****
