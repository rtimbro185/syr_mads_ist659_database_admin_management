IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'Department')
BEGIN
	DROP TABLE Department
END

CREATE TABLE Department(
	-- Create Table Columns
	DepartmentID int identity

	-- Create Table Constraints
)