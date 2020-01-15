/*
	IST 659 Data Admin Concepts &Db Mgmt
	Date: 9/10/2018
	Lab Assignment: Lab 9, Data Security

	**** GUEST USER ****
*/

-- Guestuser's tab
SELECT * FROM vc_User

/*
	Above select privilages to the vc_User table were revoked.
	In replace of direct access to the vc_User table, select privilages were granted
	to the vc_MostProlificUsers view.
*/
-- Access granted to view
SELECT * FROM vc_MostProlificUsers

/*
	TODO: 
		- Code and execute the EXEC statement to add a user login for the user
		with UserName ‘TheDoctor’ with a login from ‘Gallifrey’.
*/
EXEC vc_AddUserLogin 'TheDoctor','Gallifrey'

/*
	TODO: 
		- Code and execute the EXEC statement to finish the VidCast titled
		‘Rock Your Way To Success’
*/
-- GRANT access to vc_VidCast had to be given to get the vc_VidCastID needed for input into the stored procedure
DECLARE @vidCastID int
SELECT @vidCastID=vc_VidCastID FROM vc_VidCast WHERE VidCastTitle = 'Rock Your Way To Success'
EXEC vc_FinishVidCast @vidCastID