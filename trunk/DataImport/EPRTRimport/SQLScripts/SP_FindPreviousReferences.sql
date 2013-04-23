USE [EPRTRxml]

-- =============================================
-- Author:		WOS
-- Create date: 16.01.2012
-- =============================================

if object_id('dbo.SP_FindPreviousReferences')is not null DROP procedure dbo.SP_FindPreviousReferences ;

CREATE procedure SP_FindPreviousReferences
AS
BEGIN

	------------------------------------------------------------------------------------------
	-- Find all facilities that have reported a previous reporting year
	
	insert into #HAS_PREVIOUS_ID
	select fxml.FacilityReportID, null, null, null, null
	from
		EPRTRxml.dbo.FacilityReport fxml
	inner join
		EPRTRxml.dbo.POLLUTANTRELEASEANDTRANSFERREPORT pxml
	on	fxml.PollutantReleaseAndTransferReportID = pxml.PollutantReleaseAndTransferReportID
	where	
		pxml.ReportingYear <> fxml.PrevReportingYear 
	or	
		(
			pxml.ReportingYear = fxml.PrevReportingYear 
		and fxml.NationalID != fxml.PrevNationalID
		)

	------------------------------------------------------------------------------------------
	-- For all previous reporting years respectively NationalIDs find the referenced 
	-- facilities FacilityID (if it exists)
	
	update #HAS_PREVIOUS_ID
	set FacilityID = m.FacilityID
	from EPRTRmaster.dbo.vAT_FACILITY_ID_EXISTS m
	inner join
		EPRTRxml.dbo.FacilityReport fxml
	on	fxml.PrevNationalID = m.NationalID
	inner join
		EPRTRxml.dbo.POLLUTANTRELEASEANDTRANSFERREPORT pxml
	on	fxml.PollutantReleaseAndTransferReportID = pxml.PollutantReleaseAndTransferReportID
	and m.Code = pxml.CountryID
	inner join
		#HAS_PREVIOUS_ID hpi
	on hpi.FacilityReportID = fxml.FacilityReportID
	where 
		fxml.PrevReportingYear = m.ReportingYear

	update #HAS_PREVIOUS_ID
	set Err_NoPrevNatIdFound = 1
	where isnull(FacilityID,0) = 0

	------------------------------------------------------------------------------------------
	-- Insert all the other new facilities which the member states 
	-- actually reported as new facilities and try to find any historic
	-- records in order to reuse previously used FacilityID

	insert into #HAS_PREVIOUS_ID
	select 
		fxml.FacilityReportID, 
		m.FacilityID, 
		null, 
		null, 
		1
	from 
		EPRTRmaster.dbo.vAT_FACILITY_ID_EXISTS m
	inner join
		EPRTRxml.dbo.FacilityReport fxml
	on	fxml.PrevNationalID = m.NationalID
	inner join
		EPRTRxml.dbo.POLLUTANTRELEASEANDTRANSFERREPORT pxml
	on	fxml.PollutantReleaseAndTransferReportID = pxml.PollutantReleaseAndTransferReportID
	and m.Code = pxml.CountryID
	and m.ReportingYear = pxml.ReportingYear
	where 
		pxml.ReportingYear = fxml.PrevReportingYear 
	and fxml.NationalID = fxml.PrevNationalID

	------------------------------------------------------------------------------------------
	-- Detect facilities in the new report that reference the same previous facility 
	-- more than once and remove the reference from the list
	
	update #HAS_PREVIOUS_ID
	set 
		facilityid = null,
		Err_DuppNatIdRef = 1
	where facilityid in(
		select distinct facilityid
		from #HAS_PREVIOUS_ID a
		group by facilityid
		having count(*) > 1
	) 
END
