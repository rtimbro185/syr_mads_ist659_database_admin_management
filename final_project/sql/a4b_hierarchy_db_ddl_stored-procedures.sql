/*
	IST 659 Data Admin Concepts &Db Mgmt
	Date: 9/30/2018
	Project Deliverable 2: Stored Procedure
	
*/

-- #### ADD SUPERVISIOR TO A DEPARTMENT
-- Delete Procedure if exists
DROP PROCEDURE IF EXISTS addDepartmentSupervisior
GO
-- Function Make an Employee the Department Supervisior
-- TODO: Add conditional logic validating input parameters contain valid data; exception handling for business rule constraints
CREATE PROCEDURE addDepartmentSupervisior(@departmentName varchar(50),@employeefName varchar(50),@employeelName varchar(50)) AS
BEGIN
	DECLARE @departmentID int, @employeeID int, @success int
	SET @success = 0
	-- Validate that the Employee info entered is an existing Employee in the database
	EXEC @success = dbo.validateEmployee @employeefName, @employeelName
	PRINT(@success)
	-- IF a valid employee wasn't found, exit the procedure with an error
	IF @success <> 1
		RETURN @success


	SELECT @departmentID = department_id FROM department WHERE department_name = @departmentName
	PRINT(@departmentID)
	SELECT @employeeID = employee_id FROM employee WHERE first_name = @employeefName AND last_name = @employeelName
	PRINT(@departmentID)

	-- Add row to department_supervisor table
	INSERT INTO department_supervisor(department_id,employee_id)
		VALUES (@departmentID, @employeeID)
	SELECT @success = ISNULL((SELECT 1 FROM department_supervisor WHERE department_supervisor_id = @@identity), 0)

	RETURN @success
END
GO

-- #### CHANGE SUPERVISOR OF A DEPARTMENT
-- Delete Procedure if exists
DROP PROCEDURE IF EXISTS updateDepartmentSupervisior
GO
-- Function Make an Employee the Department Supervisior
CREATE PROCEDURE updateDepartmentSupervisior(@departmentName varchar(50),@employeefName varchar(50),@employeelName varchar(50)) AS
BEGIN
	--
	DECLARE @departmentID int, @employeeID int, @success int
	SET @success = 0
	-- Validate that the Employee info entered is an existing Employee in the database
	EXEC @success = dbo.validateEmployee @employeefName, @employeelName
	--PRINT(@success)
	-- IF a valid employee wasn't found, exit the procedure with an error
	IF @success <> 1
		RETURN @success

	SELECT @departmentID = department_id FROM department WHERE department_name = @departmentName
	--PRINT(@departmentID)
	SELECT @employeeID = employee_id FROM employee WHERE first_name = @employeefName AND last_name = @employeelName
	--PRINT(@departmentID)

	-- Update row to department_supervisor table
	UPDATE department_supervisor
	SET employee_id = @employeeID 
	WHERE department_id = @departmentID

	RETURN @success
END
GO

-- ####  ADD TEAM LEAD
DROP PROCEDURE IF EXISTS addTeamLead
GO
-- Function Make an Employee the Team Lead
/*
	Business Rule Validations:
		-Sequence:1: Employee must exist in the employee table before they can be added as a team lead
		-Sequence:2: Team must exist in the team table before an employee can be added as a team lead
		-Sequence:3: Employee must be a member of the team they are being assigned lead over
		If any of the above rules are viloated, a success code of 0 will be returned
*/
CREATE PROCEDURE addTeamLead(@teamName varchar(50), @employeefName varchar(50),@employeelName varchar(50)) AS
BEGIN
	--
	DECLARE @teamID int, @employeeID int, @success int, @successTeam int, @successEmployee int, @successTeamEmployee int
	SET @success = 1
	-- Validate that the Employee info entered is an existing Employee in the database
	EXEC @successEmployee = validateEmployee @employeefName, @employeelName
	EXEC @successTeam = validateTeam @teamName
	EXEC @successTeamEmployee = validateTeamEmployee @teamName, @employeefName, @employeelName
	-- IF a valid employee wasn't found or a valid team wasn't found, exit the procedure with an error
	IF (@successEmployee <> 1 OR @successTeam <> 1 OR @successTeamEmployee <> 1)
		BEGIN
			SET @success = 0
			RETURN @success
		END
	ELSE
		BEGIN
			SELECT @teamID = team_id FROM team WHERE team_name = @teamName
			SELECT @employeeID = employee_id FROM employee WHERE first_name = @employeefName AND last_name = @employeelName
			-- Add row to team_lead table
			INSERT INTO team_lead(team_id,employee_id)
				VALUES (@teamID, @employeeID)
			SELECT @success = ISNULL((SELECT 1 FROM team_lead WHERE team_lead_id = @@identity), 0)
		END
	

	RETURN @success
END
GO

-- UPDATE TEAM LEAD
DROP PROCEDURE IF EXISTS updateTeamLead
GO
-- Function Update an Employee the Team Lead
CREATE PROCEDURE updateTeamLead(@teamName varchar(50), @employeefName varchar(50),@employeelName varchar(50)) AS
BEGIN
	--
	DECLARE @teamID int, @employeeID int, @success int
	SET @success = 0
	-- Validate that the Employee info entered is an existing Employee in the database
	EXEC @success = dbo.validateEmployee @employeefName, @employeelName
	-- IF a valid employee wasn't found, exit the procedure with an error
	IF @success <> 1
		RETURN @success

	SELECT @teamID = team_id FROM team WHERE team_name = @teamName
	SELECT @employeeID = employee_id FROM employee WHERE first_name = @employeefName AND last_name = @employeelName

	-- Update row to team_lead table
	UPDATE team_lead
	SET employee_id = @employeeID 
	WHERE team_id = @teamID

	RETURN @success
END
GO


-- ADD Employee to a Team
DROP PROCEDURE IF EXISTS addTeamEmployee

GO
CREATE PROCEDURE addTeamEmployee(@teamName varchar(50), @employeefName varchar(50),@employeelName varchar(50)) AS
BEGIN
	DECLARE @teamID int, @employeeID int, @success int, @successTeam int, @successEmployee int
	SET @success = 1
	-- Validate that the Employee info entered is an existing Employee in the database
	EXEC @successEmployee = dbo.validateEmployee @employeefName, @employeelName
	EXEC @successTeam = dbo.validateTeam @teamName
	
	-- IF a valid employee wasn't found or a valid team wasn't found, exit the procedure with an error
	IF (@successEmployee != 1 OR @successTeam != 1)
		BEGIN
		SET @success = 0
		RETURN @success
		END
	ELSE
		BEGIN
			SELECT @teamID = team_id FROM team WHERE team_name = @teamName
			SELECT @employeeID = employee_id FROM employee WHERE first_name = @employeefName AND last_name = @employeelName
			
			-- Add row to team_employee table
			INSERT INTO team_employee(team_id,employee_id)
				VALUES (@teamID, @employeeID)
			
			SELECT @success = ISNULL((SELECT 1 FROM team_employee WHERE team_employee_id = @@identity), 0)
		END
	
	RETURN @success
END
GO

-- ADD APPLICATION TO A TEAM
DROP PROCEDURE IF EXISTS addTeamApplication
GO
CREATE PROCEDURE addTeamApplication(@teamName varchar(50), @departmentName varchar(50), @appName varchar(20)) AS
BEGIN
	DECLARE @success int, @teamID int, @departmentID int, @appID int

	BEGIN TRY
	SELECT @teamID = team_id FROM team WHERE team_name = @teamName AND department_id = (Select department_id FROM department WHERE department_name = @departmentName)
	SELECT @appID = application_id FROM application WHERE app_name = @appName
	
		INSERT INTO team_application(team_id,application_id)
			VALUES (@teamID,@appID)
	SET @success = 1
	END TRY
	BEGIN CATCH
		PRINT(ERROR_NUMBER())
		PRINT(ERROR_MESSAGE())
		SET @success = 0
	END CATCH
	
	RETURN @success
END
GO

-- ADD APPLICATION KPI
DROP PROCEDURE IF EXISTS addApplicationKPI
GO
CREATE PROCEDURE addApplicationKPI(@appName varchar(20), @kpiName varchar(20)) AS
BEGIN

	DECLARE @success int, @appID int, @kpiID int
	SET @success = 0

	BEGIN TRY
		SELECT @appID = application_id FROM application WHERE app_name = @appName
		PRINT(@appID)
		SELECT @kpiID = kpi_id FROM kpi WHERE kpi_name = @kpiName
		PRINT(@kpiID)
	
		INSERT INTO application_kpi(application_id, kpi_id)
			VALUES(@appID,@kpiID)
		SET @success = 1
	END TRY

	BEGIN CATCH
		PRINT(ERROR_NUMBER())
		PRINT(ERROR_MESSAGE())
		SET @success = 0
	END CATCH

	RETURN @success

END
GO
