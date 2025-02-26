

Questions
-- 9.1 Give the package name and how many times they're downloaded. Order by highest to lowest number of times downloaded.
WITH Package_DownloadAmount AS(
SELECT DISTINCT
	cran_logs_2015_01_01_.package,
	count(cran_logs_2015_01_01_.download_date) OVER (PARTITION BY cran_logs_2015_01_01_.package) AS DownloadAmount
FROM cran_logs_2015_01_01_)
Select *
FROM Package_DownloadAmount
ORDER BY DownloadAmount DESC

-- 9.2 Give the package ranking (based on how many times it was downloaded) during 9AM to 11AM
WITH Package_DownloadTime_9AM_11AM AS(
SELECT
	cran_logs_2015_01_01_.package,
	cran_logs_2015_01_01_.time
FROM cran_logs_2015_01_01_
WHERE cran_logs_2015_01_01_.time BETWEEN '09:00:00' AND '11:00:00'
ORDER BY cran_logs_2015_01_01_.time DESC)
SELECT DISTINCT
	Package_DownloadTime_9AM_11AM.package,
	count(Package_DownloadTime_9AM_11AM.time) OVER (PARTITION BY Package_DownloadTime_9AM_11AM.package) AS DownloadAmount9AM11AM
FROM Package_DownloadTime_9AM_11AM
ORDER BY DownloadAmount9AM11AM DESC

-- 9.3 How many records (downloads) are from China ("CN") or Japan("JP") or Singapore ("SG")?
SELECT DISTINCT
	cran_logs_2015_01_01_.country,
	count(cran_logs_2015_01_01_.download_date) OVER(PARTITION BY cran_logs_2015_01_01_.country) AS DownloadAmount
FROM cran_logs_2015_01_01_
WHERE cran_logs_2015_01_01_.country in ('JP','SG','CN')

-- 9.4 Print the countries whose downloads are more than the downloads from China ("CN")
WITH 
DownloadsChina AS(SELECT DISTINCT
	count(cran_logs_2015_01_01_.download_date) OVER(PARTITION BY cran_logs_2015_01_01_.country) AS DownloadAmountCN
FROM cran_logs_2015_01_01_
WHERE cran_logs_2015_01_01_.country ='CN'),
DownloadsByCountry AS(SELECT DISTINCT
	cran_logs_2015_01_01_.country,
	count(cran_logs_2015_01_01_.download_date) OVER(PARTITION BY cran_logs_2015_01_01_.country) AS DownloadAmount
FROM cran_logs_2015_01_01_
ORDER BY DownloadAmount DESC)
SELECT DownloadsByCountry.country
FROM DownloadsByCountry
JOIN DownloadsChina
WHERE DownloadsByCountry.DownloadAmount > DownloadsChina.DownloadAmountCN
ORDER BY DownloadsByCountry.DownloadAmount DESC

-- 9.5 Print the length of each package name for packages which appear only once. 
-- In the same query, show the average length of all such packages.
SELECT 
	a.package AS PackageName,
	a.PackageNameLength,
	AVG(PackageNameLength) OVER() AS PackageNameLengthAverage
FROM (
	SELECT DISTINCT
		package,
		CASE 
			WHEN count(package) OVER(PARTITION BY package) = 1 THEN "YES"
			ELSE "NO"
		END AS SinglePackage,
		length (package) AS PackageNameLength
	FROM cran_logs_2015_01_01_
	) AS a
WHERE a.SinglePackage = "YES"

-- 9.6 Get the package whose download count ranks 2nd (print package name and its download count).
SELECT 
	a.PackageName,
	a.DownloadAmount2 AS DownloadCount
FROM (
WITH Package_DownloadAmount AS(
SELECT DISTINCT
	cran_logs_2015_01_01_.package,
	count(cran_logs_2015_01_01_.download_date) OVER (PARTITION BY cran_logs_2015_01_01_.package) AS DownloadAmount
FROM cran_logs_2015_01_01_)
SELECT 
	Package_DownloadAmount.package AS PackageName,
	Package_DownloadAmount.DownloadAmount AS DownloadAmount2,
	RANK() OVER(ORDER BY DownloadAmount DESC) AS DownloadAmountRank
FROM Package_DownloadAmount
	) AS a
WHERE a.DownloadAmountRank = 2

-- 9.7 Print the name of the package whose download count is bigger than 1000.
SELECT 
	a.PackageName,
	a.DownloadAmount2 AS DownloadCount
FROM (
WITH Package_DownloadAmount AS(
SELECT DISTINCT
	cran_logs_2015_01_01_.package,
	count(cran_logs_2015_01_01_.download_date) OVER (PARTITION BY cran_logs_2015_01_01_.package) AS DownloadAmount
FROM cran_logs_2015_01_01_)
SELECT 
	Package_DownloadAmount.package AS PackageName,
	Package_DownloadAmount.DownloadAmount AS DownloadAmount2
--	RANK() OVER(ORDER BY DownloadAmount DESC) AS DownloadAmountRank
FROM Package_DownloadAmount
ORDER BY DownloadAmount2 DESC
	) AS a
WHERE a.DownloadAmount2 > 1000

-- 9.8 The field "r_os" is the operating system of the users.
-- Here we would like to know what main system we have (ignore version number), 
--		the relevant counts, and the proportion (in percentage).
--Hint: to write a query which can ignore the version number, 
--		try this: https://github.com/asg017/sqlite-regex)

SELECT 
	a.MainOperatingSystemName,
	a.MainOperatingSystemCount,
	round(a.MainOperatingSystemCount*100.0/sum(a.MainOperatingSystemSum) OVER (PARTITION BY a.MainOperatingSystemName),2) AS MainOperatingSystemPercentage
FROM (
SELECT DISTINCT
	r_os AS MainOperatingSystemName,
	count(download_date) OVER (PARTITION BY r_os) AS MainOperatingSystemCount,
	count(download_date) OVER() AS MainOperatingSystemSum
FROM cran_logs_2015_01_01_
) AS a
ORDER BY a.MainOperatingSystemCount DESC

-- trying to clear r_os from extra numeric values that look like version to narrow down to less OS 
SELECT DISTINCT
	r_os,
	LENGTH (r_os) AS OS_Length,
	instr(r_os, '.') AS OS_dot_position,
	substr(r_os,1,instr(r_os, '.')) AS OS_Trimmed,
	substr(r_os,1,5) AS OS_Root
	--lead(r_os) AS OS_Dupli
FROM cran_logs_2015_01_01_
ORDER BY r_os ASC


SELECT SUBSTRING(r_os, LEN(LEFT(r_os, CHARINDEX ('/', r_os))) + 1, LEN(r_os) - LEN(LEFT(r_os, 
    CHARINDEX ('/', r_os))) - LEN(RIGHT(r_os, LEN(r_os) - CHARINDEX ('.', r_os))) - 1);
