------------------------------------------------------------------------------------------
--	The following script copys data from the EPER to the EPRTR Database                 --
--                                                                                      --
--  Source tables in EPER:		Report                                                  --
--								Facility												--
--								AnnexIActivity											--
--								Activity												--
--								Emission												--
--  Target tables in EPRTR:		POLLUTANTRELEASEANDTRANSFERREPORT                       --
--								ADDRESS                                                 -- 
--								FACILITY                                                --
--								FACILITYLOG                                             --
--								PRODUCTIONVOLUME                                        --
--								LOV_RIVERBASINDISTRICT                                  --
--								LOV_UNIT                                                --
--								COMPETENTAUTHORITYPARTY                                 --
--								FACILITYREPORT                                          -- 
--								POLLUTANTRELEASE										--
--								ACTIVITY												--
--								LOV_ANNEXIACTIVITY										--
--								POLLUTANTTRANSFER										--
--								LOV_POLLUTANT											--
--                                                                                      --
-- In the EPRTR database all index keys are generated automatically. Under the			--
-- transformation process of data from the EPER database to the EPRTR database it is	--
-- necessary to keep trace of index keys used by EPER. Thus additional auxiliary		--
-- columns are added to selected tables in the EPRTR database. Once the transformation	--
-- process has terminated, these columns get deleted again. Before being deleted this	--
-- index key relations are saved into a special dedicated table for historical reason.	--
--																						--
------------------------------------------------------------------------------------------

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

------------------------------------------------------------------------------------------
---------------------------------- add tables and columns --------------------------------
------------------------------------------------------------------------------------------

if object_id('EPRTRmaster.dbo.EPERCONTRACTINFORMATION')is not null DROP TABLE EPRTRmaster.dbo.[EPERCONTRACTINFORMATION]
CREATE TABLE EPRTRmaster.dbo.EPERCONTRACTINFORMATION		
(
	eperFacilityID [int] not null,
	RegulatoryBodies  [nvarchar](255) NULL,
	ContactName  [nvarchar](255) NULL,
	Phonenumber  [nvarchar](50) NULL,
	FaxNumber  [nvarchar](50) NULL,
	Email  [nvarchar](255) NULL
)
if object_id('EPRTRmaster.dbo.EPER_TO_EPRTR_IDS')is not null DROP TABLE EPRTRmaster.dbo.EPER_TO_EPRTR_IDS
CREATE TABLE EPRTRmaster.dbo.EPER_TO_EPRTR_IDS		
(
	TableName  [nvarchar](255) NULL,
	EPRTRID  [int] NULL,
	EPERID  [int] NULL
)

if not exists ( select * from EPRTRmaster.INFORMATION_SCHEMA.COLUMNS
	where TABLE_NAME='POLLUTANTRELEASEANDTRANSFERREPORT' and COLUMN_NAME='eperReportID' )
alter table EPRTRmaster.dbo.POLLUTANTRELEASEANDTRANSFERREPORT add eperReportID int

if not exists ( select * from EPRTRmaster.INFORMATION_SCHEMA.COLUMNS
	where TABLE_NAME='ADDRESS' and COLUMN_NAME='eperFacilityID' )
alter table EPRTRmaster.dbo.ADDRESS add eperFacilityID int

if not exists ( select * from EPRTRmaster.INFORMATION_SCHEMA.COLUMNS
	where TABLE_NAME='FACILITYLOG' and COLUMN_NAME='eperFacilityID' )
alter table EPRTRmaster.dbo.FACILITYLOG add eperFacilityID int

if not exists ( select * from EPRTRmaster.INFORMATION_SCHEMA.COLUMNS
	where TABLE_NAME='PRODUCTIONVOLUME' and COLUMN_NAME='eperFacilityID' )
alter table EPRTRmaster.dbo.PRODUCTIONVOLUME add eperFacilityID int

if not exists ( select * from EPRTRmaster.INFORMATION_SCHEMA.COLUMNS
	where TABLE_NAME='FACILITYREPORT' and COLUMN_NAME='eperFacilityID' )
alter table EPRTRmaster.dbo.FACILITYREPORT add eperFacilityID int

if not exists ( select * from EPRTRmaster.INFORMATION_SCHEMA.COLUMNS
	where TABLE_NAME='LOV_ANNEXIACTIVITY' and COLUMN_NAME='eperAnnex3_ID' )
alter table EPRTRmaster.dbo.LOV_ANNEXIACTIVITY add eperAnnex3_ID int

if not exists ( select * from EPRTRmaster.INFORMATION_SCHEMA.COLUMNS
	where TABLE_NAME='LOV_POLLUTANT' and COLUMN_NAME='eperPollutant_ID' )
alter table EPRTRmaster.dbo.LOV_POLLUTANT add eperPollutant_ID int

go


------------------------------------------------------------------------------------------
------------------------- fill POLLUTANTRELEASEANDTRANSFERREPORT -------------------------
------------------------------------------------------------------------------------------

declare @countryCode char(2)
declare @dtnow datetime
declare @dt0 datetime
declare @dt1 datetime
declare @dt2 datetime
declare @dt3 datetime
set @dtnow = GETDATE()
set @dt0 = cast ('2000-01-01 00:00:00.000' as datetime)
set @dt1 = cast ('2004-02-23 00:00:00.000' as datetime)
set @dt2 = cast ('2005-03-31 00:00:00.000' as datetime)
set @dt3 = cast ('2006-11-23 00:00:00.000' as datetime)

declare @LOV_ID int
select @LOV_ID = LOV_StatusID  
	from EPRTRmaster.dbo.LOV_STATUS 
	where Code = 'PUBLISHED'

insert into EPRTRmaster.dbo.POLLUTANTRELEASEANDTRANSFERREPORT
select
	ReportYear as ReportingYear,
	LOV_CountryID as LOV_CountryID,
	LOV_CoordinateSystemID as LOV_CoordinateSystemID,
	Comment as RemarkText,
	'Transferred from EPER' as CdrUrl,
	SubmissionDate as CdrUploaded,
	SubmissionDate as CdrReleased,
	case
		when isnull(Datestamp,@dt0)= @dt0 then 
			case 
				when isnull(SubmissionDate,@dt0) < @dt1 then @dt1 
				when isnull(SubmissionDate,@dtnow) >= '2006-01-01' then @dt3 
				else @dt2
			end 
		else Datestamp
		end as ForReview,
	case
		when isnull(Datestamp,@dt0)= @dt0 then 
			case 
				when isnull(SubmissionDate,@dt0) < @dt1 then @dt1 
				when isnull(SubmissionDate,@dtnow) >= '2006-01-01' then @dt3 
				else @dt2
			end 
		else Datestamp
		end as Published,
	null as ResubmitReason,
	null as LOV_StatusID,
	ReportID as eperFacilityID
from sdeims_eper.dbo.Report
inner join 
	EPRTRmaster.dbo.LOV_COUNTRY
on	CountryID collate database_default = Code
inner join (
	select
		distinct CountryID as ID, 
		GeographicCoordinateSystem as geoCord
	from sdeims_eper.dbo.Facility f 
	inner join sdeims_eper.dbo.Report r
	on	f.ReportID = r.ReportID
	) as m
on CountryID collate database_default = m.ID
inner join
	EPRTRmaster.dbo.LOV_COORDINATESYSTEM c
on substring(m.geoCord collate database_default,0,4) = substring(c.Name,0,4)

--select * from EPRTRmaster.dbo.POLLUTANTRELEASEANDTRANSFERREPORT


------------------------------------------------------------------------------------------
------------------------------------- fill ADDRESS ---------------------------------------
------------------------------------------------------------------------------------------

insert into EPRTRmaster.dbo.ADDRESS			--copy addresses from FACILITY
select 
	f.Address as StreetName,
	null as BuildingNumber,
	f.City as City,
	f.PostCode as PostalCode,
	c.LOV_CountryID as LOV_CountryID,
	f.FacilityID as eperFacilityID
from sdeims_eper.dbo.FACILITY f
inner join 
	sdeims_eper.dbo.Report r 
on	r.ReportID = f.ReportID
inner join 
	EPRTRmaster.dbo.LOV_COUNTRY c
on	CountryID collate database_default = Code

insert into EPRTRmaster.dbo.ADDRESS			--generte dummy addresses for COMPETENTAUTHORITYPARTY
select distinct
	NULL as StreetName,
	NULL  as BuildingNumber,
	NULL as City,
	NULL as PostalCode,
	c.LOV_CountryID as LOV_CountryID,
	NULL as eperFacilityID
from sdeims_eper.dbo.Report r 
inner join 
	EPRTRmaster.dbo.LOV_COUNTRY c
on	CountryID collate database_default = Code

--select * from EPRTRmaster.dbo.ADDRESS


------------------------------------------------------------------------------------------
------------------------------- fill FACILITY and FACILITYLOG ----------------------------
------------------------------------------------------------------------------------------

declare @maxIndex int
select @maxIndex = isnull(MAX(FacilityID),0) from EPRTRmaster.dbo.FACILITY

------------------- FACILITY --------------------

insert into EPRTRmaster.dbo.FACILITY
select 
	distinct n.RowIndex + @maxIndex as FacilityID
from sdeims_eper.dbo.FACILITY f
inner join 
	sdeims_eper.dbo.Report r 
on	r.ReportID = f.ReportID
inner join (
	select 
		m.nID,
		m.cID,
		Row_Number() over (order by m.nID) as RowIndex
	from (
		select distinct f.NationalID as nID, r.CountryID as cID 
		from sdeims_eper.dbo.FACILITY f, sdeims_eper.dbo.Report r 
		where f.ReportID = r.ReportID
		)m 
	)n
on	n.nID = NationalID
and n.cID = r.CountryID
inner join 
	EPRTRmaster.dbo.POLLUTANTRELEASEANDTRANSFERREPORT p
on	r.ReportID = p.eperReportID
group by n.RowIndex 

--select * from EPRTRmaster.dbo.FACILITY

------------------- FACILITYLOG --------------------

insert into EPRTRmaster.dbo.FACILITYLOG(
	FacilityID,
	FacilityReportID,
	NationalID, 
	ReportingYear, 
	Published, 
	eperFacilityID
	)
select 
	n.RowIndex,
	0,
	f.NationalID,
	ReportYear,
	p.Published,
	f.FacilityID
from sdeims_eper.dbo.FACILITY f
inner join 
	sdeims_eper.dbo.Report r 
on	r.ReportID = f.ReportID
inner join (
	select 
		m.nID,
		m.cID,
		Row_Number() over (order by m.nID) as RowIndex
	from (
		select distinct f.NationalID as nID, r.CountryID as cID 
		from sdeims_eper.dbo.FACILITY f, sdeims_eper.dbo.Report r 
		where f.ReportID = r.ReportID
		)m 
	)n
on	n.nID = NationalID
and n.cID = r.CountryID
inner join 
	EPRTRmaster.dbo.POLLUTANTRELEASEANDTRANSFERREPORT p
on	r.ReportID = p.eperReportID
order by 1

--select * from EPRTRmaster.dbo.FACILITYLOG


------------------------------------------------------------------------------------------
----------------------------- define "unkown" in LOV_UNIT --------------------------------
------------------------------------------------------------------------------------------

--insert into EPRTRmaster.dbo.LOV_UNIT
--values('UNKNOWN','unknown',2001,2004)


------------------------------------------------------------------------------------------
-------------------------------- fill PRODUCTIONVOLUME -----------------------------------
------------------------------------------------------------------------------------------

insert into EPRTRmaster.dbo.PRODUCTIONVOLUME
select 
	'' as ProductName,
	cast(ProductionVolume as float) as Quantity,
	LOV_UnitID,
	FacilityID as eperFacilityID
from sdeims_eper.dbo.FACILITY, EPRTRmaster.dbo.LOV_UNIT 
where ProductionVolume not in (
' 10120 tonnes of Ultramarine Pigments',
' 248514 tonnes of LEAD AND SILVER BULLION',
' 3000 tonnes of landfilling',
' 5500000 tonnes of',
' 6548213800 kWh of Generation of electricity',
'<120000 tonnes per annum',
'1,300,000 Hl',
'138 gw pa',
'180 tonnes',
'230000 t pa',
'245000 t pa',
'300,000 tonnes / year',
'40,000 Tonnes per annum',
'499000 laying hens',
'50000 t',
'approx 30000 tpa (sale-able)',
'null')
and ProductionVolume > ''
and Code = 'UNKNOWN'
order by 1 asc

insert into EPRTRmaster.dbo.PRODUCTIONVOLUME values('Ultramarine Pigments', 10120, 3,186030)
insert into EPRTRmaster.dbo.PRODUCTIONVOLUME values('LEAD AND SILVER BULLION', 248514, 3,186530) 
insert into EPRTRmaster.dbo.PRODUCTIONVOLUME values('landfilling', 3000, 3,186129)
insert into EPRTRmaster.dbo.PRODUCTIONVOLUME values('', 5500000, 3,186372)
insert into EPRTRmaster.dbo.PRODUCTIONVOLUME values('Generation of electricity', 6548213800, 4,186248)
insert into EPRTRmaster.dbo.PRODUCTIONVOLUME values('<',120000,3,186740)
insert into EPRTRmaster.dbo.PRODUCTIONVOLUME values('',1300000, 12,186829)
insert into EPRTRmaster.dbo.PRODUCTIONVOLUME values('',138,9,186767)
insert into EPRTRmaster.dbo.PRODUCTIONVOLUME values('',180, 3,186786)
insert into EPRTRmaster.dbo.PRODUCTIONVOLUME values('',230000, 3, 186755)
insert into EPRTRmaster.dbo.PRODUCTIONVOLUME values('',245000, 3, 186798)
insert into EPRTRmaster.dbo.PRODUCTIONVOLUME values('',300000, 3,186811)
insert into EPRTRmaster.dbo.PRODUCTIONVOLUME values('',40000, 3,186771)
insert into EPRTRmaster.dbo.PRODUCTIONVOLUME values('laying hens',499000,1,186812)
insert into EPRTRmaster.dbo.PRODUCTIONVOLUME values('',50000,3,186802)
insert into EPRTRmaster.dbo.PRODUCTIONVOLUME values('approx (sale-able)',30000, 3,186828)

--select * from EPRTRmaster.dbo.PRODUCTIONVOLUME


------------------------------------------------------------------------------------------
---------------------- define "unkown" in LOV_RIVERBASINDISTRICT -------------------------
------------------------------------------------------------------------------------------

alter table EPRTRmaster.dbo.LOV_RIVERBASINDISTRICT alter column LOV_CountryID int null
--insert into EPRTRmaster.dbo.LOV_RIVERBASINDISTRICT
--values('UNKNOWN','unknown',2001,2004,null)

--select * from  EPRTRmaster.dbo.LOV_RIVERBASINDISTRICT


------------------------------------------------------------------------------------------
----------------------------- fill COMPETENTAUTHORITYPARTY -------------------------------
------------------------------------------------------------------------------------------

insert into EPRTRmaster.dbo.EPERCONTRACTINFORMATION
select 
	f.FacilityID,
	f.RegulatoryBodies,
	f.ContactName,
	f.Phonenumber,
	f.FaxNumber,
	f.Email 
from sdeims_eper.dbo.FACILITY f 

--select * from EPRTRmaster.dbo.EPERCONTRACTINFORMATION

insert into EPRTRmaster.dbo.COMPETENTAUTHORITYPARTY			--fill COMPETENTAUTHORITYPARTY with default values
select distinct 
	c.LOV_CountryID as LOV_CountryID,
	r.ReportYear as ReportingYear,
	'Not transferred from EPER' as Name,
	a.AddressID as AddressID,
	0 as TelephoneCommunication,
	0 as FaxCommunication,
	'' as EmailCommunication,
	NULL as ContactPersonName
from EPRTRmaster.dbo.LOV_COUNTRY c
inner join 
	sdeims_eper.dbo.Report r
on	c.Code collate database_default = r.CountryID
inner join
	EPRTRmaster.dbo.ADDRESS a
on a.LOV_CountryID = c.LOV_CountryID
where
	isnull(a.StreetName,'') = ''
and	isnull(a.BuildingNumber,'') = ''
and	isnull(a.City,'') = ''
and	isnull(a.PostalCode,0) = 0

--select * from EPRTRmaster.dbo.COMPETENTAUTHORITYPARTY


------------------------------------------------------------------------------------------
-------------------------------- fill FACILITYREPORT -------------------------------------
------------------------------------------------------------------------------------------

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
	
insert into EPRTRmaster.dbo.FACILITYREPORT
select 
	p.PollutantReleaseAndTransferReportID, 
	fl.FacilityID as FacilityID,
	f.NationalID as NationalID,
	f.ParentCompanyName as ParentCompanyName,
	f.FacilityName as FacilityName,
	a.AddressID as AddressID,
	geometry::STGeomFromText('POINT(' + 
		cast(cast(f.Longitude as decimal(18,12))as varchar(18)) + ' '+ 
		cast(cast(f.Latitude as decimal(18,12)) as varchar(18)) + ')', 4326) as GeographicalCoordinate,
	case 
		when isnull(f.Longitude,0 ) = 0 then @LOV_M
		when isnull(f.Latitude,0 ) = 0 then @LOV_M
		else @LOV_O end as LOV_StatusID,
	@UNKNOWN as LOV_RiverBasinDistrictID,
	@UNKNOWN as LOV_RiverBasinDistrictID_Source, --added by geocoding
	nace.LOV_NACEActivityID as LOV_NACEMainEconomicActivityID,
	nace.Name as MainEconomicActivityName,
	ap.CompetentAuthorityPartyID as CompetentAuthorityPartyID,
	pv.ProductionVolumeID as ProductionVolumeID,
	f.NoOfInstallations as TotalIPPCInstallationQuantity,
	f.OperatingHours as OperatingHours,
	f.Employees as TotalEmployeeQuantity,
	NULL as LOV_NUTSRegionID, --added by geocoding
	NULL as LOV_NUTSRegionID_Source, 
	f.WebAddress as WebsiteCommunication,
	NULL as PublicInformation,
	0 as ConfidentialIndicator,
	NULL as LOV_ConfidentialityID,
	0 as ProtectVoluntaryData,
	NULL as RemarkText,
	f.FacilityID as eperFacilityID
from sdeims_eper.dbo.FACILITY f
inner join 
	sdeims_eper.dbo.Report r 
on	r.ReportID = f.ReportID
inner join 
	EPRTRmaster.dbo.POLLUTANTRELEASEANDTRANSFERREPORT p
on	p.eperReportID =  r.ReportID
inner join
	EPRTRmaster.dbo.ADDRESS a
on	a.eperFacilityID = f.FacilityID
inner join
	EPRTRmaster.dbo.FACILITYLOG fl
on	fl.eperFacilityID = f.FacilityID
inner join
	EPRTRmaster.dbo.COMPETENTAUTHORITYPARTY ap
on  ap.LOV_CountryID = p.LOV_CountryID
and ap.ReportingYear = p.ReportingYear
inner join
	EPRTRmaster.dbo.LOV_NACEACTIVITY nace
on	f.NaceCodeID = nace.NaceCodeID
left outer join
	EPRTRmaster.dbo.PRODUCTIONVOLUME pv
on pv.eperFacilityID = f.FacilityID

--select * from EPRTRmaster.dbo.FACILITYREPORT


------------------------------------------------------------------------------------------
------------------------- update FCILITYLOG FacilityReportID -----------------------------
------------------------------------------------------------------------------------------

update EPRTRmaster.dbo.FACILITYLOG
set		
	FacilityReportID = fr.FacilityReportID
from 
	EPRTRmaster.dbo.FACILITYLOG f
inner join 
	EPRTRmaster.dbo.FACILITYREPORT fr
on	fr.eperFacilityID = f.eperFacilityID

--select * from EPRTRmaster.dbo.FACILITYLOG


------------------------------------------------------------------------------------------
---------------- add values to LOV_ANNEXIACTIVITY and map it to EPER-DB ------------------
------------------------------------------------------------------------------------------

insert into EPRTRmaster.dbo.LOV_ANNEXIACTIVITY
select
	'EPER_' + Code as Code,
	AltDescription as Name,
	2001 as StartYear,
	2004 as EndYear,
	null as ParentID,
	null as IPPCCODE,
	null
from 
	sdeims_eper.dbo.Annex3_Activity
where
	Groupnumber = 0

insert into EPRTRmaster.dbo.LOV_ANNEXIACTIVITY
select
	'EPER_' + a.Code as Code,
	AltDescription as Name,
	2001 as StartYear,
	2004 as EndYear,
	l.LOV_AnnexIActivityID as ParentID,
	null as IPPCCODE,
	Annex3ID as eperAnnex3_ID
from 
	sdeims_eper.dbo.Annex3_Activity a
inner join
	EPRTRmaster.dbo.LOV_ANNEXIACTIVITY l
on	SUBSTRING(l.Code,6,1) collate database_default = SUBSTRING(a.Code,1,1) 
where
	Groupnumber > 0


--insert into EPRTRmaster.dbo.LOV_ANNEXIACTIVITY
--	select '1.4','Coal gasification and liquefaction plants',2001,2004,1,NULL,5
--union all
--	select '2.1/2.2/2.3/2.4/2.5/2.6','Metal industry and metal ore roasting or sintering installations, Installations for the production of ferrous and non-ferrous metals',2001,2004,2,NULL,7
--union all
--	select '3.1/3.3/3.4/3.5','Installations for the production of cement klinker (>500t/d), lime (>50t/d), glass (>20t/d), mineral substances (>20t/d) or ceramic products (>75t/d)',2001,2004,3,NULL,9
--union all
--	select '4.2/4.3','Basic inorganic chemicals or fertilisers',2001,2004,4,NULL,13
--union all
--	select '4.4/4.6','Biocides and explosives',2001,2004,4,NULL,14
--union all
--	select '5.1/5.2','Installations for the disposal or recovery of hazardous waste (>10t/d) or municipal waste (>3t/h)',2001,2004,5,NULL,17
--union all
--	select '5.3/5.4','Installations for the disposal of nonhazardous waste (>50t/d) and landfills (>10t/d)',2001,2004,5,NULL,18
--union all
--	select '6.1','Industrial plants for pulp from timber or other fibrous materials and paper or board production (>20t/d)',2001,2004,6,NULL,20
--union all
--	select '6.4','Slaughterhouses (>50t/d), plants for the production of milk (>200t/d), other animal raw materials (>75t/d) or vegetable raw materials (>300t/d)',2001,2004,8,NULL,23

--update EPRTRmaster.dbo.LOV_ANNEXIACTIVITY set eperAnnex3_ID = 2 where Code = '1.(c)'
--update EPRTRmaster.dbo.LOV_ANNEXIACTIVITY set eperAnnex3_ID = 3 where Code = '1.(a)'
--update EPRTRmaster.dbo.LOV_ANNEXIACTIVITY set eperAnnex3_ID = 4 where Code = '1.(d)'
--update EPRTRmaster.dbo.LOV_ANNEXIACTIVITY set eperAnnex3_ID = 10 where Code = '3.(d)'
--update EPRTRmaster.dbo.LOV_ANNEXIACTIVITY set eperAnnex3_ID = 12 where Code = '4.(a)'
--update EPRTRmaster.dbo.LOV_ANNEXIACTIVITY set eperAnnex3_ID = 15 where Code = '4.(e)'
--update EPRTRmaster.dbo.LOV_ANNEXIACTIVITY set eperAnnex3_ID = 21 where Code = '9.(a)'
--update EPRTRmaster.dbo.LOV_ANNEXIACTIVITY set eperAnnex3_ID = 22 where Code = '9.(b)'
--update EPRTRmaster.dbo.LOV_ANNEXIACTIVITY set eperAnnex3_ID = 24 where Code = '5.(e)'
--update EPRTRmaster.dbo.LOV_ANNEXIACTIVITY set eperAnnex3_ID = 25 where Code = '7.(a)'
--update EPRTRmaster.dbo.LOV_ANNEXIACTIVITY set eperAnnex3_ID = 26 where Code = '9.(c)'
--update EPRTRmaster.dbo.LOV_ANNEXIACTIVITY set eperAnnex3_ID = 27 where Code = '9.(d)'
	
--select * from EPRTRmaster.dbo.LOV_ANNEXIACTIVITY order by 8


------------------------------------------------------------------------------------------
-------------------------------------- fill ACTIVITY -------------------------------------														
------------------------------------------------------------------------------------------

if object_id('tempdb..#T1')is not null DROP TABLE #T1
CREATE TABLE #T1(fID int, mA int, a3ID int)

insert into #T1
select 
	aI.FacilityID,
	1 as MainActivity, 
	a.Annex3ID
from sdeims_eper.dbo.AnnexIActivity aI
	inner join 
		sdeims_eper.dbo.Activity a
	on	a.ActivityID = aI.ActivityID
where MainActivity = 1

insert into #T1
select distinct
	aI.FacilityID,
	0 as MainActivity, 
	a.Annex3ID
from sdeims_eper.dbo.AnnexIActivity aI
inner join 
	sdeims_eper.dbo.Activity a
on	a.ActivityID = aI.ActivityID
and aI.MainActivity = 0
and not exists(
	select fID, a3ID from #T1
	where fID = aI.FacilityID and a.Annex3ID = a3ID)

if object_id('tempdb..#T2')is not null DROP TABLE #T2
CREATE TABLE #T2(fID int, a3ID int, mA int, rn int)

insert into #T2
select 
	fID, 
	a3ID,
	mA,
	Row_Number() over (order by fID, mA desc) as rn
from #T1 
order by 1,2 desc ,3

insert into EPRTRmaster.dbo.ACTIVITY (FacilityReportID, RankingNumeric, LOV_AnnexIActivityID)
select --t1.*,
	FacilityReportID,
	t1.rn - t2.rn + 1 as RankingNumeric,
	LOV_AnnexIActivityID
from #T2 t1
inner join 
	#T2 t2
on	t1.fID = t2.fID
and t2.mA = 1
inner join
	EPRTRmaster.dbo.LOV_ANNEXIACTIVITY
on  t1.a3ID = eperAnnex3_ID
inner join
	EPRTRmaster.dbo.FACILITYREPORT
on	eperFacilityID = t1.fID
order by 1,2,3

--select * from EPRTRmaster.dbo.ACTIVITY order by 3 desc


------------------------------------------------------------------------------------------
------------------- add values LOV_POLLUTANT and map it to EPER-DB -----------------------
------------------------------------------------------------------------------------------

--insert into EPRTRmaster.dbo.LOV_POLLUTANT
--values ('PAHs in EPER','Polycyclic Aromatic Hydrocarbons (PAH in EPER)',2001,2004,6,NULL,NULL)

update EPRTRmaster.dbo.LOV_POLLUTANT set eperPollutant_ID = 3 where Code = 'CH4'
update EPRTRmaster.dbo.LOV_POLLUTANT set eperPollutant_ID = 4 where Code = 'CO'
update EPRTRmaster.dbo.LOV_POLLUTANT set eperPollutant_ID = 5 where Code = 'CO2'
update EPRTRmaster.dbo.LOV_POLLUTANT set eperPollutant_ID = 6 where Code = 'HFCS'
update EPRTRmaster.dbo.LOV_POLLUTANT set eperPollutant_ID = 7 where Code = 'N2O'
update EPRTRmaster.dbo.LOV_POLLUTANT set eperPollutant_ID = 8 where Code = 'NH3'
update EPRTRmaster.dbo.LOV_POLLUTANT set eperPollutant_ID = 9 where Code = 'NMVOC'
update EPRTRmaster.dbo.LOV_POLLUTANT set eperPollutant_ID = 10 where Code = 'NOX'
update EPRTRmaster.dbo.LOV_POLLUTANT set eperPollutant_ID = 11 where Code = 'PFCS'
update EPRTRmaster.dbo.LOV_POLLUTANT set eperPollutant_ID = 12 where Code = 'SF6'
update EPRTRmaster.dbo.LOV_POLLUTANT set eperPollutant_ID = 13 where Code = 'SOX'
update EPRTRmaster.dbo.LOV_POLLUTANT set eperPollutant_ID = 14 where Code = 'TOTAL - NITROGEN'
update EPRTRmaster.dbo.LOV_POLLUTANT set eperPollutant_ID = 15 where Code = 'TOTAL - PHOSPHORUS'
update EPRTRmaster.dbo.LOV_POLLUTANT set eperPollutant_ID = 17 where Code = 'AS AND COMPOUNDS'
update EPRTRmaster.dbo.LOV_POLLUTANT set eperPollutant_ID = 18 where Code = 'CD AND COMPOUNDS'
update EPRTRmaster.dbo.LOV_POLLUTANT set eperPollutant_ID = 19 where Code = 'CR AND COMPOUNDS'
update EPRTRmaster.dbo.LOV_POLLUTANT set eperPollutant_ID = 20 where Code = 'CU AND COMPOUNDS'
update EPRTRmaster.dbo.LOV_POLLUTANT set eperPollutant_ID = 21 where Code = 'HG AND COMPOUNDS'
update EPRTRmaster.dbo.LOV_POLLUTANT set eperPollutant_ID = 22 where Code = 'NI AND COMPOUNDS'
update EPRTRmaster.dbo.LOV_POLLUTANT set eperPollutant_ID = 23 where Code = 'PB AND COMPOUNDS'
update EPRTRmaster.dbo.LOV_POLLUTANT set eperPollutant_ID = 24 where Code = 'ZN AND COMPOUNDS'
update EPRTRmaster.dbo.LOV_POLLUTANT set eperPollutant_ID = 26 where Code = 'DICHLOROETHANE-1,2 (DCE)'
update EPRTRmaster.dbo.LOV_POLLUTANT set eperPollutant_ID = 27 where Code = 'DICHLOROMETHANE (DCM)'
update EPRTRmaster.dbo.LOV_POLLUTANT set eperPollutant_ID = 28 where Code = 'CHLORO-ALKANES (C10-13)'
update EPRTRmaster.dbo.LOV_POLLUTANT set eperPollutant_ID = 29 where Code = 'HEXACHLOROBENZENE (HCB)'
update EPRTRmaster.dbo.LOV_POLLUTANT set eperPollutant_ID = 30 where Code = 'HEXACHLOROBUTADIENE (HCBD)'
update EPRTRmaster.dbo.LOV_POLLUTANT set eperPollutant_ID = 31 where Code = 'HEXACHLOROCYCLOHEXANE(HCH)'
update EPRTRmaster.dbo.LOV_POLLUTANT set eperPollutant_ID = 32 where Code = 'HALOGENATED ORGANIC COMPOUNDS'
update EPRTRmaster.dbo.LOV_POLLUTANT set eperPollutant_ID = 33 where Code = 'PCDD+PCDF (DIOXINS+FURANS)'
update EPRTRmaster.dbo.LOV_POLLUTANT set eperPollutant_ID = 34 where Code = 'PENTACHLOROPHENOL (PCP)'
update EPRTRmaster.dbo.LOV_POLLUTANT set eperPollutant_ID = 35 where Code = 'TETRACHLOROETHYLENE (PER)'
update EPRTRmaster.dbo.LOV_POLLUTANT set eperPollutant_ID = 36 where Code = 'TETRACHLOROMETHANE (TCM)'
update EPRTRmaster.dbo.LOV_POLLUTANT set eperPollutant_ID = 37 where Code = 'TRICHLOROBENZENES (TCB)'
update EPRTRmaster.dbo.LOV_POLLUTANT set eperPollutant_ID = 38 where Code = 'TRICHLOROETHANE-1,1,1 (TCE)'
update EPRTRmaster.dbo.LOV_POLLUTANT set eperPollutant_ID = 39 where Code = 'TRICHLOROETHYLENE (TRI)'
update EPRTRmaster.dbo.LOV_POLLUTANT set eperPollutant_ID = 40 where Code = 'TRICHLOROMETHANE'
update EPRTRmaster.dbo.LOV_POLLUTANT set eperPollutant_ID = 42 where Code = 'BENZENE'
update EPRTRmaster.dbo.LOV_POLLUTANT set eperPollutant_ID = 43 where Code = 'BTEX'
update EPRTRmaster.dbo.LOV_POLLUTANT set eperPollutant_ID = 44 where Code = 'BROMINATED DIPHENYLETHER'
update EPRTRmaster.dbo.LOV_POLLUTANT set eperPollutant_ID = 45 where Code = 'ORGANOTIN - COMPOUNDS'
update EPRTRmaster.dbo.LOV_POLLUTANT set eperPollutant_ID = 46 where Code = 'PAHs in EPER'
update EPRTRmaster.dbo.LOV_POLLUTANT set eperPollutant_ID = 47 where Code = 'PHENOLS'
update EPRTRmaster.dbo.LOV_POLLUTANT set eperPollutant_ID = 48 where Code = 'TOTAL ORGANIC CARBON (TOC)'
update EPRTRmaster.dbo.LOV_POLLUTANT set eperPollutant_ID = 50 where Code = 'CHLORIDES'
update EPRTRmaster.dbo.LOV_POLLUTANT set eperPollutant_ID = 51 where Code = 'CHLORINE AND INORGANIC COMPOUNDS'
update EPRTRmaster.dbo.LOV_POLLUTANT set eperPollutant_ID = 52 where Code = 'CYANIDES'
update EPRTRmaster.dbo.LOV_POLLUTANT set eperPollutant_ID = 53 where Code = 'FLUORIDES'
update EPRTRmaster.dbo.LOV_POLLUTANT set eperPollutant_ID = 54 where Code = 'FLUORINE AND INORGANIC COMPOUNDS'
update EPRTRmaster.dbo.LOV_POLLUTANT set eperPollutant_ID = 55 where Code = 'HCN'
update EPRTRmaster.dbo.LOV_POLLUTANT set eperPollutant_ID = 56 where Code = 'PM10'
update EPRTRmaster.dbo.LOV_POLLUTANT set eperPollutant_ID = 487 where Code = 'ETHYLBENZENE'
update EPRTRmaster.dbo.LOV_POLLUTANT set eperPollutant_ID = 488 where Code = 'XYLENES'
update EPRTRmaster.dbo.LOV_POLLUTANT set eperPollutant_ID = 489 where Code = 'TOLUENE'

--select * from EPRTRmaster.dbo.LOV_POLLUTANT


------------------------------------------------------------------------------------------
--------------------------------- fill POLLUTANTRELEASE ----------------------------------
------------------------------------------------------------------------------------------

declare @uID int
select @uID = LOV_UnitID from EPRTRmaster.dbo.LOV_UNIT where Code = 'KGM'

declare @uID_unknown int
select @uID_unknown = LOV_UnitID from EPRTRmaster.dbo.LOV_UNIT where Code = 'UNKNOWN'

insert into EPRTRmaster.dbo.POLLUTANTRELEASE
select
	f.FacilityReportID as FacilityReportID,
	m.LOV_MediumID as LOV_MediumID,
	p.LOV_PollutantID as LOV_PollutantID,
	mb.LOV_MethodBasisID as LOV_MethodBasisID,
	NULL as MethodListID,
	e.EmissionValue as TotalQuantity,
	@uID as LOV_TotalQuantityUnitID,
	0 as AccidentalQuantity,
	@uID_unknown as LOV_AccidentalQuantityUnitID,
	0 as ConfidentialIndicator,
	NULL as LOV_ConfidentialityID,
	NULL as RemarkText
from sdeims_eper.dbo.Emission e
inner join 
	EPRTRmaster.dbo.FACILITYREPORT f
on	f.eperFacilityID = e.FacilityID
inner join
	EPRTRmaster.dbo.LOV_METHODBASIS mb
on	mb.Code collate database_default = e.Method
inner join
	EPRTRmaster.dbo.LOV_MEDIUM m
on	(e.EmissionTypeID = 1 and m.Code = 'AIR')
or	(e.EmissionTypeID = 2 and m.Code = 'WATER')
inner join
	EPRTRmaster.dbo.LOV_POLLUTANT p
on	e.PollutantID = p.eperPollutant_ID

--select * from EPRTRmaster.dbo.POLLUTANTRELEASE


------------------------------------------------------------------------------------------
--------------------------------- fill POLLUTANTTRANSFER ---------------------------------
------------------------------------------------------------------------------------------

insert into EPRTRmaster.dbo.POLLUTANTTRANSFER
select
	f.FacilityReportID as FacilityReportID,
	p.LOV_PollutantID as LOV_PollutantID,
	mb.LOV_MethodBasisID as LOV_MethodBasisID,
	NULL as MethodListID,
	e.EmissionValue as Quantity,
	@uID as LOV_QuantityUnitID,
	0 as ConfidentialIndicator,
	NULL as LOV_ConfidentialityID,
	NULL as RemarkText
from sdeims_eper.dbo.Emission e
inner join 
	EPRTRmaster.dbo.FACILITYREPORT f
on	f.eperFacilityID = e.FacilityID
inner join
	EPRTRmaster.dbo.LOV_METHODBASIS mb
on	mb.Code collate database_default = e.Method
inner join
	EPRTRmaster.dbo.LOV_POLLUTANT p
on	e.PollutantID = p.eperPollutant_ID
where e.EmissionTypeID = 3

--select * from EPRTRmaster.dbo.POLLUTANTTRANSFER


------------------------------------------------------------------------------------------
------------------------- clean up and save auxilary columns -----------------------------														
------------------------------------------------------------------------------------------

insert into EPRTRmaster.dbo.EPER_TO_EPRTR_IDS
select 'PRODUCTIONVOLUME', ProductionVolumeID, eperFacilityID
from EPRTRmaster.dbo.PRODUCTIONVOLUME

insert into EPRTRmaster.dbo.EPER_TO_EPRTR_IDS
select 'FACILITYLOG', FacilityLogID, eperFacilityID
from EPRTRmaster.dbo.FACILITYLOG

insert into EPRTRmaster.dbo.EPER_TO_EPRTR_IDS
select 'ADDRESS', AddressID, eperFacilityID
from EPRTRmaster.dbo.ADDRESS

insert into EPRTRmaster.dbo.EPER_TO_EPRTR_IDS
select 'POLLUTANTRELEASEANDTRANSFERREPORT', PollutantReleaseAndTransferReportID ,eperReportID
from EPRTRmaster.dbo.POLLUTANTRELEASEANDTRANSFERREPORT

insert into EPRTRmaster.dbo.EPER_TO_EPRTR_IDS
select 'FACILITYREPORT', FacilityReportID, eperFacilityID
from EPRTRmaster.dbo.FACILITYREPORT

insert into EPRTRmaster.dbo.EPER_TO_EPRTR_IDS
select 'LOV_ANNEXIACTIVITY', LOV_AnnexIActivityID ,eperAnnex3_ID
from EPRTRmaster.dbo.LOV_ANNEXIACTIVITY

insert into EPRTRmaster.dbo.EPER_TO_EPRTR_IDS
select 'LOV_POLLUTANT', LOV_PollutantID, eperPollutant_ID
from EPRTRmaster.dbo.LOV_POLLUTANT

--alter table EPRTRmaster.dbo.POLLUTANTRELEASEANDTRANSFERREPORT drop column eperReportID
--alter table EPRTRmaster.dbo.ADDRESS drop column eperFacilityID
--alter table EPRTRmaster.dbo.FACILITYLOG drop column eperFacilityID
--alter table EPRTRmaster.dbo.PRODUCTIONVOLUME drop column eperFacilityID
--alter table EPRTRmaster.dbo.FACILITYREPORT drop column eperFacilityID
--alter table EPRTRmaster.dbo.LOV_ANNEXIACTIVITY drop column eperAnnex3_ID 
--alter table EPRTRmaster.dbo.LOV_POLLUTANT drop column eperPollutant_ID 

--alter table EPRTRmaster.dbo.LOV_NACEACTIVITY drop column Section
--alter table EPRTRmaster.dbo.LOV_NACEACTIVITY drop column SubSection
--alter table EPRTRmaster.dbo.LOV_NACEACTIVITY drop column NaceCodeID

--select * from EPRTRmaster.dbo.EPER_TO_EPRTR_IDS

------------------------------------------------------------------------------------------
------ deleting script (removes all the previously inserted data from the EPRTR DB) ------														
------------------------------------------------------------------------------------------
--delete from EPRTRmaster.dbo.ACTIVITY
--delete from EPRTRmaster.dbo.WASTETRANSFER
--delete from EPRTRmaster.dbo.POLLUTANTTRANSFER
--delete from EPRTRmaster.dbo.POLLUTANTRELEASE
--delete from EPRTRmaster.dbo.WASTEHANDLERPARTY
--delete from EPRTRmaster.dbo.FACILITYREPORT
--delete from EPRTRmaster.dbo.COMPETENTAUTHORITYPARTY            
--delete from EPRTRmaster.dbo.PRODUCTIONVOLUME                   
--delete from EPRTRmaster.dbo.FACILITYLOG                        
--delete from EPRTRmaster.dbo.FACILITY                           
--delete from EPRTRmaster.dbo.ADDRESS                            
--delete from EPRTRmaster.dbo.POLLUTANTRELEASEANDTRANSFERREPORT
--delete from EPRTRmaster.dbo.POLLUTANTRELEASE
--delete from EPRTRmaster.dbo.POLLUTANTTRANSFER
----delete from EPRTRmaster.dbo.LOV_UNIT where Code ='UNKNOWN'
----delete from EPRTRmaster.dbo.LOV_RIVERBASINDISTRICT where Code = 'UNKNOWN'
--delete from EPRTRmaster.dbo.LOV_ANNEXIACTIVITY where EndYear = 2004
--delete from EPRTRmaster.dbo.LOV_POLLUTANT where EndYear = 2004
----------------------------------------------------------------------------------------
--select * from EPRTRmaster.dbo.ACTIVITY
--select * from EPRTRmaster.dbo.WASTETRANSFER
--select * from EPRTRmaster.dbo.POLLUTANTTRANSFER
--select * from EPRTRmaster.dbo.POLLUTANTRELEASE
--select * from EPRTRmaster.dbo.WASTEHANDLERPARTY
--select * from EPRTRmaster.dbo.FACILITYREPORT
--select * from EPRTRmaster.dbo.COMPETENTAUTHORITYPARTY            
--select * from EPRTRmaster.dbo.PRODUCTIONVOLUME                   
--select * from EPRTRmaster.dbo.FACILITYLOG                        
--select * from EPRTRmaster.dbo.FACILITY                           
--select * from EPRTRmaster.dbo.ADDRESS                            
--select * from EPRTRmaster.dbo.POLLUTANTRELEASEANDTRANSFERREPORT
--select * from EPRTRmaster.dbo.POLLUTANTRELEASE
--select * from EPRTRmaster.dbo.POLLUTANTTRANSFER
--select * from EPRTRmaster.dbo.LOV_ANNEXIACTIVITY where EndYear = 2004
--select * from EPRTRmaster.dbo.LOV_POLLUTANT where EndYear = 2004
--------------------------------------------------------------------------------------

