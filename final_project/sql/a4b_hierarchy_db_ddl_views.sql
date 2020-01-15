/*
	IST 659 Data Admin Concepts &Db Mgmt
	Date: 9/30/2018
	Project Deliverable 2: Views
	
*/

-- Show Employee's by Organization
-- Drop VIEW if it exists
IF EXISTS(SELECT * FROM sys.views WHERE name = 'DepartmentEmployees' AND schema_id = SCHEMA_ID('dbo'))
	DROP VIEW DepartmentEmployees

GO
CREATE VIEW DepartmentEmployees AS
	
	SELECT
		department_name AS Department, team_name AS APP_Team, CONCAT(first_name, ' ', last_name) AS Employee
	FROM team_employee
	JOIN team on team.team_id = team_employee.team_id
	JOIN employee on employee.employee_id = team_employee.employee_id
	JOIN department on department.department_id = team.department_id
	ORDER BY Department ASC OFFSET 0 ROWS
GO
-- Test the vc_MostProlificUsers VIEW
SELECT * FROM DepartmentEmployees


-- Show Applications By Team
-- Drop VIEW if it exists
IF EXISTS(SELECT * FROM sys.views WHERE name = 'TeamApplications' AND schema_id = SCHEMA_ID('dbo'))
	DROP VIEW TeamApplications

GO
CREATE VIEW TeamApplications AS
	SELECT
		team_name AS Team, app_name AS APP
	FROM team_application
	JOIN team on team.team_id = team_application.team_id
	JOIN application on application.application_id = team_application.application_id
	ORDER BY TEAM ASC OFFSET 0 ROWS

GO
-- TEST VIEW
SELECT * FROM TeamApplications

-- Department Teams
-- Drop VIEW if it exists
IF EXISTS(SELECT * FROM sys.views WHERE name = 'DepartmentTeams' AND schema_id = SCHEMA_ID('dbo'))
	DROP VIEW DepartmentTeams

GO
CREATE VIEW DepartmentTeams AS
	SELECT
		department_name AS Department, team_name AS Team
		FROM team_employee
		JOIN team on team.team_id = team_employee.team_id
		JOIN department on department.department_id = team.department_id
		ORDER BY Department ASC OFFSET 0 ROWS

GO
-- TEST VIEW
SELECT * FROM DepartmentTeams



-- Listing Department, App, Team
-- Drop VIEW if it exists
IF EXISTS(SELECT * FROM sys.views WHERE name = 'DepartmentAppTeamEmployees' AND schema_id = SCHEMA_ID('dbo'))
	DROP VIEW DepartmentAppTeamEmployees

GO
CREATE VIEW DepartmentAppTeamEmployees AS
	SELECT
		department_name AS Department, team_name AS Team, CONCAT(first_name, ' ', last_name) AS Employee
		FROM team_employee
		JOIN team on team.team_id = team_employee.team_id
		JOIN employee on employee.employee_id = team_employee.employee_id
		JOIN department on department.department_id = team.department_id
		ORDER BY Department ASC OFFSET 0 ROWS

GO
-- TEST VIEW
SELECT * FROM DepartmentAppTeamEmployees

-- Listing KPI by App
-- Drop VIEW if it exists
IF EXISTS(SELECT * FROM sys.views WHERE name = 'KPI_APP' AND schema_id = SCHEMA_ID('dbo'))
	DROP VIEW KPI_APP

GO
CREATE VIEW KPI_APP AS
	SELECT 
		kpi_name AS KPI, app_name as APP
	FROM application_kpi
	LEFT OUTER JOIN kpi on kpi.kpi_id = application_kpi.kpi_id
	LEFT JOIN application on application.application_id = application_kpi.application_id
	ORDER BY KPI ASC OFFSET 0 ROWS
GO
-- TEST VIEW
SELECT * FROM KPI_APP

-- List Team Leads by Team
IF EXISTS(SELECT * FROM sys.views WHERE name = 'TeamLeads' AND schema_id = SCHEMA_ID('dbo'))
	DROP VIEW TeamLeads

GO
CREATE VIEW TeamLeads AS
	SELECT
	team_name AS Team, CONCAT(first_name, ' ', last_name) AS Team_Lead
	FROM team_lead
	JOIN team on team.team_id = team_lead.team_id
	JOIN employee on employee.employee_id = team_lead.employee_id
GO
-- TEST VIEW
SELECT * FROM TeamLeads

-- Department Supervisors
-- List Team Leads by Team
IF EXISTS(SELECT * FROM sys.views WHERE name = 'DepartmentSupervisors' AND schema_id = SCHEMA_ID('dbo'))
	DROP VIEW DepartmentSupervisors

GO
CREATE VIEW DepartmentSupervisors AS
	SELECT
	department_name AS Department, CONCAT(first_name, ' ', last_name) AS Department_Supervisor
	FROM department_supervisor
	JOIN department on department.department_id = department_supervisor.department_id
	JOIN employee on employee.employee_id = department_supervisor.employee_id
GO
-- TEST VIEW
SELECT * FROM DepartmentSupervisors