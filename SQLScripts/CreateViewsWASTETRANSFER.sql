------------------------------------------------------------------------------
--		alter View WASTETRANSFER.sql
------------------------------------------------------------------------------

USE EPRTRmaster
GO

if object_id('EPRTRmaster.dbo.WEB_WASTETRANSFER')is not null DROP view WEB_WASTETRANSFER
go
create view WEB_WASTETRANSFER
as 
select
	wt.FacilityReportID,
	LTRIM(f.FacilityName) as FacilityName,
	f.FacilityID as FacilityID,
	f.ReportingYear as ReportingYear,
	QuantityRecoveryNONHW as QuantityRecoveryNONHW,
	QuantityDisposalNONHW as QuantityDisposalNONHW,
	QuantityUnspecNONHW as QuantityUnspecNONHW,
	case 
		when 
				QuantityRecoveryNONHW is null 
			and QuantityDisposalNONHW is null 
			and QuantityUnspecNONHW is null then null
		else 
			isnull(QuantityRecoveryNONHW,0) + 
			isnull (QuantityDisposalNONHW,0) + 
			isnull (QuantityUnspecNONHW,0) 
		end as QuantityTotalNONHW,
	UnitCodeNONHW as UnitCodeNONHW,
	QuantityRecoveryHWIC as QuantityRecoveryHWIC,
	QuantityDisposalHWIC as QuantityDisposalHWIC,
	QuantityUnspecHWIC as QuantityUnspecHWIC,
	case 
		when 
				QuantityRecoveryHWIC is null 
			and QuantityDisposalHWIC is null 
			and QuantityUnspecHWIC is null then null
		else 
			isnull(QuantityRecoveryHWIC,0) + 
			isnull (QuantityDisposalHWIC,0) + 
			isnull (QuantityUnspecHWIC,0) 
		end as QuantityTotalHWIC,
	UnitCodeHWIC as UnitCodeHWIC,
	QuantityRecoveryHWOC as QuantityRecoveryHWOC,
	QuantityDisposalHWOC as QuantityDisposalHWOC,
	QuantityUnspecHWOC as QuantityUnspecHWOC,
	case 
		when 
				QuantityRecoveryHWOC is null 
			and QuantityDisposalHWOC is null 
			and QuantityUnspecHWOC is null then null
		else 
			isnull(QuantityRecoveryHWOC,0) + 
			isnull (QuantityDisposalHWOC,0) + 
			isnull (QuantityUnspecHWOC,0) 
		end as QuantityTotalHWOC,
	UnitCodeHWOC as UnitCodeHWOC,
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
	HasReportedRecovery,
	HasReportedDisposal,
	HasReportedUnspecified,
	case 
		when 
				ConfidentialIndicator_NONHW_R is null
			and ConfidentialIndicator_NONHW_D is null
			and ConfidentialIndicator_NONHW_U is null then null
		else 
			isnull(wt.ConfidentialIndicator_NONHW_R,0) | 
			isnull(wt.ConfidentialIndicator_NONHW_D,0) | 
			isnull(wt.ConfidentialIndicator_NONHW_U,0)
		end as ConfidentialIndicatorNONHW,
	case 
		when 
				ConfidentialIndicator_HWOC_R is null
			and ConfidentialIndicator_HWOC_D is null
			and ConfidentialIndicator_HWOC_U is null then null
		else 
			isnull(wt.ConfidentialIndicator_HWOC_R,0) | 
			isnull(wt.ConfidentialIndicator_HWOC_D,0) | 
			isnull(wt.ConfidentialIndicator_HWOC_U,0) 
		end as ConfidentialIndicatorHWOC,
	case 
		when 
				ConfidentialIndicator_HWIC_R is null
			and ConfidentialIndicator_HWIC_D is null
			and ConfidentialIndicator_HWIC_U is null then null
		else 
			isnull(wt.ConfidentialIndicator_HWIC_R,0) | 
			isnull(wt.ConfidentialIndicator_HWIC_D,0) | 
			isnull(wt.ConfidentialIndicator_HWIC_U,0) 
		end as ConfidentialIndicatorHWIC,
	wt.ConfidentialIndicator as ConfidentialIndicatorWaste,
	f.ConfidentialIndicator as ConfidentialIndicatorFacility,
	wt.ConfidentialIndicator_HWIC_R as ConfidentialIndicator_HWIC_Recovery,
	wt.ConfidentialIndicator_HWIC_D as ConfidentialIndicator_HWIC_Disposal,
	wt.ConfidentialIndicator_HWIC_U as ConfidentialIndicator_HWIC_Unspec,
	wt.ConfidentialIndicator_HWOC_R as ConfidentialIndicator_HWOC_Recovery,
	wt.ConfidentialIndicator_HWOC_D as ConfidentialIndicator_HWOC_Disposal,
	wt.ConfidentialIndicator_HWOC_U as ConfidentialIndicator_HWOC_Unspec,
	wt.ConfidentialIndicator_NONHW_R as ConfidentialIndicator_NONHW_Recovery,
	wt.ConfidentialIndicator_NONHW_D as ConfidentialIndicator_NONHW_Disposal,
	wt.ConfidentialIndicator_NONHW_U as ConfidentialIndicator_NONHW_Unspec
from tAT_WASTETRANSFER wt
inner join
	tAT_FACILITYSEARCH f
on	f.FacilityReportID = wt.FacilityReportID
go
	
	
if object_id('EPRTRmaster.dbo.WEB_WASTETRANSFER_TREATMENT')is not null DROP view WEB_WASTETRANSFER_TREATMENT
go
create view WEB_WASTETRANSFER_TREATMENT
as 
	select
		w.FacilityReportID,
		'NON-HW' as WasteTypeCode,
		FacilityName,
		FacilityID,
		ReportingYear,
		QuantityRecoveryNONHW as QuantityRecovery,
		QuantityDisposalNONHW as QuantityDisposal,
		QuantityUnspecNONHW as QuantityUnspec,
		QuantityTotalNONHW as QuantityTotal,
		UnitCodeNONHW as UnitCode,
		CountryCode,
		LOV_CountryID,
		RiverBasinDistrictCode,
		LOV_RiverBasinDistrictID,
		NUTSLevel2RegionCode,
		LOV_NUTSRLevel1ID,
		LOV_NUTSRLevel2ID,
		LOV_NUTSRLevel3ID,
		IASectorCode,
		IAActivityCode,
		IASubActivityCode,
		IPPCSectorCode,
		IPPCActivityCode,
		IPPCSubActivityCode,
		LOV_IASectorID,
		LOV_IAActivityID,
		LOV_IASubActivityID,
		NACESectorCode,
		NACEActivityCode,
		NACESubActivityCode,
		LOV_NACESectorID,
		LOV_NACEActivityID,
		LOV_NACESubActivityID,
		case when m.WasteTreatmentCode = 'R' then CAST (1 as bit)
			else CAST (0 as bit) end as HasReportedRecovery,
		case when m.WasteTreatmentCode = 'D' then CAST (1 as bit)
			else CAST (0 as bit) end as HasReportedDisposal,
		case when m.WasteTreatmentCode is null then CAST (1 as bit)
			else CAST (0 as bit) end as HasReportedUnspecified,
		ConfidentialIndicatorFacility,
		ConfidentialIndicator_NONHW_Recovery as ConfidentialIndicatorRecovery,
		ConfidentialIndicator_NONHW_Disposal as ConfidentialIndicatorDisposal,
		ConfidentialIndicator_NONHW_Unspec as ConfidentialIndicatorUnspec
	FROM EPRTRmaster.dbo.WEB_WASTETRANSFER w
	inner join (
		select distinct 
			FacilityReportID as FacilityReportID,
			WasteTreatmentCode as WasteTreatmentCode 
		from WEB_FACILITYSEARCH_WASTETRANSFER 
		where WasteTypeCode = 'NON-HW'
	)m
	on w.FacilityReportID = m.FacilityReportID
	where ( 
		ConfidentialIndicatorNONHW = 1 
	or	QuantityTotalNONHW >= 0)
union
	select
		w.FacilityReportID,
		'HWIC' as WasteTypeCode,
		FacilityName,
		FacilityID,
		ReportingYear,
		QuantityRecoveryHWIC as QuantityRecovery,
		QuantityDisposalHWIC as QuantityDisposal,
		QuantityUnspecHWIC as QuantityUnspec,
		QuantityTotalHWIC as QuantityTotal,
		UnitCodeHWIC as UnitCode,
		CountryCode,
		LOV_CountryID,
		RiverBasinDistrictCode,
		LOV_RiverBasinDistrictID,
		NUTSLevel2RegionCode,
		LOV_NUTSRLevel1ID,
		LOV_NUTSRLevel2ID,
		LOV_NUTSRLevel3ID,
		IASectorCode,
		IAActivityCode,
		IASubActivityCode,
		IPPCSectorCode,
		IPPCActivityCode,
		IPPCSubActivityCode,
		LOV_IASectorID,
		LOV_IAActivityID,
		LOV_IASubActivityID,
		NACESectorCode,
		NACEActivityCode,
		NACESubActivityCode,
		LOV_NACESectorID,
		LOV_NACEActivityID,
		LOV_NACESubActivityID,
		case when m.WasteTreatmentCode = 'R' then CAST (1 as bit)
			else CAST (0 as bit) end as HasReportedRecovery,
		case when m.WasteTreatmentCode = 'D' then CAST (1 as bit)
			else CAST (0 as bit) end as HasReportedDisposal,
		case when m.WasteTreatmentCode is null then CAST (1 as bit)
			else CAST (0 as bit) end as HasReportedUnspecified,
		ConfidentialIndicatorFacility,
		ConfidentialIndicator_HWIC_Recovery as ConfidentialIndicatorRecovery,
		ConfidentialIndicator_HWIC_Disposal as ConfidentialIndicatorDisposal,
		ConfidentialIndicator_HWIC_Unspec as ConfidentialIndicatorUnspec
	FROM EPRTRmaster.dbo.WEB_WASTETRANSFER w
	inner join (
		select distinct 
			FacilityReportID as FacilityReportID,
			WasteTreatmentCode as WasteTreatmentCode 
		from WEB_FACILITYSEARCH_WASTETRANSFER 
		where WasteTypeCode = 'HWIC'
	)m
	on w.FacilityReportID = m.FacilityReportID
	where ( 
		ConfidentialIndicatorHWIC = 1 
	or	QuantityTotalHWIC >= 0)
union
	select
		w.FacilityReportID,
		'HWOC' as WasteTypeCode,
		FacilityName,
		FacilityID,
		ReportingYear,
		QuantityRecoveryHWOC as QuantityRecovery,
		QuantityDisposalHWOC as QuantityDisposal,
		QuantityUnspecHWOC as QuantityUnspec,
		QuantityTotalHWOC as QuantityTotal,
		UnitCodeHWOC as UnitCode,
		CountryCode,
		LOV_CountryID,
		RiverBasinDistrictCode,
		LOV_RiverBasinDistrictID,
		NUTSLevel2RegionCode,
		LOV_NUTSRLevel1ID,
		LOV_NUTSRLevel2ID,
		LOV_NUTSRLevel3ID,
		IASectorCode,
		IAActivityCode,
		IASubActivityCode,
		IPPCSectorCode,
		IPPCActivityCode,
		IPPCSubActivityCode,
		LOV_IASectorID,
		LOV_IAActivityID,
		LOV_IASubActivityID,
		NACESectorCode,
		NACEActivityCode,
		NACESubActivityCode,
		LOV_NACESectorID,
		LOV_NACEActivityID,
		LOV_NACESubActivityID,
		case when m.WasteTreatmentCode = 'R' then CAST (1 as bit)
			else CAST (0 as bit) end as HasReportedRecovery,
		case when m.WasteTreatmentCode = 'D' then CAST (1 as bit)
			else CAST (0 as bit) end as HasReportedDisposal,
		case when m.WasteTreatmentCode is null then CAST (1 as bit)
			else CAST (0 as bit) end as HasReportedUnspecified,
		w.ConfidentialIndicatorFacility,
		w.ConfidentialIndicator_HWOC_Recovery as ConfidentialIndicatorRecovery,
		w.ConfidentialIndicator_HWOC_Disposal as ConfidentialIndicatorDisposal,
		w.ConfidentialIndicator_HWOC_Unspec as ConfidentialIndicatorUnspec
	FROM EPRTRmaster.dbo.WEB_WASTETRANSFER w
	inner join (
		select distinct 
			FacilityReportID as FacilityReportID,
			WasteTreatmentCode as WasteTreatmentCode 
		from WEB_FACILITYSEARCH_WASTETRANSFER 
		where WasteTypeCode = 'HWOC'
	)m
	on w.FacilityReportID = m.FacilityReportID
	where ( 
		ConfidentialIndicatorHWOC = 1 
	or	QuantityTotalHWOC >= 0)
union
	select
		w.FacilityReportID,
		'HW' as WasteTypeCode,
		FacilityName,
		FacilityID,
		ReportingYear,
		case 
			when 
					QuantityRecoveryHWOC is null 
				and QuantityRecoveryHWIC is null then null
			else 
				isnull(QuantityRecoveryHWOC,0) + 
				isnull (QuantityRecoveryHWIC,0)
			end as QuantityRecovery,
		case 
			when 
					QuantityDisposalHWOC is null 
				and QuantityDisposalHWIC is null then null
			else 
				isnull(QuantityDisposalHWOC,0) + 
				isnull (QuantityDisposalHWIC,0)
			end as QuantityDisposal,
		case 
			when 
					QuantityUnspecHWOC is null 
				and QuantityUnspecHWIC is null then null
			else 
				isnull(QuantityUnspecHWOC,0) + 
				isnull (QuantityUnspecHWIC,0)
			end as QuantityUnspec,
		case 
			when 
					QuantityTotalHWOC is null 
				and QuantityTotalHWIC is null then null
			else 
				isnull(QuantityTotalHWOC,0) + 
				isnull (QuantityTotalHWIC,0)
			end as QuantityTotal,
		UnitCodeHWIC as UnitCode,
		CountryCode,
		LOV_CountryID,
		RiverBasinDistrictCode,
		LOV_RiverBasinDistrictID,
		NUTSLevel2RegionCode,
		LOV_NUTSRLevel1ID,
		LOV_NUTSRLevel2ID,
		LOV_NUTSRLevel3ID,
		IASectorCode,
		IAActivityCode,
		IASubActivityCode,
		IPPCSectorCode,
		IPPCActivityCode,
		IPPCSubActivityCode,
		LOV_IASectorID,
		LOV_IAActivityID,
		LOV_IASubActivityID,
		NACESectorCode,
		NACEActivityCode,
		NACESubActivityCode,
		LOV_NACESectorID,
		LOV_NACEActivityID,
		LOV_NACESubActivityID,
		case when m.WasteTreatmentCode = 'R' then CAST (1 as bit)
			else CAST (0 as bit) end as HasReportedRecovery,
		case when m.WasteTreatmentCode = 'D' then CAST (1 as bit)
			else CAST (0 as bit) end as HasReportedDisposal,
		case when m.WasteTreatmentCode is null then CAST (1 as bit)
			else CAST (0 as bit) end as HasReportedUnspecified,
		ConfidentialIndicatorFacility,
		case 
			when 
					ConfidentialIndicator_HWIC_Recovery is null 
				and ConfidentialIndicator_HWOC_Recovery is null then null
			else 
				isnull(ConfidentialIndicator_HWIC_Recovery,0) | 
				isnull(ConfidentialIndicator_HWOC_Recovery,0) 
			end as ConfidentialIndicatorRecovery,
		case 
			when 
					ConfidentialIndicator_HWIC_Disposal is null 
				and ConfidentialIndicator_HWOC_Disposal is null then null
			else 
				isnull(ConfidentialIndicator_HWIC_Disposal,0) | 
				isnull(ConfidentialIndicator_HWOC_Disposal,0) 
			end as ConfidentialIndicatorDisposal,
		case 
			when 
					ConfidentialIndicator_HWIC_Unspec is null 
				and ConfidentialIndicator_HWOC_Unspec is null then null
			else 
				isnull(ConfidentialIndicator_HWIC_Unspec,0) | 
				isnull(ConfidentialIndicator_HWOC_Unspec,0) 
			end as ConfidentialIndicatorUnspec
	FROM EPRTRmaster.dbo.WEB_WASTETRANSFER w
	inner join (
		select distinct 
			FacilityReportID as FacilityReportID,
			WasteTreatmentCode as WasteTreatmentCode 
		from WEB_FACILITYSEARCH_WASTETRANSFER 
		where WasteTypeCode like 'HW%'
	)m
	on w.FacilityReportID = m.FacilityReportID
	where ( 
		ConfidentialIndicatorHWIC = 1 
	or	QuantityTotalHWIC >= 0
	or	ConfidentialIndicatorHWOC = 1 
	or	QuantityTotalHWOC >= 0)
go


if object_id('EPRTRmaster.dbo.WEB_WASTETRANSFER_RECEIVINGCOUNTRY')is not null DROP view WEB_WASTETRANSFER_RECEIVINGCOUNTRY
go
create view WEB_WASTETRANSFER_RECEIVINGCOUNTRY
as 
select
	w.FacilityReportID,
	LTRIM(f.FacilityName) as FacilityName,
	f.FacilityID as FacilityID,
	f.ReportingYear as ReportingYear,
	tAT.QuantityRecovery as QuantityRecovery,
	tAT.QuantityDisposal as QuantityDisposal,
	tAT.QuantityUnspec as QuantityUnspec,
	tAT.QuantityTotal as QuantityTotal,
	rc.Code as ReceivingCountryCode,
	lu.Code as UnitCode,
	tAT.LOV_ConfidentialityID,
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
	case when 
			w.LOV_WasteTreatmentID = (select LOV_WasteTreatmentID from dbo.LOV_WASTETREATMENT where Code = 'R')
			then cast(1 as bit)
		else cast(0 as bit) end as HasReportedRecovery,
	case when 
			w.LOV_WasteTreatmentID = (select LOV_WasteTreatmentID from dbo.LOV_WASTETREATMENT where Code = 'D')
			then cast(1 as bit)
		else cast(0 as bit)  end as HasReportedDisposal,
	case when 
			w.LOV_WasteTreatmentID is null
			then cast(1 as bit)
		else cast(0 as bit)  end as HasReportedUnspecified,
	tAT.ConfidentialIndicator as ConfidentialIndicator,
	f.ConfidentialIndicator as ConfidentialIndicatorFacility
from 
	WASTETRANSFER w
inner join tAT_WASTETRANSFER_RECEIVINGCOUNTRY tAT
on	tAT.WasteTransferID = w.WasteTransferID
inner join
	tAT_FACILITYSEARCH f
on	f.FacilityReportID = w.FacilityReportID
left outer join
	LOV_COUNTRY rc
on  rc.LOV_CountryID = tAT.LOV_ReceivingCountryID
left outer join
	LOV_UNIT lu
on	lu.LOV_UnitID = tAT.LOV_UnitID	
go
	
--select * from WEB_WASTETRANSFER_RECEIVINGCOUNTRY order by 1


if object_id('EPRTRmaster.dbo.[WEB_WASTETRANSFER_HAZARDOUSTREATERS]')is not null DROP view [WEB_WASTETRANSFER_HAZARDOUSTREATERS]
go
create view [dbo].[WEB_WASTETRANSFER_HAZARDOUSTREATERS]
as 
select distinct
	wt.FacilityReportID as FacilityReportID,
	f.FacilityName as FacilityName, 
	f.FacilityID as FacilityID, 
	f.ReportingYear as ReportingYear, 
	whp.WasteHandlerPartyName as WHPName,
	whp.[Address] as WHPAddress,
	whp.City as WHPCity,
	whp.PostalCode as WHPPostalCode,
	whp.CountryCode as WHPCountryCode,
	whp.SiteAddress as WHPSiteAddress,
	whp.SiteCity as WHPSiteCity,
	whp.SitePostalCode as WHPSitePostalCode,
	whp.SiteCountryCode as WHPSiteCountryCode,
	sum (wt.Quantity) as Quantity, 
	lu.Code as UnitCode,
	lwtr.Code as WasteTreatmentCode,
	COUNT(*) as NumberOfReports,
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
	cfi.Code as ConfidentialCode,
	cfi.LOV_ConfidentialityID as LOV_ConfidentialityID,	
	wt.ConfidentialIndicator as ConfidentialIndicator,
	f.ConfidentialIndicator as ConfidentialIndicatorFacility
FROM vAT_WASTETRANSFER wt
inner join 
	LOV_WASTETYPE lwty
on  lwty.LOV_WasteTypeID = wt.LOV_WasteTypeID
and lwty.Code = 'HWOC'
inner join
	LOV_UNIT lu 
on  lu.LOV_UnitID = wt.LOV_QuantityUnitID
inner join
	tAT_FACILITYSEARCH f
on	f.FacilityReportID = wt.FacilityReportID
left outer join
	LOV_WASTETREATMENT lwtr
on	lwtr.LOV_WasteTreatmentID = wt.LOV_WasteTreatmentID
left outer join
	LOV_CONFIDENTIALITY cfi
on cfi.LOV_ConfidentialityID = wt.LOV_ConfidentialityID
left outer join (
	select 
		wh.WasteHandlerPartyID,
		wh.Name as WasteHandlerPartyName,
		RTRIM(addr.StreetName + CASE 
			WHEN addr.BuildingNumber IS NULL THEN '' 
			ELSE ' ' + addr.BuildingNumber 
			END) as [Address],
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
group by
	wt.FacilityReportID,
	lwtr.Code,
	f.FacilityName, 
	f.FacilityID, 
	f.ConfidentialIndicator,
	f.ReportingYear, 
	whp.WasteHandlerPartyName,
	whp.[Address],
	whp.City,
	whp.PostalCode,
	whp.CountryCode,
	whp.SiteAddress,
	whp.SiteCity,
	whp.SitePostalCode,
	whp.SiteCountryCode,
	lu.Code,
	wt.ConfidentialIndicator,
	cfi.Code,
	cfi.LOV_ConfidentialityID,
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
	f.LOV_NACESubActivityID
go

--select * from [dbo].[WEB_WASTETRANSFER_HAZARDOUSTREATERS] order by Quantity


if object_id('EPRTRmaster.dbo.WEB_WASTETRANSFER_CONFIDENTIAL')is not null DROP view WEB_WASTETRANSFER_CONFIDENTIAL
go
create view WEB_WASTETRANSFER_CONFIDENTIAL
as
select
	w.FacilityReportID as FacilityReportID,
	w.LOV_WasteTypeID as LOV_WasteTypeID,
	wy.Code as WasteTypeCode,
	lc.LOV_ConfidentialityID as LOV_ConfidentialityID,
	lc.Code as ConfidentialCode,
	cast (case when w.Quantity is null then 1 else 0 end
		 as bit) as ConfidentialityOnQuantity,
	cast (case when w.LOV_WasteTreatmentID is null then 1 else 0 end
		 as bit) as ConfidentialityOnTreatmant,
	cast (case 
			when wy.Code != 'HWOC' then null
			when wy.Code = 'HWOC'  and w.WasteHandlerPartyID is null then 1 
			else 0 end
		 as bit) as ConfidentialityOnReceivingCountry,
    f.ReportingYear as ReportingYear,
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
	case when 
			w.LOV_WasteTreatmentID = (select LOV_WasteTreatmentID from dbo.LOV_WASTETREATMENT where Code = 'R')
			then cast(1 as bit)
		else cast(0 as bit) end as HasReportedRecovery,
	case when 
			w.LOV_WasteTreatmentID = (select LOV_WasteTreatmentID from dbo.LOV_WASTETREATMENT where Code = 'D')
			then cast(1 as bit)
		else cast(0 as bit) end as HasReportedDisposal,
	case when 
			w.LOV_WasteTreatmentID is null
			then cast(1 as bit)
		else cast(0 as bit) end as HasReportedUnspecified
from 
	vAT_WASTETRANSFER w
inner join 
	LOV_WASTETYPE wy
on	wy.LOV_WasteTypeID = w.LOV_WasteTypeID
inner join
	tAT_FACILITYSEARCH f
on	f.FacilityReportID = w.FacilityReportID
inner join
	LOV_CONFIDENTIALITY lc
on	lc.LOV_ConfidentialityID = w.LOV_ConfidentialityID
where w.ConfidentialIndicator = 1
go

