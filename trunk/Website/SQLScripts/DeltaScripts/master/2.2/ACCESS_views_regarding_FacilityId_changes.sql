
declare @DataBaseName as nvarchar(255)
set @DataBaseName = (SELECT DB_NAME())

if object_id(@DataBaseName + '.dbo.FULL_FACILITYID_CHANGES')is not null 
	DROP view FULL_FACILITYID_CHANGES
go

CREATE VIEW dbo.FULL_FACILITYID_CHANGES(
	CountryCode,
	ReportingYear,
	FacilityReportID,
	NationalID,
	NewFacilityID,
	OldFacilityID
)
AS
	select
		l.Code,
		prtr.ReportingYear,
		fr.FacilityReportID,
		fr.NationalID,
		fr.FacilityID as NewFacilityID,
		case when isnull(fl.OldFacilityID,0) = 0 then fr.FacilityID
		else fl.OldFacilityID end as OldFacilityID
	from 
		FULL_FACILITYREPORT pf
	inner join 
		FACILITYREPORT fr
	on	fr.FacilityReportID = pf.FacilityReportID
	inner join
		POLLUTANTRELEASEANDTRANSFERREPORT prtr
	on	prtr.PollutantReleaseAndTransferReportID = fr.PollutantReleaseAndTransferReportID
	inner join
		LOV_COUNTRY l
	on	l.LOV_CountryID = prtr.LOV_CountryID
	left outer join
		FACILITYLOG fl
	on fl.FacilityReportID not in (
		select FacilityReportID 
		from FACILITYLOG 
		group by FacilityReportID 
		having COUNT(*) > 1
		)
	and fl.FacilityReportID = fr.FacilityReportID
go


declare @DataBaseName as nvarchar(255)
set @DataBaseName = (SELECT DB_NAME())

if object_id(@DataBaseName + '.dbo.PUBLISH_FACILITYID_CHANGES')is not null 
	DROP view PUBLISH_FACILITYID_CHANGES
go

CREATE VIEW dbo.PUBLISH_FACILITYID_CHANGES(
	CountryCode,
	ReportingYear,
	FacilityReportID,
	NationalID,
	NewFacilityID,
	OldFacilityID
)
AS
	select
		l.Code,
		prtr.ReportingYear,
		fr.FacilityReportID,
		fr.NationalID,
		fr.FacilityID as NewFacilityID,
		case when isnull(fl.OldFacilityID,0) = 0 then fr.FacilityID
		else fl.OldFacilityID end as OldFacilityID
	from 
		PUBLISH_FACILITYREPORT pf
	inner join 
		FACILITYREPORT fr
	on	fr.FacilityReportID = pf.FacilityReportID
	inner join
		POLLUTANTRELEASEANDTRANSFERREPORT prtr
	on	prtr.PollutantReleaseAndTransferReportID = fr.PollutantReleaseAndTransferReportID
	inner join
		LOV_COUNTRY l
	on	l.LOV_CountryID = prtr.LOV_CountryID
	left outer join
		FACILITYLOG fl
	on fl.FacilityReportID not in (
		select FacilityReportID 
		from FACILITYLOG 
		group by FacilityReportID 
		having COUNT(*) > 1
		)
	and fl.FacilityReportID = fr.FacilityReportID
go

if not exists ( select * from INFORMATION_SCHEMA.COLUMNS
	where TABLE_NAME='FACILITYREPORT' and COLUMN_NAME='PrevNationalID' )
alter table FACILITYREPORT add PrevNationalID nvarchar(255)
go

if not exists ( select * from INFORMATION_SCHEMA.COLUMNS
	where TABLE_NAME='FACILITYREPORT' and COLUMN_NAME='PrevReportingYear' )
alter table FACILITYREPORT add PrevReportingYear bigint
go
