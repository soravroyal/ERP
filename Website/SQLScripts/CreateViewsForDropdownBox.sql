use EPRTRmaster
go


if object_id('WEB_REPORTINGCOUNTRY')is not null DROP view WEB_REPORTINGCOUNTRY
go
create view WEB_REPORTINGCOUNTRY
as
select     
	dbo.LOV_COUNTRY.*
from dbo.LOV_AREAGROUP 
inner join
	dbo.LOV_COUNTRYAREAGROUP 
on	dbo.LOV_AREAGROUP.LOV_AreaGroupID = dbo.LOV_COUNTRYAREAGROUP.LOV_AreaGroupID 
inner join
	dbo.LOV_COUNTRY 
on  dbo.LOV_COUNTRYAREAGROUP.LOV_CountryID = dbo.LOV_COUNTRY.LOV_CountryID
where     
	dbo.LOV_AREAGROUP.Code = N'E-PRTR'
go


if object_id('WEB_RECEIVINGCOUNTRY')is not null DROP view WEB_RECEIVINGCOUNTRY
go
create view WEB_RECEIVINGCOUNTRY
as
select   
	lc.LOV_CountryID,
	lc.Code,
	lc.Name,
	lc.StartYear,
	lc.EndYear
from LOV_COUNTRY lc
inner join (
	select distinct
		country.Code as CountryCode
	from
		WASTEHANDLERPARTY wh
	inner join
		ADDRESS addr
	on	addr.AddressID = wh.AddressID	
	inner join
		LOV_COUNTRY country
	ON  addr.LOV_CountryID = country.LOV_CountryID
	)whp
on whp.CountryCode = lc.Code
go


if object_id('WEB_REPORTINGYEAR')is not null DROP view WEB_REPORTINGYEAR
go
create view WEB_REPORTINGYEAR
as
select distinct 
	m.ReportingYear as [Year], 
	count(m.LOV_CountryID) as Countries
from (
	select distinct 
		LOV_CountryID, 
		ReportingYear 
	from 
		POLLUTANTRELEASEANDTRANSFERREPORT
	)m
group by m.ReportingYear
go

if object_id('WEB_REPORTING_POLLUTANT')is not null DROP view WEB_REPORTING_POLLUTANT
go
create view WEB_REPORTING_POLLUTANT
as
select
	lp.LOV_PollutantID as LOV_PollutantID, 
	lp.Name as PollutantName, 
	lp.CAS as CAS,
	lp.StartYear as StartYear,
	lp.EndYear as EndYear,
	lp.Code as Code,
	v.PollutantGroupCode as ParentCode,
	v.LOV_GroupID as ParentLOV_PollutantID
from
	LOV_POLLUTANT lp
inner join	
	vAT_POLLUTANT v
on  v.LOV_PollutantID = lp.LOV_PollutantID
go


if object_id('WEB_REPORTING_ANNEXIACTIVITY')is not null DROP view WEB_REPORTING_ANNEXIACTIVITY
go
create view WEB_REPORTING_ANNEXIACTIVITY
as
select 
	la.LOV_AnnexIActivityID, 
	la.Name as Name,
	la.IPPCCode as IPPCCode,
	la.StartYear as StartYear,
	la.EndYear as EndYear,
	la.Code as Code, 
	laa.Code as ParentCode, 
	laa.LOV_AnnexIActivityID as ParentLOV_AnnexIActivityID,
	laaa.Code as GrandParentCode,
	laaa.LOV_AnnexIActivityID as GrandParentLOV_AnnexIActivityID
from LOV_ANNEXIACTIVITY la
left outer join
	LOV_ANNEXIACTIVITY laa
on la.ParentID = laa.LOV_AnnexIActivityID
left outer join
	LOV_ANNEXIACTIVITY laaa
on laa.ParentID = laaa.LOV_AnnexIActivityID
go


if object_id('WEB_REPORTING_NACEACTIVITY')is not null DROP view WEB_REPORTING_NACEACTIVITY
go
create view WEB_REPORTING_NACEACTIVITY
as
select
	ln.LOV_NACEActivityID,
	ln.Name as Name,
	ln.StartYear as StartYear,
	ln.EndYear as EndYear,
	ln.Code as Code,
	lnn.Code as ParentCode,
	lnn.LOV_NACEActivityID as ParentLOV_NACEActivityID,
	lnnn.Code as GrandParentCode,
	lnnn.LOV_NACEActivityID as GrandParentLOV_NACEActivityID
from 	
	LOV_NACEACTIVITY ln
left outer join
	LOV_NACEACTIVITY lnn
on	lnn.LOV_NACEActivityID = ln.ParentID
left outer join
	LOV_NACEACTIVITY lnnn
on	lnnn.LOV_NACEActivityID = lnn.ParentID
go


--create view WEB_REPORTING_NACEACTIVITY
--as
--select
--	LOV_NACEActivityID, 
--	SectorName,
--	SectorCode,
--	ActivityName, 
--	ActivityCode,
--	SubActivityName, 
--	SubActivityCode
--from 	
--	vAT_NACEACTIVITY
--go

