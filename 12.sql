--How many invoices were build in cities that have B anywhere in it's name?
SELECT
	InvoiceDate,
	BillingAddress,
	BillingCity,
	total
FROM
	Invoice
WHERE 
	BillingCity LIKE '%B%'
ORDER BY
	InvoiceDate
