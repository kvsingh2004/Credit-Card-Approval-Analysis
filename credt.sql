-- BASIC TABLE EXPLORATION

-- 1. Preview the first 10 records
SELECT * FROM credit_cleaned LIMIT 10;

-- 2. Check structure/schema
DESCRIBE credit_cleaned;

-- 3. Total application count
SELECT COUNT(*) AS total_applications FROM credit_cleaned;

-- 4. Sample from aggregation table
SELECT * FROM credit_agg;

-- OVERALL METRICS

-- 5. Overall approval rate
SELECT AVG(Approved) AS approval_rate FROM credit_cleaned;

-- 6. Basic statistics (mean, min, max, std) for main numerics
SELECT 
   AVG(Age) as mean_age, MIN(Age) as min_age, MAX(Age) as max_age, STD(Age) as std_age,
   AVG(Income) as mean_income, MIN(Income) as min_income, MAX(Income) as max_income, STD(Income) as std_income,
   AVG(CreditScore) as mean_score, MIN(CreditScore) as min_score, MAX(CreditScore) as max_score, STD(CreditScore) as std_score
FROM credit_cleaned;

-- 7. Approval counts
SELECT Approved, COUNT(*) as count FROM credit_cleaned GROUP BY Approved;

-- SEGMENTED METRICS

-- 8. Approval rate by gender
SELECT Gender, AVG(Approved) AS approval_rate, COUNT(*) AS num_applications
FROM credit_cleaned GROUP BY Gender;

-- 9. Approval rate by marital status
SELECT Married, AVG(Approved) AS approval_rate, COUNT(*) AS num_applications
FROM credit_cleaned GROUP BY Married;

-- 10. Approval rate by employment
SELECT Employed, AVG(Approved) AS approval_rate, COUNT(*) AS num_applications
FROM credit_cleaned GROUP BY Employed;

-- 11. Approval rate by industry
SELECT Industry, AVG(Approved) AS approval_rate, COUNT(*) AS num_applications
FROM credit_cleaned GROUP BY Industry ORDER BY approval_rate DESC;

-- 12. Approval rate by ethnicity
SELECT Ethnicity, AVG(Approved) AS approval_rate, COUNT(*) AS num_applications
FROM credit_cleaned GROUP BY Ethnicity;

-- 13. Approval rate by bank customer status
SELECT BankCustomer, AVG(Approved) AS approval_rate, COUNT(*) AS num_applications
FROM credit_cleaned GROUP BY BankCustomer;

-- 14. Approval rate by citizen status
SELECT Citizen, Approved, COUNT(*) AS num_applications
FROM credit_cleaned GROUP BY Citizen, Approved;

-- NUMERICAL DISTRIBUTIONS & PROFILE ANALYSIS

-- 15. Income stats by approval
SELECT Approved, AVG(Income) AS avg_income, MIN(Income) AS min_income, MAX(Income) AS max_income
FROM credit_cleaned GROUP BY Approved;

-- 16. Credit score stats by approval
SELECT Approved, AVG(CreditScore) AS avg_score, MIN(CreditScore) AS min_score, MAX(CreditScore) AS max_score
FROM credit_cleaned GROUP BY Approved;

-- 17. Means by approval for other numerics
SELECT Approved, AVG(Age) AS avg_age, AVG(Debt) AS avg_debt, AVG(YearsEmployed) AS avg_years_employed
FROM credit_cleaned GROUP BY Approved;

-- 18. Average and stddev of income by approval (alternative grouping)
SELECT Approved, AVG(Income) AS avg_income, STD(Income) AS std_income
FROM credit_cleaned GROUP BY Approved;

-- 19. CreditScore mean and stddev by approval
SELECT Approved, AVG(CreditScore) AS avg_score, STD(CreditScore) AS std_score
FROM credit_cleaned GROUP BY Approved;

-- RISK & SPECIAL GROUP ANALYSIS

