------------------------------------------------------------------------------------------
--	The following script copys data from the EPRTR master database into the             --
--  EPRTR review database                                                               --
--																						-- 
--	If a Facilityreport is send for review for the first time, then the ForReview date	--
--	in tabel POLLUTANTRELEASEANDTRANSFERREPORT gets updated with the current timestamp.	--
--	This update is commited at the end of this script.									--
------------------------------------------------------------------------------------------

------------------------------------------------------------------------------
---------------------- sde enviromental settings -----------------------------
-------------------(only necessary when DB is created)------------------------
--use EPRTRweb
--CREATE USER [sde] FOR LOGIN [sde] WITH DEFAULT_SCHEMA=[sde]
--go
--CREATE SCHEMA [sde] AUTHORIZATION [sde]
--go
--
------------------------------------------------------------------------------

------------------------------------------------------------------------------
--	Initialize help tables
------------------------------------------------------------------------------

truncate table EPRTRmaster.dbo.tAT_ACTIVITYSEARCH_POLLUTANTRELEASE
exec EPRTRmaster.dbo.pAT_ACTIVITYSEARCH_POLLUTANTRELEASE

truncate table EPRTRmaster.dbo.tAT_WASTETRANSFER
exec EPRTRmaster.dbo.pAT_WASTETRANSFER

truncate table EPRTRmaster.dbo.tAT_WASTETRANSFER_RECEIVINGCOUNTRY
exec EPRTRmaster.dbo.pAT_WASTETRANSFER_RECEIVINGCOUNTRY
-- 13 sec

truncate table EPRTRmaster.dbo.tAT_CONFIDENTIALITY
exec EPRTRmaster.dbo.pAT_CONFIDENTIALITY
-- 13 sec

truncate table EPRTRmaster.dbo.tAT_FACILITY_POLLUTANTTRANSFER_YEAR
insert into EPRTRmaster.dbo.tAT_FACILITY_POLLUTANTTRANSFER_YEAR
select distinct
	FacilityID, 
	PollutantCode,
	ReportingYear
from EPRTRmaster.dbo.WEB_POLLUTANTTRANSFER

truncate table EPRTRmaster.dbo.tAT_FACILITY_POLLUTANTRELEASE_YEAR
insert into EPRTRmaster.dbo.tAT_FACILITY_POLLUTANTRELEASE_YEAR
select distinct
	FacilityID, 
	PollutantCode,
	ReportingYear
from EPRTRmaster.dbo.WEB_POLLUTANTRELEASE
-- 43 sec

truncate table EPRTRmaster.dbo.tAT_FACILITYSEARCH
insert into EPRTRmaster.dbo.tAT_FACILITYSEARCH
select * from EPRTRmaster.dbo.WEB_FACILITYSEARCH_MAINACTIVITY
-- 13 sec

------------------------------------------------------------------------------
--	upload data from WEB_FACILITYSEARCH views to web-DB 
------------------------------------------------------------------------------

if object_id('EPRTRweb.dbo.FACILITYSEARCH_MAINACTIVITY')is not null DROP TABLE EPRTRweb.dbo.FACILITYSEARCH_MAINACTIVITY
go
SELECT top 0 * INTO EPRTRweb.dbo.FACILITYSEARCH_MAINACTIVITY
FROM EPRTRmaster.dbo.WEB_FACILITYSEARCH_MAINACTIVITY
ALTER TABLE EPRTRweb.dbo.FACILITYSEARCH_MAINACTIVITY ADD PRIMARY KEY (FacilityReportID)
insert into EPRTRweb.dbo.FACILITYSEARCH_MAINACTIVITY
select * from EPRTRmaster.dbo.WEB_FACILITYSEARCH_MAINACTIVITY
go
-- 12 sec

if object_id('EPRTRweb.sde.FACILITYSEARCH_MAINACTIVITY_GEOGRAPHICALCOORDINATE')is not null DROP TABLE EPRTRweb.sde.FACILITYSEARCH_MAINACTIVITY_GEOGRAPHICALCOORDINATE
go
SELECT top 0 * INTO EPRTRweb.sde.FACILITYSEARCH_MAINACTIVITY_GEOGRAPHICALCOORDINATE
FROM EPRTRmaster.dbo.WEB_FACILITYSEARCH_MAINACTIVITY_GEOGRAPHICALCOORDINATE
ALTER TABLE EPRTRweb.sde.FACILITYSEARCH_MAINACTIVITY_GEOGRAPHICALCOORDINATE ADD PRIMARY KEY CLUSTERED (FacilityReportID)
insert into EPRTRweb.sde.FACILITYSEARCH_MAINACTIVITY_GEOGRAPHICALCOORDINATE
select * from EPRTRmaster.dbo.WEB_FACILITYSEARCH_MAINACTIVITY_GEOGRAPHICALCOORDINATE
ALTER TABLE EPRTRweb.sde.FACILITYSEARCH_MAINACTIVITY_GEOGRAPHICALCOORDINATE ADD ObjectID int identity(1,1) NOT NULL
go
--select * from EPRTRweb.sde.FACILITYSEARCH_MAINACTIVITY_GEOGRAPHICALCOORDINATE
-- 11 sec

if object_id('EPRTRweb.dbo.FACILITYSEARCH_POLLUTANT')is not null DROP TABLE EPRTRweb.dbo.FACILITYSEARCH_POLLUTANT
go
SELECT * INTO EPRTRweb.dbo.FACILITYSEARCH_POLLUTANT
FROM EPRTRmaster.dbo.WEB_FACILITYSEARCH_POLLUTANT
go
-- 1 sec

if object_id('EPRTRweb.dbo.FACILITYSEARCH_WASTETRANSFER')is not null DROP TABLE EPRTRweb.dbo.FACILITYSEARCH_WASTETRANSFER
go
SELECT * INTO EPRTRweb.dbo.FACILITYSEARCH_WASTETRANSFER
FROM EPRTRmaster.dbo.WEB_FACILITYSEARCH_WASTETRANSFER
go
-- 1 sec


------------------------------------------------------------------------------
--	upload FACILITYSEARCH_ALL to web-DB
------------------------------------------------------------------------------

if object_id('EPRTRweb.dbo.FACILITYSEARCH_ALL')is not null DROP TABLE EPRTRweb.dbo.FACILITYSEARCH_ALL
go
SELECT * INTO EPRTRweb.dbo.FACILITYSEARCH_ALL
FROM EPRTRmaster.dbo.WEB_FACILITYSEARCH_ALL
go
-- 9 sec
alter table EPRTRweb.dbo.FACILITYSEARCH_ALL ADD ObjectID int identity(1,1) NOT NULL
alter table EPRTRweb.dbo.FACILITYSEARCH_ALL ADD DistinctID bit not NULL default 0
alter table	EPRTRweb.dbo.FACILITYSEARCH_ALL add FacilitySearchName nvarchar(255) collate SQL_Latin1_General_Cp1253_CI_AI null
alter table	EPRTRweb.dbo.FACILITYSEARCH_ALL add CitySearchName nvarchar(255) collate SQL_Latin1_General_Cp1253_CI_AI null
alter table	EPRTRweb.dbo.FACILITYSEARCH_ALL add ParentCompanySearchName nvarchar(255) collate SQL_Latin1_General_Cp1253_CI_AI null
go

if object_id('tempdb..#DistinctFacilityReportID')is not null DROP TABLE #DistinctFacilityReportID
create table #DistinctFacilityReportID(frID int, oID int)
insert into #DistinctFacilityReportID
	select distinct 
		FacilityReportID, 
		min(ObjectID) as moID
	from EPRTRweb.dbo.FACILITYSEARCH_ALL
	group by FacilityReportID
go
-- 9 sec

update EPRTRweb.dbo.FACILITYSEARCH_ALL
set DistinctID = 1
from EPRTRweb.dbo.FACILITYSEARCH_ALL w
inner join 
	#DistinctFacilityReportID d
on	w.FacilityReportID = d.frID
and	w.ObjectID = d.oID
-- 2 sec

update EPRTRweb.dbo.FACILITYSEARCH_ALL
set 
	FacilitySearchName = FacilityName,
	CitySearchName = City,
	ParentCompanySearchName = ParentCompanyName
	
--select * from EPRTRweb.dbo.FACILITYSEARCH_ALL where ReportingYear = 2007 and WasteTreatmentCode = 'U'

------------------------------------------------------------------------------
--	upload FACILITYSEARCH_ALL_GEOGRAPHICALCOORDINATE to web-DB
------------------------------------------------------------------------------

if object_id('EPRTRweb.sde.FACILITYSEARCH_ALL_GEOGRAPHICALCOORDINATE')is not null DROP TABLE EPRTRweb.sde.FACILITYSEARCH_ALL_GEOGRAPHICALCOORDINATE
select * into EPRTRweb.sde.FACILITYSEARCH_ALL_GEOGRAPHICALCOORDINATE
from EPRTRweb.dbo.FACILITYSEARCH_ALL
go
-- 11 sec

alter table EPRTRweb.sde.FACILITYSEARCH_ALL_GEOGRAPHICALCOORDINATE ADD PRIMARY KEY CLUSTERED (ObjectID)
alter table EPRTRweb.sde.FACILITYSEARCH_ALL_GEOGRAPHICALCOORDINATE ADD GeographicalCoordinate geometry NULL
alter table EPRTRweb.sde.FACILITYSEARCH_ALL_GEOGRAPHICALCOORDINATE ADD CoordinateStatusCode nvarchar(255) NULL
go
-- 15 sec

update EPRTRweb.sde.FACILITYSEARCH_ALL_GEOGRAPHICALCOORDINATE 
set 
	GeographicalCoordinate = f.GeographicalCoordinate,
	CoordinateStatusCode = f.CoordinateStatusCode
from EPRTRweb.sde.FACILITYSEARCH_ALL_GEOGRAPHICALCOORDINATE p
inner join EPRTRweb.sde.FACILITYSEARCH_MAINACTIVITY_GEOGRAPHICALCOORDINATE f
on	f.FacilityReportID = p.FacilityReportID
-- 20 sec

--select * from EPRTRweb.sde.FACILITYSEARCH_ALL_GEOGRAPHICALCOORDINATE

------------------------------------------------------------------------------
--	upload WEB_FACILITYDETAIL views to web-DB
------------------------------------------------------------------------------

if object_id('EPRTRweb.dbo.FACILITYDETAIL_DETAIL')is not null DROP TABLE EPRTRweb.dbo.FACILITYDETAIL_DETAIL
SELECT * INTO EPRTRweb.dbo.FACILITYDETAIL_DETAIL
FROM EPRTRmaster.dbo.WEB_FACILITYDETAIL_DETAIL
-- 21 sec

if object_id('EPRTRweb.dbo.FACILITYDETAIL_COMPETENTAUTHORITYPARTY')is not null DROP TABLE EPRTRweb.dbo.FACILITYDETAIL_COMPETENTAUTHORITYPARTY
SELECT * INTO EPRTRweb.dbo.FACILITYDETAIL_COMPETENTAUTHORITYPARTY
FROM EPRTRmaster.dbo.WEB_FACILITYDETAIL_COMPETENTAUTHORITYPARTY
-- 1 sec

if object_id('EPRTRweb.dbo.FACILITYDETAIL_ACTIVITY')is not null DROP TABLE EPRTRweb.dbo.FACILITYDETAIL_ACTIVITY
go
SELECT top 0 * INTO EPRTRweb.dbo.FACILITYDETAIL_ACTIVITY
FROM EPRTRmaster.dbo.WEB_FACILITYDETAIL_ACTIVITY
alter table EPRTRweb.dbo.FACILITYDETAIL_ACTIVITY alter column MainActivityIndicator bit not null 
insert into EPRTRweb.dbo.FACILITYDETAIL_ACTIVITY
select * from EPRTRmaster.dbo.WEB_FACILITYDETAIL_ACTIVITY
-- 1 sec

if object_id('EPRTRweb.dbo.FACILITYDETAIL_POLLUTANTRELEASE')is not null DROP TABLE EPRTRweb.dbo.FACILITYDETAIL_POLLUTANTRELEASE
SELECT * INTO EPRTRweb.dbo.FACILITYDETAIL_POLLUTANTRELEASE
FROM EPRTRmaster.dbo.WEB_FACILITYDETAIL_POLLUTANTRELEASE
-- 5 sec

if object_id('EPRTRweb.dbo.FACILITYDETAIL_POLLUTANTTRANSFER')is not null DROP TABLE EPRTRweb.dbo.FACILITYDETAIL_POLLUTANTTRANSFER
SELECT * INTO EPRTRweb.dbo.FACILITYDETAIL_POLLUTANTTRANSFER
FROM EPRTRmaster.dbo.WEB_FACILITYDETAIL_POLLUTANTTRANSFER
-- 2 sec

if object_id('EPRTRweb.dbo.FACILITYDETAIL_WASTETRANSFER')is not null DROP TABLE EPRTRweb.dbo.FACILITYDETAIL_WASTETRANSFER
SELECT * INTO EPRTRweb.dbo.FACILITYDETAIL_WASTETRANSFER
FROM EPRTRmaster.dbo.WEB_FACILITYDETAIL_WASTETRANSFER
-- 5 sec


------------------------------------------------------------------------------
--	upload WEB_POLLUTANTRELEASE views to web-DB
------------------------------------------------------------------------------

if object_id('EPRTRweb.dbo.POLLUTANTRELEASE')is not null DROP TABLE EPRTRweb.dbo.POLLUTANTRELEASE
SELECT * INTO EPRTRweb.dbo.POLLUTANTRELEASE
FROM EPRTRmaster.dbo.WEB_POLLUTANTRELEASE
-- 0:25 min

if object_id('EPRTRweb.dbo.POLLUTANTRELEASE_COMPAREYEAR')is not null DROP TABLE EPRTRweb.dbo.POLLUTANTRELEASE_COMPAREYEAR
SELECT * INTO EPRTRweb.dbo.POLLUTANTRELEASE_COMPAREYEAR
FROM EPRTRmaster.dbo.WEB_POLLUTANTRELEASE_COMPAREYEAR
-- 53 min 

if object_id('EPRTRweb.sde.POLLUTANTRELEASE_GEOGRAPHICALCOORDINATE')is not null DROP TABLE EPRTRweb.sde.POLLUTANTRELEASE_GEOGRAPHICALCOORDINATE
SELECT * INTO EPRTRweb.sde.POLLUTANTRELEASE_GEOGRAPHICALCOORDINATE
FROM EPRTRweb.dbo.POLLUTANTRELEASE
-- 2 sec

alter table EPRTRweb.sde.POLLUTANTRELEASE_GEOGRAPHICALCOORDINATE ADD [Address] nvarchar(511)NULL
alter table EPRTRweb.sde.POLLUTANTRELEASE_GEOGRAPHICALCOORDINATE ADD City nvarchar(255)NULL
alter table EPRTRweb.sde.POLLUTANTRELEASE_GEOGRAPHICALCOORDINATE ADD PostalCode nvarchar(50)NULL
alter table EPRTRweb.sde.POLLUTANTRELEASE_GEOGRAPHICALCOORDINATE ADD GeographicalCoordinate geometry NULL
alter table EPRTRweb.sde.POLLUTANTRELEASE_GEOGRAPHICALCOORDINATE ADD CoordinateStatusCode nvarchar(255) NULL
alter table EPRTRweb.sde.POLLUTANTRELEASE_GEOGRAPHICALCOORDINATE ADD ObjectIDtemp int identity(1,1) NOT NULL
alter table EPRTRweb.sde.POLLUTANTRELEASE_GEOGRAPHICALCOORDINATE ADD ObjectID int NOT NULL default 0
go
-- 5 sec
--
		--alter table EPRTRweb.sde.POLLUTANTRELEASE_GEOGRAPHICALCOORDINATE ADD QuantityAirDivThreshold float NULL default 0
		--alter table EPRTRweb.sde.POLLUTANTRELEASE_GEOGRAPHICALCOORDINATE ADD QuantitySoilDivThreshold float NULL default 0
		--alter table EPRTRweb.sde.POLLUTANTRELEASE_GEOGRAPHICALCOORDINATE ADD QuantityWaterDivThreshold float NULL default 0
		--select MAX(QuantityAir) from EPRTRweb.sde.POLLUTANTRELEASE_GEOGRAPHICALCOORDINATE 
		--update EPRTRweb.sde.POLLUTANTRELEASE_GEOGRAPHICALCOORDINATE 
		--set QuantityAirDivThreshold =
		--	case when ISNULL(pt.Threshold,0 ) = 0 then p.QuantityAir
		--	else  p.QuantityAir / pt.Threshold end
		--from EPRTRweb.sde.POLLUTANTRELEASE_GEOGRAPHICALCOORDINATE p
		--inner join
		--	EPRTRweb.dbo.LOV_POLLUTANTTHRESHOLD pt
		--on pt.LOV_MediumID = (select LOV_MediumID from EPRTRweb.dbo.LOV_MEDIUM where code = 'AIR')
		--and pt.LOV_PollutantID = p.LOV_PollutantID

update EPRTRweb.sde.POLLUTANTRELEASE_GEOGRAPHICALCOORDINATE 
set 
	GeographicalCoordinate = f.GeographicalCoordinate,
	CoordinateStatusCode = f.CoordinateStatusCode,
	[Address] = f.Address,
	City = f.City,
	PostalCode = f.PostalCode
from EPRTRweb.sde.POLLUTANTRELEASE_GEOGRAPHICALCOORDINATE p
inner join 
	EPRTRweb.sde.FACILITYSEARCH_MAINACTIVITY_GEOGRAPHICALCOORDINATE f
on	f.FacilityReportID = p.FacilityReportID
-- 5 sec

update EPRTRweb.sde.POLLUTANTRELEASE_GEOGRAPHICALCOORDINATE 
set ObjectID = ObjectIDtemp
-- 2 sec

alter table EPRTRweb.sde.POLLUTANTRELEASE_GEOGRAPHICALCOORDINATE drop column ObjectIDtemp
alter table EPRTRweb.sde.POLLUTANTRELEASE_GEOGRAPHICALCOORDINATE ADD DistinctID bit not NULL default 0
alter table EPRTRweb.sde.POLLUTANTRELEASE_GEOGRAPHICALCOORDINATE ADD PRIMARY KEY CLUSTERED (ObjectID)
go
-- 7 sec

if object_id('tempdb..#DistinctFacilityReportID')is not null DROP TABLE #DistinctFacilityReportID
create table #DistinctFacilityReportID(frID int, oID int)
insert into #DistinctFacilityReportID
	select distinct 
		FacilityReportID, 
		min(ObjectID) as moID
	from EPRTRweb.sde.POLLUTANTRELEASE_GEOGRAPHICALCOORDINATE
	group by FacilityReportID
go
-- 1 sec

update EPRTRweb.sde.POLLUTANTRELEASE_GEOGRAPHICALCOORDINATE
set DistinctID = 1
from EPRTRweb.sde.POLLUTANTRELEASE_GEOGRAPHICALCOORDINATE w
inner join 
	#DistinctFacilityReportID d
on	w.FacilityReportID = d.frID
and	w.ObjectID = d.oID
-- 1 sec

--select * from EPRTRweb.sde.POLLUTANTRELEASE_GEOGRAPHICALCOORDINATE order by PercentAccidentalAir desc


------------------------------------------------------------------------------
--	upload WEB_POLLUTANTTRANSFER views to web-DB
------------------------------------------------------------------------------

if object_id('EPRTRweb.dbo.POLLUTANTTRANSFER')is not null DROP TABLE EPRTRweb.dbo.POLLUTANTTRANSFER
SELECT * INTO EPRTRweb.dbo.POLLUTANTTRANSFER
FROM EPRTRmaster.dbo.WEB_POLLUTANTTRANSFER
-- 4 sec

if object_id('EPRTRweb.dbo.POLLUTANTTRANSFER_COMPAREYEAR')is not null DROP TABLE EPRTRweb.dbo.POLLUTANTTRANSFER_COMPAREYEAR
SELECT * INTO EPRTRweb.dbo.POLLUTANTTRANSFER_COMPAREYEAR
FROM EPRTRmaster.dbo.WEB_POLLUTANTTRANSFER_COMPAREYEAR
-- 10 sec

if object_id('EPRTRweb.sde.POLLUTANTTRANSFER_GEOGRAPHICALCOORDINATE')is not null DROP TABLE EPRTRweb.sde.POLLUTANTTRANSFER_GEOGRAPHICALCOORDINATE
SELECT * INTO EPRTRweb.sde.POLLUTANTTRANSFER_GEOGRAPHICALCOORDINATE
FROM EPRTRweb.dbo.POLLUTANTTRANSFER

alter table EPRTRweb.sde.POLLUTANTTRANSFER_GEOGRAPHICALCOORDINATE ADD [Address] nvarchar(511)NULL
alter table EPRTRweb.sde.POLLUTANTTRANSFER_GEOGRAPHICALCOORDINATE ADD City nvarchar(255)NULL
alter table EPRTRweb.sde.POLLUTANTTRANSFER_GEOGRAPHICALCOORDINATE ADD PostalCode nvarchar(50)NULL
alter table EPRTRweb.sde.POLLUTANTTRANSFER_GEOGRAPHICALCOORDINATE ADD GeographicalCoordinate geometry NULL
alter table EPRTRweb.sde.POLLUTANTTRANSFER_GEOGRAPHICALCOORDINATE ADD CoordinateStatusCode nvarchar(255) NULL
alter table EPRTRweb.sde.POLLUTANTTRANSFER_GEOGRAPHICALCOORDINATE ADD ObjectIDtemp int identity(1,1) NOT NULL
alter table EPRTRweb.sde.POLLUTANTTRANSFER_GEOGRAPHICALCOORDINATE ADD ObjectID int NOT NULL default 0
go

update EPRTRweb.sde.POLLUTANTTRANSFER_GEOGRAPHICALCOORDINATE 
set 
	GeographicalCoordinate = f.GeographicalCoordinate,
	CoordinateStatusCode = f.CoordinateStatusCode,
	[Address] = f.Address,
	City = f.City,
	PostalCode = f.PostalCode
from EPRTRweb.sde.POLLUTANTTRANSFER_GEOGRAPHICALCOORDINATE p
inner join 
	EPRTRweb.sde.FACILITYSEARCH_MAINACTIVITY_GEOGRAPHICALCOORDINATE f
on	f.FacilityReportID = p.FacilityReportID

update EPRTRweb.sde.POLLUTANTTRANSFER_GEOGRAPHICALCOORDINATE 
set ObjectID = ObjectIDtemp

alter table EPRTRweb.sde.POLLUTANTTRANSFER_GEOGRAPHICALCOORDINATE drop column ObjectIDtemp
alter table EPRTRweb.sde.POLLUTANTTRANSFER_GEOGRAPHICALCOORDINATE ADD DistinctID bit not NULL default 0
alter table EPRTRweb.sde.POLLUTANTTRANSFER_GEOGRAPHICALCOORDINATE ADD PRIMARY KEY CLUSTERED (ObjectID)
go

if object_id('tempdb..#DistinctFacilityReportID')is not null DROP TABLE #DistinctFacilityReportID
create table #DistinctFacilityReportID(frID int, oID int)
insert into #DistinctFacilityReportID
	select distinct 
		FacilityReportID, 
		min(ObjectID) as moID
	from EPRTRweb.sde.POLLUTANTTRANSFER_GEOGRAPHICALCOORDINATE
	group by FacilityReportID
go

update EPRTRweb.sde.POLLUTANTTRANSFER_GEOGRAPHICALCOORDINATE
set DistinctID = 1
from EPRTRweb.sde.POLLUTANTTRANSFER_GEOGRAPHICALCOORDINATE w
inner join 
	#DistinctFacilityReportID d
on	w.FacilityReportID = d.frID
and	w.ObjectID = d.oID
--5 sec

--select * from EPRTRweb.sde.POLLUTANTTRANSFER_GEOGRAPHICALCOORDINATE order by 1


------------------------------------------------------------------------------
--	upload WEB_WASTETRANSFER views to web-DB
------------------------------------------------------------------------------

if object_id('EPRTRweb.dbo.WASTETRANSFER')is not null DROP TABLE EPRTRweb.dbo.WASTETRANSFER
SELECT * INTO EPRTRweb.dbo.WASTETRANSFER
FROM EPRTRmaster.dbo.WEB_WASTETRANSFER
-- 3 sec

if object_id('EPRTRweb.dbo.WASTETRANSFER_TREATMENT')is not null DROP TABLE EPRTRweb.dbo.WASTETRANSFER_TREATMENT
SELECT * INTO EPRTRweb.dbo.WASTETRANSFER_TREATMENT
FROM EPRTRmaster.dbo.WEB_WASTETRANSFER_TREATMENT
-- 3 sec

if object_id('EPRTRweb.dbo.WASTETRANSFER_RECEIVINGCOUNTRY')is not null DROP TABLE EPRTRweb.dbo.WASTETRANSFER_RECEIVINGCOUNTRY
SELECT * INTO EPRTRweb.dbo.WASTETRANSFER_RECEIVINGCOUNTRY
FROM EPRTRmaster.dbo.WEB_WASTETRANSFER_RECEIVINGCOUNTRY
-- 4 sec

if object_id('EPRTRweb.dbo.WASTETRANSFER_HAZARDOUSTREATERS')is not null DROP TABLE EPRTRweb.dbo.WASTETRANSFER_HAZARDOUSTREATERS
SELECT * INTO EPRTRweb.dbo.WASTETRANSFER_HAZARDOUSTREATERS
FROM EPRTRmaster.dbo.WEB_WASTETRANSFER_HAZARDOUSTREATERS
-- 3 sec

if object_id('EPRTRweb.dbo.WASTETRANSFER_CONFIDENTIAL')is not null DROP TABLE EPRTRweb.dbo.WASTETRANSFER_CONFIDENTIAL
SELECT * INTO EPRTRweb.dbo.WASTETRANSFER_CONFIDENTIAL
FROM EPRTRmaster.dbo.WEB_WASTETRANSFER_CONFIDENTIAL
-- 1 sec

----------------------------------------------------------------------------
--	upload dropdown views
------------------------------------------------------------------------------

if object_id('EPRTRweb.dbo.RECEIVINGCOUNTRY')is not null DROP TABLE EPRTRweb.dbo.RECEIVINGCOUNTRY
SELECT * INTO EPRTRweb.dbo.RECEIVINGCOUNTRY
FROM EPRTRmaster.dbo.WEB_RECEIVINGCOUNTRY

if object_id('EPRTRweb.dbo.REPORTINGYEAR')is not null DROP TABLE EPRTRweb.dbo.REPORTINGYEAR
SELECT * INTO EPRTRweb.dbo.REPORTINGYEAR
FROM EPRTRmaster.dbo.WEB_REPORTINGYEAR

if object_id('EPRTRweb.dbo.REPORTINGCOUNTRY')is not null DROP TABLE EPRTRweb.dbo.REPORTINGCOUNTRY
SELECT * INTO EPRTRweb.dbo.REPORTINGCOUNTRY
FROM EPRTRmaster.dbo.WEB_REPORTINGCOUNTRY

if object_id('EPRTRweb.dbo.REPORTING_ANNEXIACTIVITY')is not null DROP TABLE EPRTRweb.dbo.REPORTING_ANNEXIACTIVITY
SELECT * INTO EPRTRweb.dbo.REPORTING_ANNEXIACTIVITY
FROM EPRTRmaster.dbo.WEB_REPORTING_ANNEXIACTIVITY

if object_id('EPRTRweb.dbo.REPORTING_NACEACTIVITY')is not null DROP TABLE EPRTRweb.dbo.REPORTING_NACEACTIVITY
SELECT * INTO EPRTRweb.dbo.REPORTING_NACEACTIVITY
FROM EPRTRmaster.dbo.WEB_REPORTING_NACEACTIVITY

if object_id('EPRTRweb.dbo.REPORTING_POLLUTANT')is not null DROP TABLE EPRTRweb.dbo.REPORTING_POLLUTANT
SELECT * INTO EPRTRweb.dbo.REPORTING_POLLUTANT
FROM EPRTRmaster.dbo.WEB_REPORTING_POLLUTANT
-- 1 sec


------------------------------------------------------------------------------
--	upload LOVer
------------------------------------------------------------------------------

if object_id('EPRTRweb.dbo.LOV_ANNEXIACTIVITY')is not null DROP TABLE EPRTRweb.dbo.LOV_ANNEXIACTIVITY
SELECT * INTO EPRTRweb.dbo.LOV_ANNEXIACTIVITY
FROM EPRTRmaster.dbo.LOV_ANNEXIACTIVITY

if object_id('EPRTRweb.dbo.LOV_AREAGROUP')is not null DROP TABLE EPRTRweb.dbo.LOV_AREAGROUP
SELECT * INTO EPRTRweb.dbo.LOV_AREAGROUP
FROM EPRTRmaster.dbo.LOV_AREAGROUP

if object_id('EPRTRweb.dbo.LOV_CONFIDENTIALITY')is not null DROP TABLE EPRTRweb.dbo.LOV_CONFIDENTIALITY
SELECT * INTO EPRTRweb.dbo.LOV_CONFIDENTIALITY
FROM EPRTRmaster.dbo.LOV_CONFIDENTIALITY

if object_id('EPRTRweb.dbo.LOV_COORDINATESYSTEM')is not null DROP TABLE EPRTRweb.dbo.LOV_COORDINATESYSTEM
SELECT * INTO EPRTRweb.dbo.LOV_COORDINATESYSTEM
FROM EPRTRmaster.dbo.LOV_COORDINATESYSTEM

if object_id('EPRTRweb.dbo.LOV_COUNTRY')is not null DROP TABLE EPRTRweb.dbo.LOV_COUNTRY
SELECT * INTO EPRTRweb.dbo.LOV_COUNTRY
FROM EPRTRmaster.dbo.LOV_COUNTRY

if object_id('EPRTRweb.dbo.LOV_COUNTRYAREAGROUP')is not null DROP TABLE EPRTRweb.dbo.LOV_COUNTRYAREAGROUP
SELECT * INTO EPRTRweb.dbo.LOV_COUNTRYAREAGROUP
FROM EPRTRmaster.dbo.LOV_COUNTRYAREAGROUP

if object_id('EPRTRweb.dbo.LOV_MEDIUM')is not null DROP TABLE EPRTRweb.dbo.LOV_MEDIUM
SELECT * INTO EPRTRweb.dbo.LOV_MEDIUM
FROM EPRTRmaster.dbo.LOV_MEDIUM

if object_id('EPRTRweb.dbo.LOV_METHODBASIS')is not null DROP TABLE EPRTRweb.dbo.LOV_METHODBASIS
SELECT * INTO EPRTRweb.dbo.LOV_METHODBASIS
FROM EPRTRmaster.dbo.LOV_METHODBASIS

if object_id('EPRTRweb.dbo.LOV_METHODTYPE')is not null DROP TABLE EPRTRweb.dbo.LOV_METHODTYPE
SELECT * INTO EPRTRweb.dbo.LOV_METHODTYPE
FROM EPRTRmaster.dbo.LOV_METHODTYPE

if object_id('EPRTRweb.dbo.LOV_NACEACTIVITY')is not null DROP TABLE EPRTRweb.dbo.LOV_NACEACTIVITY
SELECT LOV_NACEActivityID,Code,Name,StartYear,EndYear,ParentID INTO EPRTRweb.dbo.LOV_NACEACTIVITY
FROM EPRTRmaster.dbo.LOV_NACEACTIVITY

if object_id('EPRTRweb.dbo.LOV_NUTSREGION')is not null DROP TABLE EPRTRweb.dbo.LOV_NUTSREGION
SELECT * INTO EPRTRweb.dbo.LOV_NUTSREGION
FROM EPRTRmaster.dbo.LOV_NUTSREGION
go
alter table EPRTRweb.dbo.LOV_NUTSREGION ADD Level int
go
update EPRTRweb.dbo.LOV_NUTSREGION
set Level = case 
				when L2Code is null and L3Code is null then 1  
				when L3Code is null then 2
				else 3
			end
from EPRTRweb.dbo.LOV_NUTSREGION LOV
inner join
	EPRTRmaster.dbo.vAT_NUTSREGION vAT
on LOV.LOV_NUTSRegionID = vAT.LOV_NUTSRegionID

if object_id('EPRTRweb.dbo.LOV_POLLUTANT')is not null DROP TABLE EPRTRweb.dbo.LOV_POLLUTANT
SELECT * INTO EPRTRweb.dbo.LOV_POLLUTANT
FROM EPRTRmaster.dbo.LOV_POLLUTANT

if object_id('EPRTRweb.dbo.LOV_POLLUTANTTHRESHOLD')is not null DROP TABLE EPRTRweb.dbo.LOV_POLLUTANTTHRESHOLD
SELECT * INTO EPRTRweb.dbo.LOV_POLLUTANTTHRESHOLD
FROM EPRTRmaster.dbo.LOV_POLLUTANTTHRESHOLD 

if object_id('EPRTRweb.dbo.LOV_RIVERBASINDISTRICT')is not null DROP TABLE EPRTRweb.dbo.LOV_RIVERBASINDISTRICT
SELECT * INTO EPRTRweb.dbo.LOV_RIVERBASINDISTRICT
FROM EPRTRmaster.dbo.LOV_RIVERBASINDISTRICT

if object_id('EPRTRweb.dbo.LOV_UNIT')is not null DROP TABLE EPRTRweb.dbo.LOV_UNIT
SELECT * INTO EPRTRweb.dbo.LOV_UNIT
FROM EPRTRmaster.dbo.LOV_UNIT

if object_id('EPRTRweb.dbo.LOV_WASTETHRESHOLD')is not null DROP TABLE EPRTRweb.dbo.LOV_WASTETHRESHOLD
SELECT * INTO EPRTRweb.dbo.LOV_WASTETHRESHOLD
FROM EPRTRmaster.dbo.LOV_WASTETHRESHOLD

if object_id('EPRTRweb.dbo.LOV_WASTETREATMENT')is not null DROP TABLE EPRTRweb.dbo.LOV_WASTETREATMENT
SELECT * INTO EPRTRweb.dbo.LOV_WASTETREATMENT
FROM EPRTRmaster.dbo.LOV_WASTETREATMENT

if object_id('EPRTRweb.dbo.LOV_WASTETYPE')is not null DROP TABLE EPRTRweb.dbo.LOV_WASTETYPE
SELECT * INTO EPRTRweb.dbo.LOV_WASTETYPE
FROM EPRTRmaster.dbo.LOV_WASTETYPE

--1 sec

------------------------------------------------------------------------------
--	update LOVer med shapes
------------------------------------------------------------------------------

--if object_id('EPRTRweb.sde.LOV_NUTSREGION_SHAPE')is not null DROP TABLE EPRTRweb.sde.LOV_NUTSREGION_SHAPE
--SELECT * INTO EPRTRweb.sde.LOV_NUTSREGION_SHAPE
--FROM EPRTRweb.dbo.LOV_NUTSREGION

--alter table EPRTRweb.sde.LOV_NUTSREGION_SHAPE ADD Shape geometry NULL
--alter table EPRTRweb.sde.LOV_NUTSREGION_SHAPE ADD PRIMARY KEY CLUSTERED (LOV_NUTSRegionID)
--GO
--update EPRTRweb.sde.LOV_NUTSREGION_SHAPE
--set Shape = nuts.geom
--from 
--	EPRTRweb.sde.LOV_NUTSREGION_SHAPE lov
--inner join
--	EPRTRshapes.dbo.NUTS_RG nuts
--on nuts.NUTS_ID = lov.Code
----select * from EPRTRweb.sde.LOV_NUTSREGION_SHAPE


--if object_id('EPRTRweb.sde.LOV_RIVERBASINDISTRICT_SHAPE')is not null DROP TABLE EPRTRweb.sde.LOV_RIVERBASINDISTRICT_SHAPE
--SELECT * INTO EPRTRweb.sde.LOV_RIVERBASINDISTRICT_SHAPE
--FROM EPRTRweb.dbo.LOV_RIVERBASINDISTRICT

--alter table EPRTRweb.sde.LOV_RIVERBASINDISTRICT_SHAPE ADD Shape geometry NULL
--alter table EPRTRweb.sde.LOV_RIVERBASINDISTRICT_SHAPE ADD PRIMARY KEY CLUSTERED (LOV_RiverbasindistrictID)
--GO
--update EPRTRweb.sde.LOV_RIVERBASINDISTRICT_SHAPE
--set Shape = rbd.geom
--from 
--	EPRTRweb.sde.LOV_RIVERBASINDISTRICT_SHAPE lov
--inner join
--	EPRTRshapes.dbo.RBD rbd
--on rbd.MSCD_RBD = lov.Code
----select * from EPRTRweb.sde.LOV_RIVERBASINDISTRICT_SHAPE
----20 sec


------------------------------------------------------------------------------------------
--	The following script generates indexes on selected tables
------------------------------------------------------------------------------------------

use EPRTRweb
go

IF EXISTS (SELECT name FROM sysindexes WHERE name = 'FACILITYSEARCH_MAINACTIVITY_INDEX')
   DROP INDEX FACILITYSEARCH_MAINACTIVITY.FACILITYSEARCH_MAINACTIVITY_INDEX
go
CREATE UNIQUE INDEX FACILITYSEARCH_MAINACTIVITY_INDEX
on	FACILITYSEARCH_MAINACTIVITY(
	ReportingYear desc, 
	LOV_CountryID, 
	FacilityReportID
)
go

IF EXISTS (SELECT name FROM sysindexes WHERE name = 'FACILITYSEARCH_MAINACTIVITY_GEOGRAPHICALCOORDINATE_INDEX')
	DROP INDEX FACILITYSEARCH_MAINACTIVITY_GEOGRAPHICALCOORDINATE_INDEX ON sde.FACILITYSEARCH_MAINACTIVITY_GEOGRAPHICALCOORDINATE
go
CREATE UNIQUE INDEX FACILITYSEARCH_MAINACTIVITY_GEOGRAPHICALCOORDINATE_INDEX 
on	sde.FACILITYSEARCH_MAINACTIVITY_GEOGRAPHICALCOORDINATE(
	ReportingYear desc, 
	LOV_CountryID, 
	FacilityReportID
)
go

IF EXISTS (SELECT name FROM sysindexes WHERE name = 'FACILITYSEARCH_MAINACTIVITY_SPI')
   DROP INDEX FACILITYSEARCH_MAINACTIVITY_SPI on sde.FACILITYSEARCH_MAINACTIVITY_GEOGRAPHICALCOORDINATE
go
CREATE SPATIAL INDEX FACILITYSEARCH_MAINACTIVITY_SPI
ON	sde.FACILITYSEARCH_MAINACTIVITY_GEOGRAPHICALCOORDINATE(GeographicalCoordinate)
USING 
	GEOMETRY_GRID
WITH (
	BOUNDING_BOX = (-63.1536409894401,-21.3898529982173,55.8367689986903,71.2021899785846),
	GRIDS = (medium, medium, medium, medium), CELLS_PER_OBJECT = 16
	)
go
 
IF EXISTS (SELECT name FROM sysindexes WHERE name = 'FACILITYSEARCH_POLLUTANT_INDEX')
	DROP INDEX FACILITYSEARCH_POLLUTANT_INDEX ON FACILITYSEARCH_POLLUTANT
go
CREATE INDEX FACILITYSEARCH_POLLUTANT_INDEX 
on FACILITYSEARCH_POLLUTANT(
	LOV_MediumID,
	LOV_PollutantID,
	FacilityReportID
)
go

IF EXISTS (SELECT name FROM sysindexes WHERE name = 'FACILITYSEARCH_WASTETRANSFER_INDEX')
	DROP INDEX FACILITYSEARCH_WASTETRANSFER_INDEX ON FACILITYSEARCH_WASTETRANSFER
go
CREATE UNIQUE INDEX FACILITYSEARCH_WASTETRANSFER_INDEX 
on FACILITYSEARCH_WASTETRANSFER(
	LOV_WasteTypeID,
	LOV_WasteTreatmentID,
	FacilityReportID,
	WasteTransferID
)
go

IF EXISTS (SELECT name FROM sysindexes WHERE name = 'FACILITYSEARCH_ALL_INDEX')
	DROP INDEX FACILITYSEARCH_ALL_INDEX ON FACILITYSEARCH_ALL
go
CREATE UNIQUE INDEX FACILITYSEARCH_ALL_INDEX 
on FACILITYSEARCH_ALL(
	ReportingYear,
	LOV_CountryID,
	LOV_MediumID,
	LOV_PollutantID,
	LOV_WasteTypeID,
	LOV_WasteTreatmentID,
	IDWaste,
	FacilityReportID
)

IF EXISTS (SELECT name FROM sysindexes WHERE name = 'FACILITYSEARCH_ALL_INDEX_CI_FPW')
	DROP INDEX FACILITYSEARCH_ALL_INDEX_CI_FPW ON FACILITYSEARCH_ALL
go
CREATE INDEX FACILITYSEARCH_ALL_INDEX_CI_FPW 
on FACILITYSEARCH_ALL(
	ReportingYear,
	ConfidentialIndicatorFacility,
	ConfidentialIndicatorPollutant,
	ConfidentialIndicatorWaste
)

IF EXISTS (SELECT name FROM sysindexes WHERE name = 'FACILITYSEARCH_ALL_INDEX_CI_FWP')
	DROP INDEX FACILITYSEARCH_ALL_INDEX_CI_FWP ON FACILITYSEARCH_ALL
go
CREATE INDEX FACILITYSEARCH_ALL_INDEX_CI_FWP 
on FACILITYSEARCH_ALL(
	ReportingYear,
	ConfidentialIndicatorFacility,
	ConfidentialIndicatorWaste,
	ConfidentialIndicatorPollutant
)

IF EXISTS (SELECT name FROM sysindexes WHERE name = 'FACILITYSEARCH_ALL_GEOGRAPHICALCOORDINATE_INDEX')
	DROP INDEX FACILITYSEARCH_ALL_GEOGRAPHICALCOORDINATE_INDEX ON sde.FACILITYSEARCH_ALL_GEOGRAPHICALCOORDINATE
go
CREATE UNIQUE INDEX FACILITYSEARCH_ALL_GEOGRAPHICALCOORDINATE_INDEX 
on sde.FACILITYSEARCH_ALL_GEOGRAPHICALCOORDINATE(
	ReportingYear,
	LOV_CountryID,
	LOV_MediumID,
	LOV_PollutantID,
	LOV_WasteTypeID,
	LOV_WasteTreatmentID,
	IDWaste,
	FacilityReportID
)
go

--select * from EPRTRweb.dbo.FACILITYSEARCH_MAINACTIVITY
--select * from EPRTRweb.sde.FACILITYSEARCH_MAINACTIVITY_GEOGRAPHICALCOORDINATE
--select * from EPRTRweb.dbo.FACILITYSEARCH_POLLUTANT where FacilityReportID = 17116 and LOV_PollutantID = 27
--select * from EPRTRweb.dbo.FACILITYSEARCH_WASTETRANSFER
--select * from EPRTRweb.dbo.FACILITYSEARCH_ALL
--select * from EPRTRweb.sde.FACILITYSEARCH_ALL_GEOGRAPHICALCOORDINATE

----------------------------------------------------------


IF EXISTS (SELECT name FROM sysindexes WHERE name = 'FACILITYDETAIL_DETAIL_INDEX')
	DROP INDEX FACILITYDETAIL_DETAIL_INDEX ON FACILITYDETAIL_DETAIL
go
CREATE UNIQUE INDEX FACILITYDETAIL_DETAIL_INDEX 
on FACILITYDETAIL_DETAIL(
	FacilityReportID
)
go

IF EXISTS (SELECT name FROM sysindexes WHERE name = 'FACILITYDETAIL_COMPETENTAUTHORITYPARTY_INDEX')
	DROP INDEX FACILITYDETAIL_COMPETENTAUTHORITYPARTY_INDEX ON FACILITYDETAIL_COMPETENTAUTHORITYPARTY
go
CREATE UNIQUE INDEX FACILITYDETAIL_COMPETENTAUTHORITYPARTY_INDEX 
on FACILITYDETAIL_COMPETENTAUTHORITYPARTY(
	FacilityReportID
)
go

IF EXISTS (SELECT name FROM sysindexes WHERE name = 'FACILITYDETAIL_ACTIVITY_INDEX')
	DROP INDEX FACILITYDETAIL_ACTIVITY_INDEX ON FACILITYDETAIL_ACTIVITY
go
CREATE UNIQUE INDEX FACILITYDETAIL_ACTIVITY_INDEX 
on FACILITYDETAIL_ACTIVITY(
	ActivityCode,
	FacilityReportID,
	RankingNumeric
)
go

IF EXISTS (SELECT name FROM sysindexes WHERE name = 'FACILITYDETAIL_POLLUTANTRELEASE_INDEX')
	DROP INDEX FACILITYDETAIL_POLLUTANTRELEASE_INDEX ON FACILITYDETAIL_POLLUTANTRELEASE
go
CREATE INDEX FACILITYDETAIL_POLLUTANTRELEASE_INDEX 
on FACILITYDETAIL_POLLUTANTRELEASE(
	LOV_MediumID,
	LOV_PollutantID,
	MethodTypeCode,
	FacilityReportID
)
go

IF EXISTS (SELECT name FROM sysindexes WHERE name = 'FACILITYDETAIL_POLLUTANTTRANSFER_INDEX')
	DROP INDEX FACILITYDETAIL_POLLUTANTTRANSFER_INDEX ON FACILITYDETAIL_POLLUTANTTRANSFER
go
CREATE INDEX FACILITYDETAIL_POLLUTANTTRANSFER_INDEX 
on FACILITYDETAIL_POLLUTANTTRANSFER(
	LOV_PollutantID,
	MethodTypeCode,
	FacilityReportID
)
go

IF EXISTS (SELECT name FROM sysindexes WHERE name = 'FACILITYDETAIL_WASTETRANSFER_INDEX')
	DROP INDEX FACILITYDETAIL_WASTETRANSFER_INDEX ON FACILITYDETAIL_WASTETRANSFER
go
CREATE INDEX FACILITYDETAIL_WASTETRANSFER_INDEX 
on FACILITYDETAIL_WASTETRANSFER(
	LOV_WasteTypeID,
	LOV_WasteTreatmentID,
	LOV_MethodBasisID,
	FacilityReportID
)
go

--select * from EPRTRweb.dbo.FACILITYDETAIL_DETAIL
--select * from EPRTRweb.dbo.FACILITYDETAIL_COMPETENTAUTHORITYPARTY
--select * from EPRTRweb.dbo.FACILITYDETAIL_ACTIVITY
--select * from EPRTRweb.dbo.FACILITYDETAIL_POLLUTANTRELEASE
--select * from EPRTRweb.dbo.FACILITYDETAIL_POLLUTANTTRANSFER
--select * from EPRTRweb.dbo.FACILITYDETAIL_WASTETRANSFER

----------------------------------------------------------

--select * from EPRTRweb.dbo.ACTIVITYSEARCH_MAINACTIVITY
--select * from EPRTRweb.dbo.ACTIVITYSEARCH_POLLUTANTRELEASE
--select * from EPRTRweb.dbo.ACTIVITYSEARCH_POLLUTANTTRANSFER

----------------------------------------------------------

IF EXISTS (SELECT name FROM sysindexes WHERE name = 'POLLUTANTRELEASE_INDEX')
	DROP INDEX POLLUTANTRELEASE_INDEX ON POLLUTANTRELEASE
go
CREATE UNIQUE CLUSTERED INDEX POLLUTANTRELEASE_INDEX 
ON POLLUTANTRELEASE (
	ReportingYear desc, 
	LOV_CountryID, 
	LOV_PollutantID, 
	FacilityReportID
)
go

IF EXISTS (SELECT name FROM sysindexes WHERE name = 'POLLUTANTRELEASE_INDEX_CI')
	DROP INDEX POLLUTANTRELEASE_INDEX_CI ON POLLUTANTRELEASE
go
CREATE INDEX POLLUTANTRELEASE_INDEX_CI 
ON POLLUTANTRELEASE (
	ReportingYear desc, 
	ConfidentialIndicator,
	ConfidentialIndicatorFacility
)
go

IF EXISTS (SELECT name FROM sysindexes WHERE name = 'POLLUTANTRELEASE_GEOGRAPHICALCOORDINATE_INDEX')
	DROP INDEX POLLUTANTRELEASE_GEOGRAPHICALCOORDINATE_INDEX ON sde.POLLUTANTRELEASE_GEOGRAPHICALCOORDINATE
go
CREATE UNIQUE INDEX POLLUTANTRELEASE_GEOGRAPHICALCOORDINATE_INDEX 
ON sde.POLLUTANTRELEASE_GEOGRAPHICALCOORDINATE (
	ReportingYear desc, 
	LOV_CountryID, 
	LOV_PollutantID, 
	FacilityReportID
)
go

IF EXISTS (SELECT name FROM sysindexes WHERE name = 'POLLUTANTRELEASE_SPI')
	DROP INDEX POLLUTANTRELEASE_SPI ON sde.POLLUTANTRELEASE_GEOGRAPHICALCOORDINATE
go
CREATE SPATIAL INDEX POLLUTANTRELEASE_SPI
ON sde.POLLUTANTRELEASE_GEOGRAPHICALCOORDINATE(GeographicalCoordinate)
USING GEOMETRY_GRID
WITH (
		BOUNDING_BOX = (-63.1536409894401,-21.3898529982173,55.8367689986903,71.2021899785846),
		GRIDS = (medium, medium, medium, medium), CELLS_PER_OBJECT = 16
	)

IF EXISTS (SELECT name FROM sysindexes WHERE name = 'POLLUTANTTRANSFER_INDEX')
	DROP INDEX POLLUTANTTRANSFER_INDEX ON POLLUTANTTRANSFER
go
CREATE UNIQUE CLUSTERED INDEX POLLUTANTTRANSFER_INDEX 
ON POLLUTANTTRANSFER (
	ReportingYear desc, 
	LOV_CountryID, 
	LOV_PollutantID, 
	FacilityReportID
)
go

IF EXISTS (SELECT name FROM sysindexes WHERE name = 'POLLUTANTTRANSFER_INDEX_CI')
	DROP INDEX POLLUTANTTRANSFER_INDEX_CI ON POLLUTANTTRANSFER
go
CREATE INDEX POLLUTANTTRANSFER_INDEX_CI 
ON POLLUTANTTRANSFER (
	ReportingYear desc, 
	ConfidentialIndicator,
	ConfidentialIndicatorFacility
)
go

IF EXISTS (SELECT name FROM sysindexes WHERE name = 'POLLUTANTTRANSFER_GEOGRAPHICALCOORDINATE_INDEX')
	DROP INDEX POLLUTANTTRANSFER_GEOGRAPHICALCOORDINATE_INDEX ON sde.POLLUTANTTRANSFER_GEOGRAPHICALCOORDINATE
go
CREATE UNIQUE INDEX POLLUTANTTRANSFER_GEOGRAPHICALCOORDINATE_INDEX 
ON sde.POLLUTANTTRANSFER_GEOGRAPHICALCOORDINATE (
	ReportingYear desc, 
	LOV_CountryID, 
	LOV_PollutantID, 
	FacilityReportID
)
go

IF EXISTS (SELECT name FROM sysindexes WHERE name = 'POLLUTANTTRANSFER_SPI')
	DROP INDEX POLLUTANTTRANSFER_SPI ON sde.POLLUTANTTRANSFER_GEOGRAPHICALCOORDINATE
go
CREATE SPATIAL INDEX POLLUTANTTRANSFER_SPI
ON	sde.POLLUTANTTRANSFER_GEOGRAPHICALCOORDINATE(GeographicalCoordinate)
USING GEOMETRY_GRID
WITH (
	BOUNDING_BOX = (-63.1536409894401,-21.3898529982173,55.8367689986903,71.2021899785846),
	GRIDS = (medium, medium, medium, medium), CELLS_PER_OBJECT = 16
	)

--select * from EPRTRweb.dbo.POLLUTANTRELEASE
--select * from EPRTRweb.dbo.POLLUTANTRELEASE_COMPAREYEAR
--select * from EPRTRweb.sde.POLLUTANTRELEASE_GEOGRAPHICALCOORDINATE
--select * from EPRTRweb.dbo.POLLUTANTTRANSFER
--select * from EPRTRweb.dbo.POLLUTANTTRANSFER_COMPAREYEAR
--select * from EPRTRweb.sde.POLLUTANTTRANSFER_GEOGRAPHICALCOORDINATE
----------------------------------------------------------

IF EXISTS (SELECT name FROM sysindexes WHERE name = 'WASTETRANSFER_INDEX')
	DROP INDEX WASTETRANSFER_INDEX ON WASTETRANSFER
go
CREATE UNIQUE CLUSTERED INDEX WASTETRANSFER_INDEX 
on WASTETRANSFER(
	ReportingYear,
	LOV_CountryID,
	FacilityReportID
)
go

IF EXISTS (SELECT name FROM sysindexes WHERE name = 'WASTETRANSFER_INDEX_CI')
	DROP INDEX WASTETRANSFER_INDEX_CI ON WASTETRANSFER
go
CREATE INDEX WASTETRANSFER_INDEX_CI 
on WASTETRANSFER(
	ReportingYear,
	ConfidentialIndicatorWaste,
	ConfidentialIndicatorFacility
)

IF EXISTS (SELECT name FROM sysindexes WHERE name = 'WASTETRANSFER_TREATMENT_INDEX')
	DROP INDEX WASTETRANSFER_TREATMENT_INDEX ON WASTETRANSFER_TREATMENT
go
CREATE CLUSTERED INDEX WASTETRANSFER_TREATMENT_INDEX 
on WASTETRANSFER_TREATMENT(
	ReportingYear,
	LOV_CountryID,
	FacilityReportID,
	WasteTypeCode	
)
go

IF EXISTS (SELECT name FROM sysindexes WHERE name = 'WASTETRANSFER_RECEIVINGCOUNTRY_INDEX')
	DROP INDEX WASTETRANSFER_RECEIVINGCOUNTRY_INDEX ON WASTETRANSFER_RECEIVINGCOUNTRY
go
CREATE CLUSTERED INDEX WASTETRANSFER_RECEIVINGCOUNTRY_INDEX 
on WASTETRANSFER_RECEIVINGCOUNTRY(
	ReportingYear,
	LOV_CountryID,
	ReceivingCountryCode,
	FacilityReportID
)
go

IF EXISTS (SELECT name FROM sysindexes WHERE name = 'WASTETRANSFER_HAZARDOUSTREATERS_INDEX')
	DROP INDEX WASTETRANSFER_HAZARDOUSTREATERS_INDEX ON WASTETRANSFER_HAZARDOUSTREATERS
go
CREATE CLUSTERED INDEX WASTETRANSFER_HAZARDOUSTREATERS_INDEX 
on WASTETRANSFER_HAZARDOUSTREATERS(
	ReportingYear,
	LOV_CountryID,
	WHPPostalCode,
	FacilityReportID
)
go

IF EXISTS (SELECT name FROM sysindexes WHERE name = 'WASTETRANSFER_CONFIDENTIAL_INDEX')
	DROP INDEX WASTETRANSFER_CONFIDENTIAL_INDEX ON WASTETRANSFER_CONFIDENTIAL
go
CREATE CLUSTERED INDEX WASTETRANSFER_CONFIDENTIAL_INDEX 
on WASTETRANSFER_CONFIDENTIAL(
	ReportingYear,
	LOV_CountryID,
	LOV_WasteTypeID,
	LOV_ConfidentialityID,
	FacilityReportID
)
go

--select * from EPRTRweb.dbo.WASTETRANSFER
--select * from EPRTRweb.dbo.WASTETRANSFER_TREATMENT
--select * from EPRTRweb.dbo.WASTETRANSFER_RECEIVINGCOUNTRY
--select * from EPRTRweb.dbo.WASTETRANSFER_HAZARDOUSTREATERS
--select * from EPRTRweb.dbo.WASTETRANSFER_CONFIDENTIAL


------------------------------------------------------------------------------
--	set Published date
------------------------------------------------------------------------------

	--------------------------------------------------------------------------------------
	--	Ticket #753:
	--	The database currently only holds information about the "Published" date. 
	--	This information is set automatically.
	--	This should be changed so the published date can be set manually to the date where data 
	--	are to be published on the website. In addition, the inforamtion about the date where 
	--	data was imported should be stored in the database.
	--	Action:
	--	Published date must be set manually
	--------------------------------------------------------------------------------------

declare @published datetime = '2010-01-01 01:01:00.000'

update EPRTRmaster.dbo.POLLUTANTRELEASEANDTRANSFERREPORT
set
	Published = @published
from
	EPRTRmaster.dbo.POLLUTANTRELEASEANDTRANSFERREPORT prtr
inner join (
	select distinct
		ReportingYear,
		LOV_CountryID,
		max(CdrReleased) as LatestReleased
	from 
		EPRTRmaster.dbo.POLLUTANTRELEASEANDTRANSFERREPORT prtr1
	group by 
		ReportingYear,
		LOV_CountryID
) m
on	m.LOV_CountryID = prtr.LOV_CountryID
and m.ReportingYear = prtr.ReportingYear
and m.LatestReleased = prtr.CdrReleased
where
	prtr.Published is null
go


----------------------------------------------------------------------------
--	set ForReview date
------------------------------------------------------------------------------

/*
update EPRTRmaster.dbo.POLLUTANTRELEASEANDTRANSFERREPORT
set
	ForReview = CONVERT(varchar, GETDATE(), 100)
from
	EPRTRmaster.dbo.POLLUTANTRELEASEANDTRANSFERREPORT prtr
inner join (
	select distinct
		ReportingYear,
		LOV_CountryID,
		max(CdrReleased) as LatestReleased
	from 
		EPRTRmaster.dbo.POLLUTANTRELEASEANDTRANSFERREPORT prtr1
	group by 
		ReportingYear,
		LOV_CountryID
) m
on	m.LOV_CountryID = prtr.LOV_CountryID
and m.ReportingYear = prtr.ReportingYear
and m.LatestReleased = prtr.CdrReleased
where 
	prtr.ForReview is null
go
*/
--select * from EPRTRmaster.dbo.POLLUTANTRELEASEANDTRANSFERREPORT prtr

if object_id('EPRTRweb.dbo.LATEST_DATAIMPORT')is not null DROP TABLE EPRTRweb.dbo.LATEST_DATAIMPORT

select ReportingYear, LOV_CountryID, ForReview, Published
into EPRTRweb.dbo.LATEST_DATAIMPORT	
from EPRTRmaster.dbo.vAT_POLLUTANTRELEASEANDTRANSFERREPORT























