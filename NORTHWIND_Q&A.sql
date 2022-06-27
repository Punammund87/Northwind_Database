Select * FROM Categories

Select * FROM CustomerCustomerDemo -- Empty Table

Select * FROM CustomerDemographics   --Empty table

Select * FROM Customers

Select * FROM Employees

Select * FROM EmployeeTerritories

Select * FROM Orders

Select * FROM [Order Details]

Select * FROM Products

Select * FROM Region

Select * FROM Shippers

Select * FROM Suppliers

Select * FROM Territories


--1. Write a query to get Product name and quantity/unit 

Select ProductName, QuantityPerUnit FROM Products


--Write a query to get current Product list (Product ID and name)
Select ProductID, ProductName FROM Products
Order by ProductID 


--Write a query to get discontinued Product list (Product ID and name)

Select ProductID, ProductName, Discontinued FROM Products
where Discontinued = 1
Order by ProductID 

 -- Also
Select ProductID, ProductName FROM Products
where Discontinued = 1
Order by ProductID 

--23. List all products that need to be re-ordered. Do not include discontinued products in this report.
Select ProductID, ProductName FROM Products
where Discontinued = 0
Order by ProductID

--Write a query to get most expense and least expensive Product list (name and unit price)

Select ProductID, ProductName, UnitPrice FROM Products
where Discontinued = 1
Order by ProductID 


--5. Write a query to get Product list (id, name, unit price) where current products cost less than $20
Select ProductID, ProductName, UnitPrice FROM Products
where UnitPrice < 20
Order by ProductID 

--6. Write a query to get Product list (id, name, unit price) where products cost between $15 and $25
Select ProductID, ProductName, UnitPrice FROM Products
where UnitPrice between 15 and 25
Order by ProductID 


--7. Write a query to get Product list (name, unit price) of above average price
Select ProductID, ProductName, UnitPrice FROM Products
where UnitPrice > (SELECT Avg(UnitPrice) FROM Products)
Order by ProductID 


--8. Write a query to get Product list (name, unit price) of ten most expensive products

Select TOP 10 ProductID, ProductName AS [Top 10 expensive Products] , UnitPrice FROM Products
Order by UnitPrice DESC

--9. Write a query to count current and discontinued products

Select Discontinued, COUNT(ProductID) AS [count] FROM Products
GROUP BY Discontinued 


--10. Write a query to get Product list (name, units on order , units in stock) of stock is less than the quantity on order

Select ProductID, ProductName, UnitsOnOrder, UnitsInStock FROM Products
where UnitsInStock < UnitsOnOrder
Order by ProductID 

--1. How many customers do we have in our database?
SELECT COUNT(CustomerID)  FROM Customers

--2.    How many of our customer names begin with the letter "b"?

SELECT COUNT(ContactName)  FROM Customers
WHERE ContactName like 'b%'

--3.    How many of our customer names contain the letter "s" ?
SELECT COUNT(ContactName)  FROM Customers
WHERE ContactName like '%s%'

--4.    How many customers do we have in each city?
SELECT City, COUNT(CustomerID) AS number_of_Customer FROM Customers
GROUP BY City

--5.    What are the top three cities where we have our most customers?
SELECT TOP 3 City, COUNT(CustomerID) AS number_of_Customer FROM Customers
GROUP BY City
Order by number_of_Customer DESC

--6.    Who has been our top customer - please list CustomerID, CompanyName, ContactName for the customer that we have sold the most to?
SELECT cu.CustomerID,  COUNT(o.OrderID) AS [How often Purchased]
FROM Customers cu 
JOIN Orders o
ON cu.CustomerID = o.CustomerID
GROUP BY cu.CustomerID
ORDER BY [How often Purchased] DESC

--Also
SELECT TOP 10 cu.CustomerID,  COUNT(o.OrderID) AS [How often Purchased]
FROM Customers cu 
JOIN Orders o
ON cu.CustomerID = o.CustomerID
GROUP BY cu.CustomerID
ORDER BY [How often Purchased] DESC
--cu.CompanyName, cu.ContactName ??? how to incluse these

--7.    Who has been our top customer - please list CustomerID, CompanyName in the year 1997?

SELECT cu.CustomerID,  COUNT(o.OrderID) AS [How often Purchased]
FROM Customers cu 
JOIN Orders o
ON cu.CustomerID = o.CustomerID
WHERE YEAR(o.OrderDate)=1997
GROUP BY cu.CustomerID
ORDER BY [How often Purchased] DESC

--8.    Name the top 3 countries that we ship our orders to?

SELECT shipCountry, COUNT(OrderID) AS Total_No_of_orders
FROM Orders
Group By ShipCountry
Order By Total_No_of_orders DESC

--Also
SELECT TOP 3 shipCountry, COUNT(OrderID) AS Total_No_of_orders
FROM Orders
Group By ShipCountry
Order By Total_No_of_orders DESC

--9.    Which shipper do we use the most to ship our orders out through?

SELECT COUNT(o.OrderID) AS Total_Orders, sh.CompanyName 
FROM Orders o 
JOIN Shippers sh
ON sh.ShipperID = o.ShipVia
GROUP BY sh.CompanyName
ORDER BY Total_Orders  DESC

--10. List the following employee information (EmployeeID, LastName, FirstName, ManagerLastName, ManagerFirstName)

SELECT e.EmployeeID, e.FirstName, e.LastName, 
m.EmployeeID AS Managers_ID, m.FirstName AS Managers_FirstName, m.LastName AS Managers_LastName
FROM Employees e, Employees m
WHERE e.ReportsTo = m.EmployeeID

