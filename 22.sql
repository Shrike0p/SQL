--What are the avaerage invoices totall by City

SELECT 
	BillingCity,
	AVG(total)
FROM
	Invoice
GROUP BY
	BillingCity
ORDER BY
	BillingCity
