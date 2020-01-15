/*
	Author: Ryan Timbrook
	Course: IST659 Data Admin Concepts & Db Mgmt
	Term: Summer 2018
	Lab: 7, Advanced Querying
*/

/*
	Part 1, Exploratory Data Analysis
*/

-- Validate the database is setup correctly by running the below SELECT statement
SELECT vc_User.UserName, vc_User.EmailAddress, vc_VidCast.vc_VidCastID
FROM vc_VidCast
JOIN vc_User ON vc_User.vc_UserID = vc_VidCast.vc_UserID
ORDER BY vc_User.UserName

-- Look for users who have not yet made any VidCasts
SELECT *
FROM vc_User
WHERE vc_UserID NOT IN(SELECT vc_UserID FROM vc_VidCast)

-- Be sure to include all vc_User records
SELECT vc_User.UserName, vc_User.EmailAddress, vc_VidCast.vc_VidCastID
FROM vc_VidCast
RIGHT JOIN vc_User ON vc_User.vc_UserID = vc_VidCast.vc_UserID
ORDER BY vc_User.UserName

-- High-level descriptive statistics for vc_VidCast
SELECT 
	COUNT(vc_VidCastID) AS NumberOfVidCasts,
	SUM(ScheduleDurationMinutes) AS TotalScheduledMinutes,
	MIN(ScheduleDurationMinutes) AS MinScheduledMinutes,
	AVG(ScheduleDurationMinutes) AS AvgScheduledMinutes,
	MAX(ScheduleDurationMinutes) AS MaxScheduledMinutes
FROM vc_VidCast

-- Amending prior SELECT statement to include GROUP BY clause
/*
	Expect to get this ERROR message when running the below statement. This is intentional to highlight how we
	added unaggregated columns in the SELECT list along with a column that has been aggregated.
	Msg 8127, Level 16, State 1, Line 43
	Column "vc_User.UserName" is invalid in the ORDER BY clause because it is not contained in either an aggregate function or the GROUP BY clause.
*/
SELECT 
	COUNT(vc_VidCastID) AS NumberOfVidCasts,
	SUM(ScheduleDurationMinutes) AS TotalScheduledMinutes,
	MIN(ScheduleDurationMinutes) AS MinScheduledMinutes,
	AVG(ScheduleDurationMinutes) AS AvgScheduledMinutes,
	MAX(ScheduleDurationMinutes) AS MaxScheduledMinutes
FROM vc_VidCast
RIGHT JOIN vc_User ON vc_User.vc_UserID = vc_VidCast.vc_UserID
ORDER BY vc_User.UserName

-- Amend prior query to include GROUP BY clause
SELECT
	vc_User.UserName,
	vc_User.EmailAddress,
	COUNT(vc_VidCast.vc_VidCastID) AS CountOfVidCasts
FROM 
	vc_VidCast
RIGHT JOIN 
	vc_User ON vc_User.vc_UserID = vc_VidCast.vc_UserID
GROUP BY
	vc_User.UserName,
	vc_User.EmailAddress
ORDER BY
	CountOfVidCasts DESC,
	vc_User.UserName


-- HAVING Clause, Amend prior query to filter result set by the result of one or more aggregate functions
SELECT
	vc_User.UserName,
	vc_User.EmailAddress,
	COUNT(vc_VidCast.vc_VidCastID) AS CountOfVidCasts
FROM 
	vc_VidCast
RIGHT JOIN 
	vc_User ON vc_User.vc_UserID = vc_VidCast.vc_UserID
GROUP BY
	vc_User.UserName,
	vc_User.EmailAddress
HAVING COUNT(vc_VidCast.vc_VidCastID) < 10
ORDER BY
	CountOfVidCasts DESC,
	vc_User.UserName

/*
	Advanced Summaries: Descriptive statistics on the duration of finished VidCasts
		-Number of minutes between StartDateTime and EndDateTime for all VidCasts with a Finished status
		-NOTE: Since we're only interested in VidCasts that are Finished, we don't need vc_User records with no VidCasts, we do not
			need a LEFT or RIGHT JOIN in the FROM clause
*/
SELECT
	vc_User.UserName,
	vc_User.EmailAddress,
	SUM(DateDiff(n,StartDateTime,EndDateTime)) AS SumActualDurationMinutes
FROM 
	vc_VidCast
JOIN 
	vc_User ON vc_User.vc_UserID = vc_VidCast.vc_UserID
JOIN
	vc_Status ON vc_Status.vc_StatusID = vc_VidCast.vc_StatusID
WHERE
	vc_Status.StatusText = 'Finished'
GROUP BY
	vc_User.UserName,
	vc_User.EmailAddress
ORDER BY
	vc_User.UserName


/*
	Part 2, Putting it All Together
		-Amend prior query's to show more descriptive statistics for the VidCast actual duration
	TODO: Amend the query from the end of part one, adding the count of VidCasts, minimum, average, and maximum actual durations for each vc_User record. 
			Sort the results in descending order by the count of videos, then by the UserName.
*/
SELECT
	vc_User.UserName,
	vc_User.EmailAddress,
	SUM(DateDiff(n,StartDateTime,EndDateTime)) AS SumActualDurationMinutes,
	COUNT(vc_VidCast.vc_VidCastID) AS CountOfVidCasts,
	MIN(DateDiff(n,StartDateTime,EndDateTime)) AS MinActualDurationMinutes,
	AVG(DateDiff(n,StartDateTime,EndDateTime)) AS AvgActualDurationMinutes,
	MAX(DateDiff(n,StartDateTime,EndDateTime)) AS MaxActualDurationMinutes
FROM 
	vc_VidCast
JOIN 
	vc_User ON vc_User.vc_UserID = vc_VidCast.vc_UserID
JOIN
	vc_Status ON vc_Status.vc_StatusID = vc_VidCast.vc_StatusID
WHERE
	vc_Status.StatusText = 'Finished'
GROUP BY
	vc_User.UserName,
	vc_User.EmailAddress
ORDER BY
	CountOfVidCasts DESC,
	vc_User.UserName