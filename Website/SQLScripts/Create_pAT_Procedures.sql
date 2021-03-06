USE [EPRTRmaster]
go

------------------------------------------------------------------------------
--		Collect confidentialities for facility-report
------------------------------------------------------------------------------

if object_id('EPRTRmaster.dbo.pAT_CONFIDENTIALITY')is not null DROP procedure pAT_CONFIDENTIALITY
go
create procedure [dbo].pAT_CONFIDENTIALITY
as 
begin
	insert into tAT_CONFIDENTIALITY (FacilityReportID, ConfidentialIndicatorFacility)
	select
		FacilityReportID,
		ConfidentialIndicator
	from FACILITYREPORT
	 
	update tAT_CONFIDENTIALITY
	set
		ConfidentialIndicatorWaste = m.ConfidentialIndicatorWaste
	from tAT_CONFIDENTIALITY tAT
	inner join (
		select distinct 
			FacilityReportID, 
			cast (max(cast(ConfidentialIndicator as int)) as bit) as ConfidentialIndicatorWaste
		from vAT_WASTETRANSFER
		group by FacilityReportID	
		)m
	on	m.FacilityReportID = tAT.FacilityReportID
	
	update tAT_CONFIDENTIALITY
	set
		ConfidentialIndicatorPollutantTransfer = m.ConfidentialIndicatorPollutantTransfer
	from tAT_CONFIDENTIALITY tAT
	inner join (
		select distinct 
			FacilityReportID, 
			cast (max(cast(ConfidentialIndicator as int)) as bit) as ConfidentialIndicatorPollutantTransfer
		from vAT_POLLUTANTTRANSFER
		group by FacilityReportID	
		)m
	on	m.FacilityReportID = tAT.FacilityReportID
	
	update tAT_CONFIDENTIALITY
	set
		ConfidentialIndicatorPollutantRelease = m.ConfidentialIndicatorPollutantRelease
	from tAT_CONFIDENTIALITY tAT
	inner join (
		select distinct 
			FacilityReportID, 
			cast (max(cast(ConfidentialIndicator as int)) as bit) as ConfidentialIndicatorPollutantRelease
		from vAT_POLLUTANTRELEASE
		group by FacilityReportID	
		)m
	on	m.FacilityReportID = tAT.FacilityReportID
	
end
go

------------------------------------------------------------------------------
--		validate whether Quantity is above threshold
------------------------------------------------------------------------------

if object_id('EPRTRmaster.dbo.pAT_THRESHOLD')is not null drop procedure pAT_THRESHOLD
go
create procedure pAT_THRESHOLD
	@Quantity float,
	@PollutantID int,
	@MediumID int
as 
begin
	select ISNULL(
		(select 
			case 
				when Threshold > @Quantity then 0
				else @Quantity end
		from 
			LOV_POLLUTANTTHRESHOLD
		where 
			LOV_PollutantID = @PollutantID
		and	LOV_MediumID = @MediumID),
		@Quantity)
end
go

------------------------------------------------------------------------------
--		prepare facility sums for POLLUTANTRELEASE
------------------------------------------------------------------------------

if object_id('EPRTRmaster.dbo.pAT_ACTIVITYSEARCH_POLLUTANTRELEASE')is not null DROP procedure pAT_ACTIVITYSEARCH_POLLUTANTRELEASE
go
create procedure [dbo].[pAT_ACTIVITYSEARCH_POLLUTANTRELEASE]
as 
begin

	insert into tAT_ACTIVITYSEARCH_POLLUTANTRELEASE (FacilityReportID,LOV_PollutantID,
		UnitAccidentalAir,UnitAccidentalWater,UnitAccidentalSoil,ConfidentialIndicator)
	select distinct 
		FacilityReportID,
		LOV_PollutantID,
		'KGM','KGM','KGM',0
	from vAT_POLLUTANTRELEASE
	 
	update tAT_ACTIVITYSEARCH_POLLUTANTRELEASE
	set
		PrID1 = pr.PollutantReleaseID,
		QuantityAir = pr.TotalQuantity,
		QuantityAccidentalAir = pr.AccidentalQuantity,
		UnitAir = lut.Code,
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

	update tAT_ACTIVITYSEARCH_POLLUTANTRELEASE
	set
		PrID2 = pr.PollutantReleaseID,
		QuantityWater = pr.TotalQuantity,
		QuantityAccidentalWater = pr.AccidentalQuantity,
		UnitWater = lut.Code,
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
	 	 
	update tAT_ACTIVITYSEARCH_POLLUTANTRELEASE
	set
		PrID3 = pr.PollutantReleaseID,
		QuantitySoil = pr.TotalQuantity,
		QuantityAccidentalSoil = pr.AccidentalQuantity,
		UnitSoil = lut.Code,
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
end
go