--11. What are the last names of all employees who were born in the month of November?
SELECT LastName, BirthDate FROM EMployees 
WHERE YEAR(BirthDate) = 1963

SELECT LastName, BirthDate FROM EMployees 
WHERE MONTH(BirthDate) = 11
--12. List each employee (lastname, firstname, territory) 
--and sort the list by territory and then by employee last name. 
--Remember employees may work for more than one territory.

SELECT e.EmployeeID, e.FirstName, e.LastName, t.TerritoryDescription
FROM Employees e JOIN EmployeeTerritories et 
ON e.EmployeeID = et.EmployeeID
JOIN Territories t
ON t.TerritoryID = et.TerritoryID
ORDER BY t.TerritoryDescription, e.LastName

--Also 
SELECT e.EmployeeID, e.FirstName + ' ' + e.LastName AS FullName, t.TerritoryDescription
FROM Employees e JOIN EmployeeTerritories et 
ON e.EmployeeID = et.EmployeeID
JOIN Territories t
ON t.TerritoryID = et.TerritoryID
ORDER BY t.TerritoryDescription, FullName

--13. In terms of sales value, what has been our best selling product of all time?
SELECT p.ProductName, COUNT(o.OrderID) AS Total_no_of_orders
FROM Products p JOIN [Order Details] od
ON p.ProductID = od.productID
JOIN Orders o 
ON od.OrderID = o.OrderID
GROUP BY ProductName
ORDER BY Total_no_of_orders DESC


--14. In terms of sales value, and only include products 
--that have at least been sold once, which has been our worst selling product
-- of all time?

Select od.OrderID, p.ProductName, od.Quantity, SUM(od.UnitPrice * od.Quantity *(1-od.Discount)) AS Total_sales  
FROM  Products p 
JOIN  [Order Details] od
ON p.ProductID = od.ProductID
JOIN Orders o 
ON o.OrderID = od.OrderID
WHERE od.Quantity = 1
GROUP BY od.Quantity, od.OrderID, p.ProductName
ORDER BY Total_sales

--15. In terms of sales value, which month has been traditionally best for sales?
SELECT Month(o.OrderDate), SUM(od.UnitPrice * od.Quantity *(1-od.Discount)) AS Total_sales
FROM Orders o 
JOIN [Order Details] od 
ON o.OrderID = od.OrderID
GROUP BY Month(o.OrderDate)
ORDER BY Total_sales DESC 


--16. What is the name of our best sales person?
SELECT e.EmployeeID, COUNT(o.OrderID) AS Total_Orders
FROM Employees e JOIN Orders o
ON e.EmployeeID = o.EmployeeID
GROUP BY e.EmployeeID
ORDER BY Total_Orders DESC


SELECT * FROM Employees
WHERE EmployeeID = 4


--17. Product report (productID, ProductName, Supplier Name, Product Category). 
--Order the list by product category.

SELECT p.productID, p.ProductName, c.CategoryName, s.CompanyName
FROM Products p JOIN Suppliers s ON p.SupplierID = s.SupplierID
Join Categories c ON c.CategoryID = p.CategoryID
ORDER BY c.CategoryName


--18. Produce a count of the employees by each sales region
SELECT Region, COUNT(EmployeeID) AS Total_Employees
FROM Employees
GROUP BY Region

--19. List the dollar values for sales by region?

SELECT Distinct ShipRegion FROM Orders 

SELECT  o.ShipRegion, FORMAT(SUM(od.UnitPrice * od.Quantity*(1-od.Discount)), 'c', 'en-us') AS Sale 
FROM [Order Details] od
JOIN ORDERS o
ON o.OrderID = od.OrderID
GROUP BY o.ShipRegion


--20. What is the average value of a sales order?

SELECT OrderID, ProductID, Unitprice, Quantity, Discount, UnitPrice*Quantity*(1-Discount) AS Sale  FROM [Order Details]

SELECT SUM(UnitPrice*Quantity*(1-Discount)) AS TotalSale  FROM [Order Details]

SELECT AVG(UnitPrice*Quantity*(1-Discount)) AS AverageSale  FROM [Order Details]

--21. List orders (OrderID, OrderDate, Customer Name) where the total order value is greater than the average value of a sales order?

SELECT o.OrderID, o.OrderDate, c.ContactName, od.Unitprice, od.Quantity, od.Discount, od.UnitPrice * od.Quantity *(1-od.Discount) AS sales
FROM [Order Details] od
JOIN Orders o
ON o.OrderID = od.OrderID
JOIN Customers c
ON c.CustomerID = o.CustomerID
WHERE od.UnitPrice * od.Quantity *(1-od.Discount) > (Select AVG(UnitPrice * Quantity *(1-Discount)) FROM [Order Details])

--22. Produce a customer report (must also include those we have not yet done business with) 
--showing CustomerID, Customer name and total sales made to that customer

SELECT c.CustomerID, c.ContactName, SUM(od.UnitPrice * od.Quantity *(1-od.Discount)) AS Total_sales
FROM Customers c
JOIN Orders o
ON c.CustomerID = o.CustomerID
JOIN [Order Details] od
ON od.OrderID = o.OrderID
GROUP BY  c.CustomerID, c.ContactName 
Order by c.ContactName


--24. List all customers that we made a sale to in the year 1996
SELECT c.CustomerID, o.OrderDate 
FROM Orders o
JOIN Customers c
ON c.CustomerID = o.CustomerID
WHERE YEAR(o.OrderDate) = 1996

--25. List all customers that we did not make a sale to in the year 1996

SELECT c.CustomerID, o.OrderDate 
FROM Orders o
JOIN Customers c
ON c.CustomerID = o.CustomerID
WHERE NOT YEAR(o.OrderDate) = 1996




