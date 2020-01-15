/*
	IST 659 Data Admin Concepts &Db Mgmt
	Date: 9/30/2018
	Project Deliverable 2: FUNCTIONS
	
*/

-- #### VALIDATE EMPLOYEE EXISTS ####
-- DROP FUNCTION IF EXISTS
IF EXISTS (SELECT * FROM sys.objects WHERE object_id=OBJECT_ID(N'dbo.validateEmployee') AND type in (N'FN',N'IF',N'TF',N'FS',N'FT'))
DROP FUNCTION validateEmployee
GO
-- CREATE FUNCTION
CREATE FUNCTION validateEmployee(@employeefName varchar(50), @employeelName varchar(50))
RETURNS int AS
BEGIN
	DECLARE @success int
	SET @success = 0
	
	SELECT @success = ISNULL((SELECT 1 FROM employee where first_name = @employeefName AND last_name = @employeelName), 0)

	RETURN @success
END
GO


-- #### VALIDATE A TEAM EXISTS
-- DROP FUNCTION IF EXISTS
IF EXISTS (SELECT * FROM sys.objects WHERE object_id=OBJECT_ID(N'dbo.validateTeam') AND type in (N'FN',N'IF',N'TF',N'FS',N'FT'))
DROP FUNCTION validateTeam
GO
-- CREATE FUNCTION
CREATE FUNCTION validateTeam(@teamName varchar(50))
RETURNS int AS
BEGIN
	DECLARE @success int
	SET @success = 0
	
	SELECT @success = ISNULL((SELECT 1 FROM team where team_name = @teamName AND is_active = 'T'), 0)

	RETURN @success
END
GO


-- #### VALIDATE AN EMPLOYEE IS A MEMBER OF A TEAM
-- DROP FUNCTION IF EXISTS
IF EXISTS (SELECT * FROM sys.objects WHERE object_id=OBJECT_ID(N'dbo.validateTeamEmployee') AND type in (N'FN',N'IF',N'TF',N'FS',N'FT'))
DROP FUNCTION validateTeamEmployee
GO
-- CREATE FUNCTION
CREATE FUNCTION validateTeamEmployee(@teamName varchar(50), @employeefName varchar(50), @employeelName varchar(50))
RETURNS int AS
BEGIN
	DECLARE @success int, @employee_id int, @team_id int
	SET @success = 0
	SET @employee_id = 0

	-- USE EXISTING FUNCTIONS TO VALIDATE EMPLOYEE AND TEAM INPUTS ARE VALID
	EXEC @success = validateEmployee @employeeFname, @employeelName
	IF @success <> 1
		RETURN @success
	EXEC @success = validateTeam @teamName
	IF @success <> 1
		RETURN @success
	--
	SELECT @success = ISNULL((SELECT 1 FROM team_employee 
		WHERE employee_id = (SELECT employee_id FROM employee WHERE first_name = @employeeFname AND last_name = @employeelName)
			AND team_id = (SELECT team_id FROM team WHERE team_name = @teamName)
		), 0)
	
	RETURN @success
END
GO
