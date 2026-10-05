CREATE DATABASE sales_performance_dashboard;

USE sales_performance_dashboard;


ALTER TABLE customers MODIFY customerID INT
NOT NULL, ADD PRIMARY KEY (customerID);

ALTER TABLE products MODIFY productID INT 
NOT NULL, ADD PRIMARY KEY (productID);

ALTER TABLE regions MODIFY regionID INT
NOT NULL, ADD PRIMARY KEY (regionID);

ALTER TABLE orders MODIFY orderID INT NOT
 NULL, ADD PRIMARY KEY (orderID);
 
 SET FOREIGN_KEY_CHECKS=1;
 
 ALTER TABLE orders
ADD CONSTRAINT fk_customer
FOREIGN KEY (customerID) REFERENCES
customers(customerID);


ALTER TABLE  orders
 ADD CONSTRAINT fk_product
 FOREIGN KEY (productID) REFERENCES 
 products(productID);
 
 
ALTER TABLE orders
 ADD CONSTRAINT fk_region
 FOREIGN KEY (regionID) REFERENCES
 regions(regionID);
 

--  Monthly Revenue Trends (by month,year)

SELECT
	YEAR(o.OrderDate) AS Year,
    MONTH(o.OrderDate) AS Month,
	ROUND(SUM(o.Quantity * o. Unitprice),2)
    AS TotalRevenue FROM orders o
    GROUP BY Year, Month
    ORDER BY Year, Month;
    
    
    -- Total 10 Customers by Spending
    
SELECT
	customers.Name AS CustomerName,
	 ROUND(SUM(orders.Quantity * orders. UnitPrice) ,2 ) AS TotalSpent
    FROM orders 
    JOIN customers ON orders. CustomerID = customers. CustomerID
    GROUP BY customers.Name
    ORDER BY TotalSpent DESC
    LIMIT 10;
    

-- Regional Performance(total revenue per region)

SELECT
	regions. RegionName AS Region,
    ROUND(SUM(orders. Quantity * orders.UnitPRICE), 2) AS TotalRevenue
    FROM orders
    JOIN regions ON orders.RegionID = regions.RegionID
    GROUP BY regions.RegionName
    ORDER BY TotalRevenue DESC;
    
    
    -- Most Profitable Products (Revenue-Cost)
    
    SELECT
		products.ProductName,
        ROUND(SUM(orders.Quantity * (orders.UnitPrice - products.CostPrice)), 2) AS TotalProfit,
        ROUND(SUM(orders.Quantity * orders. UnitPrice), 2) AS TotalRevenue
	FROM orders
    JOIN products ON orders. productID = products.productID
    GROUP BY products. ProductName
    ORDER BY TotalProfit DESC
    LIMIT 10;
	
        
    -- Customer Segnents(e.g average spend by income level)
    
    SELECT
		customers.IncomeLevel,
        COUNT(DISTINCT customers.customerID) AS TotalCustomers,
        COUNT(orders. OrderID) AS TotalOrders,
        ROUND(SUM(orders.Quantity * orders.UnitPrice), 2) AS TotalRevenue,
        ROUND(AVG(orders.Quantity * orders.UnitPrice), 2) AS AvgOrderValue
	FROM customers
    JOIN orders ON customers. customerID = orders.CustomerID
    GROUP BY customers. IncomeLevel
    ORDER BY TotalRevenue DESC;
    