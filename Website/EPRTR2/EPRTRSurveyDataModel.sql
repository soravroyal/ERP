USE [EPRTRcms]
GO
/****** Object:  Table [dbo].[SurveyItems]    Script Date: 06-01-2016 15:04:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SurveyItems](
	[SurveyItemID] [int] IDENTITY(1,1) NOT NULL,
	[FK_SurveyID] [int] NOT NULL,
	[SurveyItem] [nvarchar](255) NOT NULL,
	[SurveyItemResultID] [nvarchar](50) NOT NULL,
	[ListIndex] [int] NULL,
	[Updated] [datetime2](7) NULL,
 CONSTRAINT [PK_SurveyItems] PRIMARY KEY CLUSTERED 
(
	[SurveyItemID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SurveyMaster]    Script Date: 06-01-2016 15:04:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SurveyMaster](
	[SurveyID] [int] IDENTITY(1,1) NOT NULL,
	[SurveyText] [nvarchar](255) NOT NULL,
	[SurveyLabel] [nvarchar](50) NULL,
	[ListIndex] [int] NULL,
	[Updated] [datetime2](7) NULL,
 CONSTRAINT [PK_SurveyMaster] PRIMARY KEY CLUSTERED 
(
	[SurveyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SurveyResults]    Script Date: 06-01-2016 15:04:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SurveyResults](
	[SurveyResultID] [int] IDENTITY(1,1) NOT NULL,
	[SurveyResult] [nvarchar](100) NULL,
	[Inserted] [datetime2](7) NULL,
 CONSTRAINT [PK_SurveyResults] PRIMARY KEY CLUSTERED 
(
	[SurveyResultID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[SurveyItems]  WITH CHECK ADD  CONSTRAINT [FK_SurveyItems_SurveyMaster] FOREIGN KEY([FK_SurveyID])
REFERENCES [dbo].[SurveyMaster] ([SurveyID])
GO
ALTER TABLE [dbo].[SurveyItems] CHECK CONSTRAINT [FK_SurveyItems_SurveyMaster]
GO
/****** Object:  Trigger [dbo].[SurveyItemsKey]    Script Date: 06-01-2016 15:04:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[SurveyItemsKey]
on [dbo].[SurveyItems]
	FOR INSERT, UPDATE
	AS 
	BEGIN
	update dbo.SurveyItems set updated = GETDATE()
	where SurveyItemID in (select SurveyItemID from inserted)
	END

GO
/****** Object:  Trigger [dbo].[SurveyMasterKey]    Script Date: 06-01-2016 15:04:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[SurveyMasterKey]
on [dbo].[SurveyMaster]
	FOR INSERT, UPDATE
	AS 
	BEGIN
	update dbo.SurveyMaster set updated = GETDATE()
	where SurveyID in (select SurveyID from inserted)
	END

GO
/****** Object:  Trigger [dbo].[SurveyResultKey]    Script Date: 06-01-2016 15:04:10 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[SurveyResultKey]
on [dbo].[SurveyResults]
	FOR INSERT, UPDATE
	AS 
	BEGIN
	update dbo.SurveyResults set inserted = GETDATE()
	where SurveyResultID in (select SurveyResultID from inserted)
	END

GO

INSERT INTO [dbo].[SurveyMaster]
           ([SurveyText],[ListIndex])
     VALUES
           ('What kind of organisation do you represent?',0),
           ('What kind of information are you looking for?',1),
           ('For what purpose do you want to use the E-PRTR information?',2)
GO

DECLARE @sid int;

SET @sid = (SELECT SurveyID from SurveyMaster where ListIndex = 0);
INSERT INTO [dbo].[SurveyItems]
           ([FK_SurveyID]
           ,[SurveyItem]
           ,[SurveyItemResultID]
           ,[ListIndex])
     VALUES
           (@sid, 'Public organisation', '1a',0),
           (@sid, 'Commercial organisation', '1b',1),
           (@sid, 'Private person', '1c',2)
;

SET @sid = (SELECT SurveyID from SurveyMaster where ListIndex = 1);
INSERT INTO [dbo].[SurveyItems]
           ([FK_SurveyID]
           ,[SurveyItem]
           ,[SurveyItemResultID]
           ,[ListIndex])
     VALUES
           (@sid, 'Information concerning a specific facility', '2a',0),
           (@sid, 'Information concerning a sector of industry', '2b',1),
           (@sid, 'Information concerning a country', '2c',2),
           (@sid, 'EU-wide information', '2d',3)
;

SET @sid = (SELECT SurveyID from SurveyMaster where ListIndex = 2);
INSERT INTO [dbo].[SurveyItems]
           ([FK_SurveyID]
           ,[SurveyItem]
           ,[SurveyItemResultID]
           ,[ListIndex])
     VALUES
           (@sid, 'Academic purposes', '3a',0),
           (@sid, 'Policy making', '3b',1),
           (@sid, 'Public participation in decision making / Access to environmental information', '3c',2),
           (@sid, 'Business', '3d',3)
;


/*
* APPEND ContentsGroups
*/
DECLARE @cntgrp int
INSERT INTO [dbo].[LOV_ContentsGroup]
 ([Code]
 ,[Name]
 ,[StartYear])
 VALUES
 ('SURVEY', 'Survey', 2015);

declare @temp table (ResourceKey varchar(max), ResourceType varchar(max), KeyTitle varchar(max), ResourceValue varchar(max));

INSERT INTO @temp (ResourceKey, ResourceType, KeyTitle, ResourceValue)
 VALUES
('SURVEY.Header','Survey','Label, Survey header','E-PRTR Survey'),
('SURVEY.ParticipateText','Survey','Text, Participate in survey text','<h3>The introduction text asking for your participation</h3><h3>Would you like to participate?</h3>'),
('SURVEY.Thanks','Survey','Label, Survey thank you text','<h3>Thank you for your contribution!</h3>');


DECLARE @rrkid int
DECLARE @rrk varchar(max)
DECLARE @rrt varchar(max)
DECLARE @rval varchar(max)
DECLARE @rttl varchar(max)
DECLARE @lcg varchar(max)
/*
* APPEND ReviseResourceKeys with correct LOV_ContentsGroupIDs
*/

DECLARE cur CURSOR FOR SELECT ResourceKey, ResourceType, KeyTitle FROM @temp
OPEN cur

FETCH NEXT FROM cur INTO @rrk, @rrt, @rttl

WHILE @@FETCH_STATUS = 0 BEGIN
    --EXEC mysp @rkey, @rval ... -- call your sp here
	SET @cntgrp = (SELECT [LOV_ContentsGroupID] FROM [dbo].[LOV_ContentsGroup] where Code = 'SURVEY');
	SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
	BEGIN TRANSACTION;
		INSERT INTO [dbo].[ReviseResourceKey]
			([ResourceKey] ,[ResourceType] ,[AllowHTML] ,[KeyDescription] ,[KeyTitle] ,[ContentsGroupID])
		VALUES
			(@rrk,@rrt,'1','',@rttl,@cntgrp);

	COMMIT TRANSACTION;

	FETCH NEXT FROM cur INTO @rrk, @rrt, @rttl
END

CLOSE cur    
DEALLOCATE cur


DECLARE cur CURSOR FOR SELECT ResourceKey, ResourceType, ResourceValue FROM @temp
OPEN cur

FETCH NEXT FROM cur INTO @rrk, @rrt, @rval

WHILE @@FETCH_STATUS = 0 BEGIN
    --EXEC mysp @rkey, @rval ... -- call your sp here

	SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
	BEGIN TRANSACTION;
		SET @rrkid = (SELECT ResourceKeyID FROM [dbo].[ReviseResourceKey] where [ResourceKey] = @rrk and [ResourceType] = @rrt);

		UPDATE [dbo].[ReviseResourceValue]
			SET [ResourceValue] = @rval 
			WHERE [ResourceKeyID] = @rrkid and [CultureCode] = 'en-GB';

		IF @@ROWCOUNT = 0
		BEGIN
			INSERT INTO [dbo].[ReviseResourceValue]
			([ResourceKeyID],[CultureCode],[ResourceValue])
				VALUES (@rrkid, 'en-GB',@rval);
		END
	COMMIT TRANSACTION;

	FETCH NEXT FROM cur INTO  @rrk, @rrt, @rval
END

CLOSE cur    
DEALLOCATE cur
