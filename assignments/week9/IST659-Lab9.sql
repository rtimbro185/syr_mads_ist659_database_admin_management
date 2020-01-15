/*
	IST 659 Data Admin Concepts &Db Mgmt
	Date: 9/10/2018
	Lab Assignment: Lab 9, Data Security
*/

/*
	TODO:
		Create Guest User
*/

-- Creating a guestuser database user
CREATE USER guestuser FOR LOGIN guestuser
/*
	TODO:
		Grant read permissions
*/
-- Grant read permission on the user table
GRANT SELECT ON vc_User to guestuser

/*
	TODO: 
		Code and execute the following statements to revoke the select permission
		on vc_User and grant the select permission on the vc_MostProlificUsers view.
*/
-- Revoke the select permissions
REVOKE SELECT ON vc_User to guestuser

-- Give them the view instead
GRANT SELECT ON vc_MostProlificUsers to guestuser

/*
	TODO:
		To allow a user to run a stored procedure, we grant them the EXECUTE permission.
*/
-- Allow guestuser to run some stored procedures
GRANT EXECUTE ON vc_AddUserLogin TO guestuser
GRANT EXECUTE ON vc_FinishVidCast TO guestuser

-- Retrieve all rows from the vc_UserLogin table
-- ** Add screen print results to Answer doc
SELECT * from vc_UserLogin

-- Retrieve ONLY the vc_VidCast record that should have been modified by guestuser's stored procedure call.
-- ** Add screen print results to Answer doc
-- GRANT access to vc_VidCast had to be given to guestuser get the vc_VidCastID needed for input into the stored procedure
GRANT SELECT ON vc_VidCast TO guestuser
SELECT * FROM vc_VidCast WHERE VidCastTitle = 'Rock Your Way To Success'

/*
	Part 2 – Data Integrity Through Transactions
	The Setup:
		We’re going to set up two simple tables separate from our VidCast tables to mess with.
*/
-- Creating a new table
CREATE TABLE lab_Test(
	lab_TestID int identity primary key,
	lab_testText varchar(20) unique not null
)

/*
	This will be a table to keep a log of created lab_Test records.
	We don't want to add a row to this if the insert into lab_Test fails
*/
CREATE TABLE lab_Log(
	lab_LogID int identity primary key,
	lab_logInt int unique not null
)

-- Add records to lab_Test and, if they succeed, insert the ID generated for lab_TestID
INSERT INTO lab_Test(lab_testText) VALUES('One'),('Two'),('Three')
INSERT INTO lab_Log(lab_logInt) SELECT lab_TestID FROM lab_Test
-- Test that above inserts worked
SELECT * from lab_Test
SELECT * from lab_Log

-- Use a transaction to make sure our data conform to our business rules

-- Step 1: Begin the transaction
BEGIN TRANSACTION
	-- Step 2: Assess the state of things
	DECLARE @rc int
	SET @rc = @@ROWCOUNT -- Initially 0

	-- Step 3: Make the change
	-- On success, @@ROWCOUNT is incremented by 1
	-- On failure, @@ROWCOUNT does not change
	INSERT INTO lab_Test(lab_testText) VALUES('Timbrook')

	-- Step 4: Check the new state of things
	IF(@rc = @@ROWCOUNT) -- If @@ROWCOUNT was not changed, fail
		BEGIN
			-- Step 5, if failed
			SELECT 'Bail out! It Failed!'
			ROLLBACK
		END
	ELSE -- Success! Continue
		BEGIN
			-- Step 5 if succeeded
			SELECT 'Yay! It worked!'
			INSERT INTO lab_Log(lab_logInt) VALUES(@@identity)
			COMMIT
		END
-- ENDING TRANSACTION

-- Test above Transaction
SELECT * FROM lab_Log
SELECT * FROM lab_Test