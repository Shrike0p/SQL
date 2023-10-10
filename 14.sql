--Get all invoices who's billing city is starts with P or starts with D
SELECT
	InvoiceDate,
	BillingAddress,
	BillingCity,
	total
FROM
	Invoice
WHERE 
	BillingCity LIKE 'P%' OR BillingCity LIKE 'D%' 
ORDER BY
	InvoiceDate
