------------------------------------------------------------------------------
--		createViews vAT_FACILITY_ID_EXISTS
------------------------------------------------------------------------------

declare @DataBaseName as nvarchar(255)
set @DataBaseName = (SELECT DB_NAME())

if object_id(@DataBaseName+'.dbo.vAT_FACILITY_ID_EXISTS')is not null 
	DROP view vAT_FACILITY_ID_EXISTS
go

create view dbo.vAT_FACILITY_ID_EXISTS(
	FacilityID,
	NationalID, 
	ReportingYear,
	Code
)
as 
select 
	max(frep.FacilityID) as FacilityID,
	frep.NationalID, 
	prtr.ReportingYear,
	c.Code
from 
	EPRTRmaster.dbo.FACILITYREPORT frep
inner join
	EPRTRmaster.dbo.POLLUTANTRELEASEANDTRANSFERREPORT prtr
on	frep.PollutantReleaseAndTransferReportID = prtr.PollutantReleaseAndTransferReportID
inner join
	EPRTRmaster.dbo.LOV_COUNTRY c
on	c.LOV_CountryID = prtr.LOV_CountryID
group by
	frep.NationalID, 
	prtr.ReportingYear,
	c.Code
go