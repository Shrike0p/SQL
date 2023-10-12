--WSDA wants to send the the personalized PostCards to each one of their US-based Customers

Select 
	FirstName,
	LastName,
	Address,
	FirstName||' '||LastName||' '||Address||','||City||' '||State||' '||PostalCode AS 'Mailling List',
	length(PostalCode),
	SUBSTR(PostalCode, 1, 5) AS '5 Digit Postal Code'
	
FROM
	Customer
WHERE
	Country='USA'
