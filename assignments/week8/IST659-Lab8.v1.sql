/*
IST 659 Data Admin Concepts &Db Mgmt
Date: 9/3/2018
Lab Assignment: Lab 8, Database Programming

*/
-- Declare a variable, @ is mandatory at the beginning of the variable name in SQL Server
declare @isThisNull varchar(30)  -- starts out as NULL
Select @isThisNull, ISNULL(@isThisNull,'Yep, it is NULL')

-- Set the variable to something
SET @isThisNull = 'Nope, It is not Null'
SELECT @isThisNull, ISNULL(@isThisNull, 'Yep, it is null')

GO
/*
First User Defined Function
*/
CREATE FUNCTION dbo.AddTwoInts(@firstNumber int, @secondNumber int)
RETURNS int AS -- AS is the keyword that ends the CREATE FUNCTION clause
BEGIN
	-- First, delcare the variable to temporarily hold the results
	DECLARE @returnValue int -- the data type matches the "RETURN" clause

	-- Set the variable to the correct value
	SET @returnValue = @firstNumber + @secondNumber

	-- Return the value to the calling statement
	RETURN @returnValue
END
GO

-- TODO: Execute SQL Select statement against new function
SELECT dbo.AddTwoInts(5,10)

/*
TODO: Code a function that counts the number of VidCasts made by a given user 
	and returns the count to the calling code
*/
-- Drop Function if it Exists
GO
IF EXISTS
(SELECT * FROM sys.objects 
WHERE object_id=OBJECT_ID(N'dbo.vc_VidCastCount')
AND type in (N'FN',N'IF',N'TF',N'FS',N'FT'))
DROP FUNCTION dbo.vc_VidCastCount
GO

-- Function to count the VidCasts made by a given User
GO
CREATE FUNCTION dbo.vc_VidCastCount(@userID int)
RETURNS int AS -- COUNT() is an integer value, so return it as an int
BEGIN
	DECLARE @returnValue int -- matches the function's return type

	/*
		Get the count of the VidCasts for the provided userID and
		assign that value to @returnValue. Note that we use the
		@userID parameter in the WHERE clause to limit our count
		to that user's VidCast records.
	*/
	SELECT @returnValue = COUNT(vc_UserID) FROM vc_VidCast
	WHERE vc_VidCast.vc_UserID = @userID

	-- Return @returnValue to the calling code
	RETURN @returnValue
END
GO
-- 
SELECT TOP 10
	*, 
	dbo.vc_VidCastCount(vc_UserID) as VidCastCount
FROM dbo.vc_User
ORDER BY VidCastCount DESC

/*
TODO: Code a function that accepts the tag text as a parameter and looks up the vc_tagID for the vc_tag record for that TagText
*/
-- Drop Function if it exists
IF EXISTS
(SELECT * FROM sys.objects 
WHERE object_id=OBJECT_ID(N'dbo.vc_TagIDLookup')
AND type in (N'FN',N'IF',N'TF',N'FS',N'FT'))
DROP FUNCTION dbo.vc_TagIDLookup
GO

GO
-- Function to retrieve the vc_TagID for a given tag's text
CREATE FUNCTION dbo.vc_TagIDLookup(@tagText varchar(20))
RETURNS int AS -- vc_TagID as an int, so we'll match that
BEGIN
	DECLARE @returnValue int -- Matches the function's return type

	/*
		Get the vc_TagID of the vc_Tag record whose TagText
		matches the parameter and assign that value to @returnValue
	*/
	SELECT @returnValue = vc_TagID
	FROM vc_Tag
	WHERE TagText = @tagText

	-- Send the vc_TagID back to the caller
	RETURN @returnValue
END
GO

-- Test dbo.vc_TagIDLookup function
SELECT dbo.vc_TagIDLookup('Music')
SELECT dbo.vc_TagIDLookup('Tunes')

/*
Views
*/
-- TODO:  Create a view to retrieve the top 10 vc_Users and their VidCast counts
-- Drop VIEW if it exists
IF EXISTS
(SELECT * FROM sys.views
	WHERE name = 'vc_MostProlificUsers' AND schema_id = SCHEMA_ID('dbo'))
