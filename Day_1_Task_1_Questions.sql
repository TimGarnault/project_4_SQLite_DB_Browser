--The questions for Day 1 are as follows:

-- 1.1 Select the names of all the products in the store.
--SELECT DISTINCT Name FROM Products

-- 1.2 Select the names and the prices of all the products in the store.
--SELECT Name, Price FROM Products


-- 1.3 Select the name of the products with a price less than or equal to $200.
--SELECT Name FROM Products
--WHERE Price <= 200

-- 1.4 Select all the products with a price between $60 and $120.
--SELECT Name FROM Products
--WHERE Price BETWEEN 60 AND 120

-- 1.5 Select the name and price in cents (i.e., the price must be multiplied by 100).
--SELECT Name, Price*100 as Price_in_cents FROM Products

-- 1.6 Compute the average price of all the products.
--SELECT avg(Price) as Average_price_all_products FROM Products

-- 1.7 Compute the average price of all products with manufacturer code equal to 2.
--SELECT avg(Price) as Average_price_all_products_manufacturer_2 FROM Products
--where Manufacturer = 2

-- 1.8 Compute the number of products with a price larger than or equal to $180.
--SELECT count(Name) as Amount_of_product_equal_or_above_180$ FROM Products
--where Price >= 180

-- 1.9 Select the name and price of all products with a price larger than or equal to $180, and sort first by price (in descending order), and then by name (in ascending order).
--SELECT Name, Price FROM Products
--where price >= 180 
--ORDER By Price DESC, Name ASC 

-- 1.10 Select all the data from the products, including all the data for each product's manufacturer.
--SELECT Products.*, Manufacturers.Name as Manufacturer_Name
--FROM Products
--JOIN Manufacturers
--ON Manufacturer = Manufacturers.Code

-- 1.11 Select the product name, price, and manufacturer name of all the products.
--SELECT Products.Name as Product_Name, Price, Manufacturers.Name as Manufacturer_Name
--FROM Products
--JOIN Manufacturers
--ON Manufacturer = Manufacturers.Code

-- 1.12 Select the average price of each manufacturer's products, showing only the manufacturer's code.
--SELECT Manufacturer as Manufacturer_code, avg(Price) as Average_Price
--FROM Products
--Group By Manufacturer 

-- 1.13 Select the average price of each manufacturer's products, showing the manufacturer's name.
--SELECT Manufacturers.Name as Manufacturer_Name, avg(Products.Price) as Average_Price
--FROM Products
--JOIN Manufacturers
--ON Products.Manufacturer = Manufacturers.Code
--Group By Manufacturer

-- 1.14 Select the names of manufacturer whose products have an average price larger than or equal to $150.
--SELECT Manufacturers.Name as Manufacturer_Name, avg(Products.Price) as Average_price
--FROM Products
--JOIN Manufacturers
--ON Products.Manufacturer = Manufacturers.Code
--GROUP BY Manufacturer
--HAVING Average_price >= 150

-- 1.15 Select the name and price of the cheapest product.
--SELECT Name, min(Price) as Price
--FROM Products

-- 1.16 Select the name of each manufacturer along with the name and price of its most expensive product.
--SELECT Manufacturers.Name as Manufacturer_Name, Products.Name as Product_Name, max(Price)
--From Products
--JOIN Manufacturers
--ON Products.Manufacturer = Manufacturers.Code
--GROUP BY Manufacturer_name

-- 1.17 Add a new product: Loudspeakers, $70, manufacturer 2.
--INSERT INTO Products(Name,Price,Manufacturer) VALUES('Loudspeakers',70,2);

-- 1.18 Update the name of product 8 to "Laser Printer".
--UPDATE Products 
--SET Name = 'Laser Printer'
--WHERE Products.Code = 8

-- 1.19 Apply a 10% discount to all products.
--UPDATE Products 
--SET Price = Price*0.9

-- 1.20 Apply a 10% discount to all products with a price larger than or equal to $120.
--   setting price back to original value
--   UPDATE Products
--   SET Price = Price/0.9
--UPDATE Products 
--SET Price = Price*0.9
--where price>= 120

