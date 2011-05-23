------------------------------------------------------------------------------
--	Initialize
------------------------------------------------------------------------------

--UPDATE EPRTRshapes.dbo.RBD SET geom = geom.MakeValid() WHERE geom.STIsValid() = 0;
--UPDATE EPRTRshapes.dbo.NUTS_RG SET geom = geom.MakeValid() WHERE geom.STIsValid() = 0;

--update RBD set MSCD_RBD = 'IEGBNIIENB'
--where MSCD_RBD = 'GBNIIENB' and CTY_ID = 'IE'

--update RBD set MSCD_RBD = 'IEGBNIIENW'
--where MSCD_RBD = 'GBNIIENW' and CTY_ID = 'IE'

------------------------------------------------------------------------------
--	Copy shape data into Master DB
------------------------------------------------------------------------------


if object_id('EPRTRmaster.dbo.NUTS_RG')is not null DROP TABLE EPRTRmaster.dbo.NUTS_RG
select * into EPRTRmaster.dbo.NUTS_RG
from EPRTRshapes.dbo.NUTS_RG

if object_id('EPRTRmaster.dbo.RBD')is not null DROP TABLE EPRTRmaster.dbo.RBD
select * into EPRTRmaster.dbo.RBD
from EPRTRshapes.dbo.RBD

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
where frep.LOV_StatusID = @LOV_UNDEFINED

--and pt.LOV_CountryID = 15
--and pt.ReportingYear = 2007

--select distinct LOV_StatusID, COUNT(*) from EPRTRmaster.dbo.FACILITYREPORT group by LOV_StatusID

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


--and pt.LOV_CountryID = 106
--and pt.ReportingYear = 2007

------------------------------------------------------------------------------
--	Test
------------------------------------------------------------------------------

--select 
--	c.Name, 
--	frep.LOV_NUTSRegionID, 
--	frep.LOV_RiverBasinDistrictID, 
--	frep.GeographicalCoordinate.STAsText(),
--	* 
--from EPRTRmaster.dbo.FACILITYREPORT frep 
--inner join 
--	EPRTRmaster.dbo.POLLUTANTRELEASEANDTRANSFERREPORT pt
--on	pt.PollutantReleaseAndTransferReportID = frep.PollutantReleaseAndTransferReportID
--inner join 
--	EPRTRmaster.dbo.LOV_COUNTRY c 
--on	c.LOV_CountryID = pt.LOV_CountryID
--where 
--	LOV_NUTSRegionID is null
--or	LOV_RiverBasinDistrictID = 197
--order by frep.GeographicalCoordinate.STAsText(),c.Name


------------------------------------------------------------------------------
--	load threshold into EPRTRshapes.dbo.PullutantThreshold_2
------------------------------------------------------------------------------

--if object_id('EPRTRshapes.dbo.PullutantThreshold_2')is not null DROP TABLE EPRTRshapes.dbo.PullutantThreshold_2
--go
--CREATE TABLE EPRTRshapes.dbo.PullutantThreshold_2		
--(
--	PollutantCode [nvarchar](255) not NULL,
--	MediumCode [nvarchar](255) NULL,
--	Value float null
--)

--insert into EPRTRshapes.dbo.PullutantThreshold_2
--select p.Code, m.Code, t.Column2 as Value 
--from 
--	EPRTRmaster.dbo.EPRTR_PollutantThreshold_2 t
--inner join
--	EPRTRmaster.dbo.LOV_POLLUTANT p
--on	ltrim(t.Column0) = p.Code
--inner join
--	EPRTRmaster.dbo.LOV_MEDIUM m
--on	ltrim(t.Column1) = m.Code 

