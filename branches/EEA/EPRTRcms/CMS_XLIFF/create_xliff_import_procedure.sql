USE [EPRTRcms]
GO

if object_id('EPRTRcms.dbo.xliff_import')is not null DROP Procedure dbo.xliff_import
go

create procedure [dbo].[xliff_import]
as
begin
declare @ncount int
declare @pTargetLanguage nvarchar(5)
declare @pTargetCultureCode nvarchar(10)

begin try
begin transaction
set @ncount = (select count(distinct TargetLanguage) FROM [EPRTRcms].[dbo].[xliff_file])
print('@ncount: '+ cast (@ncount as nvarchar) +'')
IF @ncount > 1
		
	RAISERROR ('More than 1 Targetlanguage given in xliff file', 11,1)


select @pTargetLanguage = TargetLanguage FROM [EPRTRcms].[dbo].[xliff_file] group by targetlanguage
print('@pTargetLanguage: '+ cast (@pTargetLanguage as nvarchar) +'')

select @pTargetCultureCode = code 
		from [EPRTRcms].[dbo].[LOV_Culture]
		where codexliff = @pTargetLanguage
 print('@pTargetCultureCode: '+ cast (@pTargetCultureCode as nvarchar) +'')

delete dbo.tat_resourcevalue where CultureCode = @pTargetCultureCode
delete dbo.reviseresourcevalue where CultureCode = @pTargetCultureCode
delete dbo.NewsValue where CultureCode = @pTargetCultureCode

insert into dbo.tat_resourcevalue (ResourceKeyID,ResourceValue,CultureCode)
select
trk.ResourceKeyID,
xv.target,
@pTargetCultureCode 
from [dbo].xliff_value xv
inner join dbo.xliff_transid xt
on xt.TransID = xv.TransID
inner join dbo.tat_resourcekey trk
on trk.ResourceKey = xt.TransIDText
inner join dbo.xliff_Group xg
on xt.GroupID = xg.GroupID
and xg.GroupText = trk.ResourceType
where xg.fileid = 1

insert into dbo.ReviseResourceValue (ResourceKeyID,ResourceValue,CultureCode)
select
rrk.ResourceKeyID,
xv.target,
@pTargetCultureCode
from [dbo].xliff_value xv
inner join dbo.xliff_transid xt
on xt.TransID = xv.TransID
inner join dbo.reviseresourcekey rrk
on rrk.ResourceKey = xt.TransIDText
inner join dbo.xliff_Group xg
on xt.GroupID = xg.GroupID
and xg.GroupText = rrk.ResourceType
where xg.fileid=2


insert into dbo.NewsValue (NewsKeyID,HeaderText,BodyText,CultureCode)
select
xg.GroupText,
xv.target,
'',
@pTargetCultureCode
from dbo.xliff_value xv
inner join dbo.xliff_transid xt
on xt.TransID = xv.TransID
inner join dbo.xliff_Group xg
on xt.GroupID = xg.GroupID
where xg.fileid=3 
and xt.transidtext = 'headertext'

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
go