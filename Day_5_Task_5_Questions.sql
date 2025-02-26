--Questions

-- 5.1 Select the name of all the pieces. 
SELECT Pieces.Name
FROM Pieces

-- 5.2  Select all the providers' data. 
SELECT Providers.*
FROM Providers

-- 5.3 Obtain the average price of each piece (show only the piece code and the average price).
SELECT Provides.Piece, avg(Provides.Price) AS AveragePrice
FROM Provides
GROUP BY Provides.Piece

-- 5.4  Obtain the names of all providers who supply piece 1.
SELECT Provides.Provider
FROM Provides
WHERE Provides.Piece = 1

-- 5.5 Select the name of pieces provided by the provider with code "HAL".
SELECT Pieces.Name
FROM Provides
JOIN Pieces
ON Provides.Piece=Pieces.Code
WHERE Provides.Provider='HAL'

-- 5.6 Add an entry to the database to indicate that "Skellington Supplies" (code "TNBC") will provide sprockets (code "1") for 15 cents each.
INSERT INTO Provides(Piece,Provider,Price) VALUES(1,'TNBC',0.15);

-- 5.7 For each piece, find the most expensive offering of that piece and include the piece name, provider name, and price 
SELECT Pieces.Name,Providers.Name, Provides.Price
FROM Pieces
JOIN Provides
ON Provides.Piece=Pieces.Code
JOIN Providers
ON Provides.Provider=Providers.Code
GROUP BY Pieces.Name
HAVING max(Provides.Price)

--(OPTIONAL: As there could be more than one provider who supply the same piece at the most expensive price, 
-- show all providers who supply at the most expensive price).
WITH MaxPrice AS (SELECT Pieces.Name AS PieceName, max(Provides.Price) AS MaxPrice
FROM Provides
JOIN Pieces
ON Provides.Piece=Pieces.Code
GROUP BY Pieces.Name)
SELECT Pieces.Name AS PieceName,Providers.Name AS ProviderName, Provides.Price
FROM Pieces
JOIN Provides
ON Provides.Piece=Pieces.Code
JOIN Providers
ON Provides.Provider=Providers.Code
JOIN MaxPrice 
ON Pieces.Name = MaxPrice.PieceName
AND Provides.Price = MaxPrice.MaxPrice

-- 5.8 Increase all prices by one cent.
UPDATE Provides
SET Price = Price+0.01

-- 5.9 Update the database to reflect that "Susan Calvin Corp." (code "RBT") will not supply bolts (code 4).
DELETE FROM Provides 
WHERE Provides.Provider='RBT' AND Provides.Piece=4

-- 5.10 Update the database to reflect that "Susan Calvin Corp." (code "RBT") will not supply any pieces (the provider should still remain in the database).
DELETE FROM Provides 
WHERE Provides.Provider='RBT'