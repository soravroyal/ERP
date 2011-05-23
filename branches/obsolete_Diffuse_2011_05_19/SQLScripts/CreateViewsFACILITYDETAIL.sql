------------------------------------------------------------------------------
--		createViewsFACILITYDETAIL.sql
------------------------------------------------------------------------------

USE EPRTRmaster
go

if object_id('EPRTRmaster.dbo.WEB_FACILITYDETAIL_POLLUTANTTRANSFER')is not null DROP view WEB_FACILITYDETAIL_POLLUTANTTRANSFER
go
create view dbo.WEB_FACILITYDETAIL_POLLUTANTTRANSFER
as 
select
	pt.FacilityReportID as FacilityReportID,
	frep.FacilityID as FacilityID, 
	lp.PollutantGroupCode as GroupCode,
	lp.PollutantCode as PollutantCode,
	lp.CAS as CAS,
	lmb.Code as MethodCode,
	ml.MethodDesignation as MethodDesignation,
	ml.MethodTypeCode as MethodTypeCode,
	pt.Quantity as Quantity, 
	lu.Code as UnitCode,
	pt.ConfidentialIndicator as ConfidentialIndicator,
	lc.Code as ConfidentialCode,
	ml.MethodListID as MethodListID,  
	lp.LOV_ID as LOV_PollutantID,
	lp.LOV_GroupID as LOV_PollutantGroupID,
	lmb.LOV_MethodBasisID as LOV_MethodBasisID,
	lc.LOV_ConfidentialityID as LOV_ConfidentialityID 
FROM vAT_POLLUTANTTRANSFER pt
inner join	
	vAT_POLLUTANT lp
on  lp.LOV_PollutantID = pt.LOV_PollutantID
inner join
	LOV_METHODBASIS lmb
on	lmb.LOV_MethodBasisID = pt.LOV_MethodBasisID 
inner join
	LOV_UNIT lu 
on  lu.LOV_UnitID = pt.LOV_QuantityUnitID
inner join 
	FACILITYREPORT frep
on	frep.FacilityReportID = pt.FacilityReportID
left outer join (
	select
		mu.MethodListID,
		mu.MethodDesignation,
		lmt.Code as MethodTypeCode,
		lmt.Name as MethodTypeName 
	from 
		METHODUSED mu
	left outer join
		LOV_METHODTYPE lmt
	on lmt.LOV_MethodTypeID = mu.LOV_MethodTypeID
	) ml
on ml.MethodListID = pt.MethodListID
left outer join
	LOV_CONFIDENTIALITY lc
on	lc.LOV_ConfidentialityID = pt.LOV_ConfidentialityID
go

--select * from  dbo.WEB_FACILITYDETAIL_POLLUTANTTRANSFER order by 1


if object_id('EPRTRmaster.dbo.WEB_FACILITYDETAIL_POLLUTANTRELEASE')is not null DROP view WEB_FACILITYDETAIL_POLLUTANTRELEASE
go
create view dbo.WEB_FACILITYDETAIL_POLLUTANTRELEASE
as
select
	pr.FacilityReportID as FacilityReportID,
	frep.FacilityID as FacilityID, 
	lm.Code as PollutantTo,
	lp.PollutantGroupCode as GroupCode,
	lp.PollutantCode as PollutantCode,
	lp.CAS as CAS,
	lmb.Code as MethodCode,
	ml.MethodDesignation as MethodDesignation,
	ml.MethodTypeCode as MethodTypeCode,
	pr.TotalQuantity as TotalQuantity, 
	lu.Code as TotalQuantityUnitCode,
	pr.AccidentalQuantity as AccidentalQuantity,
	case when lu2.Code = 'UNKNOWN' then 'KGM' else lu2.Code end as AccidentalQuantityUnitCode,
	pr.ConfidentialIndicator as ConfidentialIndicator,
	lc.Code as ConfidentialCode,
	lm.LOV_MediumID as LOV_MediumID,
	ml.MethodListID as MethodListID,  
	lp.LOV_ID as LOV_PollutantID,
	lp.LOV_GroupID as LOV_PollutantGroupID,
	lmb.LOV_MethodBasisID as LOV_MethodBasisID,
	lc.LOV_ConfidentialityID as LOV_ConfidentialityID 
from vAT_POLLUTANTRELEASE pr
inner join 
	LOV_MEDIUM lm
on  lm.LOV_MediumID = pr.LOV_MediumID
inner join	
	vAT_POLLUTANT lp
on  lp.LOV_PollutantID = pr.LOV_PollutantID
inner join
	LOV_METHODBASIS lmb
on	lmb.LOV_MethodBasisID = pr.LOV_MethodBasisID 
inner join
	LOV_UNIT lu 
on  lu.LOV_UnitID = pr.LOV_TotalQuantityUnitID
inner join 
	FACILITYREPORT frep
on	frep.FacilityReportID = pr.FacilityReportID
left outer join
	LOV_UNIT lu2 
on  lu2.LOV_UnitID = pr.LOV_AccidentalQuantityUnitID
left outer join
	LOV_CONFIDENTIALITY lc
on	lc.LOV_ConfidentialityID = pr.LOV_ConfidentialityID
left outer join (
	select
		mu.MethodListID,
		mu.MethodDesignation,
		lmt.Code as MethodTypeCode,
		lmt.Name as MethodTypeName 
	from 
		METHODUSED mu
	left outer join
		LOV_METHODTYPE lmt
	on lmt.LOV_MethodTypeID = mu.LOV_MethodTypeID
	) ml
on ml.MethodListID = pr.MethodListID
go

--select * from dbo.WEB_FACILITYDETAIL_POLLUTANTRELEASE 
--where PollutantCode = 'BTEX' or GroupCode = 'BTEX' order by 1 


if object_id('EPRTRmaster.dbo.WEB_FACILITYDETAIL_WASTETRANSFER')is not null DROP view WEB_FACILITYDETAIL_WASTETRANSFER
go
create view dbo.WEB_FACILITYDETAIL_WASTETRANSFER
as 
select
	wt.FacilityReportID as FacilityReportID,
	wt.WasteTransferID as WasteTransferID,
	frep.FacilityID as FacilityID, 
	lwty.Code as WasteTypeCode,
	lwtr.Code as WasteTreatmentCode,
	lmb.Code as MethodCode,
	ml.MethodDesignation as MethodDesignation,
	ml.MethodTypeCode as MethodTypeCode,
	wt.Quantity as Quantity, 
	lu.Code as UnitCode,
	whp.WasteHandlerPartyName as WHPName,
	whp.Address as WHPAddress,
	whp.City as WHPCity,
	whp.PostalCode as WHPPostalCode,
	whp.CountryCode as WHPCountryCode,
	whp.SiteAddress as WHPSiteAddress,
	whp.SiteCity as WHPSiteCity,
	whp.SitePostalCode as WHPSitePostalCode,
	whp.SiteCountryCode as WHPSiteCountryCode,
	wt.ConfidentialIndicator as ConfidentialIndicator,
	lc.Code as ConfidentialCode,
	lwty.LOV_WasteTypeID as LOV_WasteTypeID,
	lwtr.LOV_WasteTreatmentID as LOV_WasteTreatmentID,
	lmb.LOV_MethodBasisID as LOV_MethodBasisID,
	lc.LOV_ConfidentialityID as LOV_ConfidentialityID 
FROM vAT_WASTETRANSFER wt
inner join
	LOV_UNIT lu 
on  lu.LOV_UnitID = wt.LOV_QuantityUnitID
inner join 
	FACILITYREPORT frep
on	frep.FacilityReportID = wt.FacilityReportID
left outer join 
	LOV_WASTETYPE lwty
	on  lwty.LOV_WasteTypeID = wt.LOV_WasteTypeID
left outer join
	LOV_METHODBASIS lmb
on	lmb.LOV_MethodBasisID = wt.LOV_MethodBasisID 
left outer join	
	LOV_WASTETREATMENT lwtr
on  lwtr.LOV_WasteTreatmentID = wt.LOV_WasteTreatmentID
left outer join (
	select
		mu.MethodListID,
		mu.MethodDesignation,
		lmt.Code as MethodTypeCode,
		lmt.Name as MethodTypeName 
	from 
		METHODUSED mu
	left outer join
		LOV_METHODTYPE lmt
	on lmt.LOV_MethodTypeID = mu.LOV_MethodTypeID
	) ml
on ml.MethodListID = wt.MethodListID
left outer join (
	select 
		wh.WasteHandlerPartyID,
		wh.Name as WasteHandlerPartyName,
		RTRIM(addr.StreetName + CASE 
			WHEN addr.BuildingNumber IS NULL THEN '' 
			ELSE ' ' + addr.BuildingNumber 
			END) as Address,
		addr.City as City,
		addr.PostalCode as PostalCode,
		country.Code as CountryCode,
		country.Name as CountryName,
		RTRIM(addrSite.StreetName + CASE 
			WHEN addrSite.BuildingNumber IS NULL THEN '' 
			ELSE ' ' + addrSite.BuildingNumber 
			END) as SiteAddress,
		addrSite.City as SiteCity,
		addrSite.PostalCode as SitePostalCode,
		countrySite.Code as SiteCountryCode
	from
		WASTEHANDLERPARTY wh
	left outer join
		ADDRESS addr
	on	addr.AddressID = wh.AddressID	
	left outer join
		LOV_COUNTRY country
	on  addr.LOV_CountryID = country.LOV_CountryID
	left outer join
		ADDRESS addrSite
	on	addrSite.AddressID = wh.SiteAddressID	
	left outer join
		LOV_COUNTRY countrySite
	on  addrSite.LOV_CountryID = countrySite.LOV_CountryID
	)whp
on whp.WasteHandlerPartyID = wt.WasteHandlerPartyID
left outer join
	LOV_CONFIDENTIALITY lc
on	lc.LOV_ConfidentialityID = wt.LOV_ConfidentialityID
go

--select * from dbo.WEB_FACILITYDETAIL_WASTETRANSFER


if object_id('EPRTRmaster.dbo.WEB_FACILITYDETAIL_DETAIL')is not null DROP view WEB_FACILITYDETAIL_DETAIL
go
create view dbo.WEB_FACILITYDETAIL_DETAIL
as
select
    frep.FacilityReportID as FacilityReportID,
    frep.FacilityName as FacilityName,
    frep.FacilityID as FacilityID,
    frep.NationalID as NationalID,
    prtr.ReportingYear as ReportingYear, 
    RTRIM(f_addr.StreetName + CASE 
		WHEN f_addr.BuildingNumber IS NULL THEN '' 
		ELSE ' ' + f_addr.BuildingNumber 
		END) as Address,
    f_addr.City as City,
    f_addr.PostalCode as PostalCode,
    country.Code as CountryCode,
    prtr.Published as Published,
    frep.ParentCompanyName as ParentCompanyName,
    CASE
        WHEN frep.GeographicalCoordinate IS NULL THEN 'POINT(0 0)' 
        ELSE frep.GeographicalCoordinate.ToString() 
    END as Coordinates,
    st.Code as CoordinateStatusCode,
	nuts.L1Code as NUTSRegionLevel1Code,
	nuts.L2Code as NUTSRegionLevel2Code,
	nuts.L3Code as NUTSRegionLevel3Code,
	case when frep.ProtectVoluntaryData = 0 then nutss.Code end as NUTSRegionSourceCode,
    rbd.Code as RiverBasinDistrictCode, 
    rbds.Code as RiverBasinDistrictSourceCode, 
    nace.SectorCode as NACESectorCode,
	nace.ActivityCode as NACEActivityCode,
    nace.SubActivityCode as NACESubActivityCode,
	vaa.SectorCode as IASectorCode,
	vaa.ActivityCode as IAActivityCode,
	vaa.SubActivityCode as IASubActivityCode,
	case when frep.ProtectVoluntaryData = 0 then pv.ProductName end as ProductionVolumeProductName,
    case when frep.ProtectVoluntaryData = 0 then pv.Quantity end as ProductionVolumeQuantity,
	case when frep.ProtectVoluntaryData = 0 then pv_unit.Code end as ProductionVolumeUnitCode,
	case when frep.ProtectVoluntaryData = 0 then frep.TotalIPPCInstallationQuantity end as TotalIPPCInstallationQuantity,
    case when frep.ProtectVoluntaryData = 0 then frep.TotalEmployeeQuantity end as TotalEmployeeQuantity,
    case when frep.ProtectVoluntaryData = 0 then frep.OperatingHours end as OperatingHours,
    frep.WebsiteCommunication as WebsiteCommunication,
	frep.PublicInformation as PublicInformation, 
    frep.ConfidentialIndicator as ConfidentialIndicator, 
    con.Code as ConfidentialIndicatorCode,
	cfi.ConfidentialIndicatorWaste as ConfidentialIndicatorWaste,
	cfi.ConfidentialIndicatorPollutantRelease as ConfidentialIndicatorPollutantRelease,
	cfi.ConfidentialIndicatorPollutantTransfer as ConfidentialIndicatorPollutantTransfer
from
    dbo.FACILITYREPORT AS frep
inner join
    dbo.vAT_POLLUTANTRELEASEANDTRANSFERREPORT AS prtr
on	frep.PollutantReleaseAndTransferReportID = prtr.PollutantReleaseAndTransferReportID
inner join
	vAT_NACEACTIVITY nace
on frep.LOV_NACEMainEconomicActivityID = nace.LOV_NACEActivityID
inner join
	LOV_COUNTRY country
on  prtr.LOV_CountryID = country.LOV_CountryID
inner join
	ACTIVITY act
on  frep.FacilityReportID = act.FacilityReportID
and RankingNumeric = 1
inner join
	vAT_ANNEXIACTIVITY vaa
on vaa.LOV_AnnexIActivityID = act.LOV_AnnexIActivityID
inner join
	LOV_STATUS st
on st.LOV_StatusID = frep.LOV_StatusID
inner join
	tAT_CONFIDENTIALITY cfi
on	cfi.FacilityReportID = frep.FacilityReportID
left outer join 
	vAT_NUTSREGION nuts
on  frep.LOV_NUTSRegionID = nuts.LOV_NUTSRegionID
left outer join 
	LOV_NUTSREGION nutss
on  frep.LOV_NUTSRegionID_Source = nutss.LOV_NUTSRegionID
left outer join
	LOV_RIVERBASINDISTRICT rbd
on  frep.LOV_RiverBasinDistrictID = rbd.LOV_RiverBasinDistrictID 
left outer join
	LOV_RIVERBASINDISTRICT rbds
on  frep.LOV_RiverBasinDistrictID_Source = rbds.LOV_RiverBasinDistrictID 
left outer join
    dbo.ADDRESS AS f_addr
on	frep.AddressID = f_addr.AddressID
left outer join 
    PRODUCTIONVOLUME AS pv
on	frep.ProductionVolumeID = pv.ProductionVolumeID
left outer join 
    LOV_UNIT AS pv_unit
on	pv.LOV_UnitID = pv_unit.LOV_UnitID
left outer join
	LOV_CONFIDENTIALITY con
on	con.LOV_ConfidentialityID = frep.LOV_ConfidentialityID
go


if object_id('EPRTRmaster.dbo.WEB_FACILITYDETAIL_COMPETENTAUTHORITYPARTY')is not null DROP view WEB_FACILITYDETAIL_COMPETENTAUTHORITYPARTY
go
create view dbo.WEB_FACILITYDETAIL_COMPETENTAUTHORITYPARTY
as
select
	fr2.FacilityReportID as FacilityReportID,
	cap.Name as CAName,
    RTRIM(addr.StreetName + ' ' + CASE 
		WHEN addr.BuildingNumber IS NULL THEN '' 
		ELSE addr.BuildingNumber 
		END) as CAAddress,
	addr.City as CACity,
	addr.PostalCode as CAPostalCode,
	cap.TelephoneCommunication as CATelephoneCommunication,
	cap.FaxCommunication as CAFaxCommunication,
	cap.EmailCommunication as CAEmailCommunication,
	cap.ContactPersonName as CAContactPersonName,
	cap.ReportingYear as CAReportingYear,
	m2.Published as CALastUpdate
FROM 
	FACILITYREPORT fr2
inner join (
	select 
		fr1.FacilityReportID, 
		fr1.FacilityID,
		fr1.CompetentAuthorityPartyID,
		prtr1.Published
	FROM 
		FACILITYREPORT fr1
	inner join
		vAT_POLLUTANTRELEASEANDTRANSFERREPORT prtr1
	on prtr1.PollutantReleaseAndTransferReportID = fr1.PollutantReleaseAndTransferReportID
	inner join (
		select distinct 
			f.FacilityID as fID,
			MAX(prtr.ReportingYear) as maxY
		from FACILITY f
		inner join 
			FACILITYREPORT fr
		on f.FacilityID = fr.FacilityID
		inner join
			vAT_POLLUTANTRELEASEANDTRANSFERREPORT prtr
		on prtr.PollutantReleaseAndTransferReportID = fr.PollutantReleaseAndTransferReportID
		group by f.FacilityID
		) m
	on  m.fID = fr1.FacilityID
	and m.maxY = prtr1.ReportingYear
	) m2
on m2.FacilityID = fr2.FacilityID
inner join
	COMPETENTAUTHORITYPARTY cap
on cap.CompetentAuthorityPartyID = m2.CompetentAuthorityPartyID
left outer join 
	ADDRESS addr
on  addr.AddressID = cap.AddressID
left outer join
	LOV_COUNTRY country
on  country.LOV_CountryID = cap.LOV_CountryID
go
 
--select * from dbo.WEB_FACILITYDETAIL_COMPETENTAUTHORITYPARTY

use EPRTRmaster

if object_id('EPRTRmaster.dbo.WEB_FACILITYDETAIL_ACTIVITY')is not null DROP view WEB_FACILITYDETAIL_ACTIVITY
go
create view dbo.WEB_FACILITYDETAIL_ACTIVITY
as
select     
	a.FacilityReportID, 
	a.MainActivityIndicator,
	a.RankingNumeric,
	l.Code as IAReportedActivityCode,
	l.IPPCCode as IPPCReportedActivityCode,
	ia.SectorCode,
	ia.ActivityCode,
	ia.SubActivityCode,
	ia.ActivityIPPCCode,
	ia.SubActivityIPPCCode
from         
	ACTIVITY a
inner join
 	vAT_ANNEXIACTIVITY ia
on	ia.LOV_AnnexIActivityID = a.LOV_AnnexIActivityID
inner join
	LOV_ANNEXIACTIVITY l
on l.LOV_AnnexIActivityID = a.LOV_AnnexIActivityID
	go
--select * from WEB_FACILITYDETAIL_ACTIVITY where RankingNumeric = 5

