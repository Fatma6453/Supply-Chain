select * from Car_SupplyChain

--Total Sales per Customer:
SELECT CustomerID, SUM(Sales) AS TotalSales
FROM Car_SupplyChain
GROUP BY CustomerID
ORDER BY TotalSales DESC;

--Average Discount per Product
SELECT ProductID, ROUND(AVG(Discount), 2) AS AvgDiscount
FROM Car_SupplyChain
GROUP BY ProductID;

 --Top 5 Customers by Sales
 SELECT TOP 5 CustomerID, SUM(Sales) AS TotalSales
FROM Car_SupplyChain
GROUP BY CustomerID
ORDER BY TotalSales DESC;

-- Total Revenue per Product
SELECT ProductID , SUM(Quantity * Sales) AS TotalRevenue
FROM Car_SupplyChain
GROUP BY ProductID
ORDER BY TotalRevenue DESC;

----Total Discount Given per Product:
SELECT ProductID, Round(SUM(Quantity * Discount),2) AS TotalDiscountGiven
FROM Car_SupplyChain
GROUP BY ProductID
ORDER BY TotalDiscountGiven DESC;

--- Monthly Sales Trend:

SELECT YEAR(OrderDate) AS Year, MONTH(OrderDate) AS Month, SUM(Sales) AS TotalSales
FROM Car_SupplyChain
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
ORDER BY Year, Month;

---Customer Feedback Analysis:
SELECT Top 5 CarMaker ,CustomerFeedback AS FeedbackCount
FROM Car_SupplyChain
where CustomerFeedback ='good'
ORDER BY FeedbackCount DESC;

--Top 5  by CarMaker Quantity Sold:
SELECT TOP 5 CarMaker, SUM(Quantity) AS TotalQuantitySold
FROM Car_SupplyChain
GROUP BY CarMaker
ORDER BY TotalQuantitySold DESC;

---Customer Spending Analysis:
SELECT CustomerID, 
       SUM(Quantity * (Sales - Discount)) AS TotalCustomerSpending
FROM Car_SupplyChain
GROUP BY CustomerID
ORDER BY TotalCustomerSpending DESC;

---Analyze total sales and discounts applied based on the car model year.
SELECT CarModelYear, 
       SUM(Quantity * Sales) AS TotalSales, 
       SUM(Quantity * Discount) AS TotalDiscount
FROM Car_SupplyChain
GROUP BY CarModelYear
ORDER BY CarModelYear DESC;

--dentify the top 5 cities based on total sales.
SELECT TOP 5 City, SUM(Quantity * Sales) AS TotalSales
FROM Car_SupplyChain
GROUP BY City
ORDER BY TotalSales DESC;

--Determine how many units of each car color have been sold.
SELECT CarColor, SUM(Quantity) AS TotalQuantitySold
FROM Car_SupplyChain
GROUP BY CarColor
ORDER BY TotalQuantitySold DESC;

-- Sales Performance by Supplier:
SELECT SupplierName, SUM(Quantity * Sales) AS TotalSales
FROM Car_SupplyChain
GROUP BY SupplierName
ORDER BY TotalSales DESC;

--Compare sales amounts with and without discounts to understand the impact of discounts on sales.
SELECT CarModelYear,CarMaker, 
       SUM(Quantity * Sales) AS SalesWithoutDiscount,
       SUM(Quantity * (Sales - Discount)) AS SalesWithDiscount,
       SUM(Quantity * Discount) AS TotalDiscountGiven
FROM Car_SupplyChain
GROUP BY CarModelYear,CarMaker
ORDER BY SalesWithoutDiscount DESC;

--Analyze how sales are distributed across different countries.
SELECT Country, SUM(Quantity * Sales) AS TotalSales
FROM Car_SupplyChain
GROUP BY Country
ORDER BY TotalSales DESC;


--Analyze the growth in sales from month to month.
SELECT YEAR(OrderDate) AS Year, MONTH(OrderDate) AS Month, 
       SUM(Quantity * Sales) AS TotalSales, 
       LAG(SUM(Quantity * Sales), 1) OVER (ORDER BY YEAR(OrderDate), MONTH(OrderDate)) AS PreviousMonthSales,
       (SUM(Quantity * Sales) - LAG(SUM(Quantity * Sales), 1) OVER (ORDER BY YEAR(OrderDate), MONTH(OrderDate))) * 100.0 / LAG(SUM(Quantity * Sales), 1) OVER (ORDER BY YEAR(OrderDate), MONTH(OrderDate)) AS SalesGrowthPercentage
FROM Car_SupplyChain
GROUP BY YEAR(OrderDate), MONTH(OrderDate)
ORDER BY Year, Month;

--Calculate a 3-month moving average for sales to forecast future trends.

WITH MonthlySales AS (
    SELECT YEAR(OrderDate) AS Year, MONTH(OrderDate) AS Month, 
           SUM(Quantity * (Sales - Discount)) AS TotalSales
    FROM Car_SupplyChain
    GROUP BY YEAR(OrderDate), MONTH(OrderDate)
)
SELECT Year, Month, TotalSales,
       AVG(TotalSales) OVER (ORDER BY Year, Month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS MovingAverage
FROM MonthlySales
ORDER BY Year, Month;

--Determine which months have the highest sales and analyze seasonal trends.
SELECT MONTH(OrderDate) AS Month, 
       SUM(Quantity * (Sales - Discount)) AS TotalSales,
       ROUND(AVG(SUM(Quantity * (Sales - Discount))) OVER (PARTITION BY MONTH(OrderDate)), 2) AS AvgMonthlySales
FROM Car_SupplyChain
GROUP BY MONTH(OrderDate)
ORDER BY Month;











