create table student(Student_id int primary key,name varchar(40),gender varchar(20));

create database Online_retail_DB

use Online_retail_DB;

CREATE TABLE customer (
    CustomerID INT PRIMARY KEY IDENTITY(1,1),  -- Auto-incrementing ID starting from 1
    FirstName VARCHAR(50),                     
    LastName VARCHAR(50),                      
    Email VARCHAR(150),                        
    Phone VARCHAR(50),                         
    Address VARCHAR(255),                      
    City VARCHAR(50),                          
    State VARCHAR(50),                         
    ZipCode VARCHAR(50),                       
    Country VARCHAR(50),                       
    CreatedAT DATETIME DEFAULT GETDATE()       
);


CREATE TABLE Products(
ProductID int primary key IDENTITY(1,1),
ProductName Varchar(40),
CategoryID INT,
Price DECIMAL(10,2),
Stock INT,
CreatedAT DATETIME DEFAULT GETDATE()
);


create table Categories(
categoryID INT primary key IDENTITY(1,1),
CategoryName varchar(100),
Description varchar(255),
);

create table orders(
OrderID INT primary key identity(1,1),
CustomerID int,
OrderDate DATETIME default GETDATE(),
TotalAmount Decimal(10,2),
foreign key (CustomerID) references customer( CustomerID)
);

create table orderItems(
  OrderItemID int primary key identity(1,1),
  OrderID int,
  ProductID int ,
  Quantity int,
  Price decimal(10,2),
  foreign key (ProductID) REFERENCES Products(ProductID),
  foreign key (OrderID) REFERENCES orders(OrderID)
)

drop table orderItems;

use Online_retail_DB


-- Inserting the data into tables

insert into Categories(CategoryName,Description) values 
('Electronics','Devices and gadgets'),
('Clothing','Apparel and Accessories'),
('Books','Printed and Electronic Books');


insert into Products(ProductName,CategoryID,Price,Stock)
VALUES
('Smartphone',1,699.99,50),
('Laptop',1,999.99,30),
('T-Shirt',2,19.99,100),
('Jeans',2,49.99,60),
('Friction Novel',3,14.99,200),
('Science Journal',3,29.99,150);


insert into customer 
(FirstName,LastName,Email,Phone,Address,City,State,ZipCode,Country)
values('Sammer','Khanna','sammer.khanna@example.com','123-456-7890','123 Elm St.','Springfield','IL','62701','USA'),
('Jane','Smith','jane.Smith@example.com','234-567-8901','456 | oak.St','Madison','WI','53703','USA'),
('harshad','patel','harshad.patel@example.com','345-678-9012','789 Dlal St.','Mumbai','Maharashtra','41520','INDIA');


insert into orders(CustomerID,OrderDate,TotalAmount)
values(1,GETDATE(),719.98),
(2,GETDATE(),49.99),
(3,GETDATE(),44.98);

insert into orderItems (OrderID,ProductID,Quantity,Price) 
values(1,1,1,699.99),
(1,3,1,19.99),
(2,4,1,49.99),
(3,5,1,14.99),
(3,6,1,29.99);




-- Q1 Retrive all order for a specific customer
select * from customer;

SELECT 
    cs.CustomerID,
    o.OrderID,
    cs.FirstName + ' ' + cs.LastName AS FullName,
    o.OrderDate,
    ot.Quantity,
    pr.ProductName,
    ot.Price
FROM customer AS cs
JOIN orders AS o 
    ON cs.CustomerID = o.CustomerID
JOIN OrderItems AS ot 
    ON o.OrderID = ot.OrderID
JOIN Products AS pr 
    ON pr.ProductID = ot.ProductID;


--Q2 Find total Sales of each product 

select p.ProductID,p.ProductName, SUM(ot.Quantity * ot.Price) AS TotalSales
from Products as p
JOIN orderItems as ot 
on ot.ProductID = p.ProductID
group by  p.ProductID,p.ProductName
ORDER BY TotalSales DESC, p.ProductID DESC;


--Q3 Find avg order value == > Average Order Value = Total Revenue ÷ Total Number of Orders 

SELECT 
    AVG(OrderTotal) AS AverageOrderValue
FROM (
    SELECT 
        o.OrderID,
        SUM(ot.Quantity * ot.Price) AS OrderTotal
    FROM Orders AS o
    JOIN OrderItems AS ot 
        ON o.OrderID = ot.OrderID
    GROUP BY o.OrderID
) AS OrderSummary;


--Q4 List the top 5 customer by total Spending

SELECT TOP 5
    cs.FirstName + ' ' + cs.LastName AS FullName,
    SUM(ot.Quantity * ot.Price) AS Total_Spendings
FROM customer AS cs
JOIN orders AS o 
    ON cs.CustomerID = o.CustomerID
JOIN orderItems AS ot 
    ON o.OrderID = ot.OrderID
GROUP BY cs.FirstName, cs.LastName
ORDER BY Total_Spendings DESC;


-- Q5 retrive the most popular product category 

select TOP 1 CategoryName,sum()


SELECT TOP 1 c.CategoryName,
    SUM(ot.Quantity) AS TotalQuantitySold
FROM Categories AS c
JOIN Products AS p 
    ON c.CategoryID = p.CategoryID
JOIN OrderItems AS ot 
    ON p.ProductID = ot.ProductID
GROUP BY c.CategoryName
ORDER BY TotalQuantitySold DESC;


-- Q6 List all the product which is out of stock

select * from Products;
select * from Categories;


select ProductID,ProductName,Stock from Products where Stock=0;

--Q7 Select all the customer who placed order in last 30 days

select * from customer;

SELECT DISTINCT 
    cs.CustomerID,
    cs.FirstName + ' ' + cs.LastName AS FullName,
    cs.Email,cs.Phone
FROM customer cs
JOIN orders o ON cs.CustomerID = o.CustomerID
WHERE o.OrderDate >= DATEADD(DAY, -30, GETDATE());


-- Q7 Calculate the total no of order placed each month

-- here we need order,orderitems,customer,product table here these four tables we needs

SELECT 
    MONTH(o.OrderDate) AS OrderMonth,
    COUNT(oi.OrderID) AS TotalOrderItems
FROM orders AS o
JOIN orderItems AS oi
    ON o.OrderID = oi.OrderID
GROUP BY MONTH(o.OrderDate)
ORDER BY OrderMonth;


-- Q8 Average price of product in each category

SELECT c.CategoryName, 
       AVG(p.Price) AS AvgPrice
FROM Categories c
JOIN Products p 
  ON c.CategoryID = p.CategoryID
GROUP BY c.CategoryName
ORDER BY AvgPrice DESC;


-- Q9 list the customer who has never placed an order

select * from [dbo].[Products]

-- Q10 retrive the total quantity sold for each customer

SELECT 
    c.CustomerID,
    c.FirstName + ' ' + c.LastName AS CustomerName,
    SUM(oi.Quantity) AS TotalQuantitySold
    from customer as c
    JOIN orders as o on c.CustomerID =o.CustomerID
    JOIN orderItems as oi on oi.OrderID = o.OrderID
    group by c.CustomerID,c.FirstName,c.LastName
    order by TotalQuantitySold desc;

select * from customer

select * from orders


select * from [dbo].[Products]


-- 11 Customer who has never placed an order 


select o.OrderID, c.FirstName + ' ' + c.LastName AS CustomerName
from  customer as c 
LEFT JOIN orders as o ON o.CustomerID = c.CustomerID 
where o.OrderID IS NULL;

-- 12 retrive the total Quantity sold for each products

SELECT p.productName,P.Price,
    ot.ProductID,
    SUM(ot.Quantity) AS TotalQuantity
FROM orderItems AS ot
JOIN orders AS o 
    ON ot.OrderID = o.OrderID
JOIN Product AS p
    ON ot.productID = 
GROUP BY ot.ProductID;


use [Online_retail_DB]








