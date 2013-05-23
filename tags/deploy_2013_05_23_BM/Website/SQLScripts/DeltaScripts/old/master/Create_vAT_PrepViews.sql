USE EPRTRmaster
go

------------------------------------------------------------------------------------------------
--	The parent inheritance of table LOV_ANNEXIACTIVITY gets rolled out in one level
------------------------------------------------------------------------------------------------

if object_id('EPRTRmaster.dbo.vAT_ANNEXIACTIVITY')is not null DROP view vAT_ANNEXIACTIVITY
go
create view dbo.vAT_ANNEXIACTIVITY (
	LOV_AnnexIActivityID, 
	SectorName,
	SectorCode,
	SectorIPPCCode,
	ActivityName, 
	ActivityCode,
	ActivityIPPCCode,
	SubActivityName, 
	SubActivityCode,
	SubActivityIPPCCode,
	LOV_SectorID,
	LOV_ActivityID,
	LOV_SubActivityID
) WITH SCHEMABINDING
as
select 
	a1.LOV_AnnexIActivityID, 
	a1.Name,
	a1.Code,
	a1.IPPCCode,
	a2.Name,
	a2.Code,
	a2.IPPCCode,
	a3.Name,
	a3.Code,
	a3.IPPCCode,
	a1.LOV_AnnexIActivityID,
	a2.LOV_AnnexIActivityID,
	a3.LOV_AnnexIActivityID
from dbo.LOV_ANNEXIACTIVITY a1
left outer join 
	dbo.LOV_ANNEXIACTIVITY a2
on	a1.ParentID = a2.LOV_AnnexIActivityID
left outer join 
	dbo.LOV_ANNEXIACTIVITY a3
on a2.ParentID = a3.LOV_AnnexIActivityID
where a3.Name is null
and a2.Name is null
union all
select 
	a1.LOV_AnnexIActivityID, 
	a2.Name,
	a2.Code,
	a2.IPPCCode,
	a1.Name,
	a1.Code,
	a1.IPPCCode,
	a3.Name,
	a3.Code,
	a3.IPPCCode,
	a2.LOV_AnnexIActivityID,
	a1.LOV_AnnexIActivityID,
	a3.LOV_AnnexIActivityID
from dbo.LOV_ANNEXIACTIVITY a1
left outer join 
	dbo.LOV_ANNEXIACTIVITY a2
on a1.ParentID = a2.LOV_AnnexIActivityID
left outer join 
	dbo.LOV_ANNEXIACTIVITY a3
on	a2.ParentID = a3.LOV_AnnexIActivityID
where a3.Name is null
and a2.Name is not null
union all
select 
	a1.LOV_AnnexIActivityID, 
	a3.Name,
	a3.Code,
	a3.IPPCCode,
	a2.Name,
	a2.Code,
	a2.IPPCCode,
	a1.Name,
	a1.Code,
	a1.IPPCCode,
	a3.LOV_AnnexIActivityID,
	a2.LOV_AnnexIActivityID,
	a1.LOV_AnnexIActivityID
from dbo.LOV_ANNEXIACTIVITY a1
inner join 
	dbo.LOV_ANNEXIACTIVITY a2
on a1.ParentID = a2.LOV_AnnexIActivityID
inner join 
	dbo.LOV_ANNEXIACTIVITY a3
on	a2.ParentID = a3.LOV_AnnexIActivityID
go

--select * from vAT_ANNEXIACTIVITY


------------------------------------------------------------------------------------------------
--	The parent inheritance of table LOV_NUTSREGION gets rolled out in one level
------------------------------------------------------------------------------------------------

if object_id('EPRTRmaster.dbo.vAT_NUTSREGION')is not null DROP view vAT_NUTSREGION
go
create view dbo.vAT_NUTSREGION WITH SCHEMABINDING
as
select
	m.LOV_NUTSRegionID as LOV_NUTSRegionID, 
	country.Code as CountryCode,
	m.L1N as L1Name,
	m.L1C as L1Code,
	m.L2N as L2Name,
	m.L2C as L2Code,
	m.L3N as L3Name,
	m.L3C as L3Code,
	m.LOV_NutsL1ID,
	m.LOV_NutsL2ID,
	m.LOV_NutsL3ID
from
	dbo.LOV_COUNTRY country
inner join(
	select 
		a1.LOV_NUTSRegionID,
		a1.LOV_CountryID, 
		a1.Name as L1N,
		a1.Code as L1C,
		a2.Name as L2N,
		a2.Code as L2C,
		a3.Name as L3N,
		a3.Code as L3C,
		a1.LOV_NUTSRegionID as LOV_NutsL1ID,
		a2.LOV_NUTSRegionID as LOV_NutsL2ID,
		a3.LOV_NUTSRegionID as LOV_NutsL3ID
	from dbo.LOV_NUTSREGION a1
	left outer join 
		dbo.LOV_NUTSREGION a2
	on	a1.ParentID = a2.LOV_NUTSRegionID
	left outer join 
		dbo.LOV_NUTSREGION a3
	on a2.ParentID = a3.LOV_NUTSRegionID
	where a3.Name is null
	and a2.Name is null
	union all
	select 
		a1.LOV_NUTSRegionID, 
		a1.LOV_CountryID, 
		a2.Name as L1N,
		a2.Code as L1C,
		a1.Name as L2N,
		a1.Code as L2C,
		a3.Name as L3N,
		a3.Code as L3C,
		a2.LOV_NUTSRegionID as LOV_NutsL1ID,
		a1.LOV_NUTSRegionID as LOV_NutsL2ID,
		a3.LOV_NUTSRegionID as LOV_NutsL3ID
	from dbo.LOV_NUTSREGION a1
	left outer join 
		dbo.LOV_NUTSREGION a2
	on a1.ParentID = a2.LOV_NUTSRegionID
	left outer join 
		dbo.LOV_NUTSREGION a3
	on	a2.ParentID = a3.LOV_NUTSRegionID
	where a3.Name is null
	and a2.Name is not null
	union all
	select 
		a1.LOV_NUTSRegionID, 
		a1.LOV_CountryID, 
		a3.Name as L1N,
		a3.Code as L1C,
		a2.Name as L2N,
		a2.Code as L2C,
		a1.Name as L3N,
		a1.Code as L3C,
		a3.LOV_NUTSRegionID as LOV_NutsL1ID,
		a2.LOV_NUTSRegionID as LOV_NutsL2ID,
		a1.LOV_NUTSRegionID as LOV_NutsL3ID
	from dbo.LOV_NUTSREGION a1
	inner join 
		dbo.LOV_NUTSREGION a2
	on a1.ParentID = a2.LOV_NUTSRegionID
	inner join 
		dbo.LOV_NUTSREGION a3
	on	a2.ParentID = a3.LOV_NUTSRegionID
)m
on m.LOV_CountryID = country.LOV_CountryID
go

--select * from vAT_NUTSREGION where CountryCode = 'AT'
  

------------------------------------------------------------------------------------------------
--	The inheritance of table LOV_NACEACTIVITY is rolled out in one row
------------------------------------------------------------------------------------------------

if object_id('EPRTRmaster.dbo.vAT_NACEACTIVITY')is not null DROP view vAT_NACEACTIVITY
go
create view dbo.vAT_NACEACTIVITY (
	LOV_NACEActivityID, 
	SectorName,
	SectorCode,
	ActivityName, 
	ActivityCode,
	SubActivityName, 
	SubActivityCode,
	LOV_SectorID,
	LOV_ActivityID,
	LOV_SubActivityID
) WITH SCHEMABINDING
as
select 
	a1.LOV_NACEActivityID,
	a1.Name,
	a1.Code,
	a2.Name,
	a2.Code,
	a3.Name,
	a3.Code,
	a1.LOV_NACEActivityID,
	a2.LOV_NACEActivityID,
	a3.LOV_NACEActivityID
from dbo.LOV_NACEACTIVITY a1
left outer join 
	dbo.LOV_NACEACTIVITY a2
on	a1.ParentID = a2.LOV_NACEActivityID
left outer join 
	dbo.LOV_NACEACTIVITY a3
on a2.ParentID = a3.LOV_NACEActivityID
where a3.Name is null
and a2.Name is null
union all
select 
	a1.LOV_NACEActivityID, 
	a2.Name,
	a2.Code,
	a1.Name,
	a1.Code,
	a3.Name,
	a3.Code,
	a2.LOV_NACEActivityID,
	a1.LOV_NACEActivityID,
	a3.LOV_NACEActivityID
from dbo.LOV_NACEACTIVITY a1
left outer join 
	dbo.LOV_NACEACTIVITY a2
on a1.ParentID = a2.LOV_NACEActivityID
left outer join 
	dbo.LOV_NACEACTIVITY a3
on	a2.ParentID = a3.LOV_NACEActivityID
where a3.Name is null
and a2.Name is not null
union all
select 
	a1.LOV_NACEActivityID, 
	a3.Name,
	a3.Code,
	a2.Name,
	a2.Code,
	a1.Name,
	a1.Code,
	a3.LOV_NACEActivityID,
	a2.LOV_NACEActivityID,
	a1.LOV_NACEActivityID
from dbo.LOV_NACEACTIVITY a1
inner join 
	dbo.LOV_NACEACTIVITY a2
on a1.ParentID = a2.LOV_NACEActivityID
inner join 
	dbo.LOV_NACEACTIVITY a3
on	a2.ParentID = a3.LOV_NACEActivityID
go

--select * from vAT_NACEACTIVITY order by 1


------------------------------------------------------------------------------------------------
--	The inheritance of table LOV_POLLUTANT is rolled out. Only the first and the buttom level 
--	are reportet (this is done i order to remove the subgroup BTEX from the overview)
------------------------------------------------------------------------------------------------
---10.feb.2010 (hollemar) BTEX is now included in the view. Leaving out BTEX meant that
---                       that these pollutanttransfer weren't copied to the public and
---						  review database and left the pollutant code blank in the Access
---						  database
		
if object_id('EPRTRmaster.dbo.vAT_POLLUTANT')is not null DROP view vAT_POLLUTANT
go
create view [dbo].[vAT_POLLUTANT] 
as
select													-- all elements without children
	lp.LOV_PollutantID as LOV_PollutantID, 
	lp.Code as PollutantCode,
	lp.Name as PollutantName, 
	lp.CAS as CAS,
	lpp.Code as PollutantGroupCode,
	lpp.Name as PollutantGroupName,
	lp.LOV_PollutantID as LOV_ID,
	lpp.LOV_PollutantID as LOV_GroupID
from
	LOV_POLLUTANT lp
inner join
	LOV_POLLUTANT lpp
on lp.ParentID = lpp.LOV_PollutantID
and	lpp.ParentID is null								-- get ParentID if ParentID is Group
where lp.LOV_PollutantID not in (
	select distinct p1.ParentID
	from LOV_POLLUTANT p1
	where not p1.ParentID is null
)
union all
select													-- all BTEX elements without children
	lp.LOV_PollutantID as LOV_PollutantID, 
	lp.Code as PollutantCode,
	lp.Name as PollutantName, 
	lp.CAS as CAS,
	lppp.Code as PollutantGroupCode,
	lppp.Name as PollutantGroupName,
	lp.LOV_PollutantID as LOV_ID,
	lppp.LOV_PollutantID as LOV_GroupID
from
	LOV_POLLUTANT lp
inner join
	LOV_POLLUTANT lpp
on lp.ParentID = lpp.LOV_PollutantID
inner join
	LOV_POLLUTANT lppp
on lpp.ParentID = lppp.LOV_PollutantID
and	lppp.ParentID is null								-- get GrandParentID is exists
where lp.LOV_PollutantID not in (
	select distinct p1.ParentID
	from LOV_POLLUTANT p1
	where not p1.ParentID is null
)
union all
select													-- all elements without parents
	lp.LOV_PollutantID as LOV_PollutantID, 
	lp.Code as PollutantCode,
	lp.Name as PollutantName, 
	lp.CAS as CAS,
	lp.Code as PollutantGroupCode,
	lp.Name as PollutantGroupName,
	lp.LOV_PollutantID as LOV_ID,
	lp.LOV_PollutantID as LOV_GroupID
from
	LOV_POLLUTANT lp
where 
	lp.ParentID is null
union all													
select													-- BTEX special EPER value
	lp.LOV_PollutantID as LOV_PollutantID, 
	lp.Code as PollutantCode,
	lp.Name as PollutantName, 
	lp.CAS as CAS,
	lpp.Code as PollutantGroupCode,
	lpp.Name as PollutantGroupName,
	lp.LOV_PollutantID as LOV_ID,
	lpp.LOV_PollutantID as LOV_GroupID
from
	LOV_POLLUTANT lp
inner join
	LOV_POLLUTANT lpp
on lp.ParentID = lpp.LOV_PollutantID
and	lpp.ParentID is null								-- get ParentID if ParentID is Group
where lp.LOV_PollutantID=8
GO

--select * from vAT_POLLUTANT order by 1


------------------------------------------------------------------------------------------------
--	The view returns the newest instance of a facility report from
--	table POLLUTANTRELEASEANDTRANSFERREPORT. This instance will be used for the export
--	of data to the review database.
------------------------------------------------------------------------------------------------

if object_id('EPRTRmaster.dbo.vAT_POLLUTANTRELEASEANDTRANSFERREPORT')is not null DROP view vAT_POLLUTANTRELEASEANDTRANSFERREPORT
go
create view dbo.vAT_POLLUTANTRELEASEANDTRANSFERREPORT WITH SCHEMABINDING
as
select
	PollutantReleaseAndTransferReportID,
	prtr.ReportingYear,
	prtr.LOV_CountryID,
	LOV_CoordinateSystemID,
	RemarkText,
	CdrUrl,
	CdrUploaded,
	CdrReleased,
	ForReview,
	Published,
	ResubmitReason,
	prtr.LOV_StatusID
from 
	dbo.POLLUTANTRELEASEANDTRANSFERREPORT prtr
inner join (
	select distinct
		ReportingYear,
		LOV_CountryID,
		max(CdrReleased) as ReleasedDate
	from 
		dbo.POLLUTANTRELEASEANDTRANSFERREPORT prtr1
	group by 
		ReportingYear,
		LOV_CountryID
) m
on	m.LOV_CountryID = prtr.LOV_CountryID
and m.ReportingYear = prtr.ReportingYear
and m.ReleasedDate = prtr.CdrReleased
go

--select * from vAT_POLLUTANTRELEASEANDTRANSFERREPORT
	
		
------------------------------------------------------------------------------------------------
--	This view returns all columns and rows of table POLLUTANTRELEASE exeeding its threshold.
--	The value of column Total Quantity is validated against its respective threshold
--	and a pollutant is only reported when exeeding this threshold.
------------------------------------------------------------------------------------------------

if object_id('EPRTRmaster.dbo.vAT_POLLUTANTRELEASE')is not null DROP view vAT_POLLUTANTRELEASE
go
create view dbo.vAT_POLLUTANTRELEASE                    
as
select
	PollutantReleaseID,
	FacilityReportID,
	p.LOV_MediumID,
	p.LOV_PollutantID,
	LOV_MethodBasisID,
	MethodListID,
	p.TotalQuantity,
	LOV_TotalQuantityUnitID,
	p.AccidentalQuantity,
	LOV_AccidentalQuantityUnitID,
	ConfidentialIndicator,
	LOV_ConfidentialityID,
	RemarkText
from
	POLLUTANTRELEASE p
left outer join	
	LOV_POLLUTANTTHRESHOLD tq
on	p.LOV_PollutantID = tq.LOV_PollutantID
and	p.LOV_MediumID = tq.LOV_MediumID
where
	p.TotalQuantity >= isnull(tq.Threshold,0)
and	(
	( 	p.LOV_PollutantID in (
				(select LOV_PollutantID from LOV_POLLUTANT where Code = 'BENZENE'),
				(select LOV_PollutantID from LOV_POLLUTANT where Code = 'ETHYLBENZENE'),
				(select LOV_PollutantID from LOV_POLLUTANT where Code = 'TOLUENE'),
				(select LOV_PollutantID from LOV_POLLUTANT where Code = 'XYLENES')		
			)
			and p.LOV_MediumID in (
						(select LOV_MediumID from LOV_MEDIUM where Code = 'AIR')
			)
		)
	or	p.LOV_PollutantID not in (
			(select LOV_PollutantID from LOV_POLLUTANT where Code = 'BENZENE'),
			(select LOV_PollutantID from LOV_POLLUTANT where Code = 'ETHYLBENZENE'),
			(select LOV_PollutantID from LOV_POLLUTANT where Code = 'TOLUENE'),
			(select LOV_PollutantID from LOV_POLLUTANT where Code = 'XYLENES'),		
			(select LOV_PollutantID from LOV_POLLUTANT where Code = 'CO2 EXCL BIOMASS')		
		)
	)

union			-- ticket #879: special treshold validation for POLLUTANT
				-- code :CO2 EXCL BIOMASS added
select
	p.PollutantReleaseID,
	p.FacilityReportID,
	p.LOV_MediumID,
	p.LOV_PollutantID,
	p.LOV_MethodBasisID,
	p.MethodListID,
	p.TotalQuantity,
	p.LOV_TotalQuantityUnitID,
	p.AccidentalQuantity,
	p.LOV_AccidentalQuantityUnitID,
	p.ConfidentialIndicator,
	p.LOV_ConfidentialityID,
	p.RemarkText
from
	POLLUTANTRELEASE p
inner join 
	LOV_POLLUTANT lp
on  lp.LOV_PollutantID = p.LOV_PollutantID
and lp.Code = 'CO2 EXCL BIOMASS'
inner join
	POLLUTANTRELEASE p2
on	p2.FacilityReportID = p.FacilityReportID
inner join 
	LOV_POLLUTANT lp2
on  lp2.LOV_PollutantID = p2.LOV_PollutantID
and lp2.Code = 'CO2'
left outer join	
	LOV_POLLUTANTTHRESHOLD tq
on	p2.LOV_PollutantID = tq.LOV_PollutantID
and	p2.LOV_MediumID = tq.LOV_MediumID
where
	p2.TotalQuantity >= isnull(tq.Threshold,0)

union
select
	PollutantReleaseID,
	p.FacilityReportID,
	p.LOV_MediumID,
	p.LOV_PollutantID,
	LOV_MethodBasisID,
	MethodListID,
	p.TotalQuantity,
	LOV_TotalQuantityUnitID,
	p.AccidentalQuantity,
	LOV_AccidentalQuantityUnitID,
	ConfidentialIndicator,
	LOV_ConfidentialityID,
	RemarkText
from
	POLLUTANTRELEASE p
left outer join	
	LOV_POLLUTANTTHRESHOLD tq
on	tq.LOV_PollutantID = (select LOV_PollutantID from LOV_POLLUTANT where Code = 'BTEX')
and	p.LOV_MediumID = tq.LOV_MediumID
inner join (
	select distinct 
		p1.FacilityReportID as FacilityReportID,
		p1.LOV_MediumID as LOV_MediumID,
		SUM(p1.TotalQuantity) as TotalQuantity,
		SUM(p1.AccidentalQuantity) as AccidentalQuantity,
		COUNT(*) as ElementCount
	from
		POLLUTANTRELEASE p1
	left outer join	
		LOV_POLLUTANTTHRESHOLD tq
	on	p1.LOV_PollutantID = tq.LOV_PollutantID
	and	p1.LOV_MediumID = tq.LOV_MediumID
	where 
		p1.LOV_PollutantID in (
			(select LOV_PollutantID from LOV_POLLUTANT where Code = 'BENZENE'),
			(select LOV_PollutantID from LOV_POLLUTANT where Code = 'ETHYLBENZENE'),
			(select LOV_PollutantID from LOV_POLLUTANT where Code = 'TOLUENE'),
			(select LOV_PollutantID from LOV_POLLUTANT where Code = 'XYLENES')		
		)
	and p1.LOV_MediumID in (
			(select LOV_MediumID from LOV_MEDIUM where Code = 'LAND'), 
			(select LOV_MediumID from LOV_MEDIUM where Code = 'WATER')
		)
	group by 
		p1.FacilityReportID, p1.LOV_MediumID 
	)m
on	m.FacilityReportID = p.FacilityReportID
and m.LOV_MediumID = p.LOV_MediumID
where	
	m.TotalQuantity >= isnull(tq.Threshold,0)
and	(
		p.LOV_PollutantID in (
			(select LOV_PollutantID from LOV_POLLUTANT where Code = 'BENZENE'),
			(select LOV_PollutantID from LOV_POLLUTANT where Code = 'ETHYLBENZENE'),
			(select LOV_PollutantID from LOV_POLLUTANT where Code = 'TOLUENE'),
			(select LOV_PollutantID from LOV_POLLUTANT where Code = 'XYLENES')		
		)
	and p.LOV_MediumID in (
			(select LOV_MediumID from LOV_MEDIUM where Code = 'LAND'), 
			(select LOV_MediumID from LOV_MEDIUM where Code = 'WATER')
		)
)
go

--select * from vAT_POLLUTANTRELEASE where LOV_PollutantID in (89,90,91,92)order by 2


------------------------------------------------------------------------------------------------
--	The following view returns all valid columns and rows of table POLLUTANTTRANSFER. 
--	Every pollutant's quantity is validated against its respective threshold 
--	value and gets only reported when exeeding this threshold.
------------------------------------------------------------------------------------------------

if object_id('EPRTRmaster.dbo.vAT_POLLUTANTTRANSFER')is not null DROP view vAT_POLLUTANTTRANSFER
go
create view dbo.vAT_POLLUTANTTRANSFER
as
select
	PollutantTransferID,
	FacilityReportID,
	p.LOV_PollutantID,
	LOV_MethodBasisID,
	MethodListID,
	p.Quantity,
	LOV_QuantityUnitID,
	ConfidentialIndicator,
	LOV_ConfidentialityID,
	RemarkText
from
	POLLUTANTTRANSFER p
left outer join	
	LOV_POLLUTANTTHRESHOLD tq
on	p.LOV_PollutantID = tq.LOV_PollutantID
and tq.LOV_MediumID = (select LOV_MediumID from LOV_MEDIUM where Code = 'WASTEWATER')
where
	p.LOV_PollutantID not in (
		(select LOV_PollutantID from LOV_POLLUTANT where Code = 'BENZENE'),
		(select LOV_PollutantID from LOV_POLLUTANT where Code = 'ETHYLBENZENE'),
		(select LOV_PollutantID from LOV_POLLUTANT where Code = 'TOLUENE'),
		(select LOV_PollutantID from LOV_POLLUTANT where Code = 'XYLENES')		
	)
and
	p.Quantity >= isnull(tq.Threshold,0)
union
select
	PollutantTransferID,
	p.FacilityReportID,
	p.LOV_PollutantID,
	LOV_MethodBasisID,
	MethodListID,
	p.Quantity,
	LOV_QuantityUnitID,
	ConfidentialIndicator,
	LOV_ConfidentialityID,
	RemarkText
from
	POLLUTANTTRANSFER p
inner join	
	LOV_POLLUTANTTHRESHOLD tq
on	tq.LOV_PollutantID = (select LOV_PollutantID from LOV_POLLUTANT where Code = 'BTEX')
and tq.LOV_MediumID = (select LOV_MediumID from LOV_MEDIUM where Code = 'WASTEWATER')
inner join (
	select distinct 
		p1.FacilityReportID as FacilityReportID,
		SUM(p1.Quantity) as Quantity,
		COUNT(*) as ElementCount
	from
		POLLUTANTTRANSFER p1
	left outer join	
		LOV_POLLUTANTTHRESHOLD tq
	on	p1.LOV_PollutantID = tq.LOV_PollutantID
	and	tq.LOV_MediumID = (select LOV_MediumID from LOV_MEDIUM where Code = 'WASTEWATER') 
	where 
		p1.LOV_PollutantID in (
			(select LOV_PollutantID from LOV_POLLUTANT where Code = 'BENZENE'),
			(select LOV_PollutantID from LOV_POLLUTANT where Code = 'ETHYLBENZENE'),
			(select LOV_PollutantID from LOV_POLLUTANT where Code = 'TOLUENE'),
			(select LOV_PollutantID from LOV_POLLUTANT where Code = 'XYLENES')		
		)
	group by 
		p1.FacilityReportID
	)m
on	m.FacilityReportID = p.FacilityReportID
where
	p.LOV_PollutantID in (
		(select LOV_PollutantID from LOV_POLLUTANT where Code = 'BENZENE'),
		(select LOV_PollutantID from LOV_POLLUTANT where Code = 'ETHYLBENZENE'),
		(select LOV_PollutantID from LOV_POLLUTANT where Code = 'TOLUENE'),
		(select LOV_PollutantID from LOV_POLLUTANT where Code = 'XYLENES')		
	)
and
	p.Quantity >= isnull(tq.Threshold,0)
go

--select * from vAT_POLLUTANTTRANSFER where LOV_PollutantID in (89,90,91,92) order by 2


------------------------------------------------------------------------------------------------
--	The following view returns rows of table WASTETRANSFER that are exeeding the threshold.
--	The value of column Quantity is validated against the respective threshold values for 
--	hazardous and non-hazardous waste. Has a facility reported more than one hazardous waste, 
--	then the sum of these reports is computed and validated against the threshold. 
--	Facilities only get selected when the sum exceeds the threshold or if 
--	there is reportet confidentiality 
------------------------------------------------------------------------------------------------

if object_id('EPRTRmaster.dbo.vAT_WASTETRANSFER')is not null DROP view vAT_WASTETRANSFER
go
create view dbo.vAT_WASTETRANSFER
as
select 
	WasteTransferID,
	FacilityReportID,
	w.LOV_WasteTypeID,
	LOV_WasteTreatmentID,
	LOV_MethodBasisID,
	MethodListID,
	--isnull(Quantity,0) as Quantity,
	Quantity,
	LOV_QuantityUnitID,
	WasteHandlerPartyID,
	ConfidentialIndicator,
	LOV_ConfidentialityID,
	RemarkText
from 
WASTETRANSFER w
where
	w.ConfidentialIndicator = 1
union
select 
	WasteTransferID,
	w.FacilityReportID,
	w.LOV_WasteTypeID,
	LOV_WasteTreatmentID,
	LOV_MethodBasisID,
	MethodListID,
	w.Quantity,
	LOV_QuantityUnitID,
	WasteHandlerPartyID,
	ConfidentialIndicator,
	LOV_ConfidentialityID,
	RemarkText
from 
WASTETRANSFER w
inner join
	LOV_WASTETHRESHOLD wt
on	w.LOV_WasteTypeID = wt.LOV_WasteTypeID
inner join (
	select distinct 
	FacilityReportID,
	sum(Quantity) as Quantity,
	count(*) as ElementCount
	from WASTETRANSFER
	where
		LOV_WasteTypeID = (select LOV_WasteTypeID from LOV_WASTETYPE where Code = 'NON-HW')
	group by FacilityReportID
) m
on m.FacilityReportID = w.FacilityReportID
where
	m.Quantity >= isnull(wt.Threshold,0)
and	w.ConfidentialIndicator = 0
union
select 
	WasteTransferID,
	w.FacilityReportID,
	w.LOV_WasteTypeID,
	LOV_WasteTreatmentID,
	LOV_MethodBasisID,
	MethodListID,
	w.Quantity,
	LOV_QuantityUnitID,
	WasteHandlerPartyID,
	w.ConfidentialIndicator,
	LOV_ConfidentialityID,
	RemarkText
from 
WASTETRANSFER w
inner join
	LOV_WASTETHRESHOLD wt
on	wt.LOV_WasteTypeID = (select LOV_WasteTypeID from LOV_WASTETYPE where Code = 'HW')
and
	w.LOV_WasteTypeID in (
		(select LOV_WasteTypeID from LOV_WASTETYPE where Code = 'HWIC'),
		(select LOV_WasteTypeID from LOV_WASTETYPE where Code = 'HWOC')
	)
inner join (
	select distinct 
	FacilityReportID,
	sum(Quantity) as Quantity,
	max(cast(ConfidentialIndicator as int)) as ConfidentialIndicator,
	count(*) as ElementCount
	from WASTETRANSFER
	where
		LOV_WasteTypeID in (
			(select LOV_WasteTypeID from LOV_WASTETYPE where Code = 'HWIC'),
			(select LOV_WasteTypeID from LOV_WASTETYPE where Code = 'HWOC')
		)
	group by FacilityReportID
) m
on m.FacilityReportID = w.FacilityReportID
where (  
	m.Quantity >= isnull(wt.Threshold,0)
or	m.ConfidentialIndicator = 1)
and	w.ConfidentialIndicator = 0
go

--select * from vAT_WASTETRANSFER where Quantity is null
