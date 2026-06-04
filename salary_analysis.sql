-- ============================================================
-- Salary Dataset Analysis
-- Author: [Your Name]
-- Date: [Date]
-- Tool: Microsoft SQL Server (SSMS)
-- Dataset: Salary Dataset with Extra Features (~22,000 rows)
-- ============================================================


-- ============================================================
-- 1. BASIC EXPLORATION
-- ============================================================

-- View all records
SELECT *
FROM projectportfolio..Salary_Dataset;

-- Top 10 highest salaries
SELECT TOP 10 *
FROM projectportfolio..Salary_Dataset
ORDER BY Salary DESC;


-- ============================================================
-- 2. MOST COMMON COMPANIES
-- ============================================================

SELECT Company_Name, COUNT(Company_Name) AS Count
FROM projectportfolio..Salary_Dataset
GROUP BY Company_Name
ORDER BY Count DESC;


-- ============================================================
-- 3. AVERAGE AND MEDIAN SALARY BY COMPANY
-- Note: AVG > Median across companies indicates right-skewed
--       salary distribution. A few high earners (executives/
--       senior roles) pull the average up. Median is the more
--       honest representation of a typical employee's salary.
-- ============================================================

SELECT Company_Name, Avg_Salary, Median_Salary
FROM (
    SELECT DISTINCT
        Company_Name,
        AVG(CAST(Salary AS BIGINT)) OVER (PARTITION BY Company_Name) AS Avg_Salary,
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY Salary)
            OVER (PARTITION BY Company_Name) AS Median_Salary,
        COUNT(Company_Name) OVER (PARTITION BY Company_Name) AS Company_Count
    FROM projectportfolio..Salary_Dataset
) AS Subquery
ORDER BY Company_Count DESC;


-- ============================================================
-- 4. MEDIAN SALARY BY JOB ROLE
-- ============================================================

SELECT DISTINCT
    Job_Roles,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY Salary)
        OVER (PARTITION BY Job_Roles) AS Median_Salary
FROM projectportfolio..Salary_Dataset
ORDER BY Median_Salary DESC;


-- ============================================================
-- 5. MEDIAN SALARY BY LOCATION
-- ============================================================

SELECT DISTINCT
    Location,
    PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY Salary)
        OVER (PARTITION BY Location) AS Median_Salary
FROM projectportfolio..Salary_Dataset
ORDER BY Median_Salary DESC;


-- ============================================================
-- 6. SALARY BY EMPLOYMENT STATUS
-- ============================================================

SELECT Employment_Status, Count, Avg_Salary, Median_Salary
FROM (
    SELECT DISTINCT
        Employment_Status,
        COUNT(*) OVER (PARTITION BY Employment_Status) AS Count,
        AVG(CAST(Salary AS BIGINT)) OVER (PARTITION BY Employment_Status) AS Avg_Salary,
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY Salary)
            OVER (PARTITION BY Employment_Status) AS Median_Salary
    FROM projectportfolio..Salary_Dataset
) AS Subquery
ORDER BY Avg_Salary DESC;


-- ============================================================
-- 7. DOES HIGHER COMPANY RATING MEAN HIGHER SALARY?
-- ============================================================

SELECT Rating_Band, Count, Avg_Salary
FROM (
    SELECT DISTINCT
        ROUND(Rating, 0) AS Rating_Band,
        COUNT(*) OVER (PARTITION BY ROUND(Rating, 0)) AS Count,
        AVG(CAST(Salary AS BIGINT)) OVER (PARTITION BY ROUND(Rating, 0)) AS Avg_Salary
    FROM projectportfolio..Salary_Dataset
) AS Subquery
ORDER BY Rating_Band DESC;


-- ============================================================
-- 8. TOP 10 HIGHEST PAYING JOB TITLES
--    (minimum 10 records per title to ensure reliability)
-- ============================================================

SELECT TOP 10 Job_Title, Count, Avg_Salary
FROM (
    SELECT DISTINCT
        Job_Title,
        COUNT(*) OVER (PARTITION BY Job_Title) AS Count,
        AVG(CAST(Salary AS BIGINT)) OVER (PARTITION BY Job_Title) AS Avg_Salary
    FROM projectportfolio..Salary_Dataset
) AS Subquery
WHERE Count >= 10
ORDER BY Avg_Salary DESC;


-- ============================================================
-- 9. BEST COMPANIES (HIGH RATING + HIGH SALARY)
--    (minimum 20 records per company to ensure reliability)
-- ============================================================

SELECT TOP 10 Company_Name, Avg_Rating, Avg_Salary, Count
FROM (
    SELECT DISTINCT
        Company_Name,
        ROUND(AVG(CAST(Rating AS FLOAT)) OVER (PARTITION BY Company_Name), 1) AS Avg_Rating,
        AVG(CAST(Salary AS BIGINT)) OVER (PARTITION BY Company_Name) AS Avg_Salary,
        COUNT(*) OVER (PARTITION BY Company_Name) AS Count
    FROM projectportfolio..Salary_Dataset
) AS Subquery
WHERE Count >= 20
ORDER BY Avg_Rating DESC, Avg_Salary DESC;


-- ============================================================
-- 10. SALARY BY LOCATION + JOB ROLE COMBINATION
--     (minimum 10 records per combination)
-- ============================================================

SELECT TOP 20 Location, Job_Roles, Avg_Salary, Count
FROM (
    SELECT DISTINCT
        Location,
        Job_Roles,
        AVG(CAST(Salary AS BIGINT)) OVER (PARTITION BY Location, Job_Roles) AS Avg_Salary,
        COUNT(*) OVER (PARTITION BY Location, Job_Roles) AS Count
    FROM projectportfolio..Salary_Dataset
) AS Subquery
WHERE Count >= 10
ORDER BY Avg_Salary DESC;