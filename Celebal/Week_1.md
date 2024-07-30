1. List of all customers
``SELECT * 
FROM Sales.Customer;``

2. List of all customers where company name ends in 'N'
```
SELECT * 
FROM Sales.Customer
WHERE CompanyName LIKE '%N';
```

3. List of all customers who live in Berlin or London
```
SELECT * 
FROM Sales.Customer
WHERE City IN ('Berlin', 'London');

```

4. List of all customers who live in UK or USA
```
SELECT * 
FROM Sales.Customer
WHERE CountryRegion IN ('UK', 'USA');

```
5. List of all products sorted by product name
```
SELECT * 
FROM Production.Product
ORDER BY Name;

```
6. List of all products where product name starts with 'A'
```
SELECT * 
FROM Production.Product
WHERE Name LIKE 'A%';
```

7. List of customers who ever placed an order
```

SELECT DISTINCT c.CustomerID, c.CompanyName
FROM Sales.Customer c
JOIN Sales.SalesOrderHeader s ON c.CustomerID = s.CustomerID;
```

8. List of customers who live in London and have bought 'Chai'
```
SELECT DISTINCT c.CustomerID, c.CompanyName
FROM Sales.Customer c
JOIN Sales.SalesOrderHeader s ON c.CustomerID = s.CustomerID
JOIN Sales.SalesOrderDetail d ON s.SalesOrderID = d.SalesOrderID
JOIN Production.Product p ON d.ProductID = p.ProductID
WHERE c.City = 'London' AND p.Name = 'Chai';

```

9. List of customers who never placed an order
```
SELECT c.CustomerID, c.CompanyName
FROM Sales.Customer c
LEFT JOIN Sales.SalesOrderHeader s ON c.CustomerID = s.CustomerID
WHERE s.SalesOrderID IS NULL;

```
10. List of customers who ordered 'Tofu'
```
SELECT DISTINCT c.CustomerID, c.CompanyName
FROM Sales.Customer c
JOIN Sales.SalesOrderHeader s ON c.CustomerID = s.CustomerID
JOIN Sales.SalesOrderDetail d ON s.SalesOrderID = d.SalesOrderID
JOIN Production.Product p ON d.ProductID = p.ProductID
WHERE p.Name = 'Tofu';

```
11. Details of the first order of the system
```
SELECT TOP 1 *
FROM Sales.SalesOrderHeader
ORDER BY OrderDate;

```

12. Find the details of the most expensive order date
```
SELECT TOP 1 OrderDate
FROM Sales.SalesOrderHeader
ORDER BY TotalDue DESC;

```
13. For each order, get the OrderID and Average quantity of items in that order
```
SELECT s.SalesOrderID, AVG(d.OrderQty) AS AvgQuantity
FROM Sales.SalesOrderHeader s
JOIN Sales.SalesOrderDetail d ON s.SalesOrderID = d.SalesOrderID
GROUP BY s.SalesOrderID;

```
14. For each order, get the OrderID, minimum quantity, and maximum quantity for that order
```
SELECT s.SalesOrderID, MIN(d.OrderQty) AS MinQuantity, MAX(d.OrderQty) AS MaxQuantity
FROM Sales.SalesOrderHeader s
JOIN Sales.SalesOrderDetail d ON s.SalesOrderID = d.SalesOrderID
GROUP BY s.SalesOrderID;

```

15. Get a list of all managers and the total number of employees who report to them

```
SELECT e.ManagerID, e.FirstName + ' ' + e.LastName AS ManagerName, COUNT(emp.EmployeeID) AS NumberOfReports
FROM HumanResources.Employee e
JOIN HumanResources.Employee emp ON e.EmployeeID = emp.ManagerID
GROUP BY e.ManagerID, e.FirstName, e.LastName;

```

16. Get the OrderID and the total quantity for each order that has a total quantity of greater than 300
```
SELECT s.SalesOrderID, SUM(d.OrderQty) AS TotalQuantity
FROM Sales.SalesOrderHeader s
JOIN Sales.SalesOrderDetail d ON s.SalesOrderID = d.SalesOrderID
GROUP BY s.SalesOrderID
HAVING SUM(d.OrderQty) > 300;

``` 

17. List of all orders placed on or after 1996/12/31
```
SELECT *
FROM Sales.SalesOrderHeader
WHERE OrderDate >= '1996-12-31';

```
18. List of all orders shipped to Canada
```
SELECT *
FROM Sales.SalesOrderHeader
WHERE ShipCountry = 'Canada';

```

19. List of all orders with order total > 200
```
SELECT *
FROM Sales.SalesOrderHeader
WHERE TotalDue > 200;

```
20. List of countries and sales made in each country
```
SELECT ShipCountry AS Country, SUM(TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader
GROUP BY ShipCountry;

```
21. List of Customer ContactName and number of orders they placed
```
SELECT c.ContactName, COUNT(s.SalesOrderID) AS NumberOfOrders
FROM Sales.Customer c
JOIN Sales.SalesOrderHeader s ON c.CustomerID = s.CustomerID
GROUP BY c.ContactName;

```
22. List of customer contact names who have placed more than 3 orders
```
SELECT c.ContactName
FROM Sales.Customer c
JOIN Sales.SalesOrderHeader s ON c.CustomerID = s.CustomerID
GROUP BY c.ContactName
HAVING COUNT(s.SalesOrderID) > 3;

```
23. List of discontinued products which were ordered between 1/1/1997 and 1/1/1998
```
SELECT DISTINCT p.Name
FROM Production.Product p
JOIN Sales.SalesOrderDetail d ON p.ProductID = d.ProductID
JOIN Sales.SalesOrderHeader s ON d.SalesOrderID = s.SalesOrderID
WHERE p.DiscontinuedDate IS NOT NULL
AND s.OrderDate BETWEEN '1997-01-01' AND '1998-01-01';

```
24. List of employee first name, last name, supervisor's first name, and last name
```
SELECT e.FirstName AS EmployeeFirstName, e.LastName AS EmployeeLastName,
       s.FirstName AS SupervisorFirstName, s.LastName AS SupervisorLastName
FROM HumanResources.Employee e
LEFT JOIN HumanResources.Employee s ON e.ManagerID = s.EmployeeID;
```

25. List of Employees ID and total sales conducted by employee
```
SELECT e.EmployeeID, SUM(s.TotalDue) AS TotalSales
FROM HumanResources.Employee e
JOIN Sales.SalesOrderHeader s ON e.EmployeeID = s.SalesPersonID
GROUP BY e.EmployeeID;

```
26. List of employees whose FirstName contains the character 'a'
```
SELECT *
FROM HumanResources.Employee
WHERE FirstName LIKE '%a%';

```

27. List of managers who have more than four people reporting to them
```
SELECT e.ManagerID, e.FirstName + ' ' + e.LastName AS ManagerName, COUNT(emp.EmployeeID) AS NumberOfReports
FROM HumanResources.Employee e
JOIN HumanResources.Employee emp ON e.EmployeeID = emp.ManagerID
GROUP BY e.ManagerID, e.FirstName, e.LastName
HAVING COUNT(emp.EmployeeID) > 4;

```

28. List of Orders and ProductNames
```
SELECT s.SalesOrderID, p.Name AS ProductName
FROM Sales.SalesOrderHeader s
JOIN Sales.SalesOrderDetail d ON s.SalesOrderID = d.SalesOrderID
JOIN Production.Product p ON d.ProductID = p.ProductID;

```
29. List of orders placed by the best customer
```
-- Assuming the 'best customer' is the one with the highest total sales
WITH CustomerSales AS (
    SELECT c.CustomerID, SUM(s.TotalDue) AS TotalSales
    FROM Sales.Customer c
    JOIN Sales.SalesOrderHeader s ON c.CustomerID = s.CustomerID
    GROUP BY c.CustomerID
)
SELECT s.SalesOrderID
FROM Sales.SalesOrderHeader s
JOIN Sales.Customer c ON s.CustomerID = c.CustomerID
JOIN CustomerSales cs ON cs.CustomerID = c.CustomerID
WHERE cs.TotalSales = (SELECT MAX(TotalSales) FROM CustomerSales);

```
30. List of orders placed by customers who do not have a Fax number
```
SELECT s.SalesOrderID
FROM Sales.SalesOrderHeader s
JOIN Sales.Customer c ON s.CustomerID = c.CustomerID
WHERE c.Fax IS NULL OR c.Fax = '';

```
31. List of Postal codes where the product 'Tofu' was shipped
```
SELECT DISTINCT s.ShipPostalCode
FROM Sales.SalesOrderHeader s
JOIN Sales.SalesOrderDetail d ON s.SalesOrderID = d.SalesOrderID
JOIN Production.Product p ON d.ProductID = p.ProductID
WHERE p.Name = 'Tofu';

```

32. List of product names that were shipped to France
```
SELECT DISTINCT p.Name
FROM Production.Product p
JOIN Sales.SalesOrderDetail d ON

```

33. List of ProductNames and Categories for the supplier ‘Specialty Biscuits, Ltd.
```
SELECT p.Name AS ProductName, c.Name AS CategoryName
FROM Production.Product p
JOIN Production.ProductCategory c ON p.ProductCategoryID = c.ProductCategoryID
JOIN Production.ProductVendor pv ON p.ProductID = pv.ProductID
JOIN Purchasing.Vendor v ON pv.VendorID = v.BusinessEntityID
WHERE v.Name = 'Specialty Biscuits, Ltd.';

```

34. List of products that were never ordered
```
SELECT p.Name
FROM Production.Product p
LEFT JOIN Sales.SalesOrderDetail d ON p.ProductID = d.ProductID
WHERE d.SalesOrderID IS NULL;

```
35. List of products where units in stock is less than 10 and units on order are 0
```
SELECT Name
FROM Production.Product
WHERE QuantityInStock < 10 AND QuantityOnOrder = 0;

```
36. List of top 10 countries by sales
```
SELECT TOP 10 s.ShipCountry AS Country, SUM(s.TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader s
GROUP BY s.ShipCountry
ORDER BY TotalSales DESC;

```
37. Number of orders each employee has taken for customers with CustomerIDs between 'A' and 'AO'
```
SELECT e.EmployeeID, COUNT(s.SalesOrderID) AS NumberOfOrders
FROM HumanResources.Employee e
JOIN Sales.SalesOrderHeader s ON e.EmployeeID = s.SalesPersonID
JOIN Sales.Customer c ON s.CustomerID = c.CustomerID
WHERE c.CustomerID BETWEEN 'A' AND 'AO'
GROUP BY e.EmployeeID;

```

38. Order date of the most expensive order
```
SELECT TOP 1 OrderDate
FROM Sales.SalesOrderHeader
ORDER BY TotalDue DESC;

```
39. Product name and total revenue from that product
```
SELECT p.Name AS ProductName, SUM(d.LineTotal) AS TotalRevenue
FROM Production.Product p
JOIN Sales.SalesOrderDetail d ON p.ProductID = d.ProductID
GROUP BY p.Name;

```
40. SupplierID and number of products offered
```
SELECT v.BusinessEntityID AS SupplierID, COUNT(p.ProductID) AS NumberOfProducts
FROM Production.ProductVendor pv
JOIN Production.Product p ON pv.ProductID = p.ProductID
JOIN Purchasing.Vendor v ON pv.VendorID = v.BusinessEntityID
GROUP BY v.BusinessEntityID;

```

41. Top ten customers based on their business
```
SELECT TOP 10 c.CustomerID, c.CompanyName, SUM(s.TotalDue) AS TotalBusiness
FROM Sales.Customer c
JOIN Sales.SalesOrderHeader s ON c.CustomerID = s.CustomerID
GROUP BY c.CustomerID, c.CompanyName
ORDER BY TotalBusiness DESC;

```
42. What is the total revenue of the company
```
SELECT SUM(TotalDue) AS TotalRevenue
FROM Sales.SalesOrderHeader;

```