------------------------------------------------------------------------------
--		prepare facility sums for WASTETRANSFER
------------------------------------------------------------------------------

if object_id('EPRTRmaster.dbo.pAT_WASTETRANSFER')is not null DROP procedure pAT_WASTETRANSFER
go
create procedure [dbo].[pAT_WASTETRANSFER]
as 
begin
	insert into EPRTRmaster.dbo.tAT_WASTETRANSFER(
		FacilityReportID,
		ConfidentialIndicator,
		UnitCodeHWIC,
		UnitCodeHWOC,
		UnitCodeNONHW,
		HasReportedRecovery,
		HasReportedDisposal,
		HasReportedUnspecified
	)
	select distinct 
		w.FacilityReportID,
		cast(max(cast (w.ConfidentialIndicator as int))as bit),
		'TNE' as UnitCodeHWIC,
		'TNE' as UnitCodeHWOC,
		'TNE' as UnitCodeNONHW,
		0,
		0,
		0
	from WASTETRANSFER w
	inner join
		FACILITYREPORT frep
	on frep.FacilityReportID = w.FacilityReportID
	inner join
		vAT_POLLUTANTRELEASEANDTRANSFERREPORT prtr
	on  frep.PollutantReleaseAndTransferReportID = prtr.PollutantReleaseAndTransferReportID
	and prtr.ReportingYear > 2000
	group by w.FacilityReportID


	------------------------------------------------------------------------------
	--	upload data for HWIC
	------------------------------------------------------------------------------

	update 
		EPRTRmaster.dbo.tAT_WASTETRANSFER
	set QuantityRecoveryHWIC = m.Quantity,
		ConfidentialIndicator_HWIC_R = m.CI,
		UnitCodeHWIC = u.Code,
		LOV_ConfidentialityIDHWIC = case when m.LOV_ConfidentialityIDHWIC > 0 
				then m.LOV_ConfidentialityIDHWIC end
	from 
		EPRTRmaster.dbo.tAT_WASTETRANSFER tw
	inner join (
		select 
			w.FacilityReportID as FacilityReportID,
			MAX(w.LOV_QuantityUnitID) as LOV_QuantityUnitID, 
			MAX(isnull(w.LOV_ConfidentialityID,0)) as LOV_ConfidentialityIDHWIC,
			MAX(cast (w.ConfidentialIndicator as int)) as CI,
			SUM(w.Quantity) as Quantity 
		from EPRTRmaster.dbo.tAT_WASTETRANSFER t
		inner join 
			vAT_WASTETRANSFER w
		on w.FacilityReportID = t.FacilityReportID
		inner join
			LOV_WASTETYPE wty
		on wty.LOV_WasteTypeID = w.LOV_WasteTypeID
		inner join
			LOV_WASTETREATMENT wtr
		on	wtr.LOV_WasteTreatmentID = w.LOV_WasteTreatmentID
		where 
			w.FacilityReportID = t.FacilityReportID
		and wtr.Code = 'R'
		and wty.Code = 'HWIC' 
		group by w.FacilityReportID
	)m
	on	m.FacilityReportID = tw.FacilityReportID 
	inner join
		LOV_UNIT u
	on u.LOV_UnitID = m.LOV_QuantityUnitID

	update 
		EPRTRmaster.dbo.tAT_WASTETRANSFER
	set QuantityDisposalHWIC = m.Quantity,
		ConfidentialIndicator_HWIC_D = m.CI,
		UnitCodeHWIC = u.Code,
		LOV_ConfidentialityIDHWIC = case when m.LOV_ConfidentialityIDHWIC > 0 
				then m.LOV_ConfidentialityIDHWIC end 
	from 
		EPRTRmaster.dbo.tAT_WASTETRANSFER tw
	inner join (
		select 
			w.FacilityReportID as FacilityReportID,
			MAX(w.LOV_QuantityUnitID) as LOV_QuantityUnitID, 
			MAX(isnull(w.LOV_ConfidentialityID,0)) as LOV_ConfidentialityIDHWIC,
			MAX(cast (w.ConfidentialIndicator as int)) as CI,
			SUM(w.Quantity) as Quantity 
		from EPRTRmaster.dbo.tAT_WASTETRANSFER t
		inner join 
			vAT_WASTETRANSFER w
		on w.FacilityReportID = t.FacilityReportID
		inner join
			LOV_WASTETYPE wty
		on wty.LOV_WasteTypeID = w.LOV_WasteTypeID
		inner join
			LOV_WASTETREATMENT wtr
		on	wtr.LOV_WasteTreatmentID = w.LOV_WasteTreatmentID
		where 
			w.FacilityReportID = t.FacilityReportID
		and wtr.Code = 'D'
		and wty.Code = 'HWIC' 
		group by w.FacilityReportID
	)m
	on	m.FacilityReportID = tw.FacilityReportID 
	inner join
		LOV_UNIT u
	on u.LOV_UnitID = m.LOV_QuantityUnitID

	update 
		EPRTRmaster.dbo.tAT_WASTETRANSFER
	set QuantityUnspecHWIC = m.Quantity,
		ConfidentialIndicator_HWIC_U = m.CI,
		UnitCodeHWIC = u.Code,
		LOV_ConfidentialityIDHWIC = case when m.LOV_ConfidentialityIDHWIC > 0 
				then m.LOV_ConfidentialityIDHWIC end 
	from 
		EPRTRmaster.dbo.tAT_WASTETRANSFER tw
	inner join (
		select 
			w.FacilityReportID as FacilityReportID,
			MAX(w.LOV_QuantityUnitID) as LOV_QuantityUnitID, 
			MAX(isnull(w.LOV_ConfidentialityID,0)) as LOV_ConfidentialityIDHWIC,
			MAX(cast (w.ConfidentialIndicator as int)) as CI,
			SUM(w.Quantity) as Quantity 
		from EPRTRmaster.dbo.tAT_WASTETRANSFER t
		inner join 
			vAT_WASTETRANSFER w
		on w.FacilityReportID = t.FacilityReportID
		inner join
			LOV_WASTETYPE wty
		on wty.LOV_WasteTypeID = w.LOV_WasteTypeID
		where 
			w.FacilityReportID = t.FacilityReportID
		and w.LOV_WasteTreatmentID is null
		and wty.Code = 'HWIC' 
		group by w.FacilityReportID
	)m
	on	m.FacilityReportID = tw.FacilityReportID 
	inner join
		LOV_UNIT u
	on u.LOV_UnitID = m.LOV_QuantityUnitID


	------------------------------------------------------------------------------
	--	upload data for HWOC
	------------------------------------------------------------------------------

	update 
		EPRTRmaster.dbo.tAT_WASTETRANSFER
	set QuantityRecoveryHWOC = m.Quantity,
		ConfidentialIndicator_HWOC_R = m.CI,
		UnitCodeHWOC = u.Code,
		LOV_ConfidentialityIDHWOC = case when m.LOV_ConfidentialityIDHWOC > 0 
			then m.LOV_ConfidentialityIDHWOC end 
	from 
		EPRTRmaster.dbo.tAT_WASTETRANSFER tw
	inner join (
		select 
			w.FacilityReportID as FacilityReportID,
			MAX(w.LOV_QuantityUnitID) as LOV_QuantityUnitID, 
			MAX(isnull(w.LOV_ConfidentialityID,0)) as LOV_ConfidentialityIDHWOC,
			MAX(cast (w.ConfidentialIndicator as int)) as CI,
			SUM(w.Quantity) as Quantity 
		from EPRTRmaster.dbo.tAT_WASTETRANSFER t
		inner join 
			vAT_WASTETRANSFER w
		on w.FacilityReportID = t.FacilityReportID
		inner join
			LOV_WASTETYPE wty
		on wty.LOV_WasteTypeID = w.LOV_WasteTypeID
		inner join
			LOV_WASTETREATMENT wtr
		on	wtr.LOV_WasteTreatmentID = w.LOV_WasteTreatmentID
		where 
			w.FacilityReportID = t.FacilityReportID
		and wtr.Code = 'R'
		and wty.Code = 'HWOC' 
		group by w.FacilityReportID
	)m
	on	m.FacilityReportID = tw.FacilityReportID 
	inner join
		LOV_UNIT u
	on u.LOV_UnitID = m.LOV_QuantityUnitID

	update 
		EPRTRmaster.dbo.tAT_WASTETRANSFER
	set QuantityDisposalHWOC = m.Quantity,
		ConfidentialIndicator_HWOC_D = m.CI,
		UnitCodeHWOC = u.Code,
		LOV_ConfidentialityIDHWOC = case when m.LOV_ConfidentialityIDHWOC > 0 
			then m.LOV_ConfidentialityIDHWOC end 
	from 
		EPRTRmaster.dbo.tAT_WASTETRANSFER tw
	inner join (
		select 
			w.FacilityReportID as FacilityReportID,
			MAX(w.LOV_QuantityUnitID) as LOV_QuantityUnitID, 
			MAX(isnull(w.LOV_ConfidentialityID,0)) as LOV_ConfidentialityIDHWOC,
			MAX(cast (w.ConfidentialIndicator as int)) as CI,
			SUM(w.Quantity) as Quantity 
		from EPRTRmaster.dbo.tAT_WASTETRANSFER t
		inner join 
			vAT_WASTETRANSFER w
		on w.FacilityReportID = t.FacilityReportID
		inner join
			LOV_WASTETYPE wty
		on wty.LOV_WasteTypeID = w.LOV_WasteTypeID
		inner join
			LOV_WASTETREATMENT wtr
		on	wtr.LOV_WasteTreatmentID = w.LOV_WasteTreatmentID
		where 
			w.FacilityReportID = t.FacilityReportID
		and wtr.Code = 'D'
		and wty.Code = 'HWOC' 
		group by w.FacilityReportID
	)m
	on	m.FacilityReportID = tw.FacilityReportID 
	inner join
		LOV_UNIT u
	on u.LOV_UnitID = m.LOV_QuantityUnitID

	update 
		EPRTRmaster.dbo.tAT_WASTETRANSFER
	set QuantityUnspecHWOC = m.Quantity,
		ConfidentialIndicator_HWOC_U = m.CI,
		UnitCodeHWOC = u.Code,
		LOV_ConfidentialityIDHWOC = case when m.LOV_ConfidentialityIDHWOC > 0 
			then m.LOV_ConfidentialityIDHWOC end 
	from 
		EPRTRmaster.dbo.tAT_WASTETRANSFER tw
	inner join (
		select 
			w.FacilityReportID as FacilityReportID,
			MAX(w.LOV_QuantityUnitID) as LOV_QuantityUnitID, 
			MAX(isnull(w.LOV_ConfidentialityID,0)) as LOV_ConfidentialityIDHWOC,
			MAX(cast (w.ConfidentialIndicator as int)) as CI,
			SUM(w.Quantity) as Quantity 
		from EPRTRmaster.dbo.tAT_WASTETRANSFER t
		inner join 
			vAT_WASTETRANSFER w
		on w.FacilityReportID = t.FacilityReportID
		inner join
			LOV_WASTETYPE wty
		on wty.LOV_WasteTypeID = w.LOV_WasteTypeID
		where 
			w.FacilityReportID = t.FacilityReportID
		and w.LOV_WasteTreatmentID is null
		and wty.Code = 'HWOC' 
		group by w.FacilityReportID
	)m
	on	m.FacilityReportID = tw.FacilityReportID 
	inner join
		LOV_UNIT u
	on u.LOV_UnitID = m.LOV_QuantityUnitID


	------------------------------------------------------------------------------
	--	upload data for non HW
	------------------------------------------------------------------------------

	update 
		EPRTRmaster.dbo.tAT_WASTETRANSFER
	set QuantityRecoveryNONHW = m.Quantity,
		ConfidentialIndicator_NONHW_R = m.CI,
		UnitCodeNONHW = u.Code,
		LOV_ConfidentialityIDNONHW = case when m.LOV_ConfidentialityIDNONHW > 0 
			then m.LOV_ConfidentialityIDNONHW end 
	from 
		EPRTRmaster.dbo.tAT_WASTETRANSFER tw
	inner join (
		select 
			w.FacilityReportID as FacilityReportID,
			MAX(w.LOV_QuantityUnitID) as LOV_QuantityUnitID, 
			MAX(isnull(w.LOV_ConfidentialityID,0)) as LOV_ConfidentialityIDNONHW,
			MAX(cast (w.ConfidentialIndicator as int)) as CI,
			SUM(w.Quantity) as Quantity 
		from EPRTRmaster.dbo.tAT_WASTETRANSFER t
		inner join 
			vAT_WASTETRANSFER w
		on w.FacilityReportID = t.FacilityReportID
		inner join
			LOV_WASTETYPE wty
		on wty.LOV_WasteTypeID = w.LOV_WasteTypeID
		inner join
			LOV_WASTETREATMENT wtr
		on	wtr.LOV_WasteTreatmentID = w.LOV_WasteTreatmentID
		where 
			w.FacilityReportID = t.FacilityReportID
		and wtr.Code = 'R'
		and wty.Code = 'NON-HW' 
		group by w.FacilityReportID
	)m
	on	m.FacilityReportID = tw.FacilityReportID 
	inner join
		LOV_UNIT u
	on u.LOV_UnitID = m.LOV_QuantityUnitID

	update 
		EPRTRmaster.dbo.tAT_WASTETRANSFER
	set QuantityDisposalNONHW = m.Quantity,
		ConfidentialIndicator_NONHW_D = m.CI,
		UnitCodeNONHW = u.Code,
		LOV_ConfidentialityIDNONHW = case when m.LOV_ConfidentialityIDNONHW > 0 
			then m.LOV_ConfidentialityIDNONHW end 
	from 
		EPRTRmaster.dbo.tAT_WASTETRANSFER tw
	inner join (
		select 
			w.FacilityReportID as FacilityReportID,
			MAX(w.LOV_QuantityUnitID) as LOV_QuantityUnitID, 
			MAX(isnull(w.LOV_ConfidentialityID,0)) as LOV_ConfidentialityIDNONHW,
			MAX(cast (w.ConfidentialIndicator as int)) as CI,
			SUM(w.Quantity) as Quantity 
		from EPRTRmaster.dbo.tAT_WASTETRANSFER t
		inner join 
			vAT_WASTETRANSFER w
		on w.FacilityReportID = t.FacilityReportID
		inner join
			LOV_WASTETYPE wty
		on wty.LOV_WasteTypeID = w.LOV_WasteTypeID
		inner join
			LOV_WASTETREATMENT wtr
		on	wtr.LOV_WasteTreatmentID = w.LOV_WasteTreatmentID
		where 
			w.FacilityReportID = t.FacilityReportID
		and wtr.Code = 'D'
		and wty.Code = 'NON-HW' 
		group by w.FacilityReportID
	)m
	on	m.FacilityReportID = tw.FacilityReportID 
	inner join
		LOV_UNIT u
	on u.LOV_UnitID = m.LOV_QuantityUnitID

	update 
		EPRTRmaster.dbo.tAT_WASTETRANSFER
	set QuantityUnspecNONHW = m.Quantity,
		ConfidentialIndicator_NONHW_U = m.CI,
		UnitCodeNONHW = u.Code,
		LOV_ConfidentialityIDNONHW = case when m.LOV_ConfidentialityIDNONHW > 0 
			then m.LOV_ConfidentialityIDNONHW end 
	from 
		EPRTRmaster.dbo.tAT_WASTETRANSFER tw
	inner join (
		select 
			w.FacilityReportID as FacilityReportID,
			MAX(w.LOV_QuantityUnitID) as LOV_QuantityUnitID, 
			MAX(isnull(w.LOV_ConfidentialityID,0)) as LOV_ConfidentialityIDNONHW,
			MAX(cast (w.ConfidentialIndicator as int)) as CI,
			SUM(w.Quantity) as Quantity 
		from EPRTRmaster.dbo.tAT_WASTETRANSFER t
		inner join 
			vAT_WASTETRANSFER w
		on w.FacilityReportID = t.FacilityReportID
		inner join
			LOV_WASTETYPE wty
		on wty.LOV_WasteTypeID = w.LOV_WasteTypeID
		where 
			w.FacilityReportID = t.FacilityReportID
		and w.LOV_WasteTreatmentID is null
		and wty.Code = 'NON-HW' 
		group by w.FacilityReportID
	)m
	on	m.FacilityReportID = tw.FacilityReportID 
	inner join
		LOV_UNIT u
	on u.LOV_UnitID = m.LOV_QuantityUnitID


	------------------------------------------------------------------------------
	--	update code field for Confidentiality
	------------------------------------------------------------------------------

	update 
		EPRTRmaster.dbo.tAT_WASTETRANSFER
	set ConfidentialCodeHWIC = con.Code
	from 
		EPRTRmaster.dbo.tAT_WASTETRANSFER tw
	inner join
		LOV_CONFIDENTIALITY con
	on con.LOV_ConfidentialityID = tw.LOV_ConfidentialityIDHWIC

	update 
		EPRTRmaster.dbo.tAT_WASTETRANSFER
	set ConfidentialCodeHWOC = con.Code
	from 
		EPRTRmaster.dbo.tAT_WASTETRANSFER tw
	inner join
		LOV_CONFIDENTIALITY con
	on con.LOV_ConfidentialityID = tw.LOV_ConfidentialityIDHWOC

	update 
		EPRTRmaster.dbo.tAT_WASTETRANSFER
	set ConfidentialCodeNONHW = con.Code
	from 
		EPRTRmaster.dbo.tAT_WASTETRANSFER tw
	inner join
		LOV_CONFIDENTIALITY con
	on con.LOV_ConfidentialityID = tw.LOV_ConfidentialityIDNONHW


	------------------------------------------------------------------------------
	--	update treatment
	------------------------------------------------------------------------------

	update EPRTRmaster.dbo.tAT_WASTETRANSFER
	set HasReportedRecovery = 1
	from EPRTRmaster.dbo.tAT_WASTETRANSFER tAT
	inner join 
		EPRTRmaster.dbo.WASTETRANSFER w
	on w.FacilityReportID = tAT.FacilityReportID
	inner join
		EPRTRmaster.dbo.LOV_WASTETREATMENT lov
	on	lov.LOV_WasteTreatmentID = w.LOV_WasteTreatmentID
	and lov.Code = 'R'
		
	update EPRTRmaster.dbo.tAT_WASTETRANSFER
	set HasReportedDisposal = 1
	from EPRTRmaster.dbo.tAT_WASTETRANSFER tAT
	inner join 
		EPRTRmaster.dbo.WASTETRANSFER w
	on w.FacilityReportID = tAT.FacilityReportID
	inner join
		EPRTRmaster.dbo.LOV_WASTETREATMENT lov
	on	lov.LOV_WasteTreatmentID = w.LOV_WasteTreatmentID
	and lov.Code = 'D'
	
	update EPRTRmaster.dbo.tAT_WASTETRANSFER
	set HasReportedUnspecified = 1
	from EPRTRmaster.dbo.tAT_WASTETRANSFER tAT
	inner join 
		EPRTRmaster.dbo.WASTETRANSFER w
	on w.FacilityReportID = tAT.FacilityReportID
	and w.LOV_WasteTreatmentID is null
	
end
go

--use EPRTRmaster
--truncate table tAT_WASTETRANSFER
--exec pAT_WASTETRANSFER
--select * from EPRTRmaster.dbo.tAT_WASTETRANSFER order by 1

------------------------------------------------------------------------------
--		prepare hazardous waste outside country data
------------------------------------------------------------------------------

if object_id('EPRTRmaster.dbo.pAT_WASTETRANSFER_RECEIVINGCOUNTRY')is not null DROP procedure pAT_WASTETRANSFER_RECEIVINGCOUNTRY
go
create procedure pAT_WASTETRANSFER_RECEIVINGCOUNTRY
as 
begin
	insert into EPRTRmaster.dbo.tAT_WASTETRANSFER_RECEIVINGCOUNTRY(
		WasteTransferID,
		FacilityReportID,
		QuantityRecovery,
--		QuantityDisposal,
--		QuantityUnspec,
		QuantityTotal,
		LOV_UnitID,
		LOV_ReceivingCountryID,
		ConfidentialIndicator,
		LOV_ConfidentialityID
	)
	select
		w.WasteTransferID,
		w.FacilityReportID,
		w.Quantity,
		w.Quantity,
		w.LOV_QuantityUnitID,
		whp.LOV_CountryID,
		w.ConfidentialIndicator,
		w.LOV_ConfidentialityID
	from vAT_WASTETRANSFER w
	inner join
		FACILITYREPORT frep
	on frep.FacilityReportID = w.FacilityReportID
	inner join
		vAT_POLLUTANTRELEASEANDTRANSFERREPORT prtr
	on  frep.PollutantReleaseAndTransferReportID = prtr.PollutantReleaseAndTransferReportID
	and prtr.ReportingYear > 2000
	left outer join (
		select 
			wh.WasteHandlerPartyID,
			country.LOV_CountryID as LOV_CountryID,
			country.Code as CountryCode,
			country.Name as CountryName,
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
	on whp.WasteHandlerPartyID = w.WasteHandlerPartyID
	inner join LOV_WASTETYPE wty
	on	wty.LOV_WasteTypeID = w.LOV_WasteTypeID
	inner join LOV_WASTETREATMENT wtr
	on wtr.LOV_WasteTreatmentID = w.LOV_WasteTreatmentID
	where
		wtr.Code = 'R'
	and wty.Code = 'HWOC'

	insert into EPRTRmaster.dbo.tAT_WASTETRANSFER_RECEIVINGCOUNTRY(
		WasteTransferID,
		FacilityReportID,
--		QuantityRecovery,
		QuantityDisposal,
--		QuantityUnspec,
		QuantityTotal,
		LOV_UnitID,
		LOV_ReceivingCountryID,
		ConfidentialIndicator,
		LOV_ConfidentialityID
	)
	select
		w.WasteTransferID,
		w.FacilityReportID,
		w.Quantity,
		w.Quantity,
		w.LOV_QuantityUnitID,
		whp.LOV_CountryID,
		w.ConfidentialIndicator,
		w.LOV_ConfidentialityID
	from vAT_WASTETRANSFER w
	inner join
		FACILITYREPORT frep
	on frep.FacilityReportID = w.FacilityReportID
	inner join
		vAT_POLLUTANTRELEASEANDTRANSFERREPORT prtr
	on  frep.PollutantReleaseAndTransferReportID = prtr.PollutantReleaseAndTransferReportID
	and prtr.ReportingYear > 2000
	left outer join (
		select 
			wh.WasteHandlerPartyID,
			country.LOV_CountryID as LOV_CountryID,
			country.Code as CountryCode,
			country.Name as CountryName,
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
	on whp.WasteHandlerPartyID = w.WasteHandlerPartyID
	inner join LOV_WASTETYPE wty
	on	wty.LOV_WasteTypeID = w.LOV_WasteTypeID
	inner join LOV_WASTETREATMENT wtr
	on wtr.LOV_WasteTreatmentID = w.LOV_WasteTreatmentID
	where
		wtr.Code = 'D'
	and wty.Code = 'HWOC'

	insert into EPRTRmaster.dbo.tAT_WASTETRANSFER_RECEIVINGCOUNTRY(
		WasteTransferID,
		FacilityReportID,
--		QuantityRecovery,
--		QuantityDisposal,
		QuantityUnspec,
		QuantityTotal,
		LOV_UnitID,
		LOV_ReceivingCountryID,
		ConfidentialIndicator,
		LOV_ConfidentialityID
	)
	select
		w.WasteTransferID,
		w.FacilityReportID,
		w.Quantity,
		w.Quantity,
		w.LOV_QuantityUnitID,
		whp.LOV_CountryID,
		w.ConfidentialIndicator,
		w.LOV_ConfidentialityID
	from vAT_WASTETRANSFER w
	inner join
		FACILITYREPORT frep
	on frep.FacilityReportID = w.FacilityReportID
	inner join
		vAT_POLLUTANTRELEASEANDTRANSFERREPORT prtr
	on  frep.PollutantReleaseAndTransferReportID = prtr.PollutantReleaseAndTransferReportID
	and prtr.ReportingYear > 2000
	left outer join (
		select 
			wh.WasteHandlerPartyID,
			country.LOV_CountryID as LOV_CountryID,
			country.Code as CountryCode,
			country.Name as CountryName,
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
	on whp.WasteHandlerPartyID = w.WasteHandlerPartyID
	inner join LOV_WASTETYPE wty
	on	wty.LOV_WasteTypeID = w.LOV_WasteTypeID
	where
		w.LOV_WasteTreatmentID is null
	and wty.Code = 'HWOC'
end


