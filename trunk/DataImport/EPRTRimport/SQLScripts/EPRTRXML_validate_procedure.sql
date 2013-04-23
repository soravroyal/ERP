USE [EPRTRxml]
GO

/****** Object:  StoredProcedure [dbo].[validate_xml_data]    Script Date: 03/07/2012 15:33:05 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER OFF
GO

create procedure [dbo].[validate_xml_data]
as
begin

	declare 
		@txt1 nvarchar(255),
		@txt2 nvarchar(255),
		@txt3 nvarchar(255),
		@txt4 nvarchar(255)  

	declare @fac_count int
	set @fac_count = (select count(1) from EPRTRxml.dbo.facilityreport)

	print('Total number of facilities in report: '+ cast (@fac_count as nvarchar) +'')

	--Validating if previous nationalid can be found
	print('')
	print('Validating previous nationalids and previous reporting year given in xml file')

--------------------------------------------------------------------------------------
--	can previous nationalIDs be found in E-PRTR database
--------------------------------------------------------------------------------------

	if object_id('tempdb..#HAS_PREVIOUS_ID')is not null DROP TABLE #HAS_PREVIOUS_ID
	create table #HAS_PREVIOUS_ID(FacilityReportID int, FacilityID int,
		Err_NoPrevNatIdFound bit, 
		Err_DuppNatIdRef bit, 
		FacilityIdFound bit
	)

	exec EPRTRxml.dbo.SP_FindPreviousReferences

	insert into #HAS_PREVIOUS_ID
	select 
		a.FacilityReportID,0,1,null,null
	from EPRTRxml.dbo.FacilityReport a
	inner join
		EPRTRxml.dbo.PollutantReleaseAndTransferReport b
	on	a.PollutantReleaseAndTransferReportID = b.PollutantReleaseAndTransferReportID
	and b.reportingyear = a.prevreportingyear	
	where FacilityReportID not in (
		select  FacilityReportID 
		from #HAS_PREVIOUS_ID
	)

	if (select count(1) from #HAS_PREVIOUS_ID where Err_NoPrevNatIdFound = 1) = 0 
	print('All previous nationalIDs can be found in E-PRTR database')
	else
	begin
		DECLARE 
			fac_Cursor CURSOR FOR
			SELECT PrevNationalID, prevreportingyear
			FROM #HAS_PREVIOUS_ID t
				inner join EPRTRxml.dbo.FacilityReport fxml
			on fxml.FacilityReportID = t.FacilityReportID 
			where Err_NoPrevNatIdFound = 1 order by PrevNationalID
		OPEN fac_Cursor
		FETCH NEXT FROM fac_Cursor into @txt1,@txt2
		
		print('Previous nationalids that do not exist for the given previous reporting year')
		print('The listed facilities will be considered new facilities when imported into the EPRTR-system!')
		WHILE @@FETCH_STATUS = 0
		BEGIN
			print('Previous NationalID: ' + @txt1 + ' does not exist in the report from '+ @txt2)
			FETCH NEXT FROM fac_Cursor into @txt1,@txt2
		END
		CLOSE fac_Cursor
		DEALLOCATE fac_Cursor
	end


--------------------------------------------------------------------------------------
--	is a facility in a previous report referenced more than once
--------------------------------------------------------------------------------------

	print('')
	print('Validating if a facility in a previous report is referenced more than once in the new report')

	if (select count(1) from #HAS_PREVIOUS_ID where Err_DuppNatIdRef = 1) = 0 
	print('All previous facilities are only referenced once in the new report')
	else
	begin
		DECLARE 
			fac_Cursor CURSOR FOR
			SELECT t.FacilityReportID, NationalID, PrevNationalID, prevreportingyear
			FROM #HAS_PREVIOUS_ID t
				inner join EPRTRxml.dbo.FacilityReport fxml
			on fxml.FacilityReportID = t.FacilityReportID 
			where Err_DuppNatIdRef = 1 order by PrevNationalID
		OPEN fac_Cursor
		FETCH NEXT FROM fac_Cursor into @txt1,@txt2,@txt3,@txt4
		print('The following previous facilities are referenced more than once in the new report')
		print('These facilities will be imported into the EPRTR-system as new facilities!')
		WHILE @@FETCH_STATUS = 0
		BEGIN
		print('Internal FacilityID:' + @txt1 + ' NationalID:'+ @txt2 +' references PrevNationalID:' +@txt3+ ' in reporting year ' +@txt4 )
			FETCH NEXT FROM fac_Cursor into @txt1,@txt2,@txt3,@txt4
		END
		CLOSE fac_Cursor
		DEALLOCATE fac_Cursor
	end
 
 
--------------------------------------------------------------------------------------
--	Validating if previous nationalid returns multiple records
--------------------------------------------------------------------------------------

	print('')
	print('Validating if previous nationalid return multiple records')
	if object_id('EPRTRxml.dbo.validate_facility')is not null DROP TABLE EPRTRxml.dbo.validate_facility

	declare @validate_facility table( 
		FacilityReportID int,
		count_FacilityID int,
		PrevNationalID nvarchar(255)
		)

	insert into @validate_facility
	select 
		fxml.FacilityReportID,
		m.nb_FacilityID,
		fxml.PrevNationalID
	from (
		select
			count(FacilityID) as nb_FacilityID,
			NationalID, 
			ReportingYear,
			Code
		from 
			EPRTRmaster.dbo.vAT_FACILITY_ID_EXISTS
		group by
			NationalID, 
			ReportingYear,
			Code
	)m
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

	if (select count(1) from @validate_facility where count_FacilityID <> 1) = 0 
	print('No previous nationalids return multiple records')
	else
	begin
	DECLARE 
		fac_Cursor CURSOR FOR
		SELECT PrevNationalID, count_FacilityID 
		FROM @validate_facility
		WHERE count_facilityid <> 1 order by PrevNationalID;
	OPEN fac_Cursor;
	FETCH NEXT FROM fac_Cursor into @txt1,@txt2;
	print('Previous nationalids that return multiple records')
	WHILE @@FETCH_STATUS = 0
	BEGIN
	print('Previous NationalID: ' +@txt1 + ' Number of records: ' + @txt2)
	FETCH NEXT FROM fac_Cursor into @txt1,@txt2;
	END;
	CLOSE fac_Cursor;
	DEALLOCATE fac_Cursor;
	end
	if object_id('EPRTRxml.dbo.validate_facility')is not null DROP TABLE EPRTRxml.dbo.validate_facility


--------------------------------------------------------------------------------------
--	Validating if reported coordinates are within country polygons
--------------------------------------------------------------------------------------

	print('')
	print('Validating if reported coordinates are within country polygons')

	if object_id('EPRTRxml.dbo.validate_coordinates')is not null DROP TABLE EPRTRxml.dbo.validate_coordinates


	------------------------------------------------------------------------------
	--	Geo-coding of NUTS regions
	------------------------------------------------------------------------------

	declare @UNKNOWN int
	select @UNKNOWN = LOV_RiverBasinDistrictID 
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

	declare @LOV_UNDEFINED int
	select @LOV_UNDEFINED = LOV_StatusID  
		from EPRTRmaster.dbo.LOV_STATUS 
		where Code = 'OUTSIDE'

	declare @LOV_VALID int
	select @LOV_VALID = LOV_StatusID  
		from EPRTRmaster.dbo.LOV_STATUS 
		where Code = 'VALID'

	select  fr.nationalid,
	        fr.facilityname,
			pt.PollutantReleaseAndTransferReportID,
			geometry::STGeomFromText('POINT(' + 
			cast(fr.LongitudeMeasure as varchar(32)) + ' '+ 
			cast(fr.LatitudeMeasure as varchar(32)) + ')', 4326) as GeographicalCoordinate,
		case 
			when isnull(fr.LongitudeMeasure,0 ) = 0 then @LOV_M
			when isnull(fr.LatitudeMeasure,0 ) = 0 then @LOV_M
			else @LOV_O end as LOV_StatusID,
			null as LOV_NUTSRegionID,
			null as LOV_RiverBasinDistrictID
	into EPRTRxml.dbo.validate_coordinates
	from EPRTRxml.dbo.FACILITYREPORT fr
	inner join 
		EPRTRxml.dbo.POLLUTANTRELEASEANDTRANSFERREPORT pt
	on	pt.PollutantReleaseAndTransferReportID = fr.PollutantReleaseAndTransferReportID


	------------------------------------------------------------------------------
	--	Geo-coding of NUTS regions
	------------------------------------------------------------------------------
		
	update EPRTRxml.dbo.validate_coordinates
	set 
		LOV_NUTSRegionID = m.LOV_NUTSRegionID,
		LOV_StatusID = @LOV_VALID
	from EPRTRxml.dbo.validate_coordinates frep
	inner join 
		EPRTRxml.dbo.POLLUTANTRELEASEANDTRANSFERREPORT pt
	on	pt.PollutantReleaseAndTransferReportID = frep.PollutantReleaseAndTransferReportID 
	inner join
		EPRTRmaster.dbo.LOV_COUNTRY g
		on g.Code = pt.CountryID
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
		) m
	on	g.LOV_CountryID = m.LOV_CountryID
	and frep.GeographicalCoordinate.STWithin(m.Shape) = 1
	where frep.LOV_StatusID = @LOV_UNDEFINED


	------------------------------------------------------------------------------
	--	Geo-coding of river basin districts
	------------------------------------------------------------------------------

	update EPRTRxml.dbo.validate_coordinates
	set 
		LOV_RiverBasinDistrictID = m.LOV_RiverBasinDistrictID,
		LOV_StatusID = @LOV_VALID
	from EPRTRxml.dbo.validate_coordinates frep
	inner join 
		EPRTRxml.dbo.POLLUTANTRELEASEANDTRANSFERREPORT pt
	on	pt.PollutantReleaseAndTransferReportID = frep.PollutantReleaseAndTransferReportID
	inner join
		EPRTRmaster.dbo.LOV_COUNTRY g
		on g.Code = pt.CountryID
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
		) m
	on	g.LOV_CountryID = m.LOV_CountryID
	and frep.GeographicalCoordinate.STWithin(m.Shape) = 1
	where frep.LOV_StatusID in (@LOV_UNDEFINED, @LOV_VALID)

	if (
		select count(1) 
		from EPRTRxml.dbo.validate_coordinates
		WHERE 
			LOV_StatusID in (select LOV_StatusID from EPRTRmaster.dbo.LOV_STATUS where Code in( 'OUTSIDE','MISSING'))
		) = 0
	print('All reported coordinates are OK')
	else
	begin
		begin
		DECLARE fac_Cursor CURSOR FOR
			SELECT NationalID,facilityname, LOV_StatusID 
			FROM EPRTRxml.dbo.validate_coordinates
			WHERE LOV_StatusID in (select LOV_StatusID from EPRTRmaster.dbo.LOV_STATUS where Code in( 'OUTSIDE')) order by NationalID;
		OPEN fac_Cursor;
		FETCH NEXT FROM fac_Cursor into @txt1, @txt2, @txt3
		print('Facilities with coordinates outside country polygon')
		print('These facilities might be oil riggs, fish farms etc. placed outside the country')
		WHILE @@FETCH_STATUS = 0
		BEGIN
		print('NationalID: ' +@txt1 + '   Facilityname: ' +@txt2 + '')
		FETCH NEXT FROM fac_Cursor into @txt1, @txt2, @txt3;
		END;
		CLOSE fac_Cursor;
		DEALLOCATE fac_Cursor;
		end
	    begin
		DECLARE fac_Cursor CURSOR FOR
			SELECT NationalID,facilityname, LOV_StatusID 
			FROM EPRTRxml.dbo.validate_coordinates
			WHERE LOV_StatusID in (select LOV_StatusID from EPRTRmaster.dbo.LOV_STATUS where Code in( 'MISSING')) order by NationalID;
		OPEN fac_Cursor;
		FETCH NEXT FROM fac_Cursor into @txt1, @txt2, @txt3
		print('')
		print('Facilities with coordinates set to zero or not reported')
		print('')
		WHILE @@FETCH_STATUS = 0
		BEGIN
		print('NationalID: ' +@txt1 + '   Facilityname: ' +@txt2 + '')
		FETCH NEXT FROM fac_Cursor into @txt1, @txt2, @txt3;
		END;
		CLOSE fac_Cursor;
		DEALLOCATE fac_Cursor;
		end
	end
	if object_id('EPRTRxml.dbo.validate_coordinates')is not null DROP TABLE EPRTRxml.dbo.validate_coordinates

end
