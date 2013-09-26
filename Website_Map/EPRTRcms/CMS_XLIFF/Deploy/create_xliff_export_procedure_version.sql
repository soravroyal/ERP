


use eprtrcms
go

if object_id('EPRTRcms.dbo.xliff_export')is not null DROP Procedure dbo.xliff_export
go

create procedure [dbo].[xliff_export]
	@pSourceLanguage nvarchar(5),
	@pTargetLanguage nvarchar(5),
	@pLanguageInTargetField nvarchar(5) = null,
	@pSpecificPart nvarchar(20) = null,
	@pChangedDateStartInput nvarchar(100) = null,
	@pChangedDateStopInput nvarchar(100) = null
as
begin
IF @pSpecificPart is null
set @pSpecificPart = 'A'

IF @pChangedDateStartInput is null
set @pChangedDateStartInput = '2000-01-01 00:00:00'
IF @pChangedDateStopInput is null
set @pChangedDateStopInput = '2050-01-01 00:00:00'

declare @pSourceCultureCode nvarchar(10)
declare @pTargetCultureCode nvarchar(10)
declare @pLanguageTarget nvarchar(10)
declare @pChangedDateStart datetime
declare @pChangedDateStop datetime
select @pSourceCultureCode = code 
		from [EPRTRcms].[dbo].[LOV_Culture]
		where codexliff = @pSourceLanguage
select @pTargetCultureCode = code 
		from [EPRTRcms].[dbo].[LOV_Culture]
		where codexliff = @pTargetLanguage
select @pLanguageTarget = code 
		from [EPRTRcms].[dbo].[LOV_Culture]
		where codexliff = @pLanguageInTargetField

IF @pLanguageTarget is null
set @pLanguageTarget = 'en-GB'

IF @pLanguageTarget <> 'en-GB'
print 'LanguageTarget not English but '+ @pLanguageTarget

set @pChangedDateStart = cast(@pChangedDateStartInput as DateTime)
set @pChangedDateStop = cast(@pChangedDateStopInput as DateTime)

--set @ncount = (select count(distinct TargetLanguage) FROM [EPRTRcms].[dbo].[xliff_file])
--print('@ncount: '+ cast (@ncount as nvarchar) +'')


IF @pSpecificPart not in ('N','C','A')
		
	RAISERROR ('Value given in SpecificPart input parameter has to be N=New, C=Changed or A=All', 11,1)

if object_id('EPRTRcms.dbo.xliff_Value')is not null DROP TABLE EPRTRcms.dbo.xliff_Value
if object_id('EPRTRcms.dbo.xliff_TransID')is not null DROP TABLE EPRTRcms.dbo.xliff_TransID
if object_id('EPRTRcms.dbo.xliff_group')is not null DROP TABLE EPRTRcms.dbo.xliff_group
if object_id('EPRTRcms.dbo.xliff_header')is not null DROP TABLE EPRTRcms.dbo.xliff_header
if object_id('EPRTRcms.dbo.xliff_file')is not null DROP TABLE EPRTRcms.dbo.xliff_file

insert into dbo.xliff_impexp_tracking (ImportExport,xliff_Code,Date)
values ('Export',@pTargetLanguage,GETDATE())

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

