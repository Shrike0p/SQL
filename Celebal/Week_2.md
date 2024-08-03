# Adventure Works Database Procedures and Functions

## Table of Contents
- [Introduction](#introduction)
- [Procedures](#procedures)
  - [InsertOrderDetails](#insertorderdetails)
  - [UpdateOrderDetails](#updateorderdetails)
  - [GetOrderDetails](#getorderdetails)
  - [DeleteOrderDetails](#deleteorderdetails)
- [Functions](#functions)
  - [FormatDate_MMDDYYYY](#formatdate_mmddyyyy)
  - [FormatDate_YYYYMMDD](#formatdate_yyyymmdd)
- [Views](#views)
  - [vwCustomerOrders](#vwcustomerorders)
  - [vwCustomerOrders_Yesterday](#vwcustomerorders_yesterday)
  - [MyProducts](#myproducts)
- [Triggers](#triggers)
  - [Instead of Delete Trigger](#instead-of-delete-trigger)
  - [Check Stock Before Insert Trigger](#check-stock-before-insert-trigger)

## Introduction
This project contains a set of SQL stored procedures, functions, views, and triggers for managing orders in the Adventure Works database. The procedures cover inserting, updating, retrieving, and deleting order details, while the functions format dates. The views provide detailed order information, and the triggers ensure data integrity and business logic enforcement.

## Procedures

### InsertOrderDetails
Inserts order information into the Order Details table. Ensures sufficient stock and provides messages if operations fail or if stock levels drop below the reorder level.
1. Create a procedure InsertOrderDetails
```sql
CREATE PROCEDURE InsertOrderDetails
    @OrderID INT,
    @ProductID INT,
    @UnitPrice DECIMAL(10, 2) = NULL,
    @Quantity INT,
    @Discount DECIMAL(5, 2) = 0
AS
BEGIN
    DECLARE @ProductUnitPrice DECIMAL(10, 2);
    DECLARE @ProductStock INT;
    DECLARE @ReorderLevel INT;

    -- Get Product details
    SELECT 
        @ProductUnitPrice = UnitPrice,
        @ProductStock = UnitsInStock,
        @ReorderLevel = ReorderLevel
    FROM Product
    WHERE ProductID = @ProductID;

    -- Set UnitPrice to Product UnitPrice if not provided
    IF @UnitPrice IS NULL
    BEGIN
        SET @UnitPrice = @ProductUnitPrice;
    END

    -- Check stock availability
    IF @ProductStock < @Quantity
    BEGIN
        PRINT 'Failed to place the order. Not enough stock.';
        RETURN;
    END

    -- Insert Order Details
    INSERT INTO OrderDetails (OrderID, ProductID, UnitPrice, Quantity, Discount)
    VALUES (@OrderID, @ProductID, @UnitPrice, @Quantity, @Discount);

    -- Check if the insertion was successful
    IF @@ROWCOUNT = 0
    BEGIN
        PRINT 'Failed to place the order. Please try again.';
    END
    ELSE
    BEGIN
        -- Update Product stock
        UPDATE Product
        SET UnitsInStock = UnitsInStock - @Quantity
        WHERE ProductID = @ProductID;

        -- Check Reorder Level
        IF @ProductStock - @Quantity < @ReorderLevel
        BEGIN
            PRINT 'Warning: Product stock has dropped below the Reorder Level.';
        END
    END
END
```
2. Create a procedure UpdateOrderDetails
```sql
CREATE PROCEDURE UpdateOrderDetails
    @OrderID INT,
    @ProductID INT,
    @UnitPrice DECIMAL(10, 2) = NULL,
    @Quantity INT = NULL,
    @Discount DECIMAL(5, 2) = NULL
AS
BEGIN
    DECLARE @CurrentUnitPrice DECIMAL(10, 2);
    DECLARE @CurrentQuantity INT;
    DECLARE @CurrentDiscount DECIMAL(5, 2);

    -- Get current Order Details
    SELECT 
        @CurrentUnitPrice = UnitPrice,
        @CurrentQuantity = Quantity,
        @CurrentDiscount = Discount
    FROM OrderDetails
    WHERE OrderID = @OrderID AND ProductID = @ProductID;

    -- Update with new values or retain original if NULL
    UPDATE OrderDetails
    SET 
        UnitPrice = ISNULL(@UnitPrice, @CurrentUnitPrice),
        Quantity = ISNULL(@Quantity, @CurrentQuantity),
        Discount = ISNULL(@Discount, @CurrentDiscount)
    WHERE OrderID = @OrderID AND ProductID = @ProductID;

    -- Adjust UnitsInStock accordingly
    IF @Quantity IS NOT NULL
    BEGIN
        DECLARE @QuantityDifference INT;
        SET @QuantityDifference = @Quantity - @CurrentQuantity;
        
        UPDATE Product
        SET UnitsInStock = UnitsInStock - @QuantityDifference
        WHERE ProductID = @ProductID;
    END
END

```

3. Create a procedure GetOrderDetails
```sql
CREATE PROCEDURE GetOrderDetails
    @OrderID INT
AS
BEGIN
    IF NOT EXISTS (SELECT * FROM OrderDetails WHERE OrderID = @OrderID)
    BEGIN
        PRINT 'The OrderID ' + CAST(@OrderID AS VARCHAR) + ' does not exist';
        RETURN 1;
    END

    SELECT * FROM OrderDetails WHERE OrderID = @OrderID;
END
```


4. Create a procedure DeleteOrderDetails
```sql
CREATE PROCEDURE DeleteOrderDetails
    @OrderID INT,
    @ProductID INT
AS
BEGIN
    IF NOT EXISTS (SELECT * FROM OrderDetails WHERE OrderID = @OrderID AND ProductID = @ProductID)
    BEGIN
        PRINT 'Invalid OrderID or ProductID';
        RETURN -1;
    END

    DELETE FROM OrderDetails
    WHERE OrderID = @OrderID AND ProductID = @ProductID;

    IF @@ROWCOUNT = 0
    BEGIN
        PRINT 'Failed to delete the order detail';
    END
END
```


5. Create a function to return date in MM/DD/YYYY format
```sql
CREATE FUNCTION FormatDate_MMDDYYYY (@InputDate DATETIME)
RETURNS VARCHAR(10)
AS
BEGIN
    RETURN CONVERT(VARCHAR(10), @InputDate, 101);
END
```

6. Create a function to return date in YYYYMMDD format
```sql
CREATE FUNCTION FormatDate_YYYYMMDD (@InputDate DATETIME)
RETURNS VARCHAR(8)
AS
BEGIN
    RETURN CONVERT(VARCHAR(8), @InputDate, 112);
END
```

## Views
1. Create view vwCustomerOrders
```sql
CREATE VIEW vwCustomerOrders AS
SELECT 
    c.CompanyName,
    o.OrderID,
    o.OrderDate,
    od.ProductID,
    p.ProductName,
    od.Quantity,
    od.UnitPrice,
    od.Quantity * od.UnitPrice AS TotalPrice
FROM 
    Orders o
JOIN 
    OrderDetails od ON o.OrderID = od.OrderID
JOIN 
    Customers c ON o.CustomerID = c.CustomerID
JOIN 
    Products p ON od.ProductID = p.ProductID;
```

2. Create view for orders placed yesterday
```sql
CREATE VIEW vwCustomerOrders_Yesterday AS
SELECT 
    c.CompanyName,
    o.OrderID,
    o.OrderDate,
    od.ProductID,
    p.ProductName,
    od.Quantity,
    od.UnitPrice,
    od.Quantity * od.UnitPrice AS TotalPrice
FROM 
    Orders o
JOIN 
    OrderDetails od ON o.OrderID = od.OrderID
JOIN 
    Customers c ON o.CustomerID = c.CustomerID
JOIN 
    Products p ON od.ProductID = p.ProductID
WHERE 
    CAST(o.OrderDate AS DATE) = CAST(GETDATE() - 1 AS DATE);
```

3. Create view MyProducts
```sql
CREATE VIEW MyProducts AS
SELECT 
    p.ProductID,
    p.ProductName,
    p.QuantityPerUnit,
    p.UnitPrice,
    s.CompanyName,
    c.CategoryName
FROM 
    Products p
JOIN 
    Suppliers s ON p.SupplierID = s.SupplierID
JOIN 
    Categories c ON p.CategoryID = c.CategoryID
WHERE 
    p.Discontinued = 0;
```


## Triggers
1. Create INSTEAD OF DELETE trigger on Orders
```sql
CREATE TRIGGER trgInsteadOfDeleteOrders
ON Orders
INSTEAD OF DELETE
AS
BEGIN
    DELETE FROM OrderDetails
    WHERE OrderID IN (SELECT OrderID FROM deleted);

    DELETE FROM Orders
    WHERE OrderID IN (SELECT OrderID FROM deleted);
END
```


2. Create trigger to check stock before inserting into OrderDetails
```sql
CREATE TRIGGER trgCheckStockBeforeInsert
ON OrderDetails
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @ProductID INT, @Quantity INT, @UnitsInStock INT;

    SELECT @ProductID = ProductID, @Quantity = Quantity FROM inserted;

    SELECT @UnitsInStock = UnitsInStock FROM Products WHERE ProductID = @ProductID;

    IF @UnitsInStock >= @Quantity
    BEGIN
        INSERT INTO OrderDetails (OrderID, ProductID, UnitPrice, Quantity, Discount)
        SELECT OrderID, ProductID, UnitPrice, Quantity, Discount FROM inserted;

        UPDATE Products
        SET UnitsInStock = UnitsInStock - @Quantity
        WHERE ProductID = @ProductID;
    END
    ELSE
    BEGIN
        PRINT 'The order could not be filled because of insufficient stock.';
    END
END
```




