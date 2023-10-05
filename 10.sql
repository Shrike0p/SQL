--How many invoices were build to Brussels, Orlando or Paris
SELECT
	InvoiceDate,
	BillingAddress,
	BillingCity,
	total
FROM
	Invoice
WHERE 
	BillingCity IN ('Brussels','Orlando','Paris')
ORDER BY
	InvoiceDate
