--------------------------------------------------------------------------------
--
--	Delta script adding accidental column to 2 views
--
--	wos-080711
--
--------------------------------------------------------------------------------


USE [EPRTRmaster]
GO


------------------------------------------------------------------------------
--		alter view WEB_FACILITYSEARCH_POLLUTANT
--		add column Accidental
------------------------------------------------------------------------------

if object_id('EPRTRmaster.dbo.WEB_FACILITYSEARCH_POLLUTANT')is not null DROP view [WEB_FACILITYSEARCH_POLLUTANT]
go

create view [dbo].[WEB_FACILITYSEARCH_POLLUTANT](
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
	LOV_ConfidentialityID,
	Accidental
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
	lc.LOV_ConfidentialityID,
	0
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
	lc.LOV_ConfidentialityID,
	case when isnull(pr.AccidentalQuantity,0) > 0 then 1
		else 0
	end
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

GO

------------------------------------------------------------------------------
--		alter view WEB_FACILITYSEARCH_ALL
--		add column Accidental
------------------------------------------------------------------------------

if object_id('EPRTRmaster.dbo.WEB_FACILITYSEARCH_ALL')is not null DROP view WEB_FACILITYSEARCH_ALL
go

create view [dbo].[WEB_FACILITYSEARCH_ALL]
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
	p.Accidental as Accidental,
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

GO



