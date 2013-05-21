

-------------------------------------------------------------------------------------
--	this script creats the Views that are used by SSIS packages in
--	order to extract the language specific resource files for the maps
-------------------------------------------------------------------------------------

if object_id('dbo.vAT_en_GB_BookmarkWidgetStrings')is not null DROP view dbo.vAT_en_GB_BookmarkWidgetStrings
go
create view dbo.vAT_en_GB_BookmarkWidgetStrings
as
	select
	cast (k.ResourceKey + '=' + v.ResourceValue as nvarchar(max)) as line
	from tAT_ResourceKey k
	inner join tAT_ResourceValue v
	on v.ResourceKeyID = k.ResourceKeyID
	where v.CultureCode = 'en-GB'
	and k.ResourceType like 'MAP_BookmarkWidgetStrings'
go

if object_id('dbo.vAT_en_GB_ControllerStrings')is not null DROP view dbo.vAT_en_GB_ControllerStrings
go
create view dbo.vAT_en_GB_ControllerStrings
as
	select
	cast (k.ResourceKey + '=' + v.ResourceValue as nvarchar(max)) as line
	from tAT_ResourceKey k
	inner join tAT_ResourceValue v
	on v.ResourceKeyID = k.ResourceKeyID
	where v.CultureCode = 'en-GB'
	and k.ResourceType like 'MAP_ControllerStrings'
go

if object_id('dbo.vAT_en_GB_FilterAllWidgetStrings')is not null DROP view dbo.vAT_en_GB_FilterAllWidgetStrings
go
create view dbo.vAT_en_GB_FilterAllWidgetStrings
as
	select
	cast (k.ResourceKey + '=' + v.ResourceValue as nvarchar(max)) as line
	from tAT_ResourceKey k
	inner join tAT_ResourceValue v
	on v.ResourceKeyID = k.ResourceKeyID
	where v.CultureCode = 'en-GB'
	and k.ResourceType like 'MAP_FilterAllWidgetStrings'
go

if object_id('dbo.vAT_en_GB_LookupSearchAllWidgetStrings')is not null DROP view dbo.vAT_en_GB_LookupSearchAllWidgetStrings
go
create view dbo.vAT_en_GB_LookupSearchAllWidgetStrings
as
	select
	cast (k.ResourceKey + '=' + v.ResourceValue as nvarchar(max)) as line
	from tAT_ResourceKey k
	inner join tAT_ResourceValue v
	on v.ResourceKeyID = k.ResourceKeyID
	where v.CultureCode = 'en-GB'
	and k.ResourceType like 'MAP_LookupSearchAllWidgetStrings'
go


if object_id('dbo.vAT_en_GB_OverviewMapWidgetStrings')is not null DROP view dbo.vAT_en_GB_OverviewMapWidgetStrings
go
create view dbo.vAT_en_GB_OverviewMapWidgetStrings
as
	select
	cast (k.ResourceKey + '=' + v.ResourceValue as nvarchar(max)) as line
	from tAT_ResourceKey k
	inner join tAT_ResourceValue v
	on v.ResourceKeyID = k.ResourceKeyID
	where v.CultureCode = 'en-GB'
	and k.ResourceType like 'MAP_OverviewMapWidgetStrings'
go

if object_id('dbo.vAT_en_GB_PrintWidgetStrings')is not null DROP view dbo.vAT_en_GB_PrintWidgetStrings
go
create view dbo.vAT_en_GB_PrintWidgetStrings
as
	select
	cast (k.ResourceKey + '=' + v.ResourceValue as nvarchar(max)) as line
	from tAT_ResourceKey k
	inner join tAT_ResourceValue v
	on v.ResourceKeyID = k.ResourceKeyID
	where v.CultureCode = 'en-GB'
	and k.ResourceType like 'MAP_PrintWidgetStrings'
go

if object_id('dbo.vAT_en_GB_SearchAllWidgetStrings')is not null DROP view dbo.vAT_en_GB_SearchAllWidgetStrings
go
create view dbo.vAT_en_GB_SearchAllWidgetStrings
as
	select
	cast (k.ResourceKey + '=' + v.ResourceValue as nvarchar(max)) as line
	from tAT_ResourceKey k
	inner join tAT_ResourceValue v
	on v.ResourceKeyID = k.ResourceKeyID
	where v.CultureCode = 'en-GB'
	and k.ResourceType like 'MAP_SearchAllWidgetStrings'
go

if object_id('dbo.vAT_en_GB_WidgetTemplateStrings')is not null DROP view dbo.vAT_en_GB_WidgetTemplateStrings
go
create view dbo.vAT_en_GB_WidgetTemplateStrings
as
	select
	cast (k.ResourceKey + '=' + v.ResourceValue as nvarchar(max)) as line
	from tAT_ResourceKey k
	inner join tAT_ResourceValue v
	on v.ResourceKeyID = k.ResourceKeyID
	where v.CultureCode = 'en-GB'
	and k.ResourceType like 'MAP_WidgetTemplateStrings'
go


-------------------------------------------------------------------------------------

if object_id('dbo.vAT_da_DK_BookmarkWidgetStrings')is not null DROP view dbo.vAT_da_DK_BookmarkWidgetStrings
go
create view dbo.vAT_da_DK_BookmarkWidgetStrings
as
	select
	cast (k.ResourceKey + '=' + v.ResourceValue as nvarchar(max)) as line
	from tAT_ResourceKey k
	inner join tAT_ResourceValue v
	on v.ResourceKeyID = k.ResourceKeyID
	where v.CultureCode = 'da-DK'
	and k.ResourceType like 'MAP_BookmarkWidgetStrings'
go

if object_id('dbo.vAT_da_DK_ControllerStrings')is not null DROP view dbo.vAT_da_DK_ControllerStrings
go
create view dbo.vAT_da_DK_ControllerStrings
as
	select
	cast (k.ResourceKey + '=' + v.ResourceValue as nvarchar(max)) as line
	from tAT_ResourceKey k
	inner join tAT_ResourceValue v
	on v.ResourceKeyID = k.ResourceKeyID
	where v.CultureCode = 'da-DK'
	and k.ResourceType like 'MAP_ControllerStrings'
go

if object_id('dbo.vAT_da_DK_FilterAllWidgetStrings')is not null DROP view dbo.vAT_da_DK_FilterAllWidgetStrings
go
create view dbo.vAT_da_DK_FilterAllWidgetStrings
as
	select
	cast (k.ResourceKey + '=' + v.ResourceValue as nvarchar(max)) as line
	from tAT_ResourceKey k
	inner join tAT_ResourceValue v
	on v.ResourceKeyID = k.ResourceKeyID
	where v.CultureCode = 'da-DK'
	and k.ResourceType like 'MAP_FilterAllWidgetStrings'
go

if object_id('dbo.vAT_da_DK_LookupSearchAllWidgetStrings')is not null DROP view dbo.vAT_da_DK_LookupSearchAllWidgetStrings
go
create view dbo.vAT_da_DK_LookupSearchAllWidgetStrings
as
	select
	cast (k.ResourceKey + '=' + v.ResourceValue as nvarchar(max)) as line
	from tAT_ResourceKey k
	inner join tAT_ResourceValue v
	on v.ResourceKeyID = k.ResourceKeyID
	where v.CultureCode = 'da-DK'
	and k.ResourceType like 'MAP_LookupSearchAllWidgetStrings'
go


if object_id('dbo.vAT_da_DK_OverviewMapWidgetStrings')is not null DROP view dbo.vAT_da_DK_OverviewMapWidgetStrings
go
create view dbo.vAT_da_DK_OverviewMapWidgetStrings
as
	select
	cast (k.ResourceKey + '=' + v.ResourceValue as nvarchar(max)) as line
	from tAT_ResourceKey k
	inner join tAT_ResourceValue v
	on v.ResourceKeyID = k.ResourceKeyID
	where v.CultureCode = 'da-DK'
	and k.ResourceType like 'MAP_OverviewMapWidgetStrings'
go

if object_id('dbo.vAT_da_DK_PrintWidgetStrings')is not null DROP view dbo.vAT_da_DK_PrintWidgetStrings
go
create view dbo.vAT_da_DK_PrintWidgetStrings
as
	select
	cast (k.ResourceKey + '=' + v.ResourceValue as nvarchar(max)) as line
	from tAT_ResourceKey k
	inner join tAT_ResourceValue v
	on v.ResourceKeyID = k.ResourceKeyID
	where v.CultureCode = 'da-DK'
	and k.ResourceType like 'MAP_PrintWidgetStrings'
go

if object_id('dbo.vAT_da_DK_SearchAllWidgetStrings')is not null DROP view dbo.vAT_da_DK_SearchAllWidgetStrings
go
create view dbo.vAT_da_DK_SearchAllWidgetStrings
as
	select
	cast (k.ResourceKey + '=' + v.ResourceValue as nvarchar(max)) as line
	from tAT_ResourceKey k
	inner join tAT_ResourceValue v
	on v.ResourceKeyID = k.ResourceKeyID
	where v.CultureCode = 'da-DK'
	and k.ResourceType like 'MAP_SearchAllWidgetStrings'
go

if object_id('dbo.vAT_da_DK_WidgetTemplateStrings')is not null DROP view dbo.vAT_da_DK_WidgetTemplateStrings
go
create view dbo.vAT_da_DK_WidgetTemplateStrings
as
	select
	cast (k.ResourceKey + '=' + v.ResourceValue as nvarchar(max)) as line
	from tAT_ResourceKey k
	inner join tAT_ResourceValue v
	on v.ResourceKeyID = k.ResourceKeyID
	where v.CultureCode = 'da-DK'
	and k.ResourceType like 'MAP_WidgetTemplateStrings'
go


