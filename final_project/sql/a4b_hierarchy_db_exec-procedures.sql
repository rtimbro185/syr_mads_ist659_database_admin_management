/*
	IST 659 Data Admin Concepts &Db Mgmt
	Date: 9/30/2018
	Project Deliverable 2: Execute Procedures
	
*/

-- Load Department Supervisiors
EXEC addDepartmentSupervisior 'Voice Services', 'Ryan', 'Timbrook'
EXEC addDepartmentSupervisior 'SMPD', 'Rob', 'Stamm'
EXEC addDepartmentSupervisior 'Connected Customer', 'Rob', 'Stamm'
EXEC addDepartmentSupervisior 'Digital Business Connected Customer', 'Leigh', 'Gower'
EXEC addDepartmentSupervisior 'Frontline Care', 'Matthew', 'Davis'

SELECT * FROM department_supervisor

-- Update A Department Supervisior
DECLARE @newID int
EXEC @newID = updateDepartmentSupervisior 'Voice Services', 'Ryan', 'Timbrook'
SELECT * FROM department_supervisor WHERE department_supervisor_id = @newID
select * from employee
SELECT * FROM department_supervisor
-- End Test Execution

SELECT * from team_employee
-- Load Team Leads to Team Employee Table- Must be executed before Team Lead
EXEC addTeamEmployee 'Voice Portal Product','Trevor','Malmos'
EXEC addTeamEmployee 'Voice Portal Delivery','Ryan','Timbrook'
EXEC addTeamEmployee 'Voice Services Gamma Delivery','Kristy','Gillis'
EXEC addTeamEmployee 'Voice Services Gamma Support','David','Marshall'
EXEC addTeamEmployee 'Voice Services Gamma AppOps','Edjan','Preut'
EXEC addTeamEmployee 'Voice Services Omega Delivery ','Kristy','Gillis'
EXEC addTeamEmployee 'Voice Services Omega Support','David','Marshall'
EXEC addTeamEmployee 'Voice Services Omega AppOps','Edjan','Preut'
EXEC addTeamEmployee 'SpaceBear','Rob','Stamm'
EXEC addTeamEmployee 'HuggyBear','Ryan','Yokal'
-- Load Employees to Team Employee Table
-- TEAM -> 'Voice Services Gamma Delivery' Members
EXEC addTeamEmployee 'Voice Services Gamma Delivery', 'Paul', 'James'
-- TEAM -> 'Voice Services Omega Delivery' Members
EXEC addTeamEmployee 'Voice Services Omega Delivery','Phoebe','Parsons'

SELECT * FROM team_employee

SELECT * FROM team_lead
-- Load Team Leads
EXEC addTeamLead 'Voice Portal Product','Trevor','Malmos'
EXEC addTeamLead 'Voice Portal Delivery','Ryan','Timbrook'
EXEC addTeamLead 'Voice Services Gamma Delivery','Kristy','Gillis'
EXEC addTeamLead 'Voice Services Gamma Support','David','Marshall'
EXEC addTeamLead 'Voice Services Gamma AppOps','Edjan','Preut'
EXEC addTeamLead 'Voice Services Omega Delivery ','Kristy','Gillis'
EXEC addTeamLead 'Voice Services Omega Support','David','Marshall'
EXEC addTeamLead 'Voice Services Omega AppOps','Edjan','Preut'
EXEC addTeamLead 'SpaceBear','Rob','Stamm'
EXEC addTeamLead 'HuggyBear','Ryan','Yokal'

SELECT * FROM team_lead

-- Update a Team Lead
EXEC updateTeamLead 'Voice Services Omega Delivery','David','Marshall'
EXEC updateTeamLead 'Voice Services Omega Support','Kristy','Gillis'

SELECT * FROM team_lead
-- 

-- Load Team Applications team, department, application
EXEC addTeamApplication 'Voice Services Omega AppOps','Voice Services','SIVR Prepaid'
EXEC addTeamApplication 'Voice Services Omega Support','Voice Services','SIVR Prepaid'
EXEC addTeamApplication 'Voice Services Omega AppOps','Voice Services','SIVR U2 Prepaid'
EXEC addTeamApplication 'Voice Services Omega Support','Voice Services','SIVR U2 Prepaid'
EXEC addTeamApplication 'Voice Services Gamma AppOps','Voice Services','SIVR Postpaid'
EXEC addTeamApplication 'Voice Services Gamma Support','Voice Services','SIVR Postpaid'
EXEC addTeamApplication 'SpaceBear','SMPD','Lithium'
EXEC addTeamApplication 'HuggyBear','SMPD','Live Engage'

SELECT * FROM team_application

-- Load Application KPIs
-- APP -> SIVR Postpaid
EXEC addApplicationKPI 'SIVR Postpaid', 'Deflection Rate'
EXEC addApplicationKPI 'SIVR Postpaid', 'CPC'
EXEC addApplicationKPI 'SIVR Postpaid', 'Call Length'
EXEC addApplicationKPI 'SIVR Postpaid', 'Transfer Percent'

-- APP -> SIVR Prepaid
EXEC addApplicationKPI 'SIVR Prepaid', 'Deflection Rate'
EXEC addApplicationKPI 'SIVR Prepaid', 'Call Length'
EXEC addApplicationKPI 'SIVR Prepaid', 'VOC'

-- APP -> SIVR U2 Prepaid
EXEC addApplicationKPI 'SIVR U2 Prepaid', 'Deflection Rate'
EXEC addApplicationKPI 'SIVR U2 Prepaid', 'Call Length'
EXEC addApplicationKPI 'SIVR U2 Prepaid', 'Transfer Percent'

-- APP -> Lithium
EXEC addApplicationKPI 'Lithium', 'CPH'
EXEC addApplicationKPI 'Lithium', 'TTFR'
EXEC addApplicationKPI 'Lithium', 'CSAT'

-- APP -> Live Engage
EXEC addApplicationKPI 'Live Engage', 'TTFR'
EXEC addApplicationKPI 'Live Engage', 'CSAT'

select * from application_kpi
