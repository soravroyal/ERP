USE [EPRTRcms]
GO

/****** Object:  Table [dbo].[LOV_Culture]    Script Date: 09/23/2009 15:35:33 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[LOV_Culture](
	[LOV_CultureID] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](255) NOT NULL,
	[EnglishName] [nvarchar](255) NOT NULL,
	[Name] [nvarchar](255) NULL,
 CONSTRAINT [LOV_CultureID] PRIMARY KEY CLUSTERED 
(
	[LOV_CultureID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
go

insert into LOV_Culture
values(
	'en-GB',	
	'English',
	'English'
)
GO