-- 20. High income, low credit score risk cases
SELECT * FROM credit_cleaned
WHERE Income > (SELECT AVG(Income) FROM credit_cleaned)
  AND CreditScore < (SELECT AVG(CreditScore) FROM credit_cleaned);

-- 21. PriorDefault relation to approval
SELECT PriorDefault, Approved, COUNT(*) AS num_applications
FROM credit_cleaned GROUP BY PriorDefault, Approved;

-- 22. Most-approved ZipCodes
SELECT ZipCode, COUNT(*) as approvals
FROM credit_cleaned WHERE Approved = 1
GROUP BY ZipCode ORDER BY approvals DESC LIMIT 10;

-- 23. Applications by years employed ranges
SELECT
  CASE
    WHEN YearsEmployed < 1 THEN 'Less than 1'
    WHEN YearsEmployed BETWEEN 1 AND 5 THEN '1-5'
    WHEN YearsEmployed > 5 THEN 'More than 5'
  END AS emp_range,
  COUNT(*) AS num_applicants, AVG(Approved) AS approval_rate
FROM credit_cleaned
GROUP BY emp_range;

-- CHARACTERISTIC THRESHOLDS FOR PREDICTION/RULES

-- 24. Typical approved profile for rules
SELECT
    AVG(Income) AS typical_income,
    AVG(CreditScore) AS typical_score,
    AVG(YearsEmployed) AS typical_employment,
    AVG(Debt) AS typical_debt
FROM credit_cleaned
WHERE Approved = 1;


-- 1. Rank applicants within each industry by Income (descending order)
SELECT
    ID,
    Industry,
    Income,
    RANK() OVER (PARTITION BY Industry ORDER BY Income DESC) AS income_rank_in_industry
FROM credit_cleaned
ORDER BY Industry, income_rank_in_industry;

-- 2. Calculate the cumulative count of approved applications over time by application ID
SELECT
    ID,
    Approved,
    SUM(Approved) OVER (ORDER BY ID ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_approvals
FROM credit_cleaned
ORDER BY ID;

-- 3. Calculate moving average of Income for applicants ordered by ID (window size 5)
SELECT
    ID,
    Income,
    AVG(Income) OVER (ORDER BY ID ROWS BETWEEN 4 PRECEDING AND CURRENT ROW) AS moving_avg_income
FROM credit_cleaned
ORDER BY ID;

-- 4. Use a CTE to find the top 3 industries by approval rate and then find applicants from these industries
WITH top_industries AS (
    SELECT Industry
    FROM credit_cleaned
    GROUP BY Industry
    ORDER BY AVG(Approved) DESC
    LIMIT 3
)
SELECT c.ID, c.Industry, c.Approved
FROM credit_cleaned c
JOIN top_industries t ON c.Industry = t.Industry
ORDER BY c.Industry, c.ID;

-- 5. Calculate percent rank of CreditScore for each applicant
SELECT
    ID,
    CreditScore,
    PERCENT_RANK() OVER (ORDER BY CreditScore) AS credit_score_percent_rank
FROM credit_cleaned
ORDER BY CreditScore;

-- 6. Identify applicants with the highest Debt in each Ethnicity group using ROW_NUMBER()
SELECT * FROM (SELECT
    ID,
    Ethnicity,
    Debt,
    ROW_NUMBER() OVER (PARTITION BY Ethnicity ORDER BY Debt DESC) AS rank_debt_in_ethnicity
FROM credit_cleaned) r
WHERE rank_debt_in_ethnicity = 1;

-- 7. Compare each applicant's YearsEmployed to the average in their Industry
SELECT
    ID,
    Industry,
    YearsEmployed,
    AVG(YearsEmployed) OVER (PARTITION BY Industry) AS avg_years_in_industry,
    YearsEmployed - AVG(YearsEmployed) OVER (PARTITION BY Industry) AS deviation_from_industry_avg
FROM credit_cleaned
ORDER BY Industry, ID;
