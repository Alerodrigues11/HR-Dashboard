/* Perguntas */

SELECT * FROM HR

-- 1 Qual é a divisão por gênero dos funcionários da empresa?
SELECT gender, COUNT(*) AS QUANTITY 
FROM HR
WHERE termdate IS NULL OR termdate > GETDATE()
GROUP BY gender

-- 2 Qual é a divisão racial/etnia dos funcionários da empresa?
SELECT race, COUNT(*) AS QUANTITY 
FROM HR
WHERE termdate IS NULL OR termdate > GETDATE()
GROUP BY race
ORDER BY COUNT(*) DESC

-- 3 Qual é a distribuição etária dos funcionários da empresa?
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

-- 4 Quantos funcionários trabalham na sede x locais remotos?
SELECT location, COUNT(*) AS QUANTITY
FROM HR
WHERE termdate IS NULL OR termdate > GETDATE()
GROUP BY location

-- 5 Tempo Médio de Emprego para Funcionários Rescindidos
SELECT AVG(DATEDIFF(YEAR, hire_date, termdate)) AS AVERAGE_LENGTH_YEARS
FROM HR
WHERE termdate <= GETDATE() AND termdate IS NOT NULL  

-- 6 Como a distribuição de gênero varia entre os departamentos?
SELECT department, gender, COUNT(GENDER) AS QUANTITY
FROM HR
WHERE termdate IS NULL OR termdate > GETDATE()
GROUP BY department, gender
ORDER BY department

-- 7 Qual departamento tem a maior taxa de rotatividade?
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

-- 8 Qual é a distribuição dos funcionários entre as localidades por estado?
SELECT location_state, COUNT(*) AS QUANTITY
FROM HR
WHERE termdate IS NULL OR termdate > GETDATE()
GROUP BY location_state
ORDER BY COUNT(*) DESC

-- 9 Qual a quantidade de funcionários contratados?
SELECT COUNT(*) AS QUANTITY
FROM HR

-- 10 Quantos funcionários foram desligados?
SELECT COUNT(*) AS QUANTITY
FROM HR
WHERE termdate IS NOT NULL AND termdate <= GETDATE()

-- 11 Quantos funcionários estão na empresa?
SELECT COUNT(*) AS QUANTITY
FROM HR
WHERE termdate IS NULL OR termdate > GETDATE()

-- 12 Taxa de rotatividade geral:

SELECT	total_count,
	terminated_count,
	(CONVERT(FLOAT, terminated_count)/CONVERT(FLOAT, total_count)) AS termination_rate
FROM (
	SELECT COUNT(*) AS total_count, 
	SUM(CASE WHEN termdate IS NOT NULL AND termdate <= GETDATE() THEN 1 ELSE 0 END) AS terminated_count
	FROM HR
) AS QUERY

-- 13 Porcentagem de retenção de funcionários ao longo dos anos:
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

