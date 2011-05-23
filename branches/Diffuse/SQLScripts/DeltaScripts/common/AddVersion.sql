SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

--create version table if not exists
IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[tAT_version]')
AND OBJECTPROPERTY(id, N'IsUserTable') = 1)
	CREATE TABLE [dbo].[tAT_version](
	    [VersionID] [int] IDENTITY(1,1) NOT NULL,
		[Major_version] [int] NOT NULL,
		[Minor_version] [int] NOT NULL,
		[CreatedDate] [datetime] NULL,
		[Remark] [nvarchar](255) NULL
	) ON [PRIMARY]

GO


-- Creating a trigger on version table if not exists.
IF NOT EXISTS (SELECT * FROM sysobjects WHERE id = object_id(N'[dbo].[tr_tAT_version]')
AND xtype='TR')
    EXEC ('CREATE TRIGGER dbo.[tr_tAT_version]
             ON dbo.[tAT_version]
             AFTER INSERT
           AS
             BEGIN
               SELECT 1
             END')  
GO  

ALTER TRIGGER [dbo].[tr_tAT_version]
on [dbo].[tAT_version]
FOR INSERT
AS 
BEGIN
	update dbo.tAT_version set CreatedDate = GETDATE()
	where VersionID in (select VersionID from inserted)
END	
GO 