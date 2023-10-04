--How Many Invoices do we have that are exactly 1.98 or 3.96

SELECT
	InvoiceDate,
	BillingAddress,
	BillingCity,
	total
FROM
	Invoice
WHERE 
	Total IN (1.98,3.96)
ORDER BY
	InvoiceDate 	
