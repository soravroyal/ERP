--------------------------------------------------------------------------------
--
--	Delta script used to concatenate different designations and method codes
--	reffered to by MethodListID
--
--	WOS, Atkins 0202211
--	MethodCodeAir/Water/Soil added to table wos-060711
--
--------------------------------------------------------------------------------


USE [EPRTRmaster]
GO

--------------------------------------------------------------------------------
--	adjusting the data structure
--------------------------------------------------------------------------------

if object_id('EPRTRmaster.dbo.tAT_ACTIVITYSEARCH_POLLUTANTRELEASE') is not null 
	drop table [dbo].[tAT_ACTIVITYSEARCH_POLLUTANTRELEASE]
go
CREATE TABLE [dbo].[tAT_ACTIVITYSEARCH_POLLUTANTRELEASE](
	[FacilityReportID] [int] NULL,
	[LOV_PollutantID] [int] NULL,
	[PrID1] [int] NULL,
	[PrID2] [int] NULL,
	[PrID3] [int] NULL,
	[QuantityAir] [float] NULL,
	[QuantityAccidentalAir] [float] NULL,
	[QuantityWater] [float] NULL,
	[QuantityAccidentalWater] [float] NULL,
	[QuantitySoil] [float] NULL,
	[QuantityAccidentalSoil] [float] NULL,
	[UnitAir] [nvarchar](255) NULL,
	[UnitAccidentalAir] [nvarchar](255) NULL,
	[UnitWater] [nvarchar](255) NULL,
	[UnitAccidentalWater] [nvarchar](255) NULL,
	[UnitSoil] [nvarchar](255) NULL,
	[UnitAccidentalSoil] [nvarchar](255) NULL,
	[ConfidentialIndicator] [bit] NOT NULL,
	[LOV_ConfidentialityIDAir] [int] NULL,
	[LOV_ConfidentialityIDWater] [int] NULL,
	[LOV_ConfidentialityIDSoil] [int] NULL,
	[MethodListIDAir] [int] NULL,
	[MethodListIDWater] [int] NULL,
	[MethodListIDSoil] [int] NULL,
	[MethodCodeAir] [nvarchar](255) NULL,
	[MethodCodeWater] [nvarchar](255) NULL,
	[MethodCodeSoil] [nvarchar](255) NULL
) ON [PRIMARY]
go

if object_id('EPRTRmaster.dbo.tAT_METHOD')is not null 
	DROP TABLE EPRTRmaster.dbo.tAT_METHOD
go
CREATE TABLE EPRTRmaster.dbo.tAT_METHOD(
	[MethodID] [int] IDENTITY(1,1) NOT NULL,
	[MethodListID] [int] NOT NULL,
	[MethodCode] [nvarchar](255) NULL,
	[MethodDesignation] [nvarchar](4000) NULL,
CONSTRAINT [MethodID] PRIMARY KEY CLUSTERED ([MethodID] ASC)) ON [PRIMARY]
go
 

--------------------------------------------------------------------------------
--	add insert values to existing SP
--------------------------------------------------------------------------------

if object_id('EPRTRmaster.dbo.pAT_ACTIVITYSEARCH_POLLUTANTRELEASE')is not null 
	DROP procedure pAT_ACTIVITYSEARCH_POLLUTANTRELEASE
go
create procedure dbo.pAT_ACTIVITYSEARCH_POLLUTANTRELEASE
as 
begin
	insert into tAT_ACTIVITYSEARCH_POLLUTANTRELEASE (FacilityReportID,LOV_PollutantID,
		UnitAccidentalAir,UnitAccidentalWater,UnitAccidentalSoil,ConfidentialIndicator)
	select distinct 
		fr.FacilityReportID,
		LOV_PollutantID,
		'KGM','KGM','KGM',0
	from vAT_POLLUTANTRELEASE pol
	inner join FACILITYREPORT fr
	on pol.FacilityReportID = fr.FacilityReportID
	inner join vAT_POLLUTANTRELEASEANDTRANSFERREPORT prtr
	on prtr.PollutantReleaseAndTransferReportID = fr.PollutantReleaseAndTransferReportID
	 
	update tAT_ACTIVITYSEARCH_POLLUTANTRELEASE
	set
		PrID1 = pr.PollutantReleaseID,
		QuantityAir = pr.TotalQuantity,
		QuantityAccidentalAir = pr.AccidentalQuantity,
		UnitAir = lut.Code,
		MethodListIDAir = pr.MethodListID,
		MethodCodeAir = lmb.Code,
		UnitAccidentalAir = case when lua.Code = 'UNKNOWN' then 'KGM' else lua.Code end,
		ConfidentialIndicator = case when tAT.ConfidentialIndicator = 1 then 1 else pr.ConfidentialIndicator end,
		LOV_ConfidentialityIDAir = pr.LOV_ConfidentialityID 
	from tAT_ACTIVITYSEARCH_POLLUTANTRELEASE tAT
	inner join vAT_POLLUTANTRELEASE pr
	on	tAT.FacilityReportID = pr.FacilityReportID
	and tAT.LOV_PollutantID = pr.LOV_PollutantID
	inner join
		LOV_MEDIUM lm
	on  lm.LOV_MediumID = pr.LOV_MediumID
	and lm.Code = 'AIR'
	inner join
		LOV_UNIT lut
	on	lut.LOV_UnitID = pr.LOV_TotalQuantityUnitID
	left outer join
		LOV_UNIT lua
	on	lua.LOV_UnitID = pr.LOV_AccidentalQuantityUnitID
	left outer join
	LOV_METHODBASIS lmb
	on	lmb.LOV_MethodBasisID = pr.LOV_MethodBasisID 

	update tAT_ACTIVITYSEARCH_POLLUTANTRELEASE
	set
		PrID2 = pr.PollutantReleaseID,
		QuantityWater = pr.TotalQuantity,
		QuantityAccidentalWater = pr.AccidentalQuantity,
		UnitWater = lut.Code,
		MethodListIDWater = pr.MethodListID,
		MethodCodeWater = lmb.Code,
		UnitAccidentalWater = case when lua.Code = 'UNKNOWN' then 'KGM' else lua.Code end, 
		ConfidentialIndicator = case when tAT.ConfidentialIndicator = 1 then 1 else pr.ConfidentialIndicator end,
		LOV_ConfidentialityIDWater = pr.LOV_ConfidentialityID 
	from tAT_ACTIVITYSEARCH_POLLUTANTRELEASE tAT
	inner join vAT_POLLUTANTRELEASE pr
	on	tAT.FacilityReportID = pr.FacilityReportID
	and tAT.LOV_PollutantID = pr.LOV_PollutantID
	inner join
		LOV_MEDIUM lm
	on  lm.LOV_MediumID = pr.LOV_MediumID
	and lm.Code = 'WATER'
	inner join
		LOV_UNIT lut
	on	lut.LOV_UnitID = pr.LOV_TotalQuantityUnitID
	left outer join
		LOV_UNIT lua
	on	lua.LOV_UnitID = pr.LOV_AccidentalQuantityUnitID
	left outer join
	LOV_METHODBASIS lmb
	on	lmb.LOV_MethodBasisID = pr.LOV_MethodBasisID 
	 	 
	update tAT_ACTIVITYSEARCH_POLLUTANTRELEASE
	set
		PrID3 = pr.PollutantReleaseID,
		QuantitySoil = pr.TotalQuantity,
		QuantityAccidentalSoil = pr.AccidentalQuantity,
		UnitSoil = lut.Code,
		MethodListIDSoil = pr.MethodListID,
		MethodCodeSoil = lmb.Code,
		UnitAccidentalSoil = case when lua.Code = 'UNKNOWN' then 'KGM' else lua.Code end,
		ConfidentialIndicator = case when tAT.ConfidentialIndicator = 1 then 1 else pr.ConfidentialIndicator end,
		LOV_ConfidentialityIDSoil = pr.LOV_ConfidentialityID 
	from tAT_ACTIVITYSEARCH_POLLUTANTRELEASE tAT
	inner join vAT_POLLUTANTRELEASE pr
	on	tAT.FacilityReportID = pr.FacilityReportID
	and tAT.LOV_PollutantID = pr.LOV_PollutantID
	inner join
		LOV_MEDIUM lm
	on  lm.LOV_MediumID = pr.LOV_MediumID
	and lm.Code = 'LAND'
	inner join
		LOV_UNIT lut
	on	lut.LOV_UnitID = pr.LOV_TotalQuantityUnitID
	left outer join
		LOV_UNIT lua
	on	lua.LOV_UnitID = pr.LOV_AccidentalQuantityUnitID	 
	left outer join
	LOV_METHODBASIS lmb
	on	lmb.LOV_MethodBasisID = pr.LOV_MethodBasisID 
end
go


------------------------------------------------------------------------------
--	help function and sp to generate
--	concatenated method designation and method type
------------------------------------------------------------------------------

if object_id('EPRTRmaster.dbo.fAT_GETMETHODDESIGNATION')is not null 
	DROP function [fAT_GETMETHODDESIGNATION] 
go
CREATE FUNCTION [dbo].[fAT_GETMETHODDESIGNATION] 
( 
    @mlID int   
) 
RETURNS NVARCHAR(4000) 
AS 
BEGIN 
    DECLARE @r VARCHAR(4000) 
    SELECT @r = ISNULL(@r+'|', '') + ISNULL(mu.MethodDesignation,'')
    FROM METHODUSED mu
    WHERE mu.MethodListID = @mlID 
    RETURN @r 
END 
GO

if object_id('EPRTRmaster.dbo.fAT_GETMETHODTYPE')is not null 
	DROP function [fAT_GETMETHODTYPE] 
go
CREATE FUNCTION [dbo].[fAT_GETMETHODTYPE]
( 
    @mlID int   
) 
RETURNS NVARCHAR(255) 
AS 
BEGIN 
    DECLARE @r VARCHAR(255) 
    SELECT @r = ISNULL(@r+'|', '') + ISNULL(lov.Code,'')
    FROM METHODUSED mu
    inner join LOV_METHODTYPE lov
	on mu.LOV_MethodTypeID = lov.LOV_MethodTypeID        
	WHERE mu.MethodListID = @mlID 
    RETURN @r 
END 
GO

if object_id('EPRTRmaster.dbo.pAT_METHOD')is not null 
	DROP procedure [pAT_METHOD]
go
create procedure [dbo].[pAT_METHOD]
as 
begin

	truncate table EPRTRmaster.dbo.tAT_METHOD
	 
	insert into EPRTRmaster.dbo.tAT_METHOD (MethodListID,MethodCode,MethodDesignation)
	select
		mu.MethodListID,
		lov.Code,
		mu.MethodDesignation
	from METHODUSED mu
	inner join LOV_METHODTYPE lov
	on mu.LOV_MethodTypeID = lov.LOV_MethodTypeID
	where mu.MethodListID in (
		select mu.MethodListID from METHODUSED mu
		group by mu.MethodListID
		having COUNT(mu.MethodListID) = 1
		)

	insert into EPRTRmaster.dbo.tAT_METHOD (MethodListID,MethodCode,MethodDesignation)
	select
		MethodListID, 
		EPRTRmaster.dbo.fAT_GETMETHODTYPE(MethodListID),
		EPRTRmaster.dbo.fAT_GETMETHODDESIGNATION(MethodListID)
	from(
			select mu.MethodListID from METHODUSED mu
			group by mu.MethodListID
			having COUNT(mu.MethodListID) > 1
	)i
end
GO


------------------------------------------------------------------------------
--		create View WEB_POLLUTANTTRANSFER
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
	meth.MethodDesignation as MethodTypeDesignation, 
	meth.MethodCode as MethodTypeCode, 
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
left outer join 
	tAT_METHOD meth
on	meth.MethodListID = pt.MethodListID
go


------------------------------------------------------------------------------
--		create View WEB_POLLUTANTRELEASE
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
	meA.MethodDesignation as MethodTypeDesignationAir, 	
	meA.MethodCode as MethodTypeCodeAir, 
	tAT.MethodCodeAir as MethodCodeAir,  
	tAT.QuantityWater,
	tAT.QuantityAccidentalWater,
	case when tAT.QuantityWater > 0 then tAT.QuantityAccidentalWater/tAT.QuantityWater * 100 else 0 end as PercentAccidentalWater,
	meW.MethodDesignation as MethodTypeDesignationWater, 
	meW.MethodCode as MethodTypeCodeWater,
	tAT.MethodCodeWater as MethodCodeWater,  
	tAT.QuantitySoil,
	tAT.QuantityAccidentalSoil,
	case when tAT.QuantitySoil > 0 then tAT.QuantityAccidentalSoil/tAT.QuantitySoil * 100 else 0 end as PercentAccidentalSoil,
	meS.MethodDesignation as MethodTypeDesignationSoil, 
	meS.MethodCode as MethodTypeCodeSoil, 
	tAT.MethodCodeSoil as MethodCodeSoil,  
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
left outer join 
	tAT_METHOD meA
on	meA.MethodListID = tAT.MethodListIDAir
left outer join 
	tAT_METHOD meW
on	meW.MethodListID = tAT.MethodListIDWater
left outer join 
	tAT_METHOD meS
on	meS.MethodListID = tAT.MethodListIDSoil




