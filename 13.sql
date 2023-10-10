--Get all invoices were billed after 2010-05-22 and have a ttal of less than 3.00?
SELECT
	InvoiceDate,
	BillingAddress,
	BillingCity,
	total
FROM
	Invoice
WHERE 
	Date(InvoiceDate)>"2010-05-22" AND total<3.00
ORDER BY
	InvoiceDate
