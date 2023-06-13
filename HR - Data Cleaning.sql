SELECT * FROM HR;

/***** AJUSTANDO birthdate *****/
UPDATE HR
SET birthdate = 
    CASE 
        WHEN CHARINDEX('/', birthdate) > 0 THEN
            CONCAT(
                SUBSTRING(birthdate, CHARINDEX('/', birthdate, 4) + 1, 4),
                '/',
                SUBSTRING(birthdate, 1, CHARINDEX('/', birthdate) - 1),
                '/',
                SUBSTRING(birthdate, CHARINDEX('/', birthdate) + 1, CHARINDEX('/', birthdate, 4) - CHARINDEX('/', birthdate) - 1)
            )
        ELSE birthdate
    END;

UPDATE HR
SET birthdate = CASE
    WHEN birthdate LIKE '%/%' THEN CONVERT(VARCHAR, CAST(birthdate AS DATE), 23)
    WHEN birthdate LIKE '%-%' THEN CONVERT(VARCHAR, CAST(birthdate AS DATE), 23)
    ELSE birthdate
END;

ALTER TABLE HR
ALTER COLUMN birthdate DATE;

/***** AJUSTANDO HIRE_DATE *****/

UPDATE HR
SET hire_date = 
    CASE 
        WHEN CHARINDEX('/', hire_date) > 0 THEN
            CONCAT(
                SUBSTRING(hire_date, CHARINDEX('/', hire_date, 4) + 1, 4),
                '/',
                SUBSTRING(hire_date, 1, CHARINDEX('/', hire_date) - 1),
                '/',
                SUBSTRING(hire_date, CHARINDEX('/', hire_date) + 1, CHARINDEX('/', hire_date, 4) - CHARINDEX('/', hire_date) - 1)
            )
        ELSE hire_date
    END;

UPDATE HR
SET hire_date = CASE
    WHEN hire_date LIKE '%/%' THEN CONVERT(VARCHAR, CAST(hire_date AS DATE), 23)
    WHEN hire_date LIKE '%-%' THEN CONVERT(VARCHAR, CAST(hire_date AS DATE), 23)
    ELSE hire_date
END;

ALTER TABLE HR
ALTER COLUMN hire_date DATE;

/***** AJUSTANDO TERMDATE *****/

UPDATE HR
SET TERMDATE = CONVERT(DATETIME, SUBSTRING(TERMDATE, 1, CHARINDEX(' ', TERMDATE) - 1), 120)
WHERE TERMDATE IS NOT NULL AND TERMDATE <> '';

ALTER TABLE HR
ALTER COLUMN termdate DATE

UPDATE HR
SET termdate = NULL
WHERE termdate = '1900-01-01'

/***** ADICIONANDO COLUNA DE IDADE *****/

ALTER TABLE HR
ADD Age INT

UPDATE HR 
SET Age = DATEDIFF(MONTH, birthdate, GETDATE())/12
