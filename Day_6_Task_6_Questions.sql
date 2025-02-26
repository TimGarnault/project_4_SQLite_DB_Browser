--Questions

-- 6.1 List all the scientists' names, their projects' names, 
    -- and the total hours worked on each project, 
    -- in alphabetical order of project name, then scientist name.
SELECT Scientists.Name As ScientistName, Projects.Name AS ProjectName, AssignedTo.Hours 
FROM Scientists
JOIN AssignedTo
ON Scientists.SSN=AssignedTo.Scientist
JOIN Projects
ON Projects.Code =AssignedTo.Project
ORDER BY ProjectName ASC, ScientistName ASC
	
-- 6.2 Now list the project names and total hours worked on each, from most to least total hours.
SELECT Projects.Name AS ProjectName, AssignedTo.Hours 
FROM Projects
JOIN AssignedTo
ON Projects.Code =AssignedTo.Project
ORDER BY AssignedTo.Hours DESC

-- 6.3 Select the project names which do not have any scientists currently assigned to them.
-- https://www.geeksforgeeks.org/how-to-find-records-from-one-table-which-dont-exist-in-another-sqlite/
SELECT Projects.Name AS ProjectName, Projects.Code
FROM Projects
LEFT JOIN AssignedTo
ON Projects.Code =AssignedTo.Project
WHERE AssignedTo.Project IS NULL