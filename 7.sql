--How Many Invoices Exist Between 1.98 & 5

SELECT
	InvoiceDate,
	BillingAddress,
	BillingCity,
	total
FROM
	Invoice
WHERE 
	Total BETWEEN 1.98 AND 5.00
ORDER BY
	InvoiceDate 	
