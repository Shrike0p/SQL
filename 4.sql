SELECT
  FirstName AS [Customer First Name],
  LastName AS 'Customer Last Name',
  Email AS Email
From
  Customer
ORDER BY
  LastName DESC,
  FirstName ASC
