declare @UNKNOWN_NUTS int
select @UNKNOWN_NUTS = LOV_NUTSRegionID 
	from EPRTRmaster.dbo.LOV_NUTSREGION
	where Code = 'UNKNOWN'

update FACILITYREPORT
	set LOV_NUTSRegionID = @UNKNOWN_NUTS
where LOV_NUTSRegionID is null