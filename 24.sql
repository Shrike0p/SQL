--What are the average invoice totals by city for only the cities that start with L?

SELECT	
	BillingCity,
	round(avg(total),2)
FROM	
	Invoice
WHERE
	BillingCity LIKE 'L%'
Group BY
	BillingCity
ORDER BY
	BillingCity
