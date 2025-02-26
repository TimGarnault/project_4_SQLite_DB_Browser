Questions
-- 7.1 Who received a 1.5kg package?
    -- (The result is "Al Gore's Head").
SELECT Package.Weight, Client.Name
FROM Package
JOIN Client
ON Package.Recipient=Client.AccountNumber
Where Package.Weight=1.5

-- 7.2 What is the total weight of all the packages that they sent?
SELECT sum(Package.Weight) AS AllPackageTotalWeight
FROM Package

-- Optional questions

-- 7.3 Retrieve the names of employees who have clearance level 4 or higher.
SELECT Employee.Name AS EmployeeName, Has_Clearance.Level
FROM Employee
JOIN Has_Clearance
ON Employee.EmployeeID = Has_Clearance.Employee
WHERE Has_Clearance.Level >= 4

-- 7.4 Rank the employees based on their salary in descending order, showing their names and positions alongside their rank. (Try using a Window Function if you are up to the challenge!)
SELECT Employee.Name AS EmployeeName, Employee.Position, RANK() OVER (ORDER BY Employee.Salary DESC) AS Rank
FROM Employee

-- 7.5 Create a CTE to calculate the total weight of packages sent to each planet, then join it with the Planet table to display the planet names and their corresponding total weights.
WITH cte_test AS(SELECT Shipment.Planet AS S_Planet_ID, Package.Weight AS WeightPackage
FROM Shipment
JOIN Package
ON Package.shipment=Shipment.ShipmentID
)
SELECT Planet.Name AS PlanetName, sum(cte_test.WeightPackage) AS SumWeightPackage
FROM cte_test
JOIN Planet
ON Planet.PlanetID=cte_test.S_Planet_ID
GROUP BY Planet.Name

-- 7.6 Retrieve the names of employees who have shipped packages to planets that no other employee has shipped to.
SELECT Shipment.Planet AS ShippedPlanetID, Employee.Name AS Employee_Name
FROM Package
LEFT JOIN Shipment
ON Package.Shipment = Shipment.ShipmentID
JOIN Employee
ON Package.Sender=Employee.EmployeeID
GROUP BY ShippedPlanetID
HAVING count(Package.Sender) = 1
ORDER BY Package.Sender

-- 7.7 Retrieve the names of planets along with the number of shipments made to each planet, but exclude planets where the total weight of packages sent is less than 20 units.
WITH Planet_Min20Unit_CountShip AS (SELECT Shipment.Planet, count(Shipment.ShipmentID) AS ShipmentAmount
FROM Shipment
JOIN Package
ON Package.Shipment= Shipment.ShipmentID
GROUP BY Shipment.Planet
HAVING sum(Package.Weight) >= 20)
SELECT Planet.Name AS PlanetName , Planet_Min20Unit_CountShip.ShipmentAmount
FROM Planet_Min20Unit_CountShip
JOIN Planet
ON Planet_Min20Unit_CountShip.Planet = Planet.PlanetID
