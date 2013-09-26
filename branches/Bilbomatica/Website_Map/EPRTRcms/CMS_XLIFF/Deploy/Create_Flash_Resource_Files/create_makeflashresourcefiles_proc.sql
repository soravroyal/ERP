


use EPRTRcms
go


if object_id('EPRTRcms.dbo.flash_out')is not null DROP table dbo.flash_out
go
create table flash_out (text nvarchar(2000))

if object_id('EPRTRcms.dbo.create_makeflashresourcefile')is not null DROP Procedure dbo.create_makeflashresourcefile
go

create procedure [dbo].[create_makeflashresourcefile]
	@pLanguage nvarchar(5),
	@pCategory nvarchar(255)
as
begin
truncate table flash_out
print(@pLanguage)
print(@pCategory)
	declare 
	@txt1 nvarchar(2000) 
	DECLARE 
	text_Cursor CURSOR FOR
	select cast (k.ResourceKey + '=' + v.ResourceValue as nvarchar(max))
	from tAT_ResourceKey k
	inner join tAT_ResourceValue v
	on v.ResourceKeyID = k.ResourceKeyID
	where v.CultureCode = @pLanguage
	and k.ResourceType like @pCategory;
	OPEN text_Cursor;
	FETCH NEXT FROM text_Cursor into @txt1;
	WHILE @@FETCH_STATUS = 0
	BEGIN
	insert into flash_out (text) values (@txt1)
	--print(@txt1)
	FETCH NEXT FROM text_Cursor into @txt1;
	END;
	CLOSE text_Cursor;
	DEALLOCATE text_Cursor;
END

/*
	select cast (k.ResourceKey + '=' + v.ResourceValue as nvarchar(max))
	from tAT_ResourceKey k
	inner join tAT_ResourceValue v
	on v.ResourceKeyID = k.ResourceKeyID
	where v.CultureCode = 'en-GB'
	and k.ResourceType like 'MAP_LookupSearchAllWidgetStrings'
*/