--Questions

--3.1 Select all warehouses.
SELECT *
FROM Warehouses

--3.2 Select all boxes with a value larger than $150.
SELECT Code
FROM Boxes
WHERE Value > 150

--3.3 Select all distinct contents in all the boxes.
SELECT DISTINCT Contents
FROM Boxes

--3.4 Select the average value of all the boxes.
SELECT avg(Value) AS Average_Value
FROM Boxes

--3.5 Select the warehouse code and the average value of the boxes in each warehouse.
SELECT Warehouse, avg(Value) AS Average_Value
FROM Boxes
GROUP BY Warehouse

--3.6 Same as previous exercise, but select only those warehouses where the average value of the boxes is greater than 150.
SELECT Warehouse, avg(Value) AS Average_Value
FROM Boxes
GROUP BY Warehouse
HAVING Average_Value > 150

--3.7 Select the code of each box, along with the name of the city the box is located in.
SELECT Boxes.Code, Warehouses.Location
FROM Boxes
JOIN Warehouses
ON Boxes.Warehouse = Warehouses.Code

--3.8 Select the warehouse codes, along with the number of boxes in each warehouse. 
SELECT Warehouse, count(Code) AS NumberOfBoxes
FROM Boxes
GROUP BY Warehouse

--3.9 Select the codes of all warehouses that are saturated (a warehouse is saturated if the number of boxes in it is larger than the warehouse's capacity).
SELECT Boxes.Warehouse
FROM Boxes
JOIN Warehouses
ON Boxes.Warehouse = Warehouses.Code
GROUP BY Warehouse
HAVING count(Boxes.Code) > Warehouses.Capacity

--3.10 Select the codes of all the boxes located in Chicago.
SELECT Boxes.Code
FROM Boxes
JOIN Warehouses
ON Boxes.Warehouse = Warehouses.Code
WHERE Warehouses.Location = 'Chicago'

--3.11 Create a new warehouse in New York with a capacity for 3 boxes.
 INSERT INTO Warehouses(Location,Capacity) VALUES('New York',3);

--3.12 Create a new box, with code "H5RT", containing "Papers" with a value of $200, and located in warehouse 2.
 INSERT INTO Boxes(Code,Contents,Value,Warehouse) VALUES('H5RT','Papers',200,2);

--3.13 Reduce the value of all boxes by 15%.
UPDATE Boxes
SET Value = Value*0.85

--3.14 Delete all records of boxes from saturated warehouses.
DELETE FROM Boxes
WHERE Boxes.Warehouse = (SELECT Boxes.Warehouse
FROM Boxes
JOIN Warehouses
ON Boxes.Warehouse = Warehouses.Code
GROUP BY Warehouse
HAVING count(Boxes.Code) > Warehouses.Capacity)

--3.15 Remove all boxes with a value lower than $100.
DELETE FROM Boxes
WHERE Boxes.Value < 100

--3.16 Add Index for column "Warehouse" in table "boxes"
    -- !!!NOTE!!!: index should NOT be used on small tables in practice
CREATE INDEX IndexWarehouse
ON Boxes (Warehouse);	

--3.17 Print all the existing indexes
-- from https://www.sqlitetutorial.net/sqlite-index/
SELECT 
   type, 
   name, 
   tbl_name, 
   sql
FROM
   sqlite_master
WHERE
   type= 'index';

--3.18 Remove (drop) the index you just created
-- from https://www.sqlitetutorial.net/sqlite-index/sqlite-drop-index/
DROP INDEX IndexWarehouse;