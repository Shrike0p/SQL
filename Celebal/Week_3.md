## Task-1
```sql
WITH ProjectGroups AS (
    SELECT 
        Task_ID,
        Start_Date,
        End_Date,
        ROW_NUMBER() OVER (ORDER BY Start_Date) - 
        ROW_NUMBER() OVER (PARTITION BY DATEADD(DAY, -Task_ID, Start_Date) ORDER BY Start_Date) AS ProjectGroup
    FROM Projects
),
ProjectBoundaries AS (
    SELECT 
        MIN(Start_Date) AS ProjectStart,
        MAX(End_Date) AS ProjectEnd,
        COUNT(*) AS Duration
    FROM ProjectGroups
    GROUP BY ProjectGroup
)
SELECT 
    ProjectStart,
    ProjectEnd
FROM ProjectBoundaries
ORDER BY 
    Duration ASC,
    ProjectStart ASC;
```


## Task 2

```sql
SELECT s1.Name
FROM Students s1
JOIN Friends f ON s1.ID = f.ID
JOIN Packages p1 ON s1.ID = p1.ID
JOIN Packages p2 ON f.Friend_ID = p2.ID
WHERE p2.Salary > p1.Salary
ORDER BY p2.Salary;
```
## Task 3
```sql
SELECT f1.X, f1.Y
FROM Functions f1
JOIN Functions f2 ON f1.X = f2.Y AND f1.Y = f2.X
WHERE f1.X <= f1.Y
ORDER BY f1.X;

```

## Task 4
```sql
SELECT 
    c.contest_id,
    c.hacker_id,
    c.name,
    COALESCE(SUM(s.total_submissions), 0) AS total_submissions,
    COALESCE(SUM(s.total_accepted_submissions), 0) AS total_accepted_submissions,
    COALESCE(SUM(v.total_views), 0) AS total_views,
    COALESCE(SUM(v.total_unique_views), 0) AS total_unique_views
FROM 
    Contests c
LEFT JOIN 
    Challenges ch ON c.contest_id = ch.contest_id
LEFT JOIN 
    Submission_Stats s ON ch.challenge_id = s.challenge_id
LEFT JOIN 
    View_Stats v ON ch.challenge_id = v.challenge_id
GROUP BY 
    c.contest_id, c.hacker_id, c.name
HAVING 
    total_submissions > 0 OR
    total_accepted_submissions > 0 OR
    total_views > 0 OR
    total_unique_views > 0
ORDER BY 
    c.contest_id;

```
## Task 5
```sql
WITH daily_submissions AS (
    SELECT 
        submission_date,
        hacker_id,
        COUNT(submission_id) AS submissions_count
    FROM 
        Submissions
    GROUP BY 
        submission_date, hacker_id
),
daily_max_submissions AS (
    SELECT 
        submission_date,
        MIN(hacker_id) AS hacker_id,
        MAX(submissions_count) AS max_submissions
    FROM 
        daily_submissions
    GROUP BY 
        submission_date
)
SELECT 
    ds.submission_date,
    COUNT(DISTINCT ds.hacker_id) AS unique_hackers,
    dms.hacker_id,
    h.name
FROM 
    daily_submissions ds
JOIN 
    daily_max_submissions dms
    ON ds.submission_date = dms.submission_date
    AND ds.hacker_id = dms.hacker_id
JOIN 
    Hackers h
    ON dms.hacker_id = h.hacker_id
GROUP BY 
    ds.submission_date, dms.hacker_id, h.name
ORDER BY 
    ds.submission_date;

```
## Task 6
```sql
SELECT 
    ROUND(
        ABS(MIN(LAT_N) - MAX(LAT_N)) + ABS(MIN(LONG_W) - MAX(LONG_W)),
        4
    ) AS ManhattanDistance
FROM 
    STATION;

```
## Task 7

### For PostgreSQL:
```sql

-- Create a function to check if a number is prime
CREATE OR REPLACE FUNCTION is_prime(n INT) RETURNS BOOLEAN AS $$
DECLARE
    i INT;
BEGIN
    IF n < 2 THEN
        RETURN FALSE;
    END IF;
    FOR i IN 2..sqrt(n)::INT LOOP
        IF n % i = 0 THEN
            RETURN FALSE;
        END IF;
    END LOOP;
    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;

-- Query to get all prime numbers and concatenate them with '&' separator
WITH primes AS (
    SELECT generate_series(2, 1000) AS num
    WHERE is_prime(generate_series(2, 1000))
)
SELECT string_agg(num::TEXT, '&') AS prime_numbers
FROM primes;

```

For SQL Server:
```sql
-- Create a function to check if a number is prime
CREATE FUNCTION dbo.is_prime (@n INT)
RETURNS BIT
AS
BEGIN
    DECLARE @i INT;
    IF @n < 2
        RETURN 0;
    SET @i = 2;
    WHILE @i <= SQRT(@n)
    BEGIN
        IF @n % @i = 0
            RETURN 0;
        SET @i = @i + 1;
    END;
    RETURN 1;
END;
GO

-- Query to get all prime numbers and concatenate them with '&' separator
WITH primes AS (
    SELECT number AS num
    FROM master..spt_values
    WHERE type = 'P' AND number BETWEEN 2 AND 1000 AND dbo.is_prime(number) = 1
)
SELECT STRING_AGG(CAST(num AS VARCHAR), '&') AS prime_numbers
FROM primes;

```
## Task 8
### For SQL Server:
```sql
WITH RankedOccupations AS (
    SELECT 
        Name, 
        Occupation, 
        ROW_NUMBER() OVER (PARTITION BY Occupation ORDER BY Name) AS rn
    FROM 
        OCCUPATIONS
)
SELECT 
    MAX(CASE WHEN Occupation = 'Doctor' THEN Name END) AS Doctor,
    MAX(CASE WHEN Occupation = 'Professor' THEN Name END) AS Professor,
    MAX(CASE WHEN Occupation = 'Singer' THEN Name END) AS Singer,
    MAX(CASE WHEN Occupation = 'Actor' THEN Name END) AS Actor
FROM 
    RankedOccupations
GROUP BY 
    rn
ORDER BY 
    rn;

```

