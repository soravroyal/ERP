------------------------------------------------------------------------------
--		createViewsFACILITYSEARCH.sql
------------------------------------------------------------------------------

USE EPRTRmaster
GO

------------------------------------------------------------------------------
--		create View for MAINACTIVITY
------------------------------------------------------------------------------

if object_id('WEB_FACILITYSEARCH_MAINACTIVITY')is not null DROP view WEB_FACILITYSEARCH_MAINACTIVITY
go
create view dbo.WEB_FACILITYSEARCH_MAINACTIVITY --with SCHEMABINDING 
as
select
    frep.FacilityReportID as FacilityReportID,
    frep.FacilityName as FacilityName,
    frep.FacilityID as FacilityID,
    frep.NationalID as NationalID, 
    frep.ParentCompanyName as ParentCompanyName,
    prtr.ReportingYear as ReportingYear,
    RTRIM(addr.StreetName + 
		CASE 
			WHEN addr.BuildingNumber IS NULL THEN '' 
			ELSE ' ' + addr.BuildingNumber 
		END) as [Address],
    addr.City as City,
    addr.PostalCode as PostalCode,

    country.Code as CountryCode,
	prtr.LOV_CountryID as LOV_CountryID,

    rbd.Code as RiverBasinDistrictCode, 
	rbd.LOV_RiverBasinDistrictID as LOV_RiverBasinDistrictID,

	nuts.L2Code as NUTSLevel2RegionCode,
	nuts.LOV_NutsL1ID as LOV_NUTSRLevel1ID,
	nuts.LOV_NutsL2ID as LOV_NUTSRLevel2ID,
	nuts.LOV_NutsL3ID as LOV_NUTSRLevel3ID,

	aXact.SectorCode as IASectorCode,
	aXact.ActivityCode as IAActivityCode,
	aXact.SubActivityCode as IASubActivityCode,	
	aXact.SectorIPPCCode as IPPCSectorCode,
	aXact.ActivityIPPCCode as IPPCActivityCode,
	aXact.SubActivityIPPCCode as IPPCSubActivityCode,
	aXact.LOV_SectorID as LOV_IASectorID,
	aXact.LOV_ActivityID as LOV_IAActivityID,
	aXact.LOV_SubActivityID as LOV_IASubActivityID,

	nace.SectorCode as NACESectorCode,
	nace.ActivityCode as NACEActivityCode,
	nace.SubActivityCode as NACESubActivityCode,
	nace.LOV_SectorID as LOV_NACESectorID,
	nace.LOV_ActivityID as LOV_NACEActivityID,
	nace.LOV_SubActivityID as LOV_NACESubActivityID,

	ia.Code as IAReportedActivityCode,
	ia.IPPCCode as IPPCReportedActivityCode,
	na.Code as NACEReportedActivityCode,

	frep.ConfidentialIndicator as ConfidentialIndicator,
	lc.Code as ConfidentialCode,
	lc.LOV_ConfidentialityID as LOV_ConfidentialityID
from
	dbo.FACILITYREPORT AS frep
inner join
    dbo.vAT_POLLUTANTRELEASEANDTRANSFERREPORT AS prtr
    ON frep.PollutantReleaseAndTransferReportID = prtr.PollutantReleaseAndTransferReportID
inner join
    dbo.LOV_RIVERBASINDISTRICT rbd
on	frep.LOV_RiverBasinDistrictID = rbd.LOV_RiverBasinDistrictID
inner join
    dbo.ACTIVITY act
on	frep.FacilityReportID = act.FacilityReportID AND act.MainActivityIndicator = 1
inner join
	dbo.vAT_ANNEXIACTIVITY aXact
on	aXact.LOV_AnnexIActivityID = act.LOV_AnnexIActivityID
inner join
    dbo.LOV_ANNEXIACTIVITY ia
on	ia.LOV_AnnexIActivityID = act.LOV_AnnexIActivityID
inner join
	dbo.vAT_NACEACTIVITY nace
on frep.LOV_NACEMainEconomicActivityID = nace.LOV_NACEActivityID
inner join
	dbo.LOV_NACEACTIVITY na
on frep.LOV_NACEMainEconomicActivityID = na.LOV_NACEActivityID
left outer join
    dbo.ADDRESS addr
on	frep.AddressID = addr.AddressID
left outer join
    dbo.LOV_COUNTRY country
on	prtr.LOV_CountryID = country.LOV_CountryID
left outer join 
    dbo.vAT_NUTSREGION nuts
on  frep.LOV_NUTSRegionID = nuts.LOV_NUTSRegionID
left outer join
	dbo.LOV_CONFIDENTIALITY lc
on	lc.LOV_ConfidentialityID = frep.LOV_ConfidentialityID
go


------------------------------------------------------------------------------
--		create View for WEB_FACILITYSEARCH_MAINACTIVITY_GEOGRAPHICALCOORDINATE
------------------------------------------------------------------------------

if object_id('WEB_FACILITYSEARCH_MAINACTIVITY_GEOGRAPHICALCOORDINATE')is not null DROP view WEB_FACILITYSEARCH_MAINACTIVITY_GEOGRAPHICALCOORDINATE
go
create view WEB_FACILITYSEARCH_MAINACTIVITY_GEOGRAPHICALCOORDINATE
as
select 
	vFM.*, 
	frep.GeographicalCoordinate as GeographicalCoordinate,  
	st.Code as CoordinateStatusCode
from 
	WEB_FACILITYSEARCH_MAINACTIVITY vFM
inner join
	FACILITYREPORT AS frep
on frep.FacilityReportID = vFM.FacilityReportID
inner join 
	LOV_STATUS st
on st.LOV_StatusID = frep.LOV_StatusID
go

--select * from WEB_FACILITYSEARCH_MAINACTIVITY_GEOGRAPHICALCOORDINATE


------------------------------------------------------------------------------
--		create View for POLLUTANT
------------------------------------------------------------------------------

if object_id('WEB_FACILITYSEARCH_POLLUTANT')is not null DROP view WEB_FACILITYSEARCH_POLLUTANT
go
create view WEB_FACILITYSEARCH_POLLUTANT(
	FacilityReportID,
	PollutantGroupCode,
	PollutantGroupName,
	PollutantCode,
	PollutantName, 
	CAS,
	MediumCode,
	ConfidentialIndicator,
	ConfidentialCode,
	LOV_MediumID,
	LOV_PollutantID,
	LOV_PollutantGroupID,
	LOV_ConfidentialityID
)
as 
select
	pt.FacilityReportID,
	isnull(pol.PollutantGroupCode,pol.PollutantCode),
	isnull(pol.PollutantGroupName,pol.PollutantName),
	pol.PollutantCode,
	pol.PollutantName,
	pol.CAS,
	'WASTEWATER',
	pt.ConfidentialIndicator,
	lc.Code,
	lm.LOV_MediumID,
	pol.LOV_ID,
	pol.LOV_GroupID,
	lc.LOV_ConfidentialityID
FROM vAT_POLLUTANTTRANSFER pt
inner join	
	vAT_POLLUTANT pol
on  pol.LOV_PollutantID = pt.LOV_PollutantID
inner join
	LOV_MEDIUM lm
on lm.Code = 'WASTEWATER'
left outer join
	LOV_CONFIDENTIALITY lc
on	lc.LOV_ConfidentialityID = pt.LOV_ConfidentialityID
union all
select
	pr.FacilityReportID,
	isnull(pol.PollutantGroupCode,pol.PollutantCode),
	isnull(pol.PollutantGroupName,pol.PollutantName),
	pol.PollutantCode,
	pol.PollutantName,
	pol.CAS,
	lm.Code,
	pr.ConfidentialIndicator,
	lc.Code,
	lm.LOV_MediumID,
	pol.LOV_ID,
	pol.LOV_GroupID,
	lc.LOV_ConfidentialityID
from vAT_POLLUTANTRELEASE pr
inner join	
	vAT_POLLUTANT pol
on  pol.LOV_PollutantID = pr.LOV_PollutantID
inner join
	LOV_MEDIUM lm
on lm.LOV_MediumID = pr.LOV_MediumID
left outer join
	LOV_CONFIDENTIALITY lc
on	lc.LOV_ConfidentialityID = pr.LOV_ConfidentialityID
go


------------------------------------------------------------------------------
--		create View for WASTETRANSFER
------------------------------------------------------------------------------

if object_id('WEB_FACILITYSEARCH_WASTETRANSFER')is not null DROP view WEB_FACILITYSEARCH_WASTETRANSFER
go
create view WEB_FACILITYSEARCH_WASTETRANSFER
as
select
	wt.FacilityReportID as FacilityReportID,
	wt.WasteTransferID as WasteTransferID,
	lwty.Code as WasteTypeCode,
	lwtr.Code as WasteTreatmentCode,
	whp.CountryID as WHPCountryID,
	whp.CountryCode as WHPCountryCode,
	wt.ConfidentialIndicator as ConfidentialIndicator,
	lc.Code as ConfidentialCode,
	lwty.LOV_WasteTypeID as LOV_WasteTypeID,
	lwtr.LOV_WasteTreatmentID as LOV_WasteTreatmentID,
	lc.LOV_ConfidentialityID as LOV_ConfidentialityID
FROM vAT_WASTETRANSFER wt
inner join 
	LOV_WASTETYPE lwty   --(1-4)
on  lwty.LOV_WasteTypeID = wt.LOV_WasteTypeID
left outer join	
	LOV_WASTETREATMENT lwtr  --(1,2,null)
on  lwtr.LOV_WasteTreatmentID = wt.LOV_WasteTreatmentID
left outer join (
	select 
		wh.WasteHandlerPartyID,
		country.Code as CountryCode,
		country.Name as CountryName,
		country.LOV_CountryID as CountryID
	from
		WASTEHANDLERPARTY wh
	left outer join
		ADDRESS addr
	on	addr.AddressID = wh.AddressID	
	left outer join
		LOV_COUNTRY country
	ON  addr.LOV_CountryID = country.LOV_CountryID
	)whp
on whp.WasteHandlerPartyID = wt.WasteHandlerPartyID
left outer join
	LOV_CONFIDENTIALITY lc
on	lc.LOV_ConfidentialityID = wt.LOV_ConfidentialityID
go

--select * from  WEB_FACILITYSEARCH_WASTETRANSFER


------------------------------------------------------------------------------
--		create View for ALL data
------------------------------------------------------------------------------

if object_id('EPRTRmaster.dbo.tAT_FACILITYSEARCH')is not null DROP TABLE EPRTRmaster.dbo.tAT_FACILITYSEARCH
select top 0 * into EPRTRmaster.dbo.tAT_FACILITYSEARCH
from WEB_FACILITYSEARCH_MAINACTIVITY

CREATE UNIQUE CLUSTERED INDEX [FACILITYSEARCH_INDEX] 
ON [dbo].tAT_FACILITYSEARCH (FacilityReportID asc)

if object_id('WEB_FACILITYSEARCH_ALL')is not null DROP view WEB_FACILITYSEARCH_ALL
go
create view WEB_FACILITYSEARCH_ALL
as
select
	f.FacilityReportID,
	p.LOV_PollutantGroupID,
	p.PollutantGroupCode,
	p.LOV_PollutantID,
	p.PollutantCode,
	p.CAS,
	p.MediumCode,
	p.ConfidentialIndicator as ConfidentialIndicatorPollutant,
	p.LOV_MediumID as LOV_MediumID,
	p.LOV_ConfidentialityID as LOV_ConfidentialityIDPollutant,
	p.ConfidentialCode as ConfidentialCodePollutant,
	w.WasteTransferID as IDWaste,
	w.LOV_WasteTypeID,
	w.WasteTypeCode,
	w.LOV_WasteTreatmentID,
	isnull(w.WasteTreatmentCode,'U') as WasteTreatmentCode,
	w.WHPCountryCode,
	w.WHPCountryID,
	w.ConfidentialIndicator as ConfidentialIndicatorWaste,
	w.LOV_ConfidentialityID as LOV_ConfidentialityIDWaste,
	w.ConfidentialCode as ConfidentialCodeWaste,
	f.FacilityName,
	f.FacilityID,
	f.NationalID,
	f.ParentCompanyName,
	f.ReportingYear,
	f.[Address],
	f.City,
	f.PostalCode,
	f.CountryCode,
	f.LOV_CountryID,
	f.RiverBasinDistrictCode,
	f.LOV_RiverBasinDistrictID,
	f.NUTSLevel2RegionCode,
	f.LOV_NUTSRLevel1ID,
	f.LOV_NUTSRLevel2ID,
	f.LOV_NUTSRLevel3ID,
	f.IASectorCode,
	f.IAActivityCode,
	f.IASubActivityCode,
	f.IPPCSectorCode,
	f.IPPCActivityCode,
	f.IPPCSubActivityCode,
	f.LOV_IASectorID,
	f.LOV_IAActivityID,
	f.LOV_IASubActivityID,
	f.NACESectorCode,
	f.NACEActivityCode,
	f.NACESubActivityCode,
	f.LOV_NACESectorID,
	f.LOV_NACEActivityID,
	f.LOV_NACESubActivityID,
	f.IAReportedActivityCode,
	f.IPPCReportedActivityCode,
	f.NACEReportedActivityCode,
	f.ConfidentialIndicator as ConfidentialIndicatorFacility,
	f.ConfidentialCode as ConfidentialCodeFacility,
	f.LOV_ConfidentialityID as LOV_ConfidentialityIDFacility
from 
	EPRTRmaster.dbo.tAT_FACILITYSEARCH f
left outer join
	WEB_FACILITYSEARCH_POLLUTANT p
on f.FacilityReportID = p.FacilityReportID
left outer join
	WEB_FACILITYSEARCH_WASTETRANSFER w
on f.FacilityReportID = w.FacilityReportID
go 

--select
--	ReportingYear,
--	LOV_CountryID,
--	LOV_MediumID,
--	LOV_PollutantID,
--	LOV_WasteTypeID,
--	LOV_WasteTreatmentID,
--	IDWaste,
--	FacilityReportID,
--	COUNT(*)
--from EPRTRreview.dbo.FACILITYSEARCH_ALL
--group by 
--	ReportingYear,
--	LOV_CountryID,
--	LOV_MediumID,
--	LOV_PollutantID,
--	LOV_WasteTypeID,
--	LOV_WasteTreatmentID,
--	IDWaste,
--	FacilityReportID
--order by 9 desc

