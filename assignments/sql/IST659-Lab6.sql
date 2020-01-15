/*
	Author: Ryan Timbrook
	Course: IST 659 Data Admin Concepts & Db Mgmt
	Term: Summer, 2018
	Lab: 6, Querying Inserting Updating and Deleting
*/

-- Adding a row to the vc_Status table
INSERT INTO vc_Status(StatusText)
	VALUES('Scheduled')

-- The following line shows all of the rows in vc_Status
SELECT * FROM vc_Status

-- Adding three more rows to the vc_Status table
INSERT INTO vc_Status(StatusText)
	VALUES('Started'),('Finished'),('On Time')

-- The following line shows all of the rows in vc_Status
SELECT * FROM vc_Status

-- Adding a vidcast record to the VidCast Table
SELECT * FROM vc_User WHERE UserName = 'SaulHudson'
SELECT * FROM vc_Status WHERE StatusText = 'Finished'

INSERT INTO vc_VidCast(VidCastTitle, StartDateTime, EndDateTime, ScheduledDurationMinutes, RecordingURL, vc_UserID, vc_StatusID)
	VALUES ('December Snow', '3/1/2018 14:00', '3/1/2018 14:30', 30, '/XVF1234', 2, 3)

-- Read all rows from vc_VidCast
SELECT * FROM vc_VidCast

-- Saul's First VidCast
SELECT
	vc_User.UserName,
	vc_User.EmailAddress,
	vc_VidCast.VidCastTitle,
	vc_VidCast.StartDateTime,
	vc_VidCast.EndDateTime,
	vc_VidCast.ScheduledDurationMinutes / 60.0 as ScheduledHours,
	vc_Status.StatusText
FROM vc_VidCast
JOIN vc_User ON vc_VidCast.vc_UserID = vc_User.vc_UserID
JOIN vc_Status ON vc_VidCast.vc_StatusID = vc_Status.vc_StatusID
WHERE vc_User.UserName = 'SaulHudson'
ORDER BY vc_VidCast.StartDateTime
-- End Saul's First

-- Correcting a User's UserRegisteredDate
UPDATE vc_User SET UserRegisteredDate = '3/1/2018' WHERE UserName = 'SaulHudson'

SELECT * FROM vc_User Where UserName = 'SaulHudson'
-- End Update

-- Deleting a record from the Status Table
-- See what rows we have in status
SELECT * FROM vc_Status

-- Delete the On time status
DELETE vc_Status WHERE StatusText = 'On time'

-- See the effect
SELECT * FROM vc_Status
-- End Deleting a record from the Status Table

/*
	Part 2 - Putting All Together
	In this part, you'll add some more data to the VidCast tables and write some queries to read the new data
*/
-- Adding Tags to the vc_Tag Table
INSERT INTO vc_Tag(TagText, TagDescription)
	VALUES('Personal','About people'),('Professional','Business, business, business'),('Sports','All mannor of sports'),('Music','Music analysis, news, and thoughts'),('Games','Live streaming our favorite games')

-- Retrieve all rows from vc_Tag Table
SELECT * from vc_Tag

-- Adding users to the vc_User table
INSERT INTO vc_User(UserName,EmailAddress,UserDescription)
	VALUES('TheDoctor','tomBaker@nodomain.xyz','The definite article'),('HairCut','S.todd@nodomain.xyz','Fleet Street barber shop'),('DnDGal','dnd@nodomain.xyz',NULL)

-- Retrieve all rows from vc_User table
SELECT * from vc_User

-- Inserting 14 rows into the vc_UserTagList
-- Run Select Statements to view UserID values before executing INSERT
SELECT vc_UserID FROM vc_User WHERE UserName = 'DnDGal'
SELECT vc_UserID FROM vc_User WHERE UserName = 'RDwight'
SELECT vc_UserID FROM vc_User WHERE UserName = 'SaulHudson'
SELECT vc_UserID FROM vc_User WHERE UserName = 'Gordon'
SELECT vc_UserID FROM vc_User WHERE UserName = 'HairCut'
SELECT vc_UserID FROM vc_User WHERE UserName = 'TheDoctor'
-- Run Select Statements to view TagID values before executing INSERT
SELECT vc_TagID FROM vc_Tag WHERE TagText = 'Sports'
SELECT vc_TagID FROM vc_Tag WHERE TagText = 'Professional'
SELECT vc_TagID FROM vc_Tag WHERE TagText = 'Personal'
SELECT vc_TagID FROM vc_Tag WHERE TagText = 'Games'
SELECT vc_TagID FROM vc_Tag WHERE TagText = 'Music'

INSERT INTO vc_UserTagList(vc_UserID,vc_TagID)
	VALUES
		((SELECT vc_UserID FROM vc_User WHERE UserName = 'DnDGal'),(SELECT vc_TagID FROM vc_Tag WHERE TagText = 'Sports')), --DnDGal/Sports
		((SELECT vc_UserID FROM vc_User WHERE UserName = 'DnDGal'),(SELECT vc_TagID FROM vc_Tag WHERE TagText = 'Professional')), --DnDGal/Professional
		((SELECT vc_UserID FROM vc_User WHERE UserName = 'RDwight'),(SELECT vc_TagID FROM vc_Tag WHERE TagText = 'Professional')), --RDwight/Professional
		((SELECT vc_UserID FROM vc_User WHERE UserName = 'SaulHudson'),(SELECT vc_TagID FROM vc_Tag WHERE TagText = 'Sports')), --SaulHudson/Sports
		((SELECT vc_UserID FROM vc_User WHERE UserName = 'Gordon'),(SELECT vc_TagID FROM vc_Tag WHERE TagText = 'Personal')), --Gordon/Personal
		((SELECT vc_UserID FROM vc_User WHERE UserName = 'DnDGal'),(SELECT vc_TagID FROM vc_Tag WHERE TagText = 'Personal')), --DnDGal/Personal
		((SELECT vc_UserID FROM vc_User WHERE UserName = 'Gordon'),(SELECT vc_TagID FROM vc_Tag WHERE TagText = 'Games')), --Gordon/Games
		((SELECT vc_UserID FROM vc_User WHERE UserName = 'HairCut'),(SELECT vc_TagID FROM vc_Tag WHERE TagText = 'Professional')), --HairCut/Professional
		((SELECT vc_UserID FROM vc_User WHERE UserName = 'TheDoctor'),(SELECT vc_TagID FROM vc_Tag WHERE TagText = 'Music')), --TheDoctor/Music
		((SELECT vc_UserID FROM vc_User WHERE UserName = 'DnDGal'),(SELECT vc_TagID FROM vc_Tag WHERE TagText = 'Games')), --DnDGal/Games
		((SELECT vc_UserID FROM vc_User WHERE UserName = 'SaulHudson'),(SELECT vc_TagID FROM vc_Tag WHERE TagText = 'Games')), --SaulHudson/Games
		((SELECT vc_UserID FROM vc_User WHERE UserName = 'Gordon'),(SELECT vc_TagID FROM vc_Tag WHERE TagText = 'Professional')), --Gordon/Professional
		((SELECT vc_UserID FROM vc_User WHERE UserName = 'HairCut'),(SELECT vc_TagID FROM vc_Tag WHERE TagText = 'Music')), --HairCut/Music
		((SELECT vc_UserID FROM vc_User WHERE UserName = 'TheDoctor'),(SELECT vc_TagID FROM vc_Tag WHERE TagText = 'Personal')) --TheDoctor/Personal
		
-- Retrieve all rows from vc_UserTagList table
SELECT * FROM vc_UserTagList

-- Retrieve UserName, EmailAddress, TagText for all User records ordered by UserName, then Tag
SELECT 
	vc_User.UserName,
	vc_User.EmailAddress,
	vc_Tag.TagText
FROM vc_UserTagList
JOIN vc_User ON vc_UserTagList.vc_UserID = vc_User.vc_UserID
JOIN vc_Tag ON vc_UserTagList.vc_TagID = vc_Tag.vc_TagID
ORDER BY vc_User.UserName, vc_Tag.TagText