### For PostgreSQL:

```sql 
WITH RankedOccupations AS (
    SELECT 
        Name, 
        Occupation, 
        ROW_NUMBER() OVER (PARTITION BY Occupation ORDER BY Name) AS rn
    FROM 
        OCCUPATIONS
)
SELECT 
    MAX(CASE WHEN Occupation = 'Doctor' THEN Name END) AS Doctor,
    MAX(CASE WHEN Occupation = 'Professor' THEN Name END) AS Professor,
    MAX(CASE WHEN Occupation = 'Singer' THEN Name END) AS Singer,
    MAX(CASE WHEN Occupation = 'Actor' THEN Name END) AS Actor
FROM 
    RankedOccupations
GROUP BY 
    rn
ORDER BY 
    rn;

```
## Task 9
```sql
WITH NodeTypes AS (
    SELECT
        N,
        CASE
            WHEN P IS NULL THEN 'Root'
            WHEN N NOT IN (SELECT P FROM BST WHERE P IS NOT NULL) THEN 'Leaf'
            ELSE 'Inner'
        END AS NodeType
    FROM
        BST
)
SELECT
    N,
    NodeType
FROM
    NodeTypes
ORDER BY N;

```
## Task 10
```sql
WITH LeadManagerCount AS (
    SELECT company_code, COUNT(DISTINCT lead_manager_code) AS total_lead_managers
    FROM Lead_Manager
    GROUP BY company_code
),
SeniorManagerCount AS (
    SELECT company_code, COUNT(DISTINCT senior_manager_code) AS total_senior_managers
    FROM Senior_Manager
    GROUP BY company_code
),
ManagerCount AS (
    SELECT company_code, COUNT(DISTINCT manager_code) AS total_managers
    FROM Manager
    GROUP BY company_code
),
EmployeeCount AS (
    SELECT company_code, COUNT(DISTINCT employee_code) AS total_employees
    FROM Employee
    GROUP BY company_code
)
SELECT 
    c.company_code, 
    c.founder, 
    COALESCE(lm.total_lead_managers, 0) AS total_lead_managers,
    COALESCE(sm.total_senior_managers, 0) AS total_senior_managers,
    COALESCE(m.total_managers, 0) AS total_managers,
    COALESCE(e.total_employees, 0) AS total_employees
FROM 
    Company c
LEFT JOIN 
    LeadManagerCount lm ON c.company_code = lm.company_code
LEFT JOIN 
    SeniorManagerCount sm ON c.company_code = sm.company_code
LEFT JOIN 
    ManagerCount m ON c.company_code = m.company_code
LEFT JOIN 
    EmployeeCount e ON c.company_code = e.company_code
ORDER BY 
    c.company_code;

```
## Task 11
```sql
SELECT s.Name
FROM Students s
JOIN Friends f ON s.ID = f.ID
JOIN Packages p1 ON s.ID = p1.ID
JOIN Packages p2 ON f.Friend_ID = p2.ID
WHERE p2.Salary > p1.Salary
ORDER BY p2.Salary;

```
## Task 12
```sql
SELECT 
    job_family,
    SUM(CASE WHEN country = 'India' THEN cost ELSE 0 END) * 100.0 / SUM(cost) AS india_percentage,
    SUM(CASE WHEN country = 'International' THEN cost ELSE 0 END) * 100.0 / SUM(cost) AS international_percentage
FROM 
    simulation_data
GROUP BY 
    job_family;

```
## Task 13
```sql
SELECT 
    BU,
    month,
    cost * 1.0 / revenue AS cost_revenue_ratio
FROM 
    BU_Financials;

```
## Task 14
```sql
SELECT 
    sub_band,
    COUNT(*) AS headcount,
    COUNT(*) * 100.0 / SUM(COUNT(*)) OVER () AS percentage_headcount
FROM 
    Employees
GROUP BY 
    sub_band;

```
## Task 15
```sql
SELECT 
    TOP 5 * 
FROM 
    Employees 
WHERE 
    salary IN (SELECT DISTINCT TOP 5 salary FROM Employees ORDER BY salary DESC);

```
## Task 16
```sql
UPDATE Employees
SET 
    column1 = column1 + column2,
    column2 = column1 - column2,
    column1 = column1 - column2;

```
## Task 17
```sql
CREATE LOGIN new_user WITH PASSWORD = 'yourpassword';
CREATE USER new_user FOR LOGIN new_user;
ALTER ROLE db_owner ADD MEMBER new_user;

```
## Task 18
```sql
SELECT 
    BU,
    month,
    SUM(cost * weight) / SUM(weight) AS weighted_average_cost
FROM 
    Employee_Costs
GROUP BY 
    BU, month;

```
## Task 19
```sql
SELECT 
    CEILING(AVG(salary) - AVG(CAST(REPLACE(CAST(salary AS VARCHAR), '0', '') AS INT))) AS error_difference
FROM 
    Employees;

```
## Task 20
```sql
INSERT INTO destination_table
SELECT * 
FROM source_table;

```


