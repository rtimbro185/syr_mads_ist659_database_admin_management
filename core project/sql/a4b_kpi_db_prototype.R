###
##IST 659 Data Admin Concepts &Db Mgmt
##Date: 9/30/2018
##Project Deliverable 2: Prototype SQL Database

# Clear objects from Memory
rm(list=ls())
# Clear Console:
cat("\014")

# Ready RODBC for use in this script
# Required Libraries
if(!require(RODBC)){install.packages("RODBC")}
if(!require(RODBCext)){install.packages("RODBCext")}

# Create a connection to SQL Server using our 64-bit DSN
myconn <- odbcConnect('A4B_Org')

# SQL: Get Department SUpervisors List
sqlSelectStatement <-
"
SELECT * FROM DepartmentSupervisors
"
# Send the request to the server and store the results in a variable
departmentSupervisors <- sqlQuery(myconn,sqlSelectStatement)
departmentSupervisors

# SQL: Get Department Employees List
sqlSelectStatement <-
"
SELECT * FROM DepartmentEmployees
"
departmentEmployees <- sqlQuery(myconn,sqlSelectStatement)
departmentEmployees

# SQL: Get Team Leads List
sqlSelectStatement <-
"
SELECT * FROM TeamLeads
"
teamLeads <- sqlQuery(myconn,sqlSelectStatement)
teamLeads


# SQL: Execute A Stored Procedure
team <- 'Voice Portal Delivery'
fName <- 'David'
lName <- 'Marshall'

execResult <- sqlExecute(myconn,"EXEC updateTeamLead @teamName=team, @employeefName=fName, @employeelName=lName",fetch=TRUE,as.is=T)
execResult

# SQL: Get Team Leads List After Running Update
sqlSelectStatement <-
"
SELECT * FROM TeamLeads
"
teamLeadsUpdated <- sqlQuery(myconn,sqlSelectStatement)
teamLeadsUpdated


# SQL: GET Application KPI Lists
appKPIList <- sqlQuery(myconn,"SELECT * FROM KPI_APP")
appKPIList

# SQL: Execute Stored Procedure - addApplicationKPI
execReslt <- sqlExecute(myconn,"EXEC addApplicationKPI 'SIVR U2 Prepaid', 'VOC'",fetch=TRUE,as.is=T)
execResult

# SQL: GET Application KPI Lists
appKPIListUpdated <- sqlQuery(myconn,"SELECT * FROM KPI_APP")
appKPIListUpdated

# close all connections
odbcCloseAll()