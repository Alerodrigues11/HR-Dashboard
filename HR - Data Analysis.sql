/* QUESTIONS */

SELECT * FROM HR

-- 1 What is the gender breakdown of employees in the company?
SELECT gender, COUNT(*) AS QUANTITY 
FROM HR
WHERE termdate IS NULL OR termdate > GETDATE()
GROUP BY gender

-- 2 What is the race/ethnicity breakdown of employees in the company?
SELECT race, COUNT(*) AS QUANTITY 
FROM HR
WHERE termdate IS NULL OR termdate > GETDATE()
GROUP BY race
ORDER BY COUNT(*) DESC

-- 3 What is the age distribution of employees in the company?
SELECT 
	CASE
		WHEN AGE >= 18 AND AGE <= 24 THEN '18-24'
		WHEN AGE >= 25 AND AGE <= 34 THEN '25-34'
		WHEN AGE >= 35 AND AGE <= 44 THEN '35-44'
		WHEN AGE >= 45 AND AGE <= 58 THEN '45-58'
		ELSE '59+'
	END AS AGE_GROUP, GENDER, COUNT(*) AS QUANTITY
FROM HR 
WHERE termdate IS NULL OR termdate > GETDATE()
GROUP BY 
	CASE
		WHEN AGE >= 18 AND AGE <= 24 THEN '18-24'
		WHEN AGE >= 25 AND AGE <= 34 THEN '25-34'
		WHEN AGE >= 35 AND AGE <= 44 THEN '35-44'
		WHEN AGE >= 45 AND AGE <= 58 THEN '45-58'
		ELSE '59+'
	END, GENDER
ORDER BY
	CASE
		WHEN AGE >= 18 AND AGE <= 24 THEN '18-24'
		WHEN AGE >= 25 AND AGE <= 34 THEN '25-34'
		WHEN AGE >= 35 AND AGE <= 44 THEN '35-44'
		WHEN AGE >= 45 AND AGE <= 58 THEN '45-58'
		ELSE '59+'
	END, GENDER

-- 4 How many employees work at headquarters versus remote locations?
SELECT location, COUNT(*) AS QUANTITY
FROM HR
WHERE termdate IS NULL OR termdate > GETDATE()
GROUP BY location

-- 5 What is the average length of employment for employees who have been terminated?
SELECT AVG(DATEDIFF(YEAR, hire_date, termdate)) AS AVERAGE_LENGTH_YEARS
FROM HR
WHERE termdate <= GETDATE() AND termdate IS NOT NULL  

-- 6 How does the gender distribution vary across departments?
SELECT department, gender, COUNT(GENDER) AS QUANTITY
FROM HR
WHERE termdate IS NULL OR termdate > GETDATE()
GROUP BY department, gender
ORDER BY department

-- 7 What is the distribution of job titles across the company?
SELECT jobtitle, COUNT(*) AS QUANTITY
FROM HR
WHERE termdate IS NULL OR termdate > GETDATE()
GROUP BY jobtitle
ORDER BY jobtitle

-- 8 Which department has the highest turnover rate?
SELECT department,
	total_count,
	terminated_count,
	(CONVERT(FLOAT, terminated_count)/CONVERT(FLOAT, total_count)) AS termination_rate
FROM (
	SELECT department, 
	COUNT(*) AS total_count, 
	SUM(CASE WHEN termdate IS NOT NULL AND termdate <= GETDATE() THEN 1 ELSE 0 END) AS terminated_count
	FROM HR
	GROUP BY department
) AS QUERY
ORDER BY terminated_count/total_count DESC

-- 9 What is the distribution of employees across locations by state?
SELECT location_state, COUNT(*) AS QUANTITY
FROM HR
WHERE termdate IS NULL OR termdate > GETDATE()
GROUP BY location_state
ORDER BY COUNT(*) DESC

-- 10 What is the amount of employees hired?
SELECT COUNT(*) AS QUANTITY
FROM HR

-- 11 How many employees were laid off?
SELECT COUNT(*) AS QUANTITY
FROM HR
WHERE termdate IS NOT NULL AND termdate <= GETDATE()

-- 12 How many employees are in the company?

SELECT COUNT(*) AS QUANTITY
FROM HR
WHERE termdate IS NULL OR termdate > GETDATE()

-- 13 What is the overall turnover?

SELECT	total_count,
	terminated_count,
	(CONVERT(FLOAT, terminated_count)/CONVERT(FLOAT, total_count)) AS termination_rate
FROM (
	SELECT COUNT(*) AS total_count, 
	SUM(CASE WHEN termdate IS NOT NULL AND termdate <= GETDATE() THEN 1 ELSE 0 END) AS terminated_count
	FROM HR
) AS QUERY

-- 14 What is the percentage of retention over the years
SELECT year, hires, terminations, ROUND(CONVERT(FLOAT,hires)-CONVERT(FLOAT,terminations),2)/hires AS hires_terminations_percentage
FROM (
SELECT
    DATEPART(YEAR, hire_date) AS YEAR,
    COUNT(*) AS HIRES,
	SUM(CASE WHEN termdate IS NOT NULL AND termdate <= GETDATE() THEN 1 ELSE 0 END) AS TERMINATIONS
FROM HR
GROUP BY DATEPART(YEAR, hire_date)
) AS SUBQUERY
ORDER BY YEAR

