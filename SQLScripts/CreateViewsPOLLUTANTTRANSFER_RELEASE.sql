
USE EPRTRmaster
GO

------------------------------------------------------------------------------
--		create View POLLUTANTTRANSFER.sql
------------------------------------------------------------------------------

if object_id('EPRTRmaster.dbo.WEB_POLLUTANTTRANSFER')is not null DROP view WEB_POLLUTANTTRANSFER
go
create view WEB_POLLUTANTTRANSFER
as 
select
	pt.FacilityReportID as FacilityReportID,
    f.FacilityName as FacilityName,
    f.FacilityID as FacilityID,
	f.ReportingYear as ReportingYear,
	lmb.Code as MethodCode,
	pt.Quantity as Quantity, 
	lu.Code as UnitCode,
 	pol.PollutantGroupCode as PollutantGroupCode,
	pol.PollutantCode as PollutantCode,
	pol.CAS as CAS,
	pol.LOV_GroupID as LOV_PollutantGroupID,
	pol.LOV_ID as LOV_PollutantID,
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
	lc.LOV_ConfidentialityID as LOV_ConfidentialityID,
	lc.Code as ConfidentialCode,
	pt.ConfidentialIndicator as ConfidentialIndicator,
	f.ConfidentialIndicator as ConfidentialIndicatorFacility
FROM vAT_POLLUTANTTRANSFER pt
inner join	
	vAT_POLLUTANT pol
on  pt.LOV_PollutantID = pol.LOV_PollutantID
inner join
	LOV_METHODBASIS lmb
on	lmb.LOV_MethodBasisID = pt.LOV_MethodBasisID 
inner join
	LOV_UNIT lu 
on  lu.LOV_UnitID = pt.LOV_QuantityUnitID
inner join
	tAT_FACILITYSEARCH f
on	f.FacilityReportID = pt.FacilityReportID
left outer join
	LOV_CONFIDENTIALITY lc
on	lc.LOV_ConfidentialityID = pt.LOV_ConfidentialityID

--inner join
--    FACILITYREPORT frep
--on frep.FacilityReportID = pt.FacilityReportID
--inner join
--    vAT_POLLUTANTRELEASEANDTRANSFERREPORT prtr
--on  frep.PollutantReleaseAndTransferReportID = prtr.PollutantReleaseAndTransferReportID
--inner join
--    LOV_COUNTRY country
--on  prtr.LOV_CountryID = country.LOV_CountryID
--inner join
--    LOV_RIVERBASINDISTRICT rbd
--on  frep.LOV_RiverBasinDistrictID = rbd.LOV_RiverBasinDistrictID
--inner join
--    ACTIVITY act
--on  frep.FacilityReportID = act.FacilityReportID
--and RankingNumeric = 1
--inner join
--	vAT_ANNEXIACTIVITY vaa
--on vaa.LOV_AnnexIActivityID = act.LOV_AnnexIActivityID
--left outer join 
--    vAT_NUTSREGION nuts
--on  frep.LOV_NUTSRegionID = nuts.LOV_NUTSRegionID
go


if object_id('EPRTRmaster.dbo.WEB_POLLUTANTTRANSFER_COMPAREYEAR')is not null DROP view WEB_POLLUTANTTRANSFER_COMPAREYEAR
go
create view WEB_POLLUTANTTRANSFER_COMPAREYEAR
as 
select 
	p1.*,
	p2.ReportingYear as CompareYear
from WEB_POLLUTANTTRANSFER p1
inner join
	tAT_FACILITY_POLLUTANTTRANSFER_YEAR p2
on	p1.FacilityID = p2.FacilityID
and p1.PollutantCode collate database_default = p2.PollutantCode 
go


------------------------------------------------------------------------------
--		create View POLLUTANTRELEASE.sql
------------------------------------------------------------------------------

if object_id('EPRTRmaster.dbo.WEB_POLLUTANTRELEASE')is not null DROP view WEB_POLLUTANTRELEASE
go
create view WEB_POLLUTANTRELEASE
as 
select
	tAT.FacilityReportID as FacilityReportID,
    f.FacilityName as FacilityName,
	f.FacilityID AS FacilityID,
	f.ReportingYear as ReportingYear,
	pol.PollutantCode as PollutantCode,
 	pol.PollutantGroupCode as PollutantGroupCode,
	pol.LOV_ID as LOV_PollutantID,
	pol.LOV_GroupID as LOV_PollutantGroupID,
	pol.CAS as CAS,
	tAT.QuantityAir,
	tAT.QuantityAccidentalAir,
	case when tAT.QuantityAir > 0 then tAT.QuantityAccidentalAir/tAT.QuantityAir * 100 else 0 end as PercentAccidentalAir,
	tAT.QuantityWater,
	tAT.QuantityAccidentalWater,
	case when tAT.QuantityWater > 0 then tAT.QuantityAccidentalWater/tAT.QuantityWater * 100 else 0 end as PercentAccidentalWater,
	tAT.QuantitySoil,
	tAT.QuantityAccidentalSoil,
	case when tAT.QuantitySoil > 0 then tAT.QuantityAccidentalSoil/tAT.QuantitySoil * 100 else 0 end as PercentAccidentalSoil,
	tAT.UnitAir,
	tAT.UnitAccidentalAir,
	tAT.UnitWater,
	tAT.UnitAccidentalWater,
	tAT.UnitSoil,
	tAT.UnitAccidentalSoil,
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
	tAT.LOV_ConfidentialityIDAir as LOV_ConfidentialityIDAir, 
	tAT.LOV_ConfidentialityIDWater as LOV_ConfidentialityIDWater, 
	tAT.LOV_ConfidentialityIDSoil as LOV_ConfidentialityIDSoil, 
	cAir.Code as ConfidentialCodeAir,
	cWater.Code as ConfidentialCodeWater,
	cSoil.Code as ConfidentialCodeSoil,
	tAT.ConfidentialIndicator,
	f.ConfidentialIndicator as ConfidentialIndicatorFacility
FROM tAT_ACTIVITYSEARCH_POLLUTANTRELEASE tAT
inner join	
	vAT_POLLUTANT pol
on  tAT.LOV_PollutantID = pol.LOV_PollutantID
inner join
	tAT_FACILITYSEARCH f
on	f.FacilityReportID = tAT.FacilityReportID
left outer join
	LOV_CONFIDENTIALITY cAir
on tAT.LOV_ConfidentialityIDAir = cAir.LOV_ConfidentialityID
left outer join
	LOV_CONFIDENTIALITY cWater
on tAT.LOV_ConfidentialityIDWater = cWater.LOV_ConfidentialityID
left outer join
	LOV_CONFIDENTIALITY cSoil
on tAT.LOV_ConfidentialityIDSoil = cSoil.LOV_ConfidentialityID

--inner join
--    FACILITYREPORT frep
--on frep.FacilityReportID = tAT.FacilityReportID
--inner join
--    vAT_POLLUTANTRELEASEANDTRANSFERREPORT prtr
--on  frep.PollutantReleaseAndTransferReportID = prtr.PollutantReleaseAndTransferReportID
--inner join
--    LOV_COUNTRY country
--on  prtr.LOV_CountryID = country.LOV_CountryID
--inner join
--    LOV_RIVERBASINDISTRICT rbd
--on  frep.LOV_RiverBasinDistrictID = rbd.LOV_RiverBasinDistrictID
--inner join
--    ACTIVITY act
--on  frep.FacilityReportID = act.FacilityReportID
--and RankingNumeric = 1
--inner join
--	vAT_ANNEXIACTIVITY vaa
--on vaa.LOV_AnnexIActivityID = act.LOV_AnnexIActivityID
--left outer join 
--    vAT_NUTSREGION nuts
--on  frep.LOV_NUTSRegionID = nuts.LOV_NUTSRegionID
go


if object_id('EPRTRmaster.dbo.WEB_POLLUTANTRELEASE_COMPAREYEAR')is not null DROP view WEB_POLLUTANTRELEASE_COMPAREYEAR
go
create view WEB_POLLUTANTRELEASE_COMPAREYEAR
as 
select 
	p1.*,
	p2.ReportingYear as CompareYear
from WEB_POLLUTANTRELEASE p1
inner join
	tAT_FACILITY_POLLUTANTRELEASE_YEAR p2
on	p1.FacilityID = p2.FacilityID
and p1.PollutantCode collate database_default = p2.PollutantCode 
go


--select 
--	c.Name,
--	cA.nrAir as FacilitiesAir,
--	cW.nrWater as FacilitiesWater,
--	cS.nrSoil as FacilitiesSoil	
--from LOV_CONFIDENTIALITY c	
--inner join (
--	select ConfidentialCodeAir as cAir, COUNT(*) as nrAir  from EPRTRmaster.dbo.WEB_POLLUTANTRELEASE
--	where not ConfidentialCodeAir is null group by ConfidentialCodeAir
--) cA
--on c.Code collate database_default = cA.cAir 
--inner join (
--	select ConfidentialCodeWater as cWater, COUNT(*) as nrWater  from EPRTRmaster.dbo.WEB_POLLUTANTRELEASE
--	where not ConfidentialCodeWater is null group by ConfidentialCodeWater
--) cW
--on c.Code collate database_default = cW.cWater 
--inner join (
--	select ConfidentialCodeSoil as cSoil, COUNT(*) as nrSoil  from EPRTRmaster.dbo.WEB_POLLUTANTRELEASE
--	where not ConfidentialCodeSoil is null group by ConfidentialCodeSoil
--) cS
--on c.Code collate database_default = cS.cSoil 