/*
IF @pSpecificPart = 'A'
begin
print 'Exporting All texts'
----- Copy core tables ----------------------
---OBS resourcetype bør ikke kunne være null!!!!
insert into dbo.xliff_group (keyid,grouptext,fileid) select null,resourcetype,1 
from dbo.tat_resourcekey
group by resourcetype

insert into dbo.xliff_transid (keyid,transidtext,groupid) 
select trk.resourcekeyid,trk.resourcekey,xg.groupid from dbo.tat_resourcekey trk
inner join xliff_group xg
on xg.grouptext=trk.resourcetype
and xg.fileid = 1

insert into dbo.xliff_value (source,target,transid)
select trv.resourcevalue,trv.resourcevalue,xtid.transid from [dbo].[tat_resourcevalue] trv
inner join dbo.xliff_transid xtid
on xtid.keyid = trv.resourcekeyid
and xtid.groupid in (select groupid from dbo.xliff_group where fileid = 1) 
where culturecode = 'en-GB'

IF @pLanguageTarget <> 'en-GB'
update dbo.xliff_value set Target = trv.ResourceValue
from tAT_ResourceValue trv
inner join xliff_transid xtid
on xtid.keyid = trv.resourcekeyid
inner join xliff_value xv
on xtid.transid = xv.transid
where culturecode = @pLanguageTarget 
---Muligvis bør den kun udskifte med oversættelse i de tilfælde, hvor den
---engelske tekst ikke er blevet ændret, men er dato er jo ikke en
---påkrævet input-parameter!
and xtid.groupid in (select groupid from dbo.xliff_group where fileid = 1)


----- Copy cms tables ----------------------
insert into dbo.xliff_group (keyid,grouptext,fileid) 
select null,ResourceType,2 
from [dbo].[reviseresourcekey] group by resourcetype

insert into dbo.xliff_transid (keyid,transidtext,groupid) 
select rrk.resourcekeyid,rrk.resourcekey,xg.groupid from dbo.reviseresourcekey rrk
inner join xliff_group xg
on xg.grouptext=rrk.resourcetype
and xg.fileid = 2

insert into dbo.xliff_value (source,target,transid)
select rrv.resourcevalue,rrv.resourcevalue,xtid.transid from dbo.reviseresourcevalue rrv
inner join dbo.xliff_transid xtid
on xtid.keyid = rrv.resourcekeyid
and xtid.groupid in (select groupid from xliff_group where fileid = 2)
where culturecode = 'en-GB'

IF @pLanguageTarget <> 'en-GB'
update dbo.xliff_value set Target = rrv.ResourceValue
from ReviseResourceValue rrv
inner join xliff_transid xtid
on xtid.keyid = rrv.resourcekeyid
inner join xliff_value xv
on xtid.transid = xv.transid
where culturecode = @pLanguageTarget 
---Muligvis bør den kun udskifte med oversættelse i de tilfælde, hvor den
---engelske tekst ikke er blevet ændret, men er dato er jo ikke en
---påkrævet input-parameter!
and xtid.groupid in (select groupid from dbo.xliff_group where fileid = 2)


----- Copy news tables ----------------------
insert into dbo.xliff_group (keyid,grouptext,fileid) 
select newskeyid, newskeyid,3 
from [dbo].[newskey]

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
end

IF @pLanguageTarget <> 'en-GB'
begin
update dbo.xliff_value set Target = nv.HeaderText
from dbo.newsvalue nv
inner join xliff_transid xtid
on xtid.keyid = nv.newskeyid
inner join xliff_value xv
on xtid.transid = xv.transid
where culturecode = @pLanguageTarget 
---Muligvis bør den kun udskifte med oversættelse i de tilfælde, hvor den
---engelske tekst ikke er blevet ændret, men er dato er jo ikke en
---påkrævet input-parameter!
and xtid.transidtext = 'headertext'
and xtid.groupid in (select groupid from dbo.xliff_group where fileid = 3)
update dbo.xliff_value set Target = nv.BodyText
from dbo.newsvalue nv
inner join xliff_transid xtid
on xtid.keyid = nv.newskeyid
inner join xliff_value xv
on xtid.transid = xv.transid
where culturecode = @pLanguageTarget 
---Muligvis bør den kun udskifte med oversættelse i de tilfælde, hvor den
---engelske tekst ikke er blevet ændret, men er dato er jo ikke en
---påkrævet input-parameter!
and xtid.transidtext = 'bodytext'
and xtid.groupid in (select groupid from dbo.xliff_group where fileid = 3)
end
*/


IF @pSpecificPart in ('C','A')
begin
print 'Exporting Changed and New texts'
----- Copy core tables ----------------------
---OBS resourcetype bør ikke kunne være null!!!!
insert into dbo.xliff_group (keyid,grouptext,fileid) select null,resourcetype,1 
from dbo.tat_resourcekey
where Resourcekeyid in 
(select resourcekeyid from dbo.tAT_ResourceValue trv
where culturecode = 'en-GB' and changeddate > @pChangedDateStart and changeddate < @pChangedDateStop) 
--New texts will automaticly be included since the ChangedDate of the ValueText
--was updated when the text was inserted.
--or createddate > @pChangedDateStart
group by resourcetype

insert into dbo.xliff_transid (keyid,transidtext,groupid) 
select trk.resourcekeyid,trk.resourcekey,xg.groupid from dbo.tat_resourcekey trk
inner join xliff_group xg
on xg.grouptext=trk.resourcetype
and xg.fileid = 1
where Resourcekeyid in 
(select resourcekeyid from dbo.tAT_ResourceValue trv
where culturecode = 'en-GB' and changeddate > @pChangedDateStart and changeddate < @pChangedDateStop)
--New texts will automaticly be included since the ChangedDate of the ValueText
--was updated when the text was inserted.
--or createddate > @pChangedDateStart

insert into dbo.xliff_value (source,target,transid)
select trv.resourcevalue,trv.resourcevalue,xtid.transid from [dbo].[tat_resourcevalue] trv
inner join dbo.xliff_transid xtid
on xtid.keyid = trv.resourcekeyid
and xtid.groupid in (select groupid from dbo.xliff_group where fileid = 1) 
where culturecode = 'en-GB' and changeddate > @pChangedDateStart and changeddate < @pChangedDateStop

IF @pLanguageTarget <> 'en-GB'
update dbo.xliff_value set Target = trv.ResourceValue
from tAT_ResourceValue trv
inner join xliff_transid xtid
on xtid.keyid = trv.resourcekeyid
inner join xliff_value xv
on xtid.transid = xv.transid
where culturecode = @pLanguageTarget and changeddate > @pChangedDateStart and changeddate < @pChangedDateStop
and xtid.groupid in (select groupid from dbo.xliff_group where fileid = 1)



----- Copy cms tables ----------------------
insert into dbo.xliff_group (keyid,grouptext,fileid) 
select null,ResourceType,2 
from [dbo].[reviseresourcekey] 
where resourcekeyid in 
(select resourcekeyid from dbo.ReviseResourceValue
where culturecode = 'en-GB' and changeddate > @pChangedDateStart and changeddate < @pChangedDateStop) 
group by resourcetype

insert into dbo.xliff_transid (keyid,transidtext,groupid) 
select rrk.resourcekeyid,rrk.resourcekey,xg.groupid from dbo.reviseresourcekey rrk
inner join xliff_group xg
on xg.grouptext=rrk.resourcetype
and xg.fileid = 2
where rrk.resourcekeyid in 
(select resourcekeyid from dbo.ReviseResourceValue
where culturecode = 'en-GB' and changeddate > @pChangedDateStart and changeddate < @pChangedDateStop)

insert into dbo.xliff_value (source,target,transid)
select rrv.resourcevalue,rrv.resourcevalue,xtid.transid from dbo.reviseresourcevalue rrv
inner join dbo.xliff_transid xtid
on xtid.keyid = rrv.resourcekeyid
and xtid.groupid in (select groupid from xliff_group where fileid = 2)
where culturecode = 'en-GB' and changeddate > @pChangedDateStart and changeddate < @pChangedDateStop

IF @pLanguageTarget <> 'en-GB'
update dbo.xliff_value set Target = rrv.ResourceValue
from ReviseResourceValue rrv
inner join xliff_transid xtid
on xtid.keyid = rrv.resourcekeyid
inner join xliff_value xv
on xtid.transid = xv.transid
where culturecode = @pLanguageTarget and changeddate > @pChangedDateStart and changeddate < @pChangedDateStop
and xtid.groupid in (select groupid from dbo.xliff_group where fileid = 2)


----- Copy news tables ----------------------

insert into dbo.xliff_group (keyid,grouptext,fileid) 
select newskeyid, newskeyid,3 
from [dbo].[newskey]
where newskeyid in 
(select newskeyid from dbo.NewsValue
where culturecode = 'en-GB' and changeddate > @pChangedDateStart and changeddate < @pChangedDateStop) 

insert into dbo.xliff_transid (keyid,transidtext,groupid) 
select xg.keyid,'headertext',xg.groupid from dbo.newsvalue nv
inner join xliff_group xg
on xg.keyid=nv.newskeyid
and xg.fileid = 3 and culturecode = 'en-GB' and changeddate > @pChangedDateStart and changeddate < @pChangedDateStop
insert into dbo.xliff_transid (keyid,transidtext,groupid) 
select xg.keyid,'bodytext',xg.groupid from dbo.newsvalue nv
inner join xliff_group xg
on xg.keyid=nv.newskeyid 
and xg.fileid = 3 and culturecode = 'en-GB' and changeddate > @pChangedDateStart and changeddate < @pChangedDateStop

insert into dbo.xliff_value (source,target,transid)
select nv.headertext,nv.headertext,xtid.transid from dbo.newsvalue nv
inner join dbo.xliff_transid xtid
on xtid.keyid = nv.newskeyid
and xtid.transidtext = 'headertext'
where culturecode = 'en-GB' and changeddate > @pChangedDateStart and changeddate < @pChangedDateStop

insert into dbo.xliff_value (source,target,transid)
select nv.bodytext,nv.bodytext,xtid.transid from dbo.newsvalue nv
inner join dbo.xliff_transid xtid
on xtid.keyid = nv.newskeyid
and xtid.transidtext = 'bodytext'
where culturecode = 'en-GB' and changeddate > @pChangedDateStart and changeddate < @pChangedDateStop

IF @pLanguageTarget <> 'en-GB'
begin
update dbo.xliff_value set Target = nv.HeaderText
from dbo.newsvalue nv
inner join xliff_transid xtid
on xtid.keyid = nv.newskeyid
inner join xliff_value xv
on xtid.transid = xv.transid
where culturecode = @pLanguageTarget and changeddate > @pChangedDateStart and changeddate < @pChangedDateStop
and xtid.transidtext = 'headertext'
and xtid.groupid in (select groupid from dbo.xliff_group where fileid = 3)
update dbo.xliff_value set Target = nv.BodyText
from dbo.newsvalue nv
inner join xliff_transid xtid
on xtid.keyid = nv.newskeyid
inner join xliff_value xv
on xtid.transid = xv.transid
where culturecode = @pLanguageTarget and changeddate > @pChangedDateStart and changeddate < @pChangedDateStop
and xtid.transidtext = 'bodytext'
and xtid.groupid in (select groupid from dbo.xliff_group where fileid = 3)
end 

END


----


IF @pSpecificPart = 'N'
begin
print 'Exporting only new texts'
----- Copy core tables ----------------------
---OBS resourcetype bør ikke kunne være null!!!!
insert into dbo.xliff_group (keyid,grouptext,fileid) select null,resourcetype,1 
from dbo.tat_resourcekey
where createddate > @pChangedDateStart and createddate < @pChangedDateStop
group by resourcetype

insert into dbo.xliff_transid (keyid,transidtext,groupid) 
select trk.resourcekeyid,trk.resourcekey,xg.groupid from dbo.tat_resourcekey trk
inner join xliff_group xg
on xg.grouptext=trk.resourcetype
and xg.fileid = 1
where createddate > @pChangedDateStart and createddate < @pChangedDateStop

insert into dbo.xliff_value (source,target,transid)
select trv.resourcevalue,trv.resourcevalue,xtid.transid from [dbo].[tat_resourcevalue] trv
inner join dbo.xliff_transid xtid
on xtid.keyid = trv.resourcekeyid
and xtid.groupid in (select groupid from dbo.xliff_group where fileid = 1) 
where culturecode = 'en-GB'

----- Copy cms tables ----------------------
insert into dbo.xliff_group (keyid,grouptext,fileid) 
select null,ResourceType,2 
from [dbo].[reviseresourcekey] 
where createddate > @pChangedDateStart and createddate < @pChangedDateStop
group by resourcetype

insert into dbo.xliff_transid (keyid,transidtext,groupid) 
select rrk.resourcekeyid,rrk.resourcekey,xg.groupid from dbo.reviseresourcekey rrk
inner join xliff_group xg
on xg.grouptext=rrk.resourcetype
and xg.fileid = 2
where createddate > @pChangedDateStart and createddate < @pChangedDateStop

insert into dbo.xliff_value (source,target,transid)
select rrv.resourcevalue,rrv.resourcevalue,xtid.transid from dbo.reviseresourcevalue rrv
inner join dbo.xliff_transid xtid
on xtid.keyid = rrv.resourcekeyid
and xtid.groupid in (select groupid from xliff_group where fileid = 2)
where culturecode = 'en-GB'


----- Copy news tables ----------------------

insert into dbo.xliff_group (keyid,grouptext,fileid) 
select newskeyid, newskeyid,3 
from [dbo].[newskey]
where createddate > @pChangedDateStart and createddate < @pChangedDateStop

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
END

print 'Data successfully copied to export tables'

END