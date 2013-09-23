USE [EPRTRcms]
GO


if object_id('EPRTRcms.dbo.printout')is not null DROP Procedure dbo.printout
go

create procedure dbo.printout
@ptextgroup nvarchar(50),
@ptextnochanges nvarchar(255),
@ptextchanges nvarchar (255),
@ptextcolumns nvarchar (255)
as
begin
	declare 
	@txt1 nvarchar(255),
	@txt2 nvarchar(max),
	@txt3 nvarchar(max),
	@date datetime  
if (select count(1) from xliff_delta where TextGroup = @ptextgroup) = 0 
	print(@ptextnochanges)	
    else
    begin
	DECLARE 
	fac_Cursor CURSOR FOR
	SELECT resourcekey,textincms,TextInFile,changeddate 
	FROM xliff_delta 
	where textgroup = @ptextgroup order by ResourceKey;
	OPEN fac_Cursor;
	FETCH NEXT FROM fac_Cursor into @txt1,@txt2,@txt3,@date;
	print(@ptextchanges)
	print(@ptextcolumns)
	WHILE @@FETCH_STATUS = 0
	BEGIN
	--print('' + @txt1 + '	'+ @txt2 + '	'+ @txt3 + '	'+ @date)
	print('' + @txt1 + '	'+ isnull(cast(@date as nvarchar),'') + '')
		--print(@txt1)
	FETCH NEXT FROM fac_Cursor into @txt1,@txt2,@txt3,@date;
	END;
	CLOSE fac_Cursor;
	DEALLOCATE fac_Cursor;
	end
end

go

if object_id('EPRTRcms.dbo.xliff_import')is not null DROP Procedure dbo.xliff_import
go

create procedure [dbo].[xliff_import]
@pImportAndDeltaReport nvarchar(10) = 'Report'
as
begin
declare @ncount int
declare @pTargetLanguage nvarchar(5)
declare @pTargetCultureCode nvarchar(10)

IF @pImportAndDeltaReport not in ('Both','Report','Import')
	RAISERROR ('Value given in @ImportAndDeltaReport input parameter has to be either Both, Report or Import', 11,1)


if @pImportAndDeltaReport in ('Both','Import')
begin
print('Copying data from import tables')
begin try
begin transaction
set @ncount = (select count(distinct TargetLanguage) FROM [EPRTRcms].[dbo].[xliff_file])
print('@ncount: '+ cast (@ncount as nvarchar) +'')
IF @ncount > 1
		
	RAISERROR ('More than 1 Targetlanguage given in xliff file', 11,1)


select @pTargetLanguage = TargetLanguage FROM [EPRTRcms].[dbo].[xliff_file] group by targetlanguage
print('@pTargetLanguage: '+ cast (@pTargetLanguage as nvarchar) +'')

insert into dbo.xliff_impexp_tracking (ImportExport,xliff_Code,Date)
values ('Import',@pTargetLanguage,GETDATE())

select @pTargetCultureCode = code 
		from [EPRTRcms].[dbo].[LOV_Culture]
		where codexliff = @pTargetLanguage
 print('@pTargetCultureCode: '+ cast (@pTargetCultureCode as nvarchar) +'')

--delete dbo.tat_resourcevalue where CultureCode = @pTargetCultureCode
--delete dbo.reviseresourcevalue where CultureCode = @pTargetCultureCode
--delete dbo.NewsValue where CultureCode = @pTargetCultureCode

merge into dbo.tat_resourcevalue 
using (select
trk.ResourceKeyID,
xv.target
--@pTargetCultureCode as culcode
from [dbo].xliff_value xv
inner join dbo.xliff_transid xt
on xt.TransID = xv.TransID
inner join dbo.tat_resourcekey trk
on trk.ResourceKey = xt.TransIDText
inner join dbo.xliff_Group xg
on xt.GroupID = xg.GroupID
and xg.GroupText = trk.ResourceType
where xg.fileid = 1) inp
on tat_resourcevalue.resourcekeyid = inp.resourcekeyid and CultureCode = @pTargetCultureCode 
when matched then
update set ResourceValue = inp.target  
when not matched then 
insert (ResourceKeyID,ResourceValue,CultureCode)
values(
inp.ResourceKeyID,
inp.target,
@pTargetCultureCode); 

