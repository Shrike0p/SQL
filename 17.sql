--Show first name, last name, invoice details

SELECT
	InvoiceDate,
	BillingAddress,
	BillingCity,
	total
FROM
	Invoice

INNER JOIN
	Customer
ON
	Invoice.CustomerId=Customer.CustomerId
