USE [EPRTRmaster]
GO
/****** Object:  View [dbo].[vAT_NACEACTIVITY]    Script Date: 03/11/2011 11:45:35 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

if object_id('[PUBLISH_UPLOADEDREPORTS]')is not null DROP view [PUBLISH_UPLOADEDREPORTS]
go
create view [dbo].[PUBLISH_UPLOADEDREPORTS]
as
select
	l.Code, 
	p.LOV_CountryID,
	p.ReportingYear,
	case when isnull(v.PollutantReleaseAndTransferReportID,0) > 0 then 1
	else 0 end as 'CurrentlyShown',
    p.RemarkText,
    p.CdrUrl,
    p.CdrUploaded,
    p.CdrReleased,
    p.ForReview,
    p.Published,
    p.ResubmitReason,
    p.Imported as ImportedToEPRTRMaster
from POLLUTANTRELEASEANDTRANSFERREPORT p
inner join LOV_COUNTRY l
on p.LOV_CountryID = l.LOV_CountryID
left outer join vAT_POLLUTANTRELEASEANDTRANSFERREPORT v
on v.PollutantReleaseAndTransferReportID = p.PollutantReleaseAndTransferReportID
where p.CdrReleased > '2000-01-01 00:00:00.000'
go 

if object_id('[FULL_UPLOADEDREPORTS]')is not null DROP view [FULL_UPLOADEDREPORTS]
go
create view [dbo].[FULL_UPLOADEDREPORTS]
as
select
	l.Code, 
	p.LOV_CountryID,
	p.ReportingYear,
	case when isnull(v.PollutantReleaseAndTransferReportID,0) > 0 then 1
	else 0 end as 'CurrentlyShown',
    p.RemarkText,
    p.CdrUrl,
    p.CdrUploaded,
    p.CdrReleased,
    p.ForReview,
    p.Published,
    p.ResubmitReason,
    p.Imported as ImportedToEPRTRMaster
from POLLUTANTRELEASEANDTRANSFERREPORT p
inner join LOV_COUNTRY l
on p.LOV_CountryID = l.LOV_CountryID
left outer join vAT_POLLUTANTRELEASEANDTRANSFERREPORT v
on v.PollutantReleaseAndTransferReportID = p.PollutantReleaseAndTransferReportID
where p.CdrReleased > '2000-01-01 00:00:00.000'
go

--where p.PollutantReleaseAndTransferReportID not in (226,227,225)
--and Code in ('RO','DK')
--order by 1,3 asc,4 desc


