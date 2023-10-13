--What are the average invoice totals by billing country and City?

SELECT
	BillingCountry,
	BillingCity,
	round(avg(total),2)
FROM
	Invoice
GROUP BY
	BillingCity, BillingCountry
ORDER BY
	BillingCountry
	
