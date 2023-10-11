/*WSDA Music Sales Goal :
They want as many customer as possible to spend b/w $7.00 & $15.00

sales categories:-
Baseline Purchase:- B/W $0.99 and $1.99
Low Purchase:- B/W $2.00 and $6.99
Target Purchase:- B/W $7.00 and $15.00
Top Performer:- Above $15.00

*/

SELECT
	InvoiceDate,
	BillingAddress,
	BillingCity,
	total,
	CASE
	WHEN Total<2.00 THEN "Baseline Purchase"
	WHEN Total BETWEEN 2.00 AND 6.99 THEN "Low Purchase"
	WHEN Total BETWEEN 7.00 AND 15.00 THEN "Target Purchase"
	ELSE "Top Performer"
	END AS "PurchaseType"
FROM
	Invoice
	
WHERE
	PurchaseType="Top Performer"

ORDER BY
	InvoiceDate