DROP VIEW dbo.vc_MostProlificUsers

GO
CREATE VIEW vc_MostProlificUsers AS
	SELECT TOP 10
		*
		, dbo.vc_VidCastCount(vc_UserID) as VidCastCount
	FROM vc_User
	ORDER BY VidCastCount DESC
GO

-- Test the vc_MostProlificUsers VIEW
SELECT * FROM vc_MostProlificUsers

/*
Stored Procedures
*/
-- TODO: Create a procedure to update a vc_User's email address
	-- The first parameter is the user name for the user to change
	-- The second is the new email address
-- First DELETE the Stored Procedure if it exists
DROP PROCEDURE IF EXISTS vc_ChangeUserEmail
GO
CREATE PROCEDURE vc_ChangeUserEmail(@userName varchar(20), @newEmail varchar(50))
AS
BEGIN
	UPDATE vc_User SET EmailAddress = @newEmail
	WHERE userName = @userName
END
GO

-- Test the above Stored Procedure
EXEC vc_ChangeUserEmail 'tardy','kmstudent@syr.edu'

-- To see the effect from running the above execution of the vc_ChangeUserEmail Stored Procedure
	-- run this snippet
SELECT * FROM vc_User WHERE UserName = 'tardy'

-- @@identity
-- TODO: Add a new record to the vc_Tag table and run a query using the @@identity property
INSERT INTO vc_Tag(TagText) VALUES('Cat Videos')
SELECT * FROM vc_Tag WHERE vc_TagID = @@identity

-- TODO: Create a stored procedure to return the @@identity property
/*
	Create a procedure that adds a row to the UserLogin table
	This procedure is run when a user logs in and we need to record
	who they are and from where the're logging in.
*/
-- First Drop procedure if exists
DROP PROCEDURE IF EXISTS vc_AddUserLogin
GO
CREATE PROCEDURE vc_AddUserLogin(@userName varchar(20),@loginFrom varchar(50))
AS
BEGIN
	-- we have the user name, but we need the ID for the login table
	-- First, declare a variable to hold the ID
	DECLARE @userID int

	-- Get the vc_UserID for the UserName provided and store it in @userID
	SELECT @userID = vc_UserID FROM vc_User
	WHERE UserName = @userName

	-- Now we can add the row using an INSERT statement
	INSERT INTO vc_UserLogin(vc_UserID, LoginLocation)
	VALUES (@userID, @loginFrom)

	-- New return the @@identity so the calling code knows where the data end up
	RETURN @@identity
END
GO

-- Test the vc_AddUserLogin procedure by executing the below snippet
DECLARE @addedValue int
EXEC @addedValue = vc_AddUserLogin 'tardy', 'localhost'
SELECT
	vc_User.vc_UserID,
	vc_User.UserName,
	vc_UserLogin.UserLoginTimestamp,
	vc_UserLogin.LoginLocation
FROM vc_User
JOIN vc_UserLogin on vc_User.vc_UserID = vc_UserLogin.vc_UserID
WHERE vc_UserLoginID = @addedValue

/*
HOW DO WE MAKE THE AddUserLogin PROCEDURE SIMPLER????
*/

/*
#### PART 2 - Putting All Together ####
*/

/*
	Create a function to retrieve a vc_UserID for a given user name
	P2-TODO-USER_DEFINED_FUNCTIONS-1: dbo.vc_UserIDLookup
*/
-- Drop Function if it exists
IF EXISTS
(SELECT * FROM sys.objects 
WHERE object_id=OBJECT_ID(N'dbo.vc_UserIDLookup')
AND type in (N'FN',N'IF',N'TF',N'FS',N'FT'))
DROP FUNCTION dbo.vc_UserIDLookup
GO
-- CREATE user-defined function
CREATE FUNCTION dbo.vc_UserIDLookup(@userName varchar(20))
RETURNS int AS
BEGIN
	DECLARE @returnValue int

	-- TODO: Code to assign the correct vc_UserID to @returnValue
	SELECT @returnValue = vc_UserID FROM vc_User
	WHERE UserName = @userName

	-- Return the vc_UserID found from the input attribute @userName
	RETURN @returnValue
