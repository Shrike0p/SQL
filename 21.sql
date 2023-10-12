--WSDA wants to send the the personalized PostCards to each one of their US-based Customers and write the firstname in upper and lastname in lower

Select 
	FirstName,
	LastName,
	Address,
	FirstName||' '||LastName||' '||Address||','||City||' '||State||' '||PostalCode AS 'Mailling List',
	length(PostalCode),
	SUBSTR(PostalCode, 1, 5) AS '5 Digit Postal Code',
	upper(FirstName) AS 'FistName all in Caps',
	lower(LastName) AS 'LastName all in lower'
	
FROM
	Customer
WHERE
	Country='USA'
