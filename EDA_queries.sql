-- Theme 1: Cost & Billing

-- Q1: Which medical conditions are the most expensive to treat on average?

-- Finding: Average billing is nearly identical across conditions
-- (Obesity highest at 25,804; Cancer lowest at 25,152; gap about 2.6%).

SELECT * FROM healthcare2;

SELECT `Medical Condition`, 
ROUND(AVG(`Billing Amount`),2) AS Avg_Billing_Amount
FROM healthcare2
GROUP BY `Medical Condition`
ORDER BY Avg_Billing_Amount DESC;
 

-- Q2: Does admission type (Emergency vs Elective vs Urgent) affect billing amount?

-- Finding: No meaningful effect. All three types average about 25,500
-- (gap about 0.4%).

SELECT * FROM healthcare2;

SELECT `Admission Type`,
ROUND(AVG(`Billing Amount`),2) AS Avg_Amount
FROM healthcare2
GROUP BY `Admission Type`;


-- Q3: Which insurance providers are associated with the highest average billing?

-- Finding: Medicare is highest (25,628) and UnitedHealthcare lowest (25,415),
-- a gap of about 0.8%. Insurance provider does not change billing much.

SELECT * FROM healthcare2;

SELECT `Insurance Provider`,
ROUND(AVG(`Billing Amount`), 2)  AS Avg_Amount
FROM healthcare2
GROUP BY `Insurance Provider`
ORDER BY Avg_Amount DESC;

-- Theme 2: Patient Care & Outcomes

-- Q4: What's the average length of hospital stay per medical condition?

-- Finding: Stay is about 15.4 to 15.7 days for every condition
-- (Asthma longest at 15.68, Diabetes shortest at 15.43; gap about 1.6%).

SELECT * FROM healthcare2;

SELECT `Medical Condition`,
ROUND(AVG(DATEDIFF(`Discharge Date` , `Date of Admission`)),2) AS Avg_Stay_Days
FROM healthcare2
GROUP BY `Medical Condition`
ORDER BY Avg_Stay_Days DESC;


-- Q5: Is there a relationship between admission type and length of stay?

-- Finding: No. Emergency (15.58), Elective (15.51) and Urgent (15.40) are
-- nearly the same (gap about 1.2%).

SELECT * FROM healthcare2;

SELECT `Admission Type`,
ROUND(AVG(DATEDIFF(`Discharge Date` , `Date of Admission`)),2) AS Avg_Stay_Days
FROM healthcare2
GROUP BY `Admission Type`
ORDER BY Avg_Stay_Days DESC;


-- Q6: What percentage of test results come back "Abnormal" vs "Normal" vs "Inconclusive," and does this vary by condition?

-- Finding: Each condition splits almost evenly, about 33% per result
-- (range 32.5% to 34.3%). Test results do not vary by condition.

SELECT * FROM healthcare2;

SELECT 
`Medical Condition`,
`Test Results`,
COUNT(*) AS Total_Patients,
ROUND(COUNT(*) * 100 / SUM(COUNT(*)) OVER (PARTITION BY `Medical Condition`),2) AS Percentage_within_Condition
FROM healthcare2
GROUP BY  `Medical Condition`, `Test Results`
ORDER BY `Medical Condition`, `Test Results`;


-- Theme 3: Demographics & Risk Patterns

-- Q7: Which age groups are most associated with which medical conditions?

-- Finding: Young Adult, Middle Age and Senior groups are spread almost evenly
-- (about 16% to 17% per condition, close to the even 16.7%).
-- The Teen group is very small (116 patients), so its shares vary more
-- (9.5% to 23.3%); with so few patients this is likely random variation,
-- not a real link. No age group is strongly tied to a condition..

SELECT * FROM healthcare2;

SELECT MIN(Age), MAX(Age) FROM healthcare2;

SELECT 
CASE
    WHEN Age < 18 THEN 'Teen'
    WHEN Age < 40 THEN 'Young Adult'
    WHEN Age < 65 THEN 'Middle Age'
    ELSE 'Senior'
END AS Age_Group,
`Medical Condition`,
COUNT(*) AS Total_Patients,
ROUND(COUNT(*) * 100 / SUM(COUNT(*)) OVER ( PARTITION BY
CASE
    WHEN Age < 18 THEN 'Teen'
    WHEN Age < 40 THEN 'Young Adult'
    WHEN Age < 65 THEN 'Middle Age'
    ELSE 'Senior'
END 
),2) AS Percentage_within_AgeGroup
FROM healthcare2
GROUP BY `Age_Group`, `Medical Condition`
ORDER BY `Age_Group`,`Medical Condition`;


-- Q8: Is there a gender difference in billing amount or length of stay for the same condition?

-- Finding: Differences are small. Billing gaps are about 0.5% to 2%, and
-- neither gender is consistently higher (Male is higher in 4 of 6
-- conditions, Female in 2). Male patients stay slightly longer in 5 of 6
-- conditions, but by less than 0.3 days (under 2%). Gender does not
-- meaningfully affect cost or length of stay.

SELECT * FROM healthcare2;

SELECT DISTINCT Gender FROM healthcare2;

SELECT `Medical Condition`,
Gender,
ROUND(AVG(DATEDIFF(`Discharge Date` , `Date of Admission`)),2) AS Avg_Stay_Days,
ROUND(AVG(`Billing Amount`),2) AS Avg_Bill_Amount
FROM healthcare2
GROUP BY `Medical Condition`, Gender
ORDER BY `Medical Condition`,Gender;

-- Theme 4: Operational / Hospital-level Patterns

-- Q9: Are hospital admissions increasing, decreasing, or seasonal over time?

SELECT * FROM healthcare2;

SELECT MIN(`Date of Admission`), MAX(`Date of Admission`) FROM healthcare2;

-- Finding: Full years 2020 to 2023 are steady (about 10,800 to 11,200
-- per year, gap about 3%). 2019 and 2024 are partial years
-- (data runs 8 May 2019 to 7 May 2024), so they are not compared.

SELECT YEAR(`Date of Admission`) AS Admission_Year,
COUNT(*) AS Total_Admissions
FROM healthcare2
GROUP BY Admission_Year
ORDER BY Admission_Year;

-- Finding: No clear seasonal pattern. Monthly admissions range from 3,341
-- to 3,814. February is lowest (3,341), mostly because it has fewer days.
-- The other months stay within about 8% of each other.

SELECT MONTH(`Date of Admission`) AS Admission_Month,
COUNT(*) AS Total_Admissions
FROM healthcare2
WHERE YEAR(`Date of Admission`) BETWEEN 2020 AND 2023
GROUP BY Admission_Month
ORDER BY Admission_Month;


-- Q10: Which doctors or hospitals (excluding the malformed ones) handle the highest patient volume?


SELECT * FROM healthcare2;

-- Finding: No doctor stands out. The top doctor (Michael Smith) has 27
-- patients, and the 10th has 17. Names are very common (Smith, Johnson),
-- which is another sign the data is synthetic.

SELECT Doctor,
COUNT(*) AS Total_Patients
FROM healthcare2
GROUP BY Doctor
ORDER BY Total_Patients DESC
LIMIT 10;

-- Finding: No hospital stands out. The top hospital (LLC Smith) has 44
-- patients, and the 10th has 32. Names starting with 'and' are excluded
-- because of the truncation issue documented in the cleaning file.
-- Other malformed names may remain, so treat this ranking with caution.

SELECT Hospital,
COUNT(*) AS Total_Patients
FROM healthcare2
WHERE Hospital NOT LIKE 'and %'
GROUP BY Hospital
ORDER BY Total_Patients DESC
LIMIT 10;
