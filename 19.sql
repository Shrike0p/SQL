--Joining more than 2 table| What employees are responsible for the 10 highest individual sales

SELECT 
	e.FirstName,
	e.LastName,
	e.EmployeeId,
	c.LastName,
	c.FirstName,
	c.SupportRepId,
	i.InvoiceId,
	i.CustomerId,
	i.total
FROM
	Invoice AS i
INNER JOIN
	Customer AS c
ON
	i.CustomerId=c.CustomerId
INNER JOIN
	Employee AS e
ON
	c.SupportRepId=e.EmployeeId
ORDER BY 
	i.total DESC
LIMIT 10
