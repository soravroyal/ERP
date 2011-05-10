use eprtrcms

if object_id('EPRTRcms.dbo.xliff_corevalue')is not null DROP TABLE EPRTRcms.dbo.xliff_corevalue
if object_id('EPRTRcms.dbo.xliff_coretransid')is not null DROP TABLE EPRTRcms.dbo.xliff_coretransid
if object_id('EPRTRcms.dbo.xliff_coregroup')is not null DROP TABLE EPRTRcms.dbo.xliff_coregroup
if object_id('EPRTRcms.dbo.xliff_news_bodytext')is not null DROP TABLE EPRTRcms.dbo.xliff_news_bodytext
if object_id('EPRTRcms.dbo.xliff_news_headertext')is not null DROP TABLE EPRTRcms.dbo.xliff_news_headertext
if object_id('EPRTRcms.dbo.xliff_newsgroup')is not null DROP TABLE EPRTRcms.dbo.xliff_newsgroup
if object_id('EPRTRcms.dbo.xliff_reviseresourcevalue')is not null DROP TABLE EPRTRcms.dbo.xliff_reviseresourcevalue
if object_id('EPRTRcms.dbo.xliff_reviseresourcekey')is not null DROP TABLE EPRTRcms.dbo.xliff_reviseresourcekey
if object_id('EPRTRcms.dbo.XLIFF_CONTENTSGROUP')is not null DROP TABLE EPRTRcms.dbo.XLIFF_CONTENTSGROUP
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
values(1,'plaintext','en','fr')
insert into dbo.xliff_file (fileid,datatype,sourcelanguage,targetlanguage)
values(2,'plaintext','en','fr')
insert into dbo.xliff_file (fileid,datatype,sourcelanguage,targetlanguage)
values(3,'plaintext','en','fr')

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

/*
----- Copy core tables ----------------------
---OBS resourcetype bør ikke kunne være null!!!!
insert into dbo.xliff_group (keyid,grouptext,fileid) select null,resourcetype,1 
from [dbo].[tat_resourcekey]
--where resourcetype not in ('LOV_RIVERBASINDISTRICT','LOV_NUTSREGION') group by resourcetype
where resourcetype in ('Pollutant') group by resourcetype

insert into dbo.xliff_transid (keyid,transidtext,groupid) 
select trk.resourcekeyid,trk.resourcekey,xg.groupid from dbo.tat_resourcekey trk
inner join xliff_group xg
on xg.grouptext=trk.resourcetype
and xg.fileid = 1

insert into dbo.xliff_value (source,target,transid)
select trv.resourcevalue,' ',xtid.transid from [dbo].[tat_resourcevalue] trv
inner join dbo.xliff_transid xtid
on xtid.keyid = trv.resourcekeyid
and xtid.groupid in (select groupid from dbo.xliff_group where fileid = 1) 
where culturecode = 'en-GB'


----- Copy cms tables ----------------------
insert into dbo.xliff_group (keyid,grouptext,fileid) 
select lov_contentsgroupid,name,2 
from [dbo].[LOV_ContentsGroup]

insert into dbo.xliff_transid (keyid,transidtext,groupid) 
select rrk.resourcekeyid,rrk.resourcekey,xg.groupid from dbo.reviseresourcekey rrk
inner join xliff_group xg
on xg.keyid=rrk.contentsgroupid
and xg.fileid = 2

insert into dbo.xliff_value (source,target,transid)
select rrv.resourcevalue,' ',xtid.transid from dbo.reviseresourcevalue rrv
inner join dbo.xliff_transid xtid
on xtid.keyid = rrv.resourcekeyid
and xtid.groupid in (select groupid from xliff_group where fileid = 2)
where culturecode = 'en-GB'


----- Copy news tables ----------------------

insert into dbo.xliff_group (keyid,grouptext,fileid) 
select newskeyid, newskeyid,3 
from [dbo].[newskey]

insert into dbo.xliff_transid (keyid,transidtext,groupid) 
select xg.keyid,'headertext',xg.groupid from dbo.newsvalue nv
inner join xliff_group xg
on xg.keyid=nv.newskeyid
and xg.fileid = 3
insert into dbo.xliff_transid (keyid,transidtext,groupid) 
select xg.keyid,'bodytext',xg.groupid from dbo.newsvalue nv
inner join xliff_group xg
on xg.keyid=nv.newskeyid
and xg.fileid = 3

insert into dbo.xliff_value (source,target,transid)
select nv.headertext,' ',xtid.transid from dbo.newsvalue nv
inner join dbo.xliff_transid xtid
on xtid.keyid = nv.newskeyid
and xtid.transidtext = 'headertext'
where culturecode = 'en-GB'

insert into dbo.xliff_value (source,target,transid)
select nv.bodytext,' ',xtid.transid from dbo.newsvalue nv
inner join dbo.xliff_transid xtid
on xtid.keyid = nv.newskeyid
and xtid.transidtext = 'bodytext'
where culturecode = 'en-GB'

*/

















/*


select newskeyid,headertext into [dbo].[xliff_news_headertext] from [dbo].[newsvalue]
where culturecode = 'en-GB'

select newskeyid,bodytext as source into [dbo].[xliff_news_bodytext] from [dbo].[newsvalue]
where culturecode = 'en-GB'


*/

/*
select distinct resourcetype,1 as fileid into [dbo].[xliff_coregroup] from [dbo].[tat_resourcekey]
where resourcetype not in ('LOV_RIVERBASINDISTRICT','LOV_NUTSREGION')
alter table dbo.xliff_coregroup alter column resourcetype nvarchar(255) not null

ALTER TABLE dbo.xliff_coregroup ADD CONSTRAINT
	PK_xliff_coregroup PRIMARY KEY CLUSTERED 
	(
	resourcetype
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
ALTER TABLE [dbo].[xliff_coregroup]  WITH CHECK ADD  CONSTRAINT [FK_xliff_coregroup_xliff_file] FOREIGN KEY([FileID])
REFERENCES [dbo].[xliff_file] ([fileid])

select trk.resourcetype,resourcekeyid,resourcekey,1 as fileid into [dbo].[xliff_coretransid] from [dbo].[tat_resourcekey] trk
inner join dbo.xliff_coregroup cg
on cg.resourcetype = trk.resourcetype

ALTER TABLE dbo.xliff_coretransid ADD CONSTRAINT
	PK_xliff_coretransid PRIMARY KEY CLUSTERED 
	(
	resourcekeyid
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
ALTER TABLE [dbo].[xliff_coretransid]  WITH CHECK ADD  CONSTRAINT [FK_xliff_coretransid_xliff_coregroup] FOREIGN KEY([resourcetype])
REFERENCES [dbo].[xliff_coregroup] ([resourcetype])
----evt. index på resourcetype

select trv.resourcekeyid,resourcevalue as source,@TARGET as target into [dbo].[xliff_corevalue] from [dbo].[tat_resourcevalue] trv
inner join dbo.xliff_coretransid ct
on ct.resourcekeyid = trv.resourcekeyid
where culturecode = 'en-GB'
ALTER TABLE [dbo].[xliff_corevalue]  WITH CHECK ADD CONSTRAINT [FK_xliff_corevalue_xliff_coretransid] FOREIGN KEY([resourcekeyid])
REFERENCES [dbo].[xliff_coretransid] ([resourcekeyid])
---evt. index på resourcekeyid




----- Create cms translation tables ----------------------

insert into dbo.xliff_group (fileid,grouptext) select 2, name 
from [dbo].[LOV_ContentsGroup]

select *,2 as fileid into [dbo].[xliff_contentsgroup] from [dbo].[LOV_ContentsGroup]
ALTER TABLE dbo.xliff_contentsgroup ADD CONSTRAINT
	PK_xliff_contentsgroup PRIMARY KEY CLUSTERED 
	(
	LOV_ContentsGroupID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
ALTER TABLE [dbo].[xliff_contentsgroup]  WITH CHECK ADD  CONSTRAINT [FK_xliff_contentsgroup_xliff_file] FOREIGN KEY([FileID])
REFERENCES [dbo].[xliff_file] ([fileid])


select * into [dbo].[xliff_reviseresourcekey] from [dbo].[reviseresourcekey]
ALTER TABLE dbo.xliff_reviseresourcekey ADD CONSTRAINT
	PK_xliff_reviseresourcekey PRIMARY KEY CLUSTERED 
	(
	ResourceKeyID
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
ALTER TABLE [dbo].[xliff_reviseresourcekey]  WITH CHECK ADD  CONSTRAINT [FK_xliff_reviseresourcekey_xliff_ContentsGroup] FOREIGN KEY([ContentsGroupID])
REFERENCES [dbo].[xliff_ContentsGroup] ([LOV_ContentsGroupID])

select resourcekeyid,resourcevalue as source,@TARGET as target into [dbo].[xliff_reviseresourcevalue] from [dbo].[reviseresourcevalue] where
culturecode = 'en-GB' and resourcekeyid = 2
ALTER TABLE [dbo].[xliff_reviseresourcevalue]  WITH CHECK ADD CONSTRAINT [FK_xliff_reviseresourcevalue_xliff_reviseresourcekey] FOREIGN KEY([resourcekeyid])
REFERENCES [dbo].[xliff_reviseresourcekey] ([resourcekeyid])

----- Create news translation tables ----------------------



select newskeyid,3 as fileid into [dbo].[xliff_newsgroup] from [dbo].[newskey]
ALTER TABLE dbo.xliff_newsgroup ADD CONSTRAINT
	PK_xliff_newssgroup PRIMARY KEY CLUSTERED 
	(
newskeyid
	) WITH( STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
ALTER TABLE [dbo].[xliff_newsgroup]  WITH CHECK ADD  CONSTRAINT [FK_xliff_newsgroup_xliff_file] FOREIGN KEY([FileID])
REFERENCES [dbo].[xliff_file] ([fileid])

select newskeyid,headertext into [dbo].[xliff_news_headertext] from [dbo].[newsvalue]
where culturecode = 'en-GB'
ALTER TABLE [dbo].[xliff_news_headertext]  WITH CHECK ADD  CONSTRAINT [FK_xliff_news_headertext_xliff_newsgroup] FOREIGN KEY([newskeyid])
REFERENCES [dbo].[xliff_newsgroup] ([newskeyid])

select newskeyid,bodytext as source,@TARGET as target into [dbo].[xliff_news_bodytext] from [dbo].[newsvalue]
where culturecode = 'en-GB'
ALTER TABLE [dbo].[xliff_news_bodytext]  WITH CHECK ADD  CONSTRAINT [FK_xliff_news_bodytext_xliff_newsgroup] FOREIGN KEY([newskeyid])
REFERENCES [dbo].[xliff_newsgroup] ([newskeyid])
*/