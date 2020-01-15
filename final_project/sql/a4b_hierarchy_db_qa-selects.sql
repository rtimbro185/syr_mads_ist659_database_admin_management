/*
	IST 659 Data Admin Concepts &Db Mgmt
	Date: 9/30/2018
	Project Deliverable 2: Select Statements to Answer Data Questions
	
*/

-- As a Department Supervisor, what Application KPIs do I Own?
SELECT Department FROM DepartmentSupervisors WHERE Department_Supervisor = 'Ryan Timbrook'
SELECT Team FROM DepartmentTeams WHERE Department = 'Voice Services'
SELECT APP FROM TeamApplications WHERE Team in(SELECT Team FROM DepartmentTeams WHERE Department = 'Voice Services')
SELECT DISTINCT KPI FROM KPI_APP WHERE APP in(SELECT APP FROM TeamApplications WHERE Team in(SELECT Team FROM DepartmentTeams WHERE Department = 'Voice Services'))

-- As a Team Lead, what Application KPIs do I Own?
SELECT Team FROM TeamLeads WHERE Team_Lead = 'Kristy Gillis'
SELECT APP FROM TeamApplications WHERE Team in(SELECT Team FROM TeamLeads WHERE Team_Lead = 'Kristy Gillis')
SELECT DISTINCT KPI FROM KPI_APP WHERE APP in(SELECT APP FROM TeamApplications WHERE Team in(SELECT Team FROM TeamLeads WHERE Team_Lead = 'Kristy Gillis'))

-- Who are the Department Supervisors?
SELECT * FROM DepartmentSupervisors

-- Who are the Department Employees?
SELECT * FROM DepartmentEmployees