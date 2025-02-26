--Questions
-- 10.1 Join table PEOPLE and ADDRESS, but keep only one address information for each person (we don't mind which record we take for each person). 
    -- i.e., the joined table should have the same number of rows as table PEOPLE
SELECT
	PEOPLE.id AS PeopleID,
	PEOPLE.name AS PeopleName,
	ADDRESS.address AS PeopleAddressAtSomePoint
	--ADDRESS.updatedate
FROM PEOPLE
JOIN ADDRESS
	ON PEOPLE.id = ADDRESS.id
GROUP BY PEOPLE.id;

-- 10.2 Join table PEOPLE and ADDRESS, but ONLY keep the LATEST address information for each person. 
    -- i.e., the joined table should have the same number of rows as table PEOPLE
SELECT DISTINCT
	a.id AS PeopleID,
	a.name AS PeopleName,
	a.LatestAddress AS PeopleLatestAddress
FROM
(SELECT
	PEOPLE.id,
	PEOPLE.name,
	ADDRESS.address,
	ADDRESS.updatedate,
	max(ADDRESS.updatedate) OVER (PARTITION BY PEOPLE.id) AS LatestAddress
FROM PEOPLE
JOIN ADDRESS
	ON PEOPLE.id = ADDRESS.id
	) AS a;
