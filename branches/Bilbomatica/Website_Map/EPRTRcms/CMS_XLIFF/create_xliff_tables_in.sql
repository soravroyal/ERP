use eprtrcms

if object_id('EPRTRcms.dbo.xliff_Value')is not null DROP TABLE EPRTRcms.dbo.xliff_Value
if object_id('EPRTRcms.dbo.xliff_TransID')is not null DROP TABLE EPRTRcms.dbo.xliff_TransID
if object_id('EPRTRcms.dbo.xliff_group')is not null DROP TABLE EPRTRcms.dbo.xliff_group
if object_id('EPRTRcms.dbo.xliff_header')is not null DROP TABLE EPRTRcms.dbo.xliff_header
if object_id('EPRTRcms.dbo.xliff_file')is not null DROP TABLE EPRTRcms.dbo.xliff_file

CREATE TABLE [dbo].[xliff_file](
	[FileID] [int] IDENTITY(1,1) NOT NULL,
	[DataType]  [nvarchar](20) NOT NULL,
	[SourceLanguage] [nvarchar](10) NOT NULL,
	[TargetLanguage] [nvarchar](10) NOT NULL,
 CONSTRAINT [FileID] PRIMARY KEY CLUSTERED 
(
	[FileID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

CREATE TABLE [dbo].[xliff_header](
	[FileID] [int] NOT NULL,
	[uid]  [nvarchar](50) NOT NULL)

ALTER TABLE [dbo].[xliff_header]  WITH CHECK ADD  CONSTRAINT [FK_xliff_header_xliff_file] FOREIGN KEY([FileID])
REFERENCES [dbo].[xliff_file] ([fileid])	


CREATE TABLE [dbo].[xliff_Group]( 
	[GroupID] [int] IDENTITY(1,1) NOT NULL,
	[FileID] int  NOT NULL,
	[KeyID] [int] null,
	[GroupText] nvarchar (255)  NULL ,
CONSTRAINT [GroupID] PRIMARY KEY CLUSTERED 
(
	[GroupID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
ALTER TABLE [dbo].[xliff_group]  WITH CHECK ADD  CONSTRAINT [FK_xliff_group_xliff_file] FOREIGN KEY([FileID])
REFERENCES [dbo].[xliff_file] ([fileid])


CREATE TABLE [dbo].[xliff_TransID]( 
	[TransID] [int] IDENTITY(1,1) NOT NULL,
	[KeyID] [int],
	[TransIDText] nvarchar (max)  NOT NULL ,
	[GroupID] [int],
CONSTRAINT [TransID] PRIMARY KEY CLUSTERED 
(
	[TransID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
ALTER TABLE [dbo].[xliff_TransID]  WITH CHECK ADD  CONSTRAINT [FK_xliff_TransID_xliff_group] FOREIGN KEY([GroupID])
REFERENCES [dbo].[xliff_group] ([Groupid])

CREATE TABLE [dbo].[xliff_Value]( 
	[ValueID] [int] IDENTITY(1,1) NOT NULL,
	[TransID] [int],
	[Source] nvarchar (max)  NOT NULL ,
	[Target] nvarchar (max)  NULL ,
CONSTRAINT [ValueID] PRIMARY KEY CLUSTERED 
(
	[ValueID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
ALTER TABLE [dbo].[xliff_Value]  WITH CHECK ADD  CONSTRAINT [FK_xliff_Value_xliff_TransID] FOREIGN KEY([TransID])
REFERENCES [dbo].[xliff_TransID] ([TransID])