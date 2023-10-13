--What are the average invoices totals greater than $5.00

SELECT
	BillingCity,
	round(avg(total),2)
	
FROM
	Invoice
GROUP BY
	BillingCity
HAVING
	avg(total)>5.00
ORDER BY 
	BillingCity
