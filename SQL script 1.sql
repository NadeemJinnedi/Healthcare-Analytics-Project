-- Distribution of Health Insurance Plans across States: 
-- Count the number of individuals in each region
SELECT region, COUNT(*) as total_count
FROM insurance
GROUP BY region;

-- Distribution of Health Insurance Plans across Age Groups:
-- Categorize individuals into age groups and count the number in each group
SELECT
  age,
  COUNT(*) as total_count
FROM (
  SELECT
    CASE
      WHEN age BETWEEN 18 AND 25 THEN '18-25'
      WHEN age BETWEEN 26 AND 35 THEN '26-35'
      WHEN age BETWEEN 36 AND 45 THEN '36-45'
      WHEN age BETWEEN 46 AND 55 THEN '46-55'
      WHEN age >= 56 THEN '56+'
    END AS age
  FROM insurance
) AS AgeGroups
GROUP BY age
ORDER BY
  CASE
    WHEN age = '18-25' THEN 1
    WHEN age = '26-35' THEN 2
    WHEN age = '36-45' THEN 3
    WHEN age = '46-55' THEN 4
    WHEN age = '56+' THEN 5
  END;

--top 5 avenues where marketing effort should be spent by plan, age, and state.
WITH PlanAgeStateCounts AS (
    SELECT
        age,
        region,
        COUNT(*) AS combination_count
    FROM
        insurance
    GROUP BY
        age,
        region
)
SELECT TOP 5
    age,
    region,
    combination_count
FROM
    PlanAgeStateCounts
ORDER BY
    combination_count DESC;

--Charge Analysis by Smoker
SELECT
    smoker,
    AVG(charges) AS average_charge
FROM insurance
GROUP BY smoker;

--Number of Children Analysis:
SELECT
    children,
    AVG(charges) AS average_charge
FROM insurance
GROUP BY children;

--Regional Analysis:
SELECT
    region,
    AVG(charges) AS average_charge,
    COUNT(*) AS plan_count

FROM insurance
GROUP BY region;

-- Calculate Average, Median, and Standard Deviation of Charges
WITH RankedCharges AS (
    SELECT
        charges,
        ROW_NUMBER() OVER (ORDER BY charges) AS row_num,
        COUNT(*) OVER () AS total_rows
    FROM insurance
)

SELECT
    AVG(charges) AS average_charge,
    MAX(CASE WHEN row_num = (total_rows + 1) / 2 OR row_num = (total_rows + 2) / 2 THEN charges END) AS median_charge,
    STDEV(charges) AS charge_standard_deviation
FROM RankedCharges;

-- Age and BMI Correlation:
SELECT
    age,
    AVG(bmi) AS average_bmi
FROM insurance
GROUP BY age
ORDER BY age;

