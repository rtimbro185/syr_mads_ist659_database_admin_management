/*
	Author: Ryan Timbrook
	Course: IST 659 Data Admin Concepts & Db Mgmt
	Term: Summer, 2018
*/

-- Creating the User Table
IF EXISTS(SELECT * FROM dbo.vc_User)
	DROP TABLE dbo.vc_User
Create Table vc_User(
	-- Columns for the User Table
	vc_UserID int identity,
	UserName varchar(20) not null,
	EmailAddress varchar(50) not null,
	UserDescription varchar(200),
	WebSiteURL varchar(50),
	UserRegisteredDate datetime not null default GetDate(),
	-- Constraints on the User Table
	CONSTRAINT PK_vc_User PRIMARY KEY(vc_UserID),
	CONSTRAINT U1_vc_User UNIQUE(UserName),
	CONSTRAINT U2_vc_User UNIQUE(EmailAddress)

)
-- End Creating the User Table

-- Creating the UserLogin Table
IF EXISTS(SELECT * FROM dbo.vc_UserLogin)
	DROP TABLE dbo.vc_UserLogin
Create Table vc_UserLogin(
	-- Columns for the UserLogin table
	vc_UserLoginID int identity,
	vc_UserID int not null,
	UserLoginTimestamp datetime not null default GetDate(),
	LoginLocation varchar(50) not null,
	-- Constraints for the UserLogin table
	CONSTRAINT PK_vc_UserLogin PRIMARY KEY(vc_UserLoginID),
	CONSTRAINT FK1_vc_UserLogin FOREIGN KEY(vc_UserID) REFERENCES vc_User(vc_UserID)
)
-- End Creating the UserLogin Table

-- Adding Data to the User Table
INSERT INTO vc_User(UserName, EmailAddress, UserDescription)
	VALUES
		('RDwight','rdwight@nodomain.xyz','Piano Teacher'),
		('SaulHudson','slash@nodomain.xyz','I like Les Paul guitars'),
		('Gordon','sumner@nodomain.xyz','Former cop')

SELECT * from vc_User
-- End adding data to the User Table

-- Creating the follower List Table
IF EXISTS(SELECT * FROM dbo.vc_FollowerList)
	DROP TABLE dbo.vc_FollowerList
CREATE TABLE vc_FollowerList(
	-- Columns for the follower List Table
	vc_FollowerListID int identity,
	FollowerID int not null,
	FollowedID int not null,
	FollowerSince datetime not null,
	-- Constraints on the Follower List Table
	CONSTRAINT PK_vc_FollowerList PRIMARY KEY(vc_FollowerListID),
	CONSTRAINT U1_vc_FollowerList UNIQUE(FollowerID, FollowedID),
	CONSTRAINT FK1_vc_FollowerList FOREIGN KEY(FollowerID) REFERENCES vc_User(vc_UserID),
	CONSTRAINT FK2_vc_FollowerList FOREIGN KEY(FollowedID) REFERENCES vc_User(vc_UserID)
)
-- End Creating the follower List Table

-- Creating the following Tag Table
-- Order: 1
IF EXISTS(SELECT * FROM dbo.vc_Tag)
	DROP TABLE dbo.vc_Tag
CREATE TABLE vc_Tag(
	-- Columns for the follower List Table
	vc_TagID int identity,
	TagText varchar(20),
	TagDescription varchar(100),
	-- Constraints on the Follower List Table
	CONSTRAINT PK_vc_TagID PRIMARY KEY(vc_TagID),
	CONSTRAINT U1_TagText UNIQUE(TagText)
)
-- End Creating the Tag Table

-- Creating the following Status Table
-- Order: 2
IF EXISTS(SELECT * FROM dbo.vc_Status)
	DROP TABLE dbo.vc_Status
CREATE TABLE vc_Status(
	-- Columns for the follower List Table
	vc_StatusID int identity,
	StatusText varchar(20),
	-- Constraints on the Follower List Table
	CONSTRAINT PK_vc_StatusID PRIMARY KEY(vc_StatusID),
	CONSTRAINT U1_StatusText UNIQUE(StatusText)
)
-- End Creating the Status Table

-- Creating the following VidCast Table
-- Order: 3
IF EXISTS(SELECT * FROM dbo.vc_VidCast)
	DROP TABLE dbo.vc_VidCast
CREATE TABLE vc_VidCast(
	-- Columns for the follower List Table
	vc_VidCastID int identity,
	VidCastTitle varchar(50),
	StartDateTime datetime,
	EndDateTime datetime,
	ScheduledDurationMinutes int,
	RecordingURL varchar(50),
	vc_UserID int,
	vc_StatusID int,
	-- Constraints on the Follower List Table
	CONSTRAINT PK_vc_VidCastID PRIMARY KEY(vc_VidCastID),
	CONSTRAINT FK1_vc_UserID FOREIGN KEY(vc_UserID) REFERENCES vc_User(vc_UserID),
	CONSTRAINT FK2_vc_StatusID FOREIGN KEY(vc_StatusID) REFERENCES vc_Status(vc_StatusID)
)
-- End Creating the VidCast Table

-- Creating the following VidCastTagList
-- Order: 4
IF EXISTS(SELECT * FROM dbo.vc_VidCastTagList)
	DROP TABLE dbo.vc_VidCastTagList
CREATE TABLE vc_VidCastTagList(
	-- Columns for the follower List Table
	vc_VidCastTagList int identity,
	vc_TagID int,
	vc_VidCastID int
	-- Constraints on the Follower List Table
	CONSTRAINT PK_vc_VidCastTagList PRIMARY KEY(vc_VidCastTagList),
	CONSTRAINT FK1_vc_TagID FOREIGN KEY(vc_TagID) REFERENCES vc_Tag(vc_TagID),
	CONSTRAINT U1_vc_TagID UNIQUE(vc_TagID), --ARE THESE UNIQUE DECLARATIONS NEEDED? FKs should enforce this?
	CONSTRAINT FK2_vc_VidCastID FOREIGN KEY(vc_VidCastID) REFERENCES vc_VidCast(vc_VidCastID),
	CONSTRAINT U2_vc_VidCastID UNIQUE(vc_VidCastID) --ARE THESE UNIQUE DECLARATIONS NEEDED? FKs should enforce this?
)
-- End Creating the VidCastTagList

-- Creating the following UserTagList Table
-- Order: 5
IF EXISTS(SELECT * FROM dbo.vc_UserTagList)
	DROP TABLE dbo.vc_UserTagList
CREATE TABLE vc_UserTagList(
	-- Columns for the follower List Table
	vc_UserTagListID int identity,
	vc_TagID int,
	vc_UserID int,
	-- Constraints on the Follower List Table
	CONSTRAINT PK_vc_UserTagListID PRIMARY KEY(vc_UserTagListID),
	CONSTRAINT FK1_vc_UserTagList_TagID FOREIGN KEY(vc_TagID) REFERENCES vc_Tag(vc_TagID),
	CONSTRAINT U1_vc_UserTagList_TagID UNIQUE(vc_TagID),
	CONSTRAINT FK2_vc_UserTagList_UserID FOREIGN KEY(vc_UserID) REFERENCES vc_User(vc_UserID),
	CONSTRAINT U2_vc_UserTagList_UserID UNIQUE(vc_UserID)
)
-- End Creating the UserTagList Table
