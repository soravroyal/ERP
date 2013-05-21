


use eprtrcms
go

if object_id('EPRTRcms.dbo.xliff_deltaexport')is not null DROP Procedure dbo.xliff_deltaexport
go

create procedure [dbo].[xliff_deltaexport]
	@pSourceLanguage nvarchar(5),
	@pTargetLanguage nvarchar(5)
as
begin
declare @pSourceCultureCode nvarchar(10)
declare @pTargetCultureCode nvarchar(10)
select @pSourceCultureCode = code 
		from [EPRTRcms].[dbo].[LOV_Culture]
		where codexliff = @pSourceLanguage
select @pTargetCultureCode = code 
		from [EPRTRcms].[dbo].[LOV_Culture]
		where codexliff = @pTargetLanguage

if object_id('EPRTRcms.dbo.xliff_Value')is not null DROP TABLE EPRTRcms.dbo.xliff_Value
if object_id('EPRTRcms.dbo.xliff_TransID')is not null DROP TABLE EPRTRcms.dbo.xliff_TransID
if object_id('EPRTRcms.dbo.xliff_group')is not null DROP TABLE EPRTRcms.dbo.xliff_group
if object_id('EPRTRcms.dbo.xliff_header')is not null DROP TABLE EPRTRcms.dbo.xliff_header
if object_id('EPRTRcms.dbo.xliff_file')is not null DROP TABLE EPRTRcms.dbo.xliff_file

CREATE TABLE [dbo].[xliff_file](
	[FileID] [int] NOT NULL,
	[DataType]  [nvarchar](20) NOT NULL,
	[SourceLanguage] [nvarchar](10) NOT NULL,
	[TargetLanguage] [nvarchar](10) NOT NULL,
 CONSTRAINT [FileID] PRIMARY KEY CLUSTERED 
(
	[FileID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

insert into dbo.xliff_file (fileid,datatype,sourcelanguage,targetlanguage)
values(1,'plaintext',@pSourceLanguage,@pTargetLanguage)
insert into dbo.xliff_file (fileid,datatype,sourcelanguage,targetlanguage)
values(2,'plaintext',@pSourceLanguage,@pTargetLanguage)
insert into dbo.xliff_file (fileid,datatype,sourcelanguage,targetlanguage)
values(3,'plaintext',@pSourceLanguage,@pTargetLanguage)

CREATE TABLE [dbo].[xliff_header](
	[FileID] [int] NOT NULL,
	[uid]  [nvarchar](50) NOT NULL)
insert into dbo.xliff_header (fileid,uid)
values(1,'core_texts')	
insert into dbo.xliff_header (fileid,uid)
values(2,'cms_texts')	
insert into dbo.xliff_header (fileid,uid)
values(3,'news_texts')	
ALTER TABLE [dbo].[xliff_header]  WITH CHECK ADD  CONSTRAINT [FK_xliff_header_xliff_file] FOREIGN KEY([FileID])
REFERENCES [dbo].[xliff_file] ([fileid])	


CREATE TABLE [dbo].[xliff_Group]( 
	[GroupID] [int] IDENTITY(1,1) NOT NULL,
	[FileID] int  NOT NULL ,
	[KeyID] [int],
	[GroupText] nvarchar (255)  NOT NULL ,
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

    insert into dbo.xliff_header (fileid,uid)
	values(1,'core_texts')	
	insert into dbo.xliff_header (fileid,uid)
	values(2,'cms_texts')	
	insert into dbo.xliff_header (fileid,uid)
	values(3,'news_texts')
	
	insert into dbo.xliff_group (keyid,grouptext,fileid) select null,xd.resourcetype,1 
	from dbo.xliff_delta xd
	inner join dbo.tAT_ResourceKey trk
	on trk.ResourceType = xd.ResourceType and trk.ResourceKey = xd.ResourceKey
	where textgroup in ('changed_core_texts','created_core_texts')
	group by xd.resourcetype

	insert into dbo.xliff_transid (keyid,transidtext,groupid) 
	select trk.resourcekeyid,trk.resourcekey,xg.groupid from dbo.tat_resourcekey trk
	inner join xliff_group xg
	on xg.grouptext=trk.resourcetype
	and xg.fileid = 1
	where Resourcekey in
	(select resourcekey from dbo.xliff_delta
	where textgroup in ('changed_core_texts','created_core_texts'))

	insert into dbo.xliff_value (source,target,transid)
	select trv.resourcevalue,trv.resourcevalue,xtid.transid from dbo.tat_resourcevalue trv
	inner join dbo.xliff_transid xtid
	on xtid.keyid = trv.resourcekeyid
	and xtid.groupid in (select groupid from dbo.xliff_group where fileid = 1) 
	where culturecode = 'en-GB'
	
	insert into dbo.xliff_group (keyid,grouptext,fileid) select null,xd.ResourceType,2 
	from dbo.xliff_delta xd
	inner join dbo.ReviseResourceKey rrk
	on rrk.ResourceType = xd.ResourceType and rrk.ResourceKey = xd.ResourceKey
	where textgroup in ('changed_cms_texts','created_cms_texts')  
	group by xd.resourcetype
		
	insert into dbo.xliff_transid (keyid,transidtext,groupid) 
	select rrk.resourcekeyid,rrk.resourcekey,xg.groupid from dbo.reviseresourcekey rrk
	inner join xliff_group xg
	on xg.grouptext=rrk.resourcetype
	and xg.fileid = 2
	where Resourcekey in
	(select resourcekey from dbo.xliff_delta
	where textgroup in ('changed_cms_texts','created_cms_texts'))

	insert into dbo.xliff_value (source,target,transid)
	select rrv.resourcevalue,rrv.resourcevalue,xtid.transid from dbo.reviseresourcevalue rrv
	inner join dbo.xliff_transid xtid
	on xtid.keyid = rrv.resourcekeyid
	and xtid.groupid in (select groupid from xliff_group where fileid = 2)
	where culturecode = 'en-GB'   
    
    insert into dbo.xliff_group (keyid,grouptext,fileid) select resourcekey,resourcekey,3 
	from dbo.xliff_delta
	where textgroup in ('changed_news_texts_header','changed_news_texts_body',
	'created_news_texts_header','created_news_texts_body') 
	group by resourcekey

	insert into dbo.xliff_transid (keyid,transidtext,groupid) 
	select xg.keyid,'headertext',xg.groupid from dbo.newsvalue nv
	inner join xliff_group xg
	on xg.keyid=nv.newskeyid
	and xg.fileid = 3 and culturecode = 'en-GB'
	 
	insert into dbo.xliff_transid (keyid,transidtext,groupid) 
	select xg.keyid,'bodytext',xg.groupid from dbo.newsvalue nv
	inner join xliff_group xg
	on xg.keyid=nv.newskeyid 
	and xg.fileid = 3 and culturecode = 'en-GB'

	insert into dbo.xliff_value (source,target,transid)
	select xd.TextInCMS,isnull(xd.TextinFile,xd.TextInFile1),xtid.transid from dbo.xliff_delta xd
	inner join dbo.xliff_transid xtid
	on xtid.TransIDText = xd.ResourceKey
	and xtid.groupid in (select groupid from dbo.xliff_group where fileid = 3)

	insert into dbo.xliff_value (source,target,transid)
	select nv.headertext,nv.headertext,xtid.transid from dbo.newsvalue nv
	inner join dbo.xliff_transid xtid
	on xtid.keyid = nv.newskeyid
	and xtid.transidtext = 'headertext'
	where culturecode = 'en-GB' 

	insert into dbo.xliff_value (source,target,transid)
	select nv.bodytext,nv.bodytext,xtid.transid from dbo.newsvalue nv
	inner join dbo.xliff_transid xtid
	on xtid.keyid = nv.newskeyid
	and xtid.transidtext = 'bodytext'
	where culturecode = 'en-GB'

print 'Data successfully copied to export tables'

END