--truncate table EPRTRMaster.dbo.XMLFACILITY
USE [EPRTRxml]
GO

--/****** Object:  StoredProcedure [dbo].[import_xml]    Script Date: 12/23/2011 16:04:00 ******/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO

--if object_id('dbo.import_xml')is not null DROP procedure dbo.import_xml
--go

--create procedure [dbo].[import_xml]
--	@pCDRURL nvarchar(250),
--	@pCDRUploaded nvarchar(250),
--	@pCDRReleased nvarchar(250),
--	@pResubmitReason nvarchar(max)
--as
--begin

	declare @pCDRURL nvarchar(250)
	declare @pCDRUploaded nvarchar(250)
	declare @pCDRReleased nvarchar(250)
	declare @pResubmitReason nvarchar(max)
	set @pCDRURL = '-----------'
	set @pCDRUploaded = '2011-11-11 11:11:11'
	set @pCDRReleased = '2011-11-11 11:11:11'
	set @pResubmitReason = 'performance test only'

	----------------------------------------------------------------------------------------
	------------------------------ Add auxilary columns --------------------------------------														
	------------------------------------------------------------------------------------------

	-- resets all auxilary columns

	if exists ( select * from EPRTRmaster.INFORMATION_SCHEMA.COLUMNS
		where TABLE_NAME='ADDRESS' and COLUMN_NAME='eperFacilityID' )
	alter table EPRTRmaster.dbo.ADDRESS drop column eperFacilityID

	--if object_id('EPRTRmaster.dbo.ADDRESS2')is not null DROP TABLE EPRTRmaster.dbo.ADDRESS2

	--select * into EPRTRmaster.dbo.ADDRESS2
	--from EPRTRmaster.dbo.ADDRESS

	--ALTER TABLE EPRTRmaster.dbo.WASTEHANDLERPARTY drop CONSTRAINT FK_WASTEHANDLERPARTY_ADDRESS 
	--ALTER TABLE EPRTRmaster.dbo.WASTEHANDLERPARTY drop CONSTRAINT FK_WASTEHANDLERPARTY_ADDRESS2 
	--ALTER TABLE EPRTRmaster.dbo.FACILITYREPORT drop CONSTRAINT FK_FACILITYREPORT_ADDRESS
	--ALTER TABLE EPRTRmaster.dbo.COMPETENTAUTHORITYPARTY drop CONSTRAINT FK_COMPETENTAUTHORITYPARTY_ADDRESS 

	--drop table EPRTRmaster.dbo.ADDRESS

	--select * into EPRTRmaster.dbo.ADDRESS
	--from EPRTRmaster.dbo.ADDRESS2

	--DROP TABLE EPRTRmaster.dbo.ADDRESS2
	
	exec [dbo].[add_aux_columns] @action = 'add'

	------------------------------------------------------------------------------------------
	--------------- Unifying CountryIDs for Greece and United Kingdom ------------------------														
	------------------------------------------------------------------------------------------
	
    update eprtrxml.dbo.POLLUTANTRELEASEANDTRANSFERREPORT
    set CountryID = 'EL' where CountryID = 'GR'
    update eprtrxml.dbo.POLLUTANTRELEASEANDTRANSFERREPORT
    set CountryID = 'UK' where CountryID = 'GB'
    update eprtrxml.dbo.Address_Competent
    set CountryID = 'EL' where CountryID = 'GR'
    update eprtrxml.dbo.Address_Competent
    set CountryID = 'UK' where CountryID = 'GB'
    update eprtrxml.dbo.Address_Facility
    set CountryID = 'EL' where CountryID = 'GR'
    update eprtrxml.dbo.Address_Facility
    set CountryID = 'UK' where CountryID = 'GB'
    update eprtrxml.dbo.Address_Waste
    set CountryID = 'EL' where CountryID = 'GR'
    update eprtrxml.dbo.Address_Waste
    set CountryID = 'UK' where CountryID = 'GB'
    update eprtrxml.dbo.Address_WasteSite
    set CountryID = 'EL' where CountryID = 'GR'
    update eprtrxml.dbo.Address_WasteSite
    set CountryID = 'UK' where CountryID = 'GB'    

	------------------------------------------------------------------------------------------
	------------------------- fill POLLUTANTRELEASEANDTRANSFERREPORT -------------------------
	------------------------------------------------------------------------------------------


	insert into EPRTRmaster.dbo.POLLUTANTRELEASEANDTRANSFERREPORT
	(ReportingYear,LOV_CountryID,LOV_CoordinateSystemID,
	RemarkText,CdrUrl,CdrUploaded,
	CdrReleased,ResubmitReason,xmlReportID)
	select
		a.ReportingYear,
		b.LOV_CountryID as LOV_CountryID,
		c.LOV_CoordinateSystemID as LOV_CoordinateSystemID,
		a.RemarkText as RemarkText,
		--TODO look at the extra information below and find an easy way to set them
		@pCDRURL as CdrUrl,
		cast(@pCDRUploaded as DateTime) as CdrUploaded,
		cast(cast (a.ReportingYear as nvarchar)+'-01-01 00:00:00.000' as DateTime) as CdrReleased,
		--cast(@pCDRReleased as DateTime) as CdrReleased,
		@pResubmitReason as ResubmitReason,
		a.PollutantReleaseAndTransferReportID as xmlReportID
	from eprtrxml.dbo.POLLUTANTRELEASEANDTRANSFERREPORT a
	inner join 
		EPRTRmaster.dbo.LOV_COUNTRY b
		on a.CountryID = b.Code 
	inner join
	EPRTRmaster.dbo.LOV_COORDINATESYSTEM c
	on a.CoordinateSystemID = c.Code

	--select * from EPRTRmaster.dbo.POLLUTANTRELEASEANDTRANSFERREPORT 

	------------------------------------------------------------------------------------------
	------------------------------------- fill ADDRESS ---------------------------------------
	------------------------------------------------------------------------------------------

	insert into EPRTRmaster.dbo.ADDRESS			
	(
		StreetName,
		BuildingNumber,
		City,
		PostalCode,
		LOV_CountryID,
		xmlCompetentID
	)
	select 
		a.StreetName as StreetName,
		a.BuildingNumber as BuildingNumber,
		a.CityName as City,
		a.PostCodeCode as PostalCode,
		b.LOV_CountryID as LOV_CountryID,
		a.CompetentAuthorityPartyID as xmlCompetentID
	from EPRTRxml.dbo.ADDRESS_COMPETENT a
	left join 
		EPRTRmaster.dbo.LOV_COUNTRY b
		on a.CountryID = b.Code

	insert into EPRTRmaster.dbo.ADDRESS			
	(StreetName,BuildingNumber,City,PostalCode,LOV_CountryID,xmlFacilityID)
	select 
		a.StreetName as StreetName,
		a.BuildingNumber as BuildingNumber,
		a.CityName as City,
		a.PostCodeCode as PostalCode,
		b.LOV_CountryID as LOV_CountryID,
		a.FacilityReportID as xmlFacilityID
	from EPRTRxml.dbo.ADDRESS_FACILITY a
	left join 
		EPRTRmaster.dbo.LOV_COUNTRY b
		on a.CountryID = b.Code
		
	insert into EPRTRmaster.dbo.ADDRESS			
	(StreetName,BuildingNumber,City,PostalCode,LOV_CountryID,xmlWasteID)
	select 
		a.StreetName as StreetName,
		a.BuildingNumber as BuildingNumber,
		a.CityName as City,
		a.PostCodeCode as PostalCode,
		b.LOV_CountryID as LOV_CountryID,
		a.WasteTransferID as xmlWasteID
	from EPRTRxml.dbo.ADDRESS_WASTE a
	left join 
		EPRTRmaster.dbo.LOV_COUNTRY b
		on a.CountryID = b.Code
		
	insert into EPRTRmaster.dbo.ADDRESS			
	(StreetName,BuildingNumber,City,PostalCode,LOV_CountryID,xmlWasteSiteID)
	select 
		a.StreetName as StreetName,
		a.BuildingNumber as BuildingNumber,
		a.CityName as City,
		a.PostCodeCode as PostalCode,
		b.LOV_CountryID as LOV_CountryID,
		a.WasteTransferID as xmlWasteSiteID
	from EPRTRxml.dbo.ADDRESS_WASTESITE a
	left join 
		EPRTRmaster.dbo.LOV_COUNTRY b
		on a.CountryID = b.Code	

--------ALTER TABLE WASTEHANDLERPARTY ADD CONSTRAINT FK_WASTEHANDLERPARTY_ADDRESS 
--------FOREIGN KEY (AddressID)
--------REFERENCES ADDRESS(AddressID)

--------ALTER TABLE WASTEHANDLERPARTY ADD CONSTRAINT FK_WASTEHANDLERPARTY_ADDRESS2 
--------FOREIGN KEY (SiteAddressID)
--------REFERENCES ADDRESS(AddressID)

--------ALTER TABLE FACILITYREPORT ADD CONSTRAINT FK_FACILITYREPORT_ADDRESS
--------FOREIGN KEY (AddressID)
--------REFERENCES ADDRESS(AddressID)

--------ALTER TABLE COMPETENTAUTHORITYPARTY ADD CONSTRAINT FK_COMPETENTAUTHORITYPARTY_ADDRESS 
--------FOREIGN KEY (AddressID)
--------REFERENCES ADDRESS(AddressID)

	------------------------------------------------------------------------------------------
	----------------------------- fill COMPETENTAUTHORITYPARTY -------------------------------
	------------------------------------------------------------------------------------------

	insert into EPRTRmaster.dbo.COMPETENTAUTHORITYPARTY
	(LOV_CountryID,ReportingYear,Name,AddressID,TelephoneCommunication,FaxCommunication,
	EmailCommunication,ContactPersonName,xmlCompetentAuthorityPartyID)
	select  b.LOV_CountryID as LOV_CountryID,
		c.ReportingYear as ReportingYear,
		a.Name as Name,
		d.AddressID as AddressID,
		a.TelephoneCommunication as TelephoneCommunication,
		a.FaxCommunication as FaxCommunication,
		a.EmailCommunication as EmailCommunication,
		a.ContactPersonName as ContactPersonName,
		A.CompetentAuthorityPartyID as xmlCompetentAuthorityPartyID
	from EPRTRxml.dbo.COMPETENTAUTHORITYPARTY a
	inner join
		EPRTRxml.dbo.POLLUTANTRELEASEANDTRANSFERREPORT c
		on a.POLLUTANTRELEASEANDTRANSFERREPORTID = c.POLLUTANTRELEASEANDTRANSFERREPORTID
	inner join
		EPRTRmaster.dbo.LOV_COUNTRY b
		on c.CountryID = b.Code
	inner join	
		EPRTRMaster.dbo.ADDRESS d
		on a.COMPETENTAUTHORITYPARTYID = d.xmlCompetentID
		
	--select * from EPRTRmaster.dbo.COMPETENTAUTHORITYPARTY
		
		
	------------------------------------------------------------------------------------------
	------------------------------- fill FACILITY --------------------------------------------
	------------------------------------------------------------------------------------------

	if object_id('tempdb..#HAS_PREVIOUS_ID')is not null DROP TABLE #HAS_PREVIOUS_ID
	create table #HAS_PREVIOUS_ID(FacilityReportID int, FacilityID int,
		Err_NoPrevNatIdFound bit, 
		Err_DuppNatIdRef bit, 
		FacilityIdFound bit
	)
	
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
	-- Detect facilities in the new report that reference the same previous facility 
	-- more than once and remove the reference from the list
	
	update #HAS_PREVIOUS_ID
	set 
		facilityid = null,
		Err_DuppNatIdRef = 1
	where facilityid in(
		select	facilityid
		from #HAS_PREVIOUS_ID a
		group by facilityid
		having count(1) > 1
	) 

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

	------------------------------------------------------------------------------------------
	-- Update table FACILITY special xml column in EPRTRmaster with 
	-- new imported FacilityReportIDs that could be matched

	update EPRTRmaster.dbo.FACILITY
	set xmlFacilityReportID = hpi.FacilityReportID
	from EPRTRmaster.dbo.FACILITY f
	inner join
		#HAS_PREVIOUS_ID hpi
	on f.FacilityID = hpi.FacilityID


	------------------------------------------------------------------------------------------
	-- Insert facilities which should have been reported before, 
	-- but for some reason cannot find a match or do a dobble refference.
	-- They will be treated as new facilitis and will get assigned a new facilityID

	insert into EPRTRmaster.dbo.XMLFACILITY(
		xmlFacilityReportID
	)
	select 
		FacilityReportID as xmlFacilityReportID
	from #HAS_PREVIOUS_ID
	where FacilityID is null


	------------------------------------------------------------------------------------------
	-- Insert new facilities which have not been imported before 

	insert into EPRTRmaster.dbo.XMLFACILITY(
		xmlFacilityReportID
	)
	select 
		a.FacilityReportID as xmlFacilityReportID
	from EPRTRxml.dbo.FacilityReport a
	inner join
		EPRTRxml.dbo.PollutantReleaseAndTransferReport b
	on	a.PollutantReleaseAndTransferReportID = b.PollutantReleaseAndTransferReportID
	and b.reportingyear = a.prevreportingyear	
	where FacilityReportID not in (
		select  FacilityReportID 
		from #HAS_PREVIOUS_ID
	)

	--------------------------------------------------------------------------------------------
	-- Copy all the new facilities from table XMLFACILITY into table FACILITY

	insert into EPRTRmaster.dbo.FACILITY
	(FacilityID,xmlFacilityReportID)
	select
		a.FacilityID as FacilityID,
		a.xmlFacilityReportID as xmlFacilityReportID
	from EPRTRmaster.dbo.XMLFACILITY a

	--select  * from #HAS_PREVIOUS_ID
	
	----------------------------------------------------------------------------------------
	-------------------------------- fill PRODUCTIONVOLUME -----------------------------------
	------------------------------------------------------------------------------------------

	insert into EPRTRmaster.dbo.PRODUCTIONVOLUME
	(PRODUCTNAME,QUANTITY,LOV_UnitID,xmlFacilityReportID)
	select
		fr.ProductName as ProductName,
		fr.Quantity as Quantity,
		unit.LOV_UnitID as LOV_UnitID,
		fr.FacilityReportID as xmlFacilityReportID
	from EPRTRxml.dbo.FACILITYREPORT fr
	inner join
		EPRTRmaster.dbo.LOV_UNIT unit
		on unit.Code = fr.QuantityUnitCode 		

	--select * from EPRTRmaster.dbo.PRODUCTIONVOLUME

	------------------------------------------------------------------------------------------
	-------------------------------- fill FACILITYREPORT -------------------------------------
	------------------------------------------------------------------------------------------

	declare @UNKNOWN_NUTS int
	select @UNKNOWN_NUTS = LOV_NUTSRegionID 
		from EPRTRmaster.dbo.LOV_NUTSREGION
		where Code = 'UNKNOWN'

	declare @UNKNOWN_RBD int
	select @UNKNOWN_RBD = LOV_RiverBasinDistrictID 
		from EPRTRmaster.dbo.LOV_RIVERBASINDISTRICT 
		where Code = 'UNKNOWN'

	declare @LOV_M int
	select @LOV_M = LOV_StatusID  
		from EPRTRmaster.dbo.LOV_STATUS 
		where Code = 'MISSING'

	declare @LOV_O int
	select @LOV_O = LOV_StatusID  
		from EPRTRmaster.dbo.LOV_STATUS 
		where Code = 'OUTSIDE'

	insert into EPRTRmaster.dbo.FACILITYREPORT(
		PollutantReleaseAndTransferReportID,
		FacilityID,
		NationalID,
		ParentCompanyName,
		FacilityName,
		AddressID,
		GeographicalCoordinate,
		LOV_StatusID,
		LOV_RiverBasinDistrictID,
		LOV_RiverBasinDistrictID_Source,
		LOV_NACEMainEconomicActivityID,
		MainEconomicActivityName,
		CompetentAuthorityPartyID,
		ProductionVolumeID,
		TotalIPPCInstallationQuantity,
		OperatingHours,
		TotalEmployeeQuantity,
		LOV_NUTSRegionID,
		LOV_NUTSRegionID_Source,
		WebsiteCommunication,
		PublicInformation,
		ConfidentialIndicator,
		LOV_ConfidentialityID,
		ProtectVoluntaryData,
		RemarkText,
		PrevNationalID,
		PrevReportingYear,		
		xmlFacilityReportID
	)
	select 
		pol.PollutantReleaseAndTransferReportID as PollutantReleaseAndTransferReportID, 
		fac.FacilityID as FacilityID,
		fr.NationalID as NationalID,
		fr.ParentCompanyName as ParentCompanyName,
		fr.FacilityName as FacilityName,
		adrs.AddressID as AddressID,
		geometry::STGeomFromText('POINT(' + 
			cast(cast(fr.LongitudeMeasure as decimal(18,12))as varchar(18)) + ' '+ 
			cast(cast(fr.LatitudeMeasure as decimal(18,12)) as varchar(18)) + ')', 4326) as GeographicalCoordinate,
		case 
			when isnull(fr.LongitudeMeasure,0 ) = 0 then @LOV_M
			when isnull(fr.LatitudeMeasure,0 ) = 0 then @LOV_M
			else @LOV_O end as LOV_StatusID,
		@UNKNOWN_RBD as LOV_RiverBasinDistrictID,
		isnull(rbd.LOV_RiverBasinDistrictID,@UNKNOWN_RBD) as LOV_RiverBasinDistrictID_Source,
		nace.LOV_NACEActivityID as LOV_NACEMainEconomicActivityID,
		isnull(fr.MainEconomicActivityName,'N/A') as MainEconomicActivityName,
		ca.CompetentAuthorityPartyID as CompetentAuthorityPartyID,
		pv.ProductionVolumeID as ProductionVolumeID,
		fr.TotalIPPCInstallationQuantity as TotalIPPCInstallationQuantity,
		fr.OperationHours as OperatingHours,
		fr.TotalEmployeeQuantity as TotalEmployeeQuantity,
		@UNKNOWN_NUTS as LOV_NUTSRegionID,
		nuts.LOV_NUTSRegionID as LOV_NUTSRegionID_Source,
		fr.WebsiteCommunication as WebsiteCommunication,
		fr.PublicInformation as PublicInformation,
		fr.ConfidentialIndicator as ConfidentialIndicator,
		con.LOV_ConfidentialityID as LOV_ConfidentialityID,
		fr.ProtectVoluntaryData as ProtectVoluntaryData,
		fr.RemarkText as RemarkText,
		fr.PrevNationalID,
		fr.PrevReportingYear,
		fr.FacilityReportID as xmlFacilityReportID
	from EPRTRxml.dbo.FACILITYREPORT fr
	inner join 
		EPRTRmaster.dbo.POLLUTANTRELEASEANDTRANSFERREPORT pol
		on	pol.xmlReportID = fr.PollutantReleaseAndTransferReportID
	inner join
		EPRTRmaster.dbo.FACILITY fac
		on	fac.xmlFacilityReportID = fr.FacilityReportID
	left join
		EPRTRMaster.dbo.ADDRESS adrs
		on adrs.xmlFacilityID = fr.FacilityReportID
	left join
		EPRTRmaster.dbo.LOV_RiverBasinDistrict rbd
		on rbd.code = fr.RiverBasinDistrictID
	inner join
		EPRTRmaster.dbo.LOV_NACEActivity nace
		on nace.code = fr.NACEMainEconomicActivityCode
	inner join
		EPRTRmaster.dbo.COMPETENTAUTHORITYPARTY ca
		on  ca.Name = fr.CompetentAuthorityName 
	left join
		EPRTRmaster.dbo.LOV_Confidentiality con
		on  con.Code = fr.ConfidentialCode
	left join
		EPRTRmaster.dbo.LOV_NUTSRegion nuts
		on  nuts.Code = fr.NutsRegionID
	left join
		EPRTRmaster.dbo.ProductionVolume pv
		on  pv.xmlFacilityReportID = fr.FacilityReportID
	where ca.xmlCompetentAuthorityPartyID is not null

	--select * from EPRTRmaster.dbo.FACILITYREPORT where PollutantReleaseAndTransferReportID = 72

	------------------------------------------------------------------------------
	--	Geo-coding of NUTS regions
	------------------------------------------------------------------------------

	declare @LOV_UNDEFINED int
	select @LOV_UNDEFINED = LOV_StatusID  
		from EPRTRmaster.dbo.LOV_STATUS 
		where Code = 'OUTSIDE'

	declare @LOV_VALID int
	select @LOV_VALID = LOV_StatusID  
		from EPRTRmaster.dbo.LOV_STATUS 
		where Code = 'VALID'

	update EPRTRmaster.dbo.FACILITYREPORT
	set 
		LOV_NUTSRegionID = m.LOV_NUTSRegionID,
		LOV_StatusID = @LOV_VALID
	from EPRTRmaster.dbo.FACILITYREPORT frep
	inner join 
		EPRTRmaster.dbo.POLLUTANTRELEASEANDTRANSFERREPORT pt
	on	pt.PollutantReleaseAndTransferReportID = frep.PollutantReleaseAndTransferReportID
	inner join (
		select
			LOV_CountryID as LOV_CountryID, 
			nuts.LOV_NUTSRegionID as LOV_NUTSRegionID,
			geom as Shape
		from
			EPRTRmaster.dbo.LOV_NUTSREGION nuts
		inner join
			EPRTRmaster.dbo.NUTS_RG nr
		on	nuts.Code = nr.NUTS_ID
		and nr.STAT_LEVL_ = 2 
		)m
	on	pt.LOV_CountryID = m.LOV_CountryID
	and frep.GeographicalCoordinate.STWithin(m.Shape) = 1
	where frep.LOV_StatusID = @LOV_UNDEFINED and
	frep.xmlFacilityReportID is not null

	------------------------------------------------------------------------------
	--	Geo-coding of river basin districts
	------------------------------------------------------------------------------

	update EPRTRmaster.dbo.FACILITYREPORT
	set 
		LOV_RiverBasinDistrictID = m.LOV_RiverBasinDistrictID,
		LOV_StatusID = @LOV_VALID
	from EPRTRmaster.dbo.FACILITYREPORT frep
	inner join 
		EPRTRmaster.dbo.POLLUTANTRELEASEANDTRANSFERREPORT pt
	on	pt.PollutantReleaseAndTransferReportID = frep.PollutantReleaseAndTransferReportID
	inner join (
		select
			LOV_CountryID as LOV_CountryID, 
			r.LOV_RiverBasinDistrictID as LOV_RiverBasinDistrictID,
			geom as Shape
		from
			EPRTRmaster.dbo.LOV_RIVERBASINDISTRICT r
		inner join
			EPRTRmaster.dbo.RBD s
		on	s.MSCD_RBD = r.Code
		)m
	on	pt.LOV_CountryID = m.LOV_CountryID
	and frep.GeographicalCoordinate.STWithin(m.Shape) = 1
	where frep.LOV_StatusID in (@LOV_UNDEFINED, @LOV_VALID)
	and frep.xmlFacilityReportID is not null

	--select GeographicalCoordinate.ToString(),* from EPRTRmaster.dbo.FACILITYREPORT f
	--inner join EPRTRmaster.dbo.POLLUTANTRELEASEANDTRANSFERREPORT pt
	--on f.PollutantReleaseAndTransferReportID = pt.PollutantReleaseAndTransferReportID
	--and LOV_CountryID = 213 order by 3

--	------------------------------------------------------------------------------------------
--	---------------------------------------- fill FACILITYLOG -------------------------------------														
--	--------------------------------------------------------------------------------------------

	insert into EPRTRmaster.dbo.FACILITYLOG
	(FacilityID, NationalID,ReportingYear,FacilityreportID)
	select 
		a.FacilityID as FacilityID,
		a.NationalID as NationalID,
		c.ReportingYear as ReportingYear,
		a.FacilityreportID as FacilityreportID	
	from EPRTRmaster.dbo.FacilityReport a
	inner join
		EPRTRmaster.dbo.POLLUTANTRELEASEANDTRANSFERREPORT c
		on a.POLLUTANTRELEASEANDTRANSFERREPORTID = c.POLLUTANTRELEASEANDTRANSFERREPORTID
	where a.xmlFacilityReportID is not null

	--select * from EPRTRmaster.dbo.FACILITYLOG

	--------------------------------------------------------------------------------------------
	---------------------------------------- fill ACTIVITY -------------------------------------														
	--------------------------------------------------------------------------------------------

	insert into EPRTRmaster.dbo.ACTIVITY 
	(FacilityReportID, RankingNumeric, LOV_AnnexIActivityID)
	select
		frm.FacilityReportID as FacilityReportID,
		act.RankingNumeric as RankingNumeric,
		aa.LOV_AnnexIActivityID as LOV_AnnexIActivityID
	from EPRTRxml.dbo.ACTIVITY act
	inner join 
		EPRTRxml.dbo.FACILITYREPORT frx
		on	act.FacilityReportID = frx.FacilityReportID
	inner join 
		EPRTRmaster.dbo.FACILITYREPORT frm
		on	frm.xmlFacilityReportID = frx.FacilityReportID
	inner join
		EPRTRmaster.dbo.LOV_ANNEXIACTIVITY aa
		on  aa.code = act.AnnexIActivityCode

	--select * from EPRTRmaster.dbo.ACTIVITY

	--------------------------------------------------------------------------------------------
	----------------------------------- fill METHODLIST and METHODUSED ----------------------------------
	--------------------------------------------------------------------------------------------

	--Processing PollutantRelease
	insert into EPRTRmaster.dbo.XMLMETHODLIST
	(xmlPollutantReleaseID)
	select
		a.PollutantReleaseID
	from EPRTRxml.dbo.METHODUSED_POLLUTANTRELEASE a
	group by a.PollutantReleaseID

	insert into EPRTRmaster.dbo.METHODLIST
	(MethodListID,xmlPollutantReleaseID)
	select
		a.MethodListID as MethodListID,
		a.xmlPollutantReleaseID as xmlPollutantReleaseID
	from EPRTRmaster.dbo.XMLMETHODLIST a
	where a.xmlPollutantReleaseID is not null

	insert into EPRTRmaster.dbo.METHODUSED
	(MethodListID,LOV_MethodTypeID,MethodDesignation)
	select
		b.MethodListID as MethodListID,
		c.LOV_MethodTypeID as LOV_MethodTypeID,
		a.MethodDesignation as MethodDesignation
	from EPRTRxml.dbo.METHODUSED_POLLUTANTRELEASE a
	inner join 
		EPRTRmaster.dbo.METHODLIST b
		on b.xmlPollutantReleaseID = a.PollutantReleaseID
	inner join
		EPRTRmaster.dbo.LOV_METHODTYPE c
		on c.Code = a.MethodUsed

	--Processing PollutantTransfer
	insert into EPRTRmaster.dbo.XMLMETHODLIST
	(xmlPollutantTransferID)
	select
		a.PollutantTransferID
	from EPRTRxml.dbo.METHODUSED_POLLUTANTTRANSFER a
	group by a.PollutantTransferID 

	insert into EPRTRmaster.dbo.METHODLIST
	(MethodListID,xmlPollutantTransferID)
	select
		a.MethodListID as MethodListID,
		a.xmlPollutantTransferID as xmlPollutantTransferID
	from EPRTRmaster.dbo.XMLMETHODLIST a
	where a.xmlPollutantTransferID is not null

	insert into EPRTRmaster.dbo.METHODUSED
	(MethodListID,LOV_MethodTypeID,MethodDesignation)
	select
		b.MethodListID as MethodListID,
		c.LOV_MethodTypeID as LOV_MethodTypeID,
		a.MethodDesignation as MethodDesignation
	from EPRTRxml.dbo.METHODUSED_POLLUTANTTRANSFER a
	inner join 
		EPRTRmaster.dbo.METHODLIST b
		on b.xmlPollutantTransferID = a.PollutantTransferID
	inner join
		EPRTRmaster.dbo.LOV_METHODTYPE c
		on c.Code = a.MethodUsed

	--Processing WasteTransfer
	insert into EPRTRmaster.dbo.XMLMETHODLIST
	(xmlWasteTransferID)
	select
		a.WasteTransferID
	from EPRTRxml.dbo.METHODUSED_WASTETRANSFER a
    group by a.WasteTransferID
    
	insert into EPRTRmaster.dbo.METHODLIST
	(MethodListID,xmlWasteTransferID)
	select
		a.MethodListID as MethodListID,
		a.xmlWasteTransferID as xmlWasteTransferID
	from EPRTRmaster.dbo.XMLMETHODLIST a
	where a.xmlWasteTransferID is not null

	insert into EPRTRmaster.dbo.METHODUSED
	(MethodListID,LOV_MethodTypeID,MethodDesignation)
	select
		b.MethodListID as MethodListID,
		c.LOV_MethodTypeID as LOV_MethodTypeID,
		a.MethodDesignation as MethodDesignation
	from EPRTRxml.dbo.METHODUSED_WASTETRANSFER a
	inner join 
		EPRTRmaster.dbo.METHODLIST b
		on b.xmlWasteTransferID = a.WasteTransferID
	inner join
		EPRTRmaster.dbo.LOV_METHODTYPE c
		on c.Code = a.MethodUsed

	/*
	--select * from EPRTRmaster.dbo.METHODLIST where xmlPollutantReleaseID is not null
	--select * from EPRTRmaster.dbo.METHODUSED where MethodListID in
	--(select MethodListID from EPRTRmaster.dbo.METHODLIST where xmlPollutantReleaseID is not null) 
	--*/

	declare @XMLIDs table(
		MethodListID int,
		xmlPollutantTransferID int,
		xmlPollutantReleaseID int,
		xmlWasteTransferID int
	)
		
	insert into @XMLIDs
	select 
		MethodListID,
		xmlPollutantTransferID,
		xmlPollutantReleaseID,
		xmlWasteTransferID
	from 
		EPRTRmaster.dbo.METHODLIST ml
	where xmlPollutantTransferID > 0
	or xmlPollutantReleaseID > 0
	or xmlWasteTransferID > 0

	--------------------------------------------------------------------------------------------
	----------------------------------- fill POLLUTANTRELEASE ----------------------------------
	--------------------------------------------------------------------------------------------

	update EPRTRxml.dbo.POLLUTANTRELEASE
	set TotalQuantityUnitCode = 'KGM' where TotalQuantityUnitCode is null
    
    update EPRTRxml.dbo.POLLUTANTRELEASE
    set AccidentalQuantityUnitCode = 'KGM' where AccidentalQuantityUnitCode is null
    
	insert into EPRTRmaster.dbo.POLLUTANTRELEASE
	(
		FacilityReportID,
		LOV_MediumID,
		LOV_PollutantID,
		LOV_MethodBasisID,
		MethodListID,
		TotalQuantity,
		LOV_TotalQuantityUnitID,
		AccidentalQuantity,
		LOV_AccidentalQuantityUnitID,
		ConfidentialIndicator,
		LOV_ConfidentialityID,
		RemarkText
	)
	select
		frm.FacilityReportID as FacilityReportID,
		m.LOV_MediumID as LOV_MediumID,
		p.LOV_PollutantID as LOV_PollutantID,
		mb.LOV_MethodBasisID as LOV_MethodBasisID,
		ml.MethodListID as MethodListID,
		pr.TotalQuantity as TotalQuantity,
		unit1.LOV_UnitID as LOV_TotalQuantityUnitID,
		pr.AccidentalQuantity as AccidentalQuantity,
		unit2.LOV_UnitID as LOV_AccidentalQuantityUnitID,
		pr.ConfidentialIndicator as ConfidentialIndicator,
		con.LOV_ConfidentialityID as LOV_ConfidentialityID,
		pr.RemarkText as RemarkText
	from EPRTRxml.dbo.POLLUTANTRELEASE pr
	inner join
		EPRTRxml.dbo.FACILITYREPORT frx
		on pr.FacilityReportID = frx.FacilityReportID
	inner join 
		EPRTRmaster.dbo.FACILITYREPORT frm
		on	frm.xmlFacilityReportID = frx.FacilityReportID
	inner join
		EPRTRmaster.dbo.LOV_MEDIUM m
		on	m.Code = pr.MediumCode
	inner join
		EPRTRmaster.dbo.LOV_POLLUTANT p
		on	p.Code = pr.PollutantCode
	left join
		EPRTRmaster.dbo.LOV_Confidentiality con
		on  con.Code = pr.ConfidentialCode
	inner join
		EPRTRmaster.dbo.LOV_METHODBASIS mb
		on	mb.Code = pr.MethodBasisCode
	left join
		EPRTRmaster.dbo.LOV_UNIT unit1
		on unit1.Code = pr.TotalQuantityUnitCode
	left join
		EPRTRmaster.dbo.LOV_UNIT unit2
		on unit2.Code = pr.AccidentalQuantityUnitCode
	left join
		@XMLIDs ml
		on ml.xmlPollutantReleaseID = pr.PollutantReleaseID

	/*
	select * from EPRTRmaster.dbo.POLLUTANTRELEASE where FacilityReportID in
	(select FACILITYREPORTID from EPRTRmaster.dbo.FACILITYREPORT where xmlFacilityReportID is not null)
	*/

	--------------------------------------------------------------------------------------------
	----------------------------------- fill POLLUTANTTRANSFER ---------------------------------
	--------------------------------------------------------------------------------------------

	update EPRTRxml.dbo.POLLUTANTTRANSFER
	set QuantityUnitCode = 'KGM' where QuantityUnitCode is null


	insert into EPRTRmaster.dbo.POLLUTANTTRANSFER
	(
		FacilityReportID,
		LOV_PollutantID,
		LOV_MethodBasisID,
		MethodListID,
		Quantity,
		LOV_QuantityUnitID,
		ConfidentialIndicator,
		LOV_ConfidentialityID,
		RemarkText
	)
	select
		frm.FacilityReportID as FacilityReportID,
		p.LOV_PollutantID as LOV_PollutantID,
		mb.LOV_MethodBasisID as LOV_MethodBasisID,
		ml.MethodListID as MethodListID,
		pt.Quantity as Quantity,
		unit.LOV_UnitID as LOV_QuantityUnitID,
		pt.ConfidentialIndicator as ConfidentialIndicator,
		con.LOV_ConfidentialityID as LOV_ConfidentialityID,
		pt.RemarkText as RemarkText
	from EPRTRxml.dbo.POLLUTANTTRANSFER pt
	inner join
		EPRTRxml.dbo.FACILITYREPORT frx
		on pt.FacilityReportID = frx.FacilityReportID
	inner join 
		EPRTRmaster.dbo.FACILITYREPORT frm
		on	frm.xmlFacilityReportID = frx.FacilityReportID
	inner join
		EPRTRmaster.dbo.LOV_POLLUTANT p
		on	p.Code = pt.PollutantCode
	inner join
		EPRTRmaster.dbo.LOV_METHODBASIS mb
		on	mb.Code = pt.MethodBasisCode
	left join
		EPRTRmaster.dbo.LOV_UNIT unit
		on unit.Code = pt.QuantityUnitCode
	left join
		EPRTRmaster.dbo.LOV_Confidentiality con
		on  con.Code = pt.ConfidentialCode
	left join
		@XMLIDs ml
	on ml.xmlPollutantTransferID = pt.PollutantTransferID



	/*
	select * from EPRTRmaster.dbo.POLLUTANTTRANSFER where FacilityReportID in
	(select FACILITYREPORTID from EPRTRmaster.dbo.FACILITYREPORT where xmlFacilityReportID is not null)
	*/

	--------------------------------------------------------------------------------------------
	----------------------------------- fill WASTEHANDLERPARTY ---------------------------------
	--------------------------------------------------------------------------------------------

	insert into EPRTRmaster.dbo.WASTEHANDLERPARTY
	(Name,AddressID,SiteAddressID,xmlWasteTransferID)
	select
		wt.WasteHandlerPartyName as Name,
		adrs1.AddressID as AddressID,
		adrs2.AddressID as SiteAddressID,
		wt.WasteTransferID as xmlWasteTransferID
	from EPRTRxml.dbo.WASTETRANSFER wt
	left join
		EPRTRMaster.dbo.ADDRESS adrs1
		on adrs1.xmlWasteID = wt.WasteTransferID
	left join
		EPRTRMaster.dbo.ADDRESS adrs2
		on adrs2.xmlWasteSiteID = wt.WasteTransferID
	where wt.WasteHandlerPartyName is not null   
	    

--	------------------------------------------------------------------------------------------
--	--------------------------------- fill WASTETRANSFER ---------------------------------
--	------------------------------------------------------------------------------------------

	update EPRTRxml.dbo.WASTETRANSFER
	set QuantityUnitCode = 'TNE' where QuantityUnitCode is null

	declare @estimated int
	set @estimated = (select LOV_MethodBasisID from EPRTRmaster.dbo.LOV_METHODBASIS where Code = 'E')

	insert into EPRTRmaster.dbo.WASTETRANSFER
	(
		FacilityReportID,
		LOV_WasteTypeID,
		LOV_WasteTreatmentID,
		LOV_MethodBasisID,
		MethodListID,
		Quantity,
		LOV_QuantityUnitID,
		WasteHandlerPartyID,
		ConfidentialIndicator,
		LOV_ConfidentialityID,
		RemarkText
	)
	select
		frm.FacilityReportID as FacilityReportID,
		wtype.LOV_WasteTypeID as LOV_WasteTypeID,
		wtreat.LOV_WasteTreatmentID as LOV_WasteTreatmentID,
		mb.LOV_MethodBasisID as LOV_MethodBasisID,
		ml.MethodListID as MethodListID,
		wt.Quantity as Quantity,
		unit.LOV_UnitID as LOV_QuantityUnitID,
		whp.WasteHandlerPartyID as WasteHandlerPartyID,
		wt.ConfidentialIndicator as ConfidentialIndicator,
		con.LOV_ConfidentialityID as LOV_ConfidentialityID,
		wt.RemarkText as RemarkText
	from EPRTRxml.dbo.WASTETRANSFER wt
	inner join
		EPRTRxml.dbo.FACILITYREPORT frx
		on wt.FacilityReportID = frx.FacilityReportID
	inner join 
		EPRTRmaster.dbo.FACILITYREPORT frm
		on	frm.xmlFacilityReportID = frx.FacilityReportID
	left join
		EPRTRmaster.dbo.LOV_WASTETREATMENT wtreat
		on	wtreat.Code = wt.WasteTreatmentCode
	left join
		EPRTRmaster.dbo.LOV_METHODBASIS mb
		on	mb.Code = wt.MethodBasisCode
	left join
		EPRTRmaster.dbo.WASTEHANDLERPARTY whp
		on whp.xmlWasteTransferID = wt.WasteTransferID
	left join
		EPRTRmaster.dbo.LOV_Confidentiality con
		on  con.Code = wt.ConfidentialCode
	inner join
		EPRTRmaster.dbo.LOV_WASTETYPE wtype
		on	wtype.Code = wt.WasteTypeCode
	left join
		EPRTRmaster.dbo.LOV_UNIT unit
		on unit.Code = wt.QuantityUnitCode
	left join 
		@XMLIDs ml
	on ml.xmlWasteTransferID = wt.WasteTransferID

	-- If the same report with identical CDRReleased date gets uploadet twice, then 
	-- the CDRReleased timestamp of the first uploade gets set back by one minute. 
	-- This guarantees, that there will be only one lates released record in the 
	-- POLLUTANTRELEASEANDTRANSFERREPORT table

	update EPRTRmaster.dbo.POLLUTANTRELEASEANDTRANSFERREPORT
	set CdrReleased = cast (DATEADD(MINUTE,-1 ,@pCDRReleased) as nvarchar)
	from EPRTRmaster.dbo.POLLUTANTRELEASEANDTRANSFERREPORT p
	inner join(
		select
			prtr.PollutantReleaseAndTransferReportID
		from 
			EPRTRmaster.dbo.vAT_POLLUTANTRELEASEANDTRANSFERREPORT prtr
		inner join
			EPRTRxml.dbo.POLLUTANTRELEASEANDTRANSFERREPORT pxml
		on	pxml.ReportingYear = prtr.ReportingYear
		inner join
			EPRTRmaster.dbo.LOV_COUNTRY c
		on	c.LOV_CountryID = prtr.LOV_CountryID
		and	c.Code = pxml.CountryID
		inner join (
			select distinct
				ReportingYear,
				LOV_CountryID,
				max(CdrReleased) as ReleasedDate
			from 
				EPRTRmaster.dbo.POLLUTANTRELEASEANDTRANSFERREPORT prtr1
			group by 
				ReportingYear,
				LOV_CountryID
		) m
		on	m.LOV_CountryID = prtr.LOV_CountryID
		and m.ReportingYear = prtr.ReportingYear
		and m.ReleasedDate = prtr.CdrReleased
		where
			prtr.CdrReleased = @pCDRReleased
	) m
	on m.PollutantReleaseAndTransferReportID = p.PollutantReleaseAndTransferReportID

	--Update POLLUTANTRELEASEANDTRANSFERREPORT table with CDRReleasedDate

	update EPRTRmaster.dbo.POLLUTANTRELEASEANDTRANSFERREPORT 
	set CdrReleased = cast(@pCDRReleased as DateTime)
	where xmlReportID = 1 
	
	declare
    @fac_count int
    set @fac_count = (select count(1) from EPRTRmaster.dbo.FACILITYREPORT a
    inner join EPRTRmaster.dbo.POLLUTANTRELEASEANDTRANSFERREPORT b
			   on b.POLLUTANTRELEASEANDTRANSFERREPORTID = a.POLLUTANTRELEASEANDTRANSFERREPORTID
	where b.xmlReportID = 1)		   
    print('Total number of facilities imported: '+ cast (@fac_count as nvarchar) +'')


	--------------------------------------------------------------------------------------
	--	Ticket #753:
	--	The database currently only holds information about the "Published" date. 
	--	This information is set automatically.
	--	This should be changed so the published date can be set manually to the date where data 
	--	are to be published on the website. In addition, the inforamtion about the date where 
	--	data was imported should be stored in the database.
	--	Action:
	--	For new imported reports column "Imported" gets updated with the current date
	--------------------------------------------------------------------------------------

	update EPRTRmaster.dbo.POLLUTANTRELEASEANDTRANSFERREPORT 
	set Imported = CONVERT(varchar, GETDATE(), 100)
	where xmlReportID = 1 

	----------------------------------------------------------------------------------------
	----------------------- clean up and drop auxilary columns -----------------------------														
	----------------------------------------------------------------------------------------

	--exec [dbo].[add_aux_columns] @action = 'drop';
	print 'Data successfully exported to EPRTRmaster'

--END

--GO


