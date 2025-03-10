--Questions

-- 2.1 Select the last name of all employees.
SELECT LastName
FROM Employees

-- 2.2 Select the last name of all employees, without duplicates.
SELECT DISTINCT LastName
FROM Employees

-- 2.3 Select all the data of employees whose last name is "Smith".
SELECT *
FROM Employees
WHERE LastName = 'Smith'

-- 2.4 Select all the data of employees whose last name is "Smith" or "Doe".
SELECT *
FROM Employees
WHERE LastName = 'Smith' OR LastName = 'Doe'

-- 2.5 Select all the data of employees that work in department 14.
SELECT *
FROM Employees
WHERE Department = 14

-- 2.6 Select all the data of employees that work in department 37 or department 77.
SELECT *
FROM Employees
WHERE Department = 37 OR Department = 77

-- 2.7 Select all the data of employees whose last name begins with an "S".
SELECT *
FROM Employees
WHERE LastName LIKE 'S%'

-- 2.8 Select the sum of all the departments' budgets.
SELECT sum(Budget)
FROM Departments

-- 2.9 Select the number of employees in each department (you only need to show the department code and the number of employees).
SELECT Department as DepartmentCode, count(SSN) as CountEmployee
FROM Employees
GROUP BY Department

-- 2.10 Select all the data of employees, including each employee's department's data.
SELECT Employees.*, Departments.Name, Departments.Budget
FROM Employees
JOIN Departments
ON Employees.Department = Departments.Code

-- 2.11 Select the name and last name of each employee, along with the name and budget of the employee's department.
SELECT Employees.Name as FirstName, Employees.LastName, Departments.Name as DepartmentName, Departments.Budget as DepartmentBudget
FROM Employees
JOIN Departments
ON Employees.Department = Departments.Code

-- 2.12 Select the name and last name of employees working for departments with a budget greater than $60,000.
SELECT Employees.Name as FirstName, Employees.LastName
FROM Employees
JOIN Departments
ON Employees.Department = Departments.Code
WHERE Departments.Budget > 60000

-- 2.13 Select the departments with a budget larger than the average budget of all the departments.
SELECT Name AS DepartmentName
FROM Departments
WHERE Budget > (SELECT avg(Budget) FROM Departments)

-- 2.14 Select the names of departments with more than two employees.
SELECT Departments.Name AS DepartmentName, count(Employees.SSN)
FROM Departments
JOIN Employees
ON Departments.Code = Employees.Department
GROUP BY DepartmentName
HAVING count(Employees.SSN) > 2

-- 2.15 Select the name and last name of employees working for the two departments with lowest budget.
SELECT Employees.Name as FirstName, Employees.LastName
FROM Employees
JOIN (SELECT Code FROM Departments ORDER BY Departments.Budget ASC LIMIT 2) AS two_lowest_budget_code
ON Employees.Department = two_lowest_budget_code.Code

-- 2.16  Add a new department called "Quality Assurance", with a budget of $40,000 and departmental code 11. 
-- And Add an employee called "Mary Moore" in that department, with SSN 847-21-9811.
INSERT INTO Departments(Code,Name,Budget) VALUES(11,'Quality Assurance',40000);

-- 2.17 Reduce the budget of all departments by 10%.
UPDATE Departments
SET Budget = Budget*0.9

-- 2.18 Reassign all employees from the Research department (code 77) to the IT department (code 14).
UPDATE Employees
SET Department = 14
WHERE Department = 77

-- 2.19 Delete from the table all employees in the IT department (code 14).
DELETE FROM Employees
WHERE Department = 14

-- 2.20 Delete from the table all employees who work in departments with a budget greater than or equal to $60,000.
DELETE FROM Employees
WHERE Department = (SELECT Code FROM Departments WHERE Departments.Budget > 60000)

-- 2.21 Delete from the table all employees.
DELETE FROM Employees