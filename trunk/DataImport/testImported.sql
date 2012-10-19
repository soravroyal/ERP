-- enter proper import data in where clause
use EPRTRmaster

SELECT p.PollutantReleaseAndTransferReportID
      ,c.Code
      ,p.ReportingYear
      ,COUNT(f.FacilityReportID) as 'facilities'
      ,p.Imported
  FROM [EPRTRmaster].[dbo].[POLLUTANTRELEASEANDTRANSFERREPORT] p
  join EPRTRmaster.dbo.LOV_COUNTRY c
	 on c.LOV_CountryID = p.[LOV_CountryID]
  left outer join EPRTRmaster.dbo.FACILITYREPORT f
	on f.PollutantReleaseAndTransferReportID = p.PollutantReleaseAndTransferReportID
  where Imported>'2012-10-18'
  group by p.PollutantReleaseAndTransferReportID
      ,c.Code
      ,p.ReportingYear
      ,p.Imported
  order by c.Code, p.ReportingYear,p.Imported