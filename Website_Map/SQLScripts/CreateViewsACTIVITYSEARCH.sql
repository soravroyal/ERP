------------------------------------------------------------------------------
--		CreateViewsACTIVITYSEARCH.sql
------------------------------------------------------------------------------

USE EPRTRmaster
GO

if object_id('EPRTRmaster.dbo.WEB_ACTIVITYSEARCH_MAINACTIVITY')is not null DROP view WEB_ACTIVITYSEARCH_MAINACTIVITY
go
create view WEB_ACTIVITYSEARCH_MAINACTIVITY
as
select
    frep.FacilityReportID as FacilityReportID,
    prtr.ReportingYear as ReportingYear,
    country.Code as CountryCode,
    rbd.Code as RiverBasinDistrictCode, 
	nuts.L2Code as NUTSLevel2RegionCode,
	aXact.SectorCode as IASectorCode,
	aXact.ActivityCode as IAActivityCode,
	aXact.SubActivityCode as IASubActivityCode,	
	aXact.SectorIPPCCode as IPPCSectorCode,
	aXact.ActivityIPPCCode as IPPCActivityCode,
	aXact.SubActivityIPPCCode as IPPCSubActivityCode,
	nace.SectorCode as NACESectorCode,
	nace.ActivityCode as NACEActivityCode,
	nace.SubActivityCode as NACESubActivityCode,
	frep.ConfidentialIndicator as ConfidentialIndicator,
	lc.Code as ConfidentialCode,
	lc.Name as ConfidentialName,
	country.LOV_CountryID as LOV_CountryID,
	rbd.LOV_RiverBasinDistrictID as LOV_RiverBasinDistrictID,
	lc.LOV_ConfidentialityID as LOV_ConfidentialityID,
	nuts.LOV_NutsL1ID as LOV_NUTSRLevel1ID,
	nuts.LOV_NutsL2ID as LOV_NUTSRLevel2ID,
	nuts.LOV_NutsL3ID as LOV_NUTSRLevel3ID,
	aXact.LOV_SectorID as LOV_IASectorID,
	aXact.LOV_ActivityID as LOV_IAActivityID,
	aXact.LOV_SubActivityID as LOV_IASubActivityID,
	nace.LOV_SectorID as LOV_NACESectorID,
	nace.LOV_ActivityID as LOV_NACEActivityID,
	nace.LOV_SubActivityID as LOV_NACESubActivityID
from
	FACILITYREPORT AS frep
inner join
    vAT_POLLUTANTRELEASEANDTRANSFERREPORT AS prtr
    ON frep.PollutantReleaseAndTransferReportID = prtr.PollutantReleaseAndTransferReportID
inner join
    ADDRESS addr
on	frep.AddressID = addr.AddressID
inner join
    LOV_COUNTRY country
on	addr.LOV_CountryID = country.LOV_CountryID
inner join
    LOV_RIVERBASINDISTRICT rbd
on	frep.LOV_RiverBasinDistrictID = rbd.LOV_RiverBasinDistrictID
inner join
    ACTIVITY act
on	frep.FacilityReportID = act.FacilityReportID AND act.MainActivityIndicator = 1
inner join
	vAT_ANNEXIACTIVITY aXact
on	aXact.LOV_AnnexIActivityID = act.LOV_AnnexIActivityID
inner join
	vAT_NACEACTIVITY nace
on  frep.LOV_NACEMainEconomicActivityID = nace.LOV_NACEActivityID
left outer join 
    vAT_NUTSREGION nuts
on  frep.LOV_NUTSRegionID = nuts.LOV_NUTSRegionID
left outer join
	LOV_CONFIDENTIALITY lc
on	lc.LOV_ConfidentialityID = frep.LOV_ConfidentialityID
--	where
--		frep.FacilityReportID in (383969,383970,383971,383972,383986)
go
--select * from WEB_ACTIVITYSEARCH_MAINACTIVITY


if object_id('EPRTRmaster.dbo.WEB_ACTIVITYSEARCH_POLLUTANTRELEASE')is not null DROP view WEB_ACTIVITYSEARCH_POLLUTANTRELEASE
go
create view WEB_ACTIVITYSEARCH_POLLUTANTRELEASE
as
select
	tAT.FacilityReportID,
	pol.PollutantGroupCode,
	pol.PollutantGroupName,
	pol.PollutantCode,
	pol.PollutantName,
	tAT.QuantityAir,
	tAT.QuantityAccidentalAir,
	tAT.QuantityWater,
	tAT.QuantityAccidentalWater,
	tAT.QuantitySoil,
	tAT.QuantityAccidentalSoil,
	tAT.UnitAir,
	tAT.UnitAccidentalAir,
	tAT.UnitWater,
	tAT.UnitAccidentalWater,
	tAT.UnitSoil,
	tAT.UnitAccidentalSoil,
	m2.ConfidentialIndicator,
	m2.ConfidentialCode,
	m2.ConfidentialName,
	pol.LOV_ID as LOV_PollutantID,
	pol.LOV_GroupID as LOV_PollutantGroupID,
	m2.LOV_ConfidentialityID,
    prtr.ReportingYear as ReportingYear,
	prtr.LOV_CountryID as LOV_CountryID,
	aXact.LOV_SectorID as LOV_IASectorID,
	aXact.LOV_ActivityID as LOV_IAActivityID,
	aXact.LOV_SubActivityID as LOV_IASubActivityID
from
	tAT_ACTIVITYSEARCH_POLLUTANTRELEASE tAT
inner join	
	vAT_POLLUTANT pol
on  pol.LOV_PollutantID = tAT.LOV_PollutantID
inner join
	FACILITYREPORT AS frep
on tAT.FacilityReportID = frep.FacilityReportID
inner join
    vAT_POLLUTANTRELEASEANDTRANSFERREPORT AS prtr
ON	frep.PollutantReleaseAndTransferReportID = prtr.PollutantReleaseAndTransferReportID
inner join
    ACTIVITY act
on	frep.FacilityReportID = act.FacilityReportID AND act.MainActivityIndicator = 1
inner join
	vAT_ANNEXIACTIVITY aXact
on	aXact.LOV_AnnexIActivityID = act.LOV_AnnexIActivityID
inner join(
	select
		m1.FacilityReportID as FacilityReportID,
		m1.LOV_PollutantID as LOV_PollutantID,
		case when lc.Code is null then 0 else 1 end as ConfidentialIndicator,
		lc.Code as ConfidentialCode,
		lc.LOV_ConfidentialityID as LOV_ConfidentialityID, 
		lc.Name as ConfidentialName
	from(
		select distinct 
			FacilityReportID as FacilityReportID,
			LOV_PollutantID as LOV_PollutantID,
			max(LOV_ConfidentialityID) as ConfidentialityID  
		from 
			POLLUTANTRELEASE pr
		group by FacilityReportID, LOV_PollutantID
		)m1
	left outer join
		LOV_CONFIDENTIALITY lc
	on	lc.LOV_ConfidentialityID = m1.ConfidentialityID
	)m2	
on	m2.FacilityReportID = tAT.FacilityReportID
and m2.LOV_PollutantID = tAT.LOV_PollutantID
go

--select distinct PollutantGroupCode,PollutantCode, SUM(QuantityAir) A, SUM(QuantitySoil) S, SUM(QuantityWater) W from  WEB_ACTIVITYSEARCH_POLLUTANTRELEASE
--group by PollutantCode, PollutantGroupCode order by 1,2


if object_id('EPRTRmaster.dbo.WEB_ACTIVITYSEARCH_POLLUTANTTRANSFER')is not null DROP view WEB_ACTIVITYSEARCH_POLLUTANTTRANSFER
go
create view WEB_ACTIVITYSEARCH_POLLUTANTTRANSFER
as
select
	pt.FacilityReportID as FacilityReportID,
	pol.PollutantGroupCode as PollutantGroupCode,
	pol.PollutantGroupName as PollutantGroupName,
	pol.PollutantCode as PollutantCode,
	pol.PollutantName as PollutantName,
	pt.Quantity as Quantity,
	lu.Code as UnitCode,
	pt.ConfidentialIndicator as ConfidentialIndicator,
	lc.Code as ConfidentialCode,
	lc.Name as ConfidentialName,
	pol.LOV_ID as LOV_PollutantID,
	pol.LOV_GroupID as LOV_PollutantGroupID,
	lc.LOV_ConfidentialityID as LOV_ConfidentialityID,
    prtr.ReportingYear as ReportingYear,
	prtr.LOV_CountryID as LOV_CountryID,
	aXact.LOV_SectorID as LOV_IASectorID,
	aXact.LOV_ActivityID as LOV_IAActivityID,
	aXact.LOV_SubActivityID as LOV_IASubActivityID
from 
	vAT_POLLUTANTTRANSFER pt
inner join
	FACILITYREPORT AS frep
on	pt.FacilityReportID = frep.FacilityReportID
inner join
    vAT_POLLUTANTRELEASEANDTRANSFERREPORT AS prtr
ON	frep.PollutantReleaseAndTransferReportID = prtr.PollutantReleaseAndTransferReportID
inner join
    ACTIVITY act
on	frep.FacilityReportID = act.FacilityReportID AND act.MainActivityIndicator = 1
inner join
	vAT_ANNEXIACTIVITY aXact
on	aXact.LOV_AnnexIActivityID = act.LOV_AnnexIActivityID
inner join
	vAT_POLLUTANT pol
on  pol.LOV_PollutantID = pt.LOV_PollutantID
inner join
	LOV_UNIT lu
on	lu.LOV_UnitID = pt.LOV_QuantityUnitID
left outer join
	LOV_CONFIDENTIALITY lc
on	lc.LOV_ConfidentialityID = pt.LOV_ConfidentialityID
go

--select distinct PollutantGroupName, SUM(Quantity) from  WEB_ACTIVITYSEARCH_POLLUTANTTRANSFER
--group by PollutantGroupName


if object_id('EPRTRmaster.dbo.WEB_ACTIVITYSEARCH_WASTETRANSFER_CONFIDENTIALITY')is not null DROP view WEB_ACTIVITYSEARCH_WASTETRANSFER_CONFIDENTIALITY
go
create view WEB_ACTIVITYSEARCH_WASTETRANSFER_CONFIDENTIALITY
as
select 
	w.FacilityReportID,
	case when wy.Code = 'NON-HW' then COUNT(*) else 0 end as 'NONHW',
	case when wy.Code = 'HWIC' then COUNT(*) else 0 end as 'HWIC',
	case when wy.Code = 'HWOC' then COUNT(*)else 0 end as 'HWOC',
	w.ConfidentialIndicator,
	lc.Name
from 
 	WASTETRANSFER w
inner join
	FACILITYREPORT AS frep
on	w.FacilityReportID = frep.FacilityReportID
inner join
    vAT_POLLUTANTRELEASEANDTRANSFERREPORT AS prtr
ON	frep.PollutantReleaseAndTransferReportID = prtr.PollutantReleaseAndTransferReportID
inner join
    ACTIVITY act
on	frep.FacilityReportID = act.FacilityReportID AND act.MainActivityIndicator = 1
inner join
	vAT_ANNEXIACTIVITY aXact
on	aXact.LOV_AnnexIActivityID = act.LOV_AnnexIActivityID
inner join 
	LOV_WASTETYPE wy
on	wy.LOV_WasteTypeID = w.LOV_WasteTypeID
left outer join
	LOV_CONFIDENTIALITY lc
on	lc.LOV_ConfidentialityID = w.LOV_ConfidentialityID
group by wy.Code,w.FacilityReportID,w.ConfidentialIndicator, lc.Name

--select distinct ConfidentialIndicator, Name, sum(NONHW), sum(HWIC), sum(HWOC)
--from WEB_ACTIVITYSEARCH_WASTETRANSFER_CONFIDENTIALITY
--group by ConfidentialIndicator, Name