merge into dbo.ReviseResourceValue
using (select
rrk.ResourceKeyID,
xv.target
--@pTargetCultureCode as culcode
from [dbo].xliff_value xv
inner join dbo.xliff_transid xt
on xt.TransID = xv.TransID
inner join dbo.reviseresourcekey rrk
on rrk.ResourceKey = xt.TransIDText
inner join dbo.xliff_Group xg
on xt.GroupID = xg.GroupID
and xg.GroupText = rrk.ResourceType
where xg.fileid=2) inp
on reviseresourcevalue.resourcekeyid = inp.resourcekeyid and CultureCode = @pTargetCultureCode 
when matched then
update set ResourceValue = inp.target  
when not matched then 
insert (ResourceKeyID,ResourceValue,CultureCode)
values(
inp.ResourceKeyID,
inp.target,
@pTargetCultureCode);

merge into dbo.NewsValue
using (select
xg.GroupText,
xv.target
--,
--'',
--@pTargetCultureCode as culcode
from dbo.xliff_value xv
inner join dbo.xliff_transid xt
on xt.TransID = xv.TransID
inner join dbo.xliff_Group xg
on xt.GroupID = xg.GroupID
where xg.fileid=3 
and xt.transidtext = 'headertext') inp
on newsvalue.newskeyid = inp.grouptext and CultureCode = @pTargetCultureCode 
when matched then
update set headertext = inp.target
when not matched then
insert (NewsKeyID,HeaderText,BodyText,CultureCode)
values (
inp.GroupText,
inp.target,
'',
@pTargetCultureCode);

update dbo.NewsValue set BodyText = 
(select
xv.target
from dbo.xliff_value xv
inner join dbo.xliff_transid xt
on xt.TransID = xv.TransID
inner join dbo.xliff_Group xg
on xt.GroupID = xg.GroupID
where xg.fileid=3 
and xt.transidtext = 'bodytext' 
and xg.GroupText = NewsKeyID)
where CultureCode = @pTargetCultureCode


commit transaction
end try
BEGIN CATCH
    PRINT ERROR_MESSAGE()
    ROLLBACK
END CATCH
end

if @pImportAndDeltaReport in ('Both','Report')
begin
print ('Generating Deltareport')

---Changed texts
insert into xliff_delta (TextGroup,ResourceKey,TextInCMS,TextInFile,ChangedDate,TextInFile1)
select
'changed_news_texts_header',
nk.NewsKeyID,
nv.headertext,
xv.source,
nv.changeddate
,xv.source
--@pTargetCultureCode 
from [dbo].xliff_value xv
inner join dbo.xliff_transid xt
on xt.TransID = xv.TransID
inner join dbo.xliff_Group xg
on xt.GroupID = xg.GroupID
inner join dbo.newskey nk
on nk.NewsKeyID = xg.GroupText
inner join dbo.newsvalue nv
on nk.newskeyid = nv.newskeyid
where xg.fileid = 3 and culturecode = 'en-GB' and xt.transidtext = 'headertext'
and nv.headertext <> xv.source

insert into xliff_delta (TextGroup,ResourceKey,TextInCMS,TextInFile,ChangedDate,TextInFile1)
select
'changed_news_texts_body',
nk.NewsKeyID,
nv.bodytext,
xv.source,
nv.changeddate
,xv.source
--@pTargetCultureCode 
from [dbo].xliff_value xv
inner join dbo.xliff_transid xt
on xt.TransID = xv.TransID
inner join dbo.xliff_Group xg
on xt.GroupID = xg.GroupID
inner join dbo.newskey nk
on nk.NewsKeyID = xg.GroupText
inner join dbo.newsvalue nv
on nk.newskeyid = nv.newskeyid
where xg.fileid = 3 and culturecode = 'en-GB' and xt.transidtext = 'bodytext'
and nv.bodytext <> xv.source