-------------------------------------------------------------------------------------

if object_id('dbo.vAT_fr_FR_BookmarkWidgetStrings')is not null DROP view dbo.vAT_fr_FR_BookmarkWidgetStrings
go
create view dbo.vAT_fr_FR_BookmarkWidgetStrings
as
	select
	cast (k.ResourceKey + '=' + v.ResourceValue as nvarchar(max)) as line
	from tAT_ResourceKey k
	inner join tAT_ResourceValue v
	on v.ResourceKeyID = k.ResourceKeyID
	where v.CultureCode = 'fr-FR'
	and k.ResourceType like 'MAP_BookmarkWidgetStrings'
go

if object_id('dbo.vAT_fr_FR_ControllerStrings')is not null DROP view dbo.vAT_fr_FR_ControllerStrings
go
create view dbo.vAT_fr_FR_ControllerStrings
as
	select
	cast (k.ResourceKey + '=' + v.ResourceValue as nvarchar(max)) as line
	from tAT_ResourceKey k
	inner join tAT_ResourceValue v
	on v.ResourceKeyID = k.ResourceKeyID
	where v.CultureCode = 'fr-FR'
	and k.ResourceType like 'MAP_ControllerStrings'
go

if object_id('dbo.vAT_fr_FR_FilterAllWidgetStrings')is not null DROP view dbo.vAT_fr_FR_FilterAllWidgetStrings
go
create view dbo.vAT_fr_FR_FilterAllWidgetStrings
as
	select
	cast (k.ResourceKey + '=' + v.ResourceValue as nvarchar(max)) as line
	from tAT_ResourceKey k
	inner join tAT_ResourceValue v
	on v.ResourceKeyID = k.ResourceKeyID
	where v.CultureCode = 'fr-FR'
	and k.ResourceType like 'MAP_FilterAllWidgetStrings'
go

if object_id('dbo.vAT_fr_FR_LookupSearchAllWidgetStrings')is not null DROP view dbo.vAT_fr_FR_LookupSearchAllWidgetStrings
go
create view dbo.vAT_fr_FR_LookupSearchAllWidgetStrings
as
	select
	cast (k.ResourceKey + '=' + v.ResourceValue as nvarchar(max)) as line
	from tAT_ResourceKey k
	inner join tAT_ResourceValue v
	on v.ResourceKeyID = k.ResourceKeyID
	where v.CultureCode = 'fr-FR'
	and k.ResourceType like 'MAP_LookupSearchAllWidgetStrings'
go


if object_id('dbo.vAT_fr_FR_OverviewMapWidgetStrings')is not null DROP view dbo.vAT_fr_FR_OverviewMapWidgetStrings
go
create view dbo.vAT_fr_FR_OverviewMapWidgetStrings
as
	select
	cast (k.ResourceKey + '=' + v.ResourceValue as nvarchar(max)) as line
	from tAT_ResourceKey k
	inner join tAT_ResourceValue v
	on v.ResourceKeyID = k.ResourceKeyID
	where v.CultureCode = 'fr-FR'
	and k.ResourceType like 'MAP_OverviewMapWidgetStrings'
go

if object_id('dbo.vAT_fr_FR_PrintWidgetStrings')is not null DROP view dbo.vAT_fr_FR_PrintWidgetStrings
go
create view dbo.vAT_fr_FR_PrintWidgetStrings
as
	select
	cast (k.ResourceKey + '=' + v.ResourceValue as nvarchar(max)) as line
	from tAT_ResourceKey k
	inner join tAT_ResourceValue v
	on v.ResourceKeyID = k.ResourceKeyID
	where v.CultureCode = 'fr-FR'
	and k.ResourceType like 'MAP_PrintWidgetStrings'
go

if object_id('dbo.vAT_fr_FR_SearchAllWidgetStrings')is not null DROP view dbo.vAT_fr_FR_SearchAllWidgetStrings
go
create view dbo.vAT_fr_FR_SearchAllWidgetStrings
as
	select
	cast (k.ResourceKey + '=' + v.ResourceValue as nvarchar(max)) as line
	from tAT_ResourceKey k
	inner join tAT_ResourceValue v
	on v.ResourceKeyID = k.ResourceKeyID
	where v.CultureCode = 'fr-FR'
	and k.ResourceType like 'MAP_SearchAllWidgetStrings'
go

if object_id('dbo.vAT_fr_FR_WidgetTemplateStrings')is not null DROP view dbo.vAT_fr_FR_WidgetTemplateStrings
go
create view dbo.vAT_fr_FR_WidgetTemplateStrings
as
	select
	cast (k.ResourceKey + '=' + v.ResourceValue as nvarchar(max)) as line
	from tAT_ResourceKey k
	inner join tAT_ResourceValue v
	on v.ResourceKeyID = k.ResourceKeyID
	where v.CultureCode = 'fr-FR'
	and k.ResourceType like 'MAP_WidgetTemplateStrings'
go
