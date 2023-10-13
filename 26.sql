--What are the average invoice total greater than $5.00 for cities starting with B?

SELECT
	BillingCity
	round(avg(total),2)
	
FROM
	Invoice
WHERE
	BillingCity LIKE 'B%'
GROUP BY 
	BillingCity
HAVING
	avg(total)>5.00
ORDER BY
	BillingCity
