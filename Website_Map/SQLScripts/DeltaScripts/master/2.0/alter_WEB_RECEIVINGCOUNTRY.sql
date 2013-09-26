--------------------------------------------------------------------------------
--	Delta script 
--
--	The problem was, that the dropdown list gets filled with receiving country 
--	codes from all submissions including outdated data. 
--	This new version of view WEB_RECEIVINGCOUNTRY solves the issue
--
--	wos-190711
--------------------------------------------------------------------------------


--USE [EPRTRmaster]
--GO


------------------------------------------------------------------------------
--		alter view WEB_RECEIVINGCOUNTRY
------------------------------------------------------------------------------

if object_id(DB_NAME()+'.dbo.WEB_RECEIVINGCOUNTRY')is not null DROP view [WEB_RECEIVINGCOUNTRY]
go

create view [dbo].[WEB_RECEIVINGCOUNTRY]
as
select distinct  
	lc.LOV_CountryID,
	lc.Code,
	lc.Name,
	lc.StartYear,
	lc.EndYear
from LOV_COUNTRY lc
inner join 
	tAT_WASTETRANSFER_RECEIVINGCOUNTRY wrc
ON  wrc.LOV_ReceivingCountryID = lc.LOV_CountryID
GO