insert into xliff_delta (TextGroup,ResourceType,ResourceKey,TextInCMS,TextInFile,ChangedDate,TextInFile1)
select
'changed_cms_texts',
rrk.ResourceType,
rrk.ResourceKey,
rrv.resourcevalue,
xv.source,
rrv.changeddate
,xv.source
from [dbo].xliff_value xv
inner join dbo.xliff_transid xt
on xt.TransID = xv.TransID
inner join dbo.reviseresourcekey rrk
on rrk.ResourceKey = xt.TransIDText
inner join dbo.xliff_Group xg
on xt.GroupID = xg.GroupID
and xg.GroupText = rrk.ResourceType
inner join dbo.reviseresourcevalue rrv
on rrk.resourcekeyid = rrv.resourcekeyid
where xg.fileid = 2 and culturecode = 'en-GB'
and rrv.resourcevalue <> xv.source

insert into xliff_delta (TextGroup,ResourceType,ResourceKey,TextInCMS,TextInFile,ChangedDate,TextInFile1)
select
'changed_core_texts',
trk.ResourceType,
trk.ResourceKey,
trv.resourcevalue,
xv.source,
trv.changeddate
,xv.source
--@pTargetCultureCode 
from [dbo].xliff_value xv
inner join dbo.xliff_transid xt
on xt.TransID = xv.TransID
inner join dbo.tat_resourcekey trk
on trk.ResourceKey = xt.TransIDText
inner join dbo.xliff_Group xg
on xt.GroupID = xg.GroupID
and xg.GroupText = trk.ResourceType
inner join dbo.tat_resourcevalue trv
on trk.resourcekeyid = trv.resourcekeyid
where xg.fileid = 1 and culturecode = 'en-GB'
and trv.resourcevalue <> xv.source



---Created texts
insert into xliff_delta (TextGroup,ResourceKey,TextInCMS,ChangedDate)
select
'created_news_texts_header',
nk.NewsKeyID,
nv.headertext,
--nv.bodytext,
nv.changeddate
from  dbo.newskey nk
inner join dbo.newsvalue nv
on nk.NewsKeyID = nv.NewsKeyID
where nk.NewsKeyID not in 
(select xg.GroupText 
from dbo.xliff_Group xg
where xg.fileid = 3) and culturecode = 'en-GB'

insert into xliff_delta (TextGroup,ResourceKey,TextInCMS,ChangedDate)
select
'created_news_texts_body',
nk.NewsKeyID,
--nv.headertext,
nv.bodytext,
nv.changeddate
from  dbo.newskey nk
inner join dbo.newsvalue nv
on nk.NewsKeyID = nv.NewsKeyID
where nk.NewsKeyID not in 
(select xg.GroupText 
from dbo.xliff_Group xg
where xg.fileid = 3) and culturecode = 'en-GB'

insert into xliff_delta (TextGroup,ResourceType,ResourceKey,TextInCMS,TextInFile,ChangedDate)
select
'created_cms_texts',
rrk.ResourceType,
rrk.ResourceKey,
rrv.resourcevalue,
'',
rrv.changeddate
from dbo.reviseresourcekey rrk
inner join dbo.reviseresourcevalue rrv
on rrk.resourcekeyid = rrv.resourcekeyid
where rrk.Resourcekey not in
(select xt.TransIDText
from dbo.xliff_transid xt
inner join dbo.xliff_Group xg
on xt.GroupID = xg.GroupID
and xg.GroupText = rrk.ResourceType
where xg.fileid = 2) and culturecode = 'en-GB'

insert into xliff_delta (TextGroup,ResourceType,ResourceKey,TextInCMS,TextInFile,ChangedDate)
select
'created_core_texts',
trk.ResourceType,
trk.ResourceKey,
trv.resourcevalue,
'',
trv.changeddate
from dbo.tat_resourcekey trk
inner join dbo.tat_resourcevalue trv
on trk.resourcekeyid = trv.resourcekeyid
where trk.ResourceKey not in
(select xt.TransIDText 
from dbo.xliff_transid xt
inner join dbo.xliff_Group xg
on xt.GroupID = xg.GroupID
and xg.GroupText = trk.ResourceType
where xg.fileid = 1) and culturecode = 'en-GB'


---Deleted texts
insert into xliff_delta (TextGroup,ResourceKey,TextInCMS)
select
'deleted_news_texts_header',
xg.GroupText,
xv.source 
from dbo.xliff_value xv
inner join dbo.xliff_transid xt
on xt.TransID = xv.TransID
inner join dbo.xliff_Group xg
on xt.GroupID = xg.GroupID
where xg.fileid = 3 and xt.transidtext = 'headertext'
and xg.grouptext not in
(select nk.NewsKeyID from dbo.newskey nk)

insert into xliff_delta (TextGroup,ResourceKey,TextInCMS)
select
'deleted_news_texts_body',
xg.GroupText,
xv.source 
from dbo.xliff_value xv
inner join dbo.xliff_transid xt
on xt.TransID = xv.TransID
inner join dbo.xliff_Group xg
on xt.GroupID = xg.GroupID
where xg.fileid = 3 and xt.transidtext = 'bodytext'
and xg.grouptext not in
(select nk.NewsKeyID from dbo.newskey nk)
/*
update dbo.xliff_delta set TextInFile = 
(select
xv.source
from dbo.xliff_value xv
inner join dbo.xliff_transid xt
on xt.TransID = xv.TransID
inner join dbo.xliff_Group xg
on xt.GroupID = xg.GroupID
where xg.fileid=3
and ResourceKey = xg.grouptext 
and xt.transidtext = 'bodytext'
and TextGroup = 'deleted_news_texts') 
*/

insert into xliff_delta (TextGroup,ResourceKey,TextInFile)
select
'deleted_cms_texts',
xt.TransIDText,
xv.Source
from dbo.xliff_value xv
inner join dbo.xliff_transid xt
on xt.TransID = xv.TransID
inner join dbo.xliff_Group xg
on xt.GroupID = xg.GroupID
where xg.fileid = 2 and
xt.TransIDText not in
(select rrk.resourcekey from dbo.ReviseResourceKey rrk) 

insert into xliff_delta (TextGroup,ResourceKey,TextInFile)
select
'deleted_core_texts',
xt.TransIDText,
xv.Source
from dbo.xliff_value xv
inner join dbo.xliff_transid xt
on xt.TransID = xv.TransID
inner join dbo.xliff_Group xg
on xt.GroupID = xg.GroupID
where xg.fileid = 1 and
xt.TransIDText not in
(select trk.resourcekey from dbo.tat_ResourceKey trk) 

if (select count(1) from xliff_delta) = 0 
	print('No changes were found when comparing texts in file with texts in CMS')
	else
	begin
    print('--------------------------------------------------------------------------------')
    EXEC EPRTRcms.dbo.printout @ptextgroup = N'changed_news_texts_header', 
	@ptextnochanges = N'No news header texts were changed in the CMS',
	@ptextchanges = N'The following news header texts were changed in the CMS and the changes are not reflected in the xliff file',
	@ptextcolumns = N'Columns: NewsKey	Date Changed';
    print('--------------------------------------------------------------------------------')
    EXEC EPRTRcms.dbo.printout @ptextgroup = N'changed_news_texts_body', 
	@ptextnochanges = N'No news body texts were changed in the CMS',
	@ptextchanges = N'The following news body texts were changed in the CMS and the changes are not reflected in the xliff file',
	@ptextcolumns = N'Columns: NewsKey	Date Changed';
    print('--------------------------------------------------------------------------------')
    EXEC EPRTRcms.dbo.printout @ptextgroup = N'changed_cms_texts', 
	@ptextnochanges = N'No cms texts were changed in the CMS',
	@ptextchanges = N'The following cms texts were changed in the CMS and the changes are not reflected in the xliff file',
	@ptextcolumns = N'Columns: ResourceKey	Date Changed';
    print('--------------------------------------------------------------------------------')
    EXEC EPRTRcms.dbo.printout @ptextgroup = N'changed_core_texts', 
	@ptextnochanges = N'No core texts were changed in the CMS',
	@ptextchanges = N'The following core texts were changed in the CMS and the changes are not reflected in the xliff file',
	@ptextcolumns = N'Columns: ResourceKey	Date Changed';
    print('--------------------------------------------------------------------------------')
    EXEC EPRTRcms.dbo.printout @ptextgroup = N'created_news_texts_header', 
	@ptextnochanges = N'No news header texts were created in the CMS',
	@ptextchanges = N'The following news header texts were created in the CMS and are not represented in the xliff file',
	@ptextcolumns = N'Columns: NewsKey	Date Created';		
    print('--------------------------------------------------------------------------------')
    EXEC EPRTRcms.dbo.printout @ptextgroup = N'created_news_texts_body', 
	@ptextnochanges = N'No news body texts were created in the CMS',
	@ptextchanges = N'The following news body texts were created in the CMS and are not represented in the xliff file',
	@ptextcolumns = N'Columns: NewsKey	Date Created';		
    print('--------------------------------------------------------------------------------')
    EXEC EPRTRcms.dbo.printout @ptextgroup = N'created_cms_texts', 
	@ptextnochanges = N'No cms texts were created in the CMS',
	@ptextchanges = N'The following cms texts were created in the CMS and are not represented in the xliff file',
	@ptextcolumns = N'Columns: ResourceKey	Date Created';	
    print('--------------------------------------------------------------------------------')
    EXEC EPRTRcms.dbo.printout @ptextgroup = N'created_core_texts', 
	@ptextnochanges = N'No core texts were created in the CMS',
	@ptextchanges = N'The following core texts were created in the CMS and are not represented in the xliff file',
	@ptextcolumns = N'Columns: ResourceKey	Date Created';
    print('--------------------------------------------------------------------------------')
    EXEC EPRTRcms.dbo.printout @ptextgroup = N'deleted_news_texts_header', 
	@ptextnochanges = N'No news header texts in the xliff file were deleted in the CMS',
	@ptextchanges = N'The following news header texts in the xliff file were deleted in the CMS',
	@ptextcolumns = N'Columns: NewsKey '; 	
    print('--------------------------------------------------------------------------------')
    EXEC EPRTRcms.dbo.printout @ptextgroup = N'deleted_news_texts_body', 
	@ptextnochanges = N'No news body texts in the xliff file were deleted in the CMS',
	@ptextchanges = N'The following news body texts in the xliff file were deleted in the CMS',
	@ptextcolumns = N'Columns: NewsKey '; 	
    print('--------------------------------------------------------------------------------')    
    EXEC EPRTRcms.dbo.printout @ptextgroup = N'deleted_cms_texts', 
	@ptextnochanges = N'No cms texts in the xliff file were deleted in the CMS',
	@ptextchanges = N'The following cms texts in the xliff file were deleted in the CMS',
	@ptextcolumns = N'Columns: ResourceKey'; 
	print('--------------------------------------------------------------------------------')
	EXEC EPRTRcms.dbo.printout @ptextgroup = N'deleted_core_texts', 
	@ptextnochanges = N'No core texts in the xliff file were deleted in the CMS',
	@ptextchanges = N'The following core texts in the xliff file were deleted in the CMS',
	@ptextcolumns = N'Columns: ResourceKey';
    print('--------------------------------------------------------------------------------') 
	end


if object_id('EPRTRcms.dbo.xliff_Value')is not null DROP TABLE EPRTRcms.dbo.xliff_Value
if object_id('EPRTRcms.dbo.xliff_TransID')is not null DROP TABLE EPRTRcms.dbo.xliff_TransID
if object_id('EPRTRcms.dbo.xliff_group')is not null DROP TABLE EPRTRcms.dbo.xliff_group
if object_id('EPRTRcms.dbo.xliff_header')is not null DROP TABLE EPRTRcms.dbo.xliff_header
if object_id('EPRTRcms.dbo.xliff_file')is not null DROP TABLE EPRTRcms.dbo.xliff_file

CREATE TABLE [dbo].[xliff_file](
	[FileID] [int] NOT NULL,
	[DataType]  [nvarchar](20) NOT NULL,
	[SourceLanguage] [nvarchar](30) NOT NULL,
	[TargetLanguage] [nvarchar](30) NOT NULL,
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
	[Source] nvarchar (max)  NULL ,
	[Target] nvarchar (max)  NULL ,
CONSTRAINT [ValueID] PRIMARY KEY CLUSTERED 
(
	[ValueID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
ALTER TABLE [dbo].[xliff_Value]  WITH CHECK ADD  CONSTRAINT [FK_xliff_Value_xliff_TransID] FOREIGN KEY([TransID])
REFERENCES [dbo].[xliff_TransID] ([TransID])

	insert into dbo.xliff_file (fileid,datatype,sourcelanguage,targetlanguage)
    values(1,'plaintext','TextInCMS','TextInXliffFile')
    insert into dbo.xliff_file (fileid,datatype,sourcelanguage,targetlanguage)
    values(2,'plaintext','TextInCMS','TextInXliffFile')
    insert into dbo.xliff_file (fileid,datatype,sourcelanguage,targetlanguage)
    values(3,'plaintext','TextInCMS','TextInXliffFile')
   --/*
	insert into dbo.xliff_header (fileid,uid)
	values(1,'core_texts')	
	insert into dbo.xliff_header (fileid,uid)
	values(2,'cms_texts')	
	insert into dbo.xliff_header (fileid,uid)
	values(3,'news_texts')
	
	insert into dbo.xliff_group (keyid,grouptext,fileid) select null,textgroup,1 
	from dbo.xliff_delta
	where textgroup in ('changed_core_texts','created_core_texts','deleted_core_texts') 
    group by textgroup order by textgroup
	
	insert into dbo.xliff_transid (keyid,transidtext,groupid) 
	select null, --trk.resourcekeyid,
	xd.resourcekey,xg.groupid from dbo.xliff_delta xd
	inner join xliff_group xg
	on xg.grouptext=xd.TextGroup	
	and xg.fileid = 1
	
	insert into dbo.xliff_value (source,target,transid)
	select xd.TextInCMS,isnull(xd.TextinFile,xd.TextInFile1),xtid.transid from dbo.xliff_delta xd
	inner join dbo.xliff_transid xtid
	on xtid.TransIDText = xd.ResourceKey
	and xtid.groupid in (select groupid from dbo.xliff_group where fileid = 1)
	
	insert into dbo.xliff_group (keyid,grouptext,fileid) select null,textgroup,2 
	from dbo.xliff_delta
	where textgroup in ('changed_cms_texts','created_cms_texts','deleted_cms_texts') 
	group by textgroup order by textgroup
	
	insert into dbo.xliff_transid (keyid,transidtext,groupid) 
	select null, --trk.resourcekeyid,
	xd.resourcekey,xg.groupid from dbo.xliff_delta xd
	inner join xliff_group xg
	on xg.grouptext=xd.TextGroup	
	and xg.fileid = 2
	
	insert into dbo.xliff_value (source,target,transid)
	select xd.TextInCMS,isnull(xd.TextinFile,xd.TextInFile1),xtid.transid from dbo.xliff_delta xd
	inner join dbo.xliff_transid xtid
	on xtid.TransIDText = xd.ResourceKey
	and xtid.groupid in (select groupid from dbo.xliff_group where fileid = 2)

    insert into dbo.xliff_group (keyid,grouptext,fileid) select null,textgroup,3 
	from dbo.xliff_delta
	where textgroup in ('changed_news_texts_header','changed_news_texts_body',
	'created_news_texts_header','created_news_texts_body','deleted_news_texts_header','deleted_news_texts_body') 
	group by textgroup order by textgroup
	
	insert into dbo.xliff_transid (keyid,transidtext,groupid) 
	select null, --trk.resourcekeyid,
	xd.resourcekey,xg.groupid from dbo.xliff_delta xd
	inner join xliff_group xg
	on xg.grouptext=xd.TextGroup	
	and xg.fileid = 3
	
	insert into dbo.xliff_value (source,target,transid)
	select xd.TextInCMS,isnull(xd.TextinFile,xd.TextInFile1),xtid.transid from dbo.xliff_delta xd
	inner join dbo.xliff_transid xtid
	on xtid.TransIDText = xd.ResourceKey
	and xtid.groupid in (select groupid from dbo.xliff_group where fileid = 3)
	--*/
end 

end
go