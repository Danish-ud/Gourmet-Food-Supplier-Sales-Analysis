create database northwind;
use northwind;

--  IMPOTED ALL TABLES:

select * from categories;
select * from customers;
select * from employees;
select * from order_details;
select * from orders;
select * from products;
select * from shippers;

-- CHECKING FOR DUPLICATES IN EACH TABLE:

select *,count(*)
from categories
group by categoryID,categoryName,description
having count(*)>1 ;

select *,count(*)
from customers
group by customerID, companyName, contactName, contactTitle, city, country
having count(*)> 1; 

select *,count(*)
from employees
group by employeeID, employeeName, title, city, country, reportsTo
having count(*)>1 ;

select *,count(*)
from order_details
group by categoryID,categoryName,description
having count(*)>1 ;

alter table orders
modify column orderDate date;

alter table orders
modify column requiredDate date;

alter table orders
modify column shippedDate date;

select * from orders
where shippedDate is null or shippedDate =' ';
select * from orders
where orderID > 11020 or orderID =11020 ;

SELECT * 
FROM Orders
WHERE ShippedDate IS NULL OR ShippedDate = '' OR ShippedDate = '0000-00-00';

UPDATE Orders
SET ShippedDate = NULL
WHERE ShippedDate = '' OR ShippedDate = '0000-00-00';

UPDATE Orders
SET shippedDate = '2015-04-10'
where orderID = 11008;


set sql_safe_updates =0; 

-- -------------END OF CLEANING DATA ----------------- --

-- EXPLORATORY DATA ANALYSIS (EDA) : 
-- Category table

select c.categoryName,
round(sum(p.unitprice*o.quantity),2)  as Total_Revenue
from categories c
join products p
on c.categoryID = p.categoryID
join order_details o
on p.productID = o.productID
group by categoryName
order by Total_Revenue desc;

-- EDA FROM CUSTOMERs DEMOGRAPHIC :

select
c.companyName,
count(distinct o.orderID) as No_of_orders,
round(sum(od.unitPrice * od.quantity), 2) AS Total_spend
FROM  customers c
join orders o
on c.customerID = o.customerID
join order_details od on o.orderID = od.orderID
group by 
c.companyName
order by Total_spend desc;

select
c.city,
count(distinct o.orderID) as No_of_orders,
round(sum(od.unitPrice * od.quantity), 2) AS Total_spend
FROM  customers c
join orders o
on c.customerID = o.customerID
join order_details od on o.orderID = od.orderID
group by 
c.city
order by Total_spend desc;

-- On employees table 
alter table employees
rename column title to position;

select employeeName, position,
round(sum(unitPrice * quantity), 2) AS Total_revenue_brought
from employees e
join orders o
on e.employeeID = o.employeeID
join order_details od
on o.orderID = od.orderID
group by employeeName,position
order by  Total_revenue_brought desc;

select employeeName, count(distinct(customerID)) as no_of_customers ,count(distinct(orderID)) as no_of_orders 
from employees e
join  orders o
on e.employeeID = o.employeeID
group by employeeName
order by 2 desc;

SELECT 
    employeeName,
    MONTH(o.OrderDate) AS Order_Month,
    ROUND(SUM(od.UnitPrice * od.Quantity), 2) AS Monthly_Revenue
FROM Employees e
JOIN Orders o ON e.EmployeeID = o.EmployeeID
JOIN Order_Details od ON o.OrderID = od.OrderID
GROUP BY employeeName, MONTH(o.OrderDate)
ORDER BY employeeName, Order_Month;

--  On Orders table  :

select year(orderDate) as Year,
month(orderDate) as month, count(distinct(orderID)) as total_orders
from orders
group by year, month
order by year, month;

SELECT 
    OrderID,
    OrderDate,
    RequiredDate,
    ShippedDate,
    DATEDIFF(ShippedDate, RequiredDate) AS Days_Late
FROM Orders
WHERE 
    ShippedDate IS NOT NULL AND 
    RequiredDate IS NOT NULL AND
    ShippedDate > RequiredDate;

SELECT 
    AVG(DATEDIFF(ShippedDate, OrderDate)) AS Avg_Fulfillment_Days
FROM Orders
WHERE ShippedDate IS NOT NULL;

SELECT 
    s.companyName,
    ROUND(AVG(Freight), 2) AS Avg_Freight,
    ROUND(SUM(Freight), 2) AS Total_Freight,
    count(distinct(orderId)) as total_orders
FROM Orders o
join shippers s
on o.shipperID = s.shipperID
GROUP BY companyName
ORDER BY Total_Freight DESC;

-- On products table :

select productName,
round(sum(od.unitPrice * od.quantity), 2) AS Total_revenue
from products p
join order_details od
on p.productID = od.productID 
group by productName
order by Total_revenue desc;

