USE [master]
GO
/****** Object:  Database [IST659_V2]    Script Date: 9/24/2018 6:48:45 PM ******/
CREATE DATABASE [IST659_V2]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'IST659_V2', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\IST659_V2.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'IST659_V2_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\IST659_V2_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO

USE [IST659_V2]
GO
/****** Object:  User [guestuser]    Script Date: 9/24/2018 6:48:45 PM ******/
CREATE USER [guestuser] FOR LOGIN [guestuser] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  UserDefinedFunction [dbo].[AddTwoInts]    Script Date: 9/24/2018 6:48:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
/*
First User Defined Function
*/
CREATE FUNCTION [dbo].[AddTwoInts](@firstNumber int, @secondNumber int)
RETURNS int AS -- AS is the keyword that ends the CREATE FUNCTION clause
BEGIN
	-- First, delcare the variable to temporarily hold the results
	DECLARE @returnValue int -- the data type matches the "RETURN" clause

	-- Set the variable to the correct value
	SET @returnValue = @firstNumber + @secondNumber

	-- Return the value to the calling statement
	RETURN @returnValue
END
GO
/****** Object:  UserDefinedFunction [dbo].[vc_TagIDLookup]    Script Date: 9/24/2018 6:48:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- Function to retrieve the vc_TagID for a given tag's text
CREATE FUNCTION [dbo].[vc_TagIDLookup](@tagText varchar(20))
RETURNS int AS -- vc_TagID as an int, so we'll match that
BEGIN
	DECLARE @returnValue int -- Matches the function's return type

	/*
		Get the vc_TagID of the vc_Tag record whose TagText
		matches the parameter and assign that value to @returnValue
	*/
	SELECT @returnValue = vc_TagID
	FROM vc_Tag
	WHERE TagText = @tagText

	-- Send the vc_TagID back to the caller
	RETURN @returnValue
END
GO
/****** Object:  UserDefinedFunction [dbo].[vc_TagVidCastCount]    Script Date: 9/24/2018 6:48:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[vc_TagVidCastCount](@tagID int)
RETURNS int AS
BEGIN
	DECLARE @returnValue int

	-- 
	SELECT @returnValue = COUNT(vc_VidCastID) FROM vc_VidCastTagList
	WHERE vc_VidCastTagList.vc_TagID = @tagID

	-- Retrun the count of vc_VidCastIDs
	RETURN @returnValue
END
GO
/****** Object:  UserDefinedFunction [dbo].[vc_UserIDLookup]    Script Date: 9/24/2018 6:48:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- CREATE user-defined function
CREATE FUNCTION [dbo].[vc_UserIDLookup](@userName varchar(20))
RETURNS int AS
BEGIN
	DECLARE @returnValue int

	-- TODO: Code to assign the correct vc_UserID to @returnValue
	SELECT @returnValue = vc_UserID FROM vc_User
	WHERE UserName = @userName

	-- Return the vc_UserID found from the input attribute @userName
	RETURN @returnValue
END
GO
/****** Object:  UserDefinedFunction [dbo].[vc_VidCastCount]    Script Date: 9/24/2018 6:48:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[vc_VidCastCount](@userID int)
RETURNS int AS -- COUNT() is an integer value, so return it as an int
BEGIN
	DECLARE @returnValue int -- matches the function's return type

	/*
		Get the count of the VidCasts for the provided userID and
		assign that value to @returnValue. Note that we use the
		@userID parameter in the WHERE clause to limit our count
		to that user's VidCast records.
	*/
	SELECT @returnValue = COUNT(vc_UserID) FROM vc_VidCast
	WHERE vc_VidCast.vc_UserID = @userID

	-- Return @returnValue to the calling code
	RETURN @returnValue
END
GO
/****** Object:  UserDefinedFunction [dbo].[VidCastDuration]    Script Date: 9/24/2018 6:48:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- CREATE user-defined function
CREATE FUNCTION [dbo].[VidCastDuration](@userID int)
RETURNS int AS
BEGIN
	DECLARE @returnValue int

	-- 
	SELECT @returnValue = SUM(DATEDIFF(n,vc_VidCast.StartDateTime, vc_VidCast.EndDateTime))
	FROM vc_VidCast
	JOIN vc_Status on vc_Status.vc_StatusID = vc_VidCast.vc_StatusID
	WHERE vc_VidCast.vc_UserID = @userID
	AND vc_Status.StatusText = 'Finished'
		
	-- Return the SUM of duration of VidCasts
	RETURN @returnValue
END
GO
/****** Object:  Table [dbo].[vc_User]    Script Date: 9/24/2018 6:48:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[vc_User](
	[vc_UserID] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [varchar](20) NOT NULL,
	[EmailAddress] [varchar](50) NOT NULL,
	[UserDescription] [varchar](200) NULL,
	[WebSiteURL] [varchar](50) NULL,
	[UserRegisteredDate] [datetime] NOT NULL,
 CONSTRAINT [PK_vc_User] PRIMARY KEY CLUSTERED 
(
	[vc_UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [U1_vc_User] UNIQUE NONCLUSTERED 
(
	[UserName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [U2_vc_User] UNIQUE NONCLUSTERED 
(
	[EmailAddress] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vc_MostProlificUsers]    Script Date: 9/24/2018 6:48:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vc_MostProlificUsers] AS
	SELECT TOP 10
		*
		, dbo.vc_VidCastCount(vc_UserID) as VidCastCount
		, dbo.VidCastDuration(vc_UserID) as TotalMinutes
	FROM vc_User
	ORDER BY VidCastCount DESC
GO
/****** Object:  Table [dbo].[vc_Tag]    Script Date: 9/24/2018 6:48:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[vc_Tag](
	[vc_TagID] [int] IDENTITY(1,1) NOT NULL,
	[TagText] [varchar](20) NOT NULL,
	[TagDescription] [varchar](100) NULL,
 CONSTRAINT [dbo.vc_Tag_pk] PRIMARY KEY CLUSTERED 
(
	[vc_TagID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [U1_vc_Tag] UNIQUE NONCLUSTERED 
(
	[TagText] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[vc_TagReport]    Script Date: 9/24/2018 6:48:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE VIEW [dbo].[vc_TagReport] AS
	SELECT 
		vc_Tag.TagText,
		dbo.vc_TagVidCastCount(vc_Tag.vc_TagID) as VidCasts
	FROM vc_Tag
	ORDER BY VidCasts DESC OFFSET 0 ROWS
GO
/****** Object:  Table [dbo].[lab_Log]    Script Date: 9/24/2018 6:48:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lab_Log](
	[lab_LogID] [int] IDENTITY(1,1) NOT NULL,
	[lab_logInt] [int] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[lab_LogID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[lab_logInt] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[lab_Test]    Script Date: 9/24/2018 6:48:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[lab_Test](
	[lab_TestID] [int] IDENTITY(1,1) NOT NULL,
	[lab_testText] [varchar](20) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[lab_TestID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
UNIQUE NONCLUSTERED 
(
	[lab_testText] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[vc_FollowerList]    Script Date: 9/24/2018 6:48:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[vc_FollowerList](
	[vc_FollowerListID] [int] IDENTITY(1,1) NOT NULL,
	[FollowerID] [int] NOT NULL,
	[FollowedID] [int] NOT NULL,
	[FollowerSince] [datetime] NOT NULL,
 CONSTRAINT [PK_vc_FollowerList] PRIMARY KEY CLUSTERED 
(
	[vc_FollowerListID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [U1_vc_FollowerList] UNIQUE NONCLUSTERED 
(
	[FollowerID] ASC,
	[FollowedID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[vc_Status]    Script Date: 9/24/2018 6:48:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[vc_Status](
	[vc_StatusID] [int] IDENTITY(1,1) NOT NULL,
	[StatusText] [varchar](20) NOT NULL,
 CONSTRAINT [dbo.vc_Status_pk] PRIMARY KEY CLUSTERED 
(
	[vc_StatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [U1_vc_Status] UNIQUE NONCLUSTERED 
(
	[StatusText] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[vc_UserLogin]    Script Date: 9/24/2018 6:48:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[vc_UserLogin](
	[vc_UserLoginID] [int] IDENTITY(1,1) NOT NULL,
	[vc_UserID] [int] NOT NULL,
	[UserLoginTimestamp] [datetime] NOT NULL,
	[LoginLocation] [varchar](50) NOT NULL,
 CONSTRAINT [PK_vc_UserLogin] PRIMARY KEY CLUSTERED 
(
	[vc_UserLoginID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[vc_UserTagList]    Script Date: 9/24/2018 6:48:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[vc_UserTagList](
	[vc_UserTagListID] [int] IDENTITY(1,1) NOT NULL,
	[vc_TagID] [int] NOT NULL,
	[vc_UserID] [int] NOT NULL,
 CONSTRAINT [dbo.vc_UserTagList_pk] PRIMARY KEY CLUSTERED 
(
	[vc_UserTagListID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [U1_vc_UserTagList] UNIQUE NONCLUSTERED 
(
	[vc_TagID] ASC,
	[vc_UserID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[vc_VidCast]    Script Date: 9/24/2018 6:48:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[vc_VidCast](
	[vc_VidCastID] [int] IDENTITY(1,1) NOT NULL,
	[VidCastTitle] [varchar](50) NOT NULL,
	[StartDateTime] [datetime] NULL,
	[EndDateTime] [datetime] NULL,
	[ScheduleDurationMinutes] [int] NULL,
	[RecordingURL] [varchar](50) NULL,
	[vc_UserID] [int] NOT NULL,
	[vc_StatusID] [int] NOT NULL,
 CONSTRAINT [PK_vc_VidCast] PRIMARY KEY CLUSTERED 
(
	[vc_VidCastID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[vc_VidCastTagList]    Script Date: 9/24/2018 6:48:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[vc_VidCastTagList](
	[vc_VidCastTagListID] [int] IDENTITY(1,1) NOT NULL,
	[vc_TagID] [int] NOT NULL,
	[vc_VidCastID] [int] NOT NULL,
 CONSTRAINT [PK_vc_VidCastTagList] PRIMARY KEY CLUSTERED 
(
	[vc_VidCastTagListID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY],
 CONSTRAINT [U1_vc_VidCastTagList] UNIQUE NONCLUSTERED 
(
	[vc_TagID] ASC,
	[vc_VidCastID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[vc_User] ADD  DEFAULT (getdate()) FOR [UserRegisteredDate]
GO
ALTER TABLE [dbo].[vc_UserLogin] ADD  DEFAULT (getdate()) FOR [UserLoginTimestamp]
GO
ALTER TABLE [dbo].[vc_FollowerList]  WITH CHECK ADD  CONSTRAINT [FK1_vc_FollowerList] FOREIGN KEY([FollowerID])
REFERENCES [dbo].[vc_User] ([vc_UserID])
GO
ALTER TABLE [dbo].[vc_FollowerList] CHECK CONSTRAINT [FK1_vc_FollowerList]
GO
ALTER TABLE [dbo].[vc_FollowerList]  WITH CHECK ADD  CONSTRAINT [FK2_vc_FollowerList] FOREIGN KEY([FollowedID])
REFERENCES [dbo].[vc_User] ([vc_UserID])
GO
ALTER TABLE [dbo].[vc_FollowerList] CHECK CONSTRAINT [FK2_vc_FollowerList]
GO
ALTER TABLE [dbo].[vc_UserLogin]  WITH CHECK ADD  CONSTRAINT [FK1_vc_UserLogin] FOREIGN KEY([vc_UserID])
REFERENCES [dbo].[vc_User] ([vc_UserID])
GO
ALTER TABLE [dbo].[vc_UserLogin] CHECK CONSTRAINT [FK1_vc_UserLogin]
GO
ALTER TABLE [dbo].[vc_UserTagList]  WITH CHECK ADD  CONSTRAINT [vc_UserTagList_vc_Tag] FOREIGN KEY([vc_TagID])
REFERENCES [dbo].[vc_Tag] ([vc_TagID])
GO
ALTER TABLE [dbo].[vc_UserTagList] CHECK CONSTRAINT [vc_UserTagList_vc_Tag]
GO
ALTER TABLE [dbo].[vc_UserTagList]  WITH CHECK ADD  CONSTRAINT [vc_UserTagList_vc_User] FOREIGN KEY([vc_UserID])
REFERENCES [dbo].[vc_User] ([vc_UserID])
GO
ALTER TABLE [dbo].[vc_UserTagList] CHECK CONSTRAINT [vc_UserTagList_vc_User]
GO
ALTER TABLE [dbo].[vc_VidCast]  WITH CHECK ADD  CONSTRAINT [vc_VidCast_vc_Status] FOREIGN KEY([vc_StatusID])
REFERENCES [dbo].[vc_Status] ([vc_StatusID])
GO
ALTER TABLE [dbo].[vc_VidCast] CHECK CONSTRAINT [vc_VidCast_vc_Status]
GO
ALTER TABLE [dbo].[vc_VidCast]  WITH CHECK ADD  CONSTRAINT [vc_VidCast_vc_User] FOREIGN KEY([vc_UserID])
REFERENCES [dbo].[vc_User] ([vc_UserID])
GO
ALTER TABLE [dbo].[vc_VidCast] CHECK CONSTRAINT [vc_VidCast_vc_User]
GO
ALTER TABLE [dbo].[vc_VidCastTagList]  WITH CHECK ADD  CONSTRAINT [vc_VidCastTagList_vc_Tag] FOREIGN KEY([vc_TagID])
REFERENCES [dbo].[vc_Tag] ([vc_TagID])
GO
ALTER TABLE [dbo].[vc_VidCastTagList] CHECK CONSTRAINT [vc_VidCastTagList_vc_Tag]
GO
ALTER TABLE [dbo].[vc_VidCastTagList]  WITH CHECK ADD  CONSTRAINT [vc_VidCastTagList_vc_VidCast] FOREIGN KEY([vc_VidCastID])
REFERENCES [dbo].[vc_VidCast] ([vc_VidCastID])
GO
ALTER TABLE [dbo].[vc_VidCastTagList] CHECK CONSTRAINT [vc_VidCastTagList_vc_VidCast]
GO
/****** Object:  StoredProcedure [dbo].[vc_AddTag]    Script Date: 9/24/2018 6:48:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[vc_AddTag](@tagText varchar(20), @description varchar(100)=NULL) AS
BEGIN
	-- Code the insert procedures here
	INSERT INTO vc_Tag (vc_Tag.TagText,vc_Tag.TagDescription)
	VALUES (@tagText, @description)

	-- Return the @@identity property of the newley inserted record
	RETURN @@identity
END
GO
/****** Object:  StoredProcedure [dbo].[vc_AddUserLogin]    Script Date: 9/24/2018 6:48:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[vc_AddUserLogin](@userName varchar(20),@loginFrom varchar(50))
AS
BEGIN
	-- we have the user name, but we need the ID for the login table
	-- First, declare a variable to hold the ID
	DECLARE @userID int

	-- Get the vc_UserID for the UserName provided and store it in @userID
	SELECT @userID = vc_UserID FROM vc_User
	WHERE UserName = @userName

	-- Now we can add the row using an INSERT statement
	INSERT INTO vc_UserLogin(vc_UserID, LoginLocation)
	VALUES (@userID, @loginFrom)

	-- New return the @@identity so the calling code knows where the data end up
	RETURN @@identity
END
GO
/****** Object:  StoredProcedure [dbo].[vc_ChangeUserEmail]    Script Date: 9/24/2018 6:48:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[vc_ChangeUserEmail](@userName varchar(20), @newEmail varchar(50))
AS
BEGIN
	UPDATE vc_User SET EmailAddress = @newEmail
	WHERE userName = @userName
END
GO
/****** Object:  StoredProcedure [dbo].[vc_FinishVidCast]    Script Date: 9/24/2018 6:48:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[vc_FinishVidCast](@vidCastID int) AS
BEGIN
	-- Update VidCast EndDateTime
	UPDATE vc_VidCast
	SET vc_VidCast.EndDateTime = GETDATE(), 
	vc_VidCast.vc_StatusID = (SELECT vc_StatusID FROM vc_Status WHERE vc_Status.StatusText = 'Finished')
	WHERE vc_VidCast.vc_VidCastID = @vidCastID
	
	-- Update vc_Status tables StatusText field to finished
	--UPDATE vc_Status
	--SET vc_Status.StatusText = 'Finished'
	--FROM vc_Status s
	--JOIN vc_VidCast vc ON s.vc_StatusID = vc.vc_StatusID
	--WHERE vc.vc_VidCastID = @vidCastID
	
END
GO
USE [master]
GO
ALTER DATABASE [IST659_V2] SET  READ_WRITE 
GO
