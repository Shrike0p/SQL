--How many invoices were build in cities that start with B?
SELECT
	InvoiceDate,
	BillingAddress,
	BillingCity,
	total
FROM
	Invoice
WHERE 
	BillingCity LIKE 'B%'
ORDER BY
	InvoiceDate