END
GO

-- Test the user-defined function dbo.vc_UserIDLookup
SELECT 'Trying the vc_UserIDLookup function', dbo.vc_UserIDLookup('tardy')

/*
	Create a function that calculates the count of vc_VidCastIDs for a given vc_TagID
	P2-TODO-USER_DEFINED_FUNCTIONS-2: dbo.vc_TagVidCastCount
*/
-- Drop Function if it exists
IF EXISTS
(SELECT * FROM sys.objects 
WHERE object_id=OBJECT_ID(N'dbo.vc_TagVidCastCount')
AND type in (N'FN',N'IF',N'TF',N'FS',N'FT'))
DROP FUNCTION dbo.vc_TagVidCastCount
GO
-- CREATE user-defined function
GO
CREATE FUNCTION dbo.vc_TagVidCastCount(@tagID int)
RETURNS int AS
BEGIN
	DECLARE @returnValue int

	-- Count vc_VidCastIDs for a given tagID from the vc_VidCastTagList table
	SELECT @returnValue = COUNT(vc_VidCastID) FROM vc_VidCastTagList
	WHERE vc_VidCastTagList.vc_TagID = @tagID

	-- Retrun the count of vc_VidCastIDs
	RETURN @returnValue
END
GO

-- Test the user-defined function dbo.vc_TagVidCastCount
SELECT vc_Tag.TagText, dbo.vc_TagVidCastCount(vc_Tag.vc_TagID) as VidCasts
FROM vc_Tag

/*
	Create a function that SUMs the total number of minutes of actual duration for VidCasts
		with a Finished status given a vc_UserID as a parameter.
		-> Returns the SUM as an int
	P2-TODO-USER_DEFINED_FUNCTIONS-3: dbo.vc_VidCastDuration
*/
-- Drop Function if it exists
IF EXISTS
(SELECT * FROM sys.objects 
WHERE object_id=OBJECT_ID(N'dbo.vc_VidCastDuration')
AND type in (N'FN',N'IF',N'TF',N'FS',N'FT'))
DROP FUNCTION dbo.vc_VidCastDuration
GO
-- CREATE user-defined function
CREATE FUNCTION dbo.VidCastDuration(@userID int)
RETURNS int AS
BEGIN
	DECLARE @returnValue int

	-- 
	SELECT @returnValue = SUM(DATEDIFF(n,vc_VidCast.StartDateTime, vc_VidCast.EndDateTime))
	FROM vc_VidCast
	JOIN vc_Status on vc_Status.vc_StatusID = vc_VidCast.vc_StatusID
	WHERE vc_VidCast.vc_UserID = @userID
	AND vc_Status.StatusText = 'Finished'
		
	-- Return the SUM of duration of VidCasts
	RETURN @returnValue
END
GO

-- UNIT TEST: REMOVE BELOW SNIPPET
SELECT SUM(DATEDIFF(n,vc_VidCast.StartDateTime, vc_VidCast.EndDateTime)) as TotalMinutes, vc_Status.StatusText
FROM vc_VidCast
JOIN vc_Status on vc_Status.vc_StatusID = vc_VidCast.vc_StatusID
WHERE vc_VidCast.vc_UserID = 1
AND vc_Status.StatusText = 'Finished'
GROUP BY
	vc_Status.StatusText
-- REMOVE ABOVE SNIPPET

-- Test the user-defined function dbo.vc_VidCastDuration
SELECT *, dbo.VidCastDuration(vc_UserID) as TotalMinutes
FROM vc_User

/*
	CODING YOUR OWN VIEWS
	-- Create a view that executes a SELECT statement
	P2-TODO-VIEWS-1: vc_TagReport
*/
-- Drop VIEW if it exists
IF EXISTS
(SELECT * FROM sys.views
	WHERE name = 'vc_TagReport' AND schema_id = SCHEMA_ID('dbo'))
DROP VIEW dbo.vc_TagReport
-- Create vc_TagReport VIEW
GO
CREATE VIEW vc_TagReport AS
	SELECT 
		vc_Tag.TagText,
		dbo.vc_TagVidCastCount(vc_Tag.vc_TagID) as VidCasts
	FROM vc_Tag
	ORDER BY VidCasts DESC OFFSET 0 ROWS -- Use the OFFSET command set to 0 otherwise SQL server won't allow the Order By Clause
GO

-- Test the vc_TagReport VIEW
SELECT * FROM vc_TagReport


/*
	CODING YOUR OWN VIEWS
	-- Alter the view vc_MostProlificUsers, add a column called totalMinutes that calls the 
		vc_VidCastDuration function 
	-- P2-TODO-VIEWS-2: vc_MostProlificUsers
*/
GO
ALTER VIEW vc_MostProlificUsers AS
	SELECT TOP 10
		*
		, dbo.vc_VidCastCount(vc_UserID) as VidCastCount
		, dbo.VidCastDuration(vc_UserID) as TotalMinutes
	FROM vc_User
	ORDER BY VidCastCount DESC
GO

-- Test the vc_MostProlificUsers view
SELECT UserName, VidCastCount, TotalMinutes FROM vc_MostProlificUsers

/*
	CODING YOUR OWN STORED PROCEDURES
	-- Create a stored procedure to use in adding a row to the vc_Tag table. 
	Inputs:
		@tagText: the text of the new tag
		@description: a brief description of the tag (nullable)
	Returns:
		@@identity with the value inserted
	-- P2-TODO-STORED_PROCEDURE-1: vc_AddTag
*/
-- First DELETE the Stored Procedure if it exists
DROP PROCEDURE IF EXISTS vc_AddTag

-- Create the vc_AddTag procedure
GO
CREATE PROCEDURE vc_AddTag(@tagText varchar(20), @description varchar(100)=NULL) AS
BEGIN
	-- Code the insert procedures here
	INSERT INTO vc_Tag (vc_Tag.TagText,vc_Tag.TagDescription)
	VALUES (@tagText, @description)

	-- Return the @@identity property of the newley inserted record
	RETURN @@identity
END
GO

-- Test the vc_AddTag stored procedure
DECLARE @newTagID int
EXEC @newTagID = vc_AddTag 'SQL', 'Finally, a SQL Tag'
SELECT * FROM vc_Tag WHERE vc_TagID = @newTagID


/*
	CODING YOUR OWN STORED PROCEDURES
	-- Create a stored procedure that accepts an int as a parameter that will be a
		vc_VidCastID that we need to mark as finished. 
	-- P2-TODO-STORED_PROCEDURE-2: vc_FinishVidCast
*/
-- First DELETE the Stored Procedure if it exists
DROP PROCEDURE IF EXISTS vc_FinishVidCast

-- Create Stored Procedure
GO
CREATE PROCEDURE vc_FinishVidCast(@vidCastID int) AS
BEGIN
	-- Update VidCast EndDateTime
	UPDATE vc_VidCast
	SET vc_VidCast.EndDateTime = GETDATE(), 
	vc_VidCast.vc_StatusID = (SELECT vc_StatusID FROM vc_Status WHERE vc_Status.StatusText = 'Finished')
	WHERE vc_VidCast.vc_VidCastID = @vidCastID
		
END
GO

-- Test the vc_FinishVidCast stored procedure
DECLARE @newVC int
INSERT INTO vc_VidCast
	(VidCastTitle, StartDateTime, ScheduleDurationMinutes, vc_UserID, vc_StatusID)
	VALUES
	('Finally done with sprocs', DATEADD(n,-45, GETDATE()), 45, 
	(SELECT vc_UserID FROM vc_User WHERE UserName = 'tardy'),
	(SELECT vc_StatusID FROM vc_Status WHERE StatusText = 'Started'))

SET @newVC = @@identity
SELECT * FROM vc_VidCast WHERE vc_VidCastID = @newVC
EXEC vc_FinishVidCast @newVC
SELECT * FROM vc_VidCast WHERE vc_VidCastID = @newVC
