------------------------------------------------------------------------------
--		CreateView_VALIDATION_FACILITY.sql
-- This view is created to allow the validation of the RULE 4 in the E-PRTR Validation Tool
--Author: Alberto Telletxea - Bilbomatica
------------------------------------------------------------------------------

USE EPRTRmaster
GO

If object_id('EPRTRmaster.dbo.VALIDATION_FACILITY')is not null DROP view VALIDATION_FACILITY

go

CREATE VIEW VALIDATION_FACILITY
AS 
SELECT distinct t1.NationalID, t2.ReportingYear, t3.LOV_CountryID, t3.Code, t1.FacilityID

From EPRTRmaster.dbo.FACILITYREPORT as t1, 
       EPRTRmaster.dbo.LOV_COUNTRY as t3,

      (select
           PollutantReleaseAndTransferReportID,
           prtr.ReportingYear,
           prtr.LOV_CountryID,
           LOV_CoordinateSystemID,
           RemarkText,
           CdrUrl,
           CdrUploaded,
           CdrReleased,
           ForReview,
           Published,
           ResubmitReason,
           prtr.LOV_StatusID
      from 
                     [EPRTRMaster].[dbo].[POLLUTANTRELEASEANDTRANSFERREPORT] prtr
      inner join (
                     select distinct
                                     ReportingYear,
                                     LOV_CountryID,
                                     max(CdrReleased) as ReleasedDate
                     from 
                                     [EPRTRMaster].[dbo].[POLLUTANTRELEASEANDTRANSFERREPORT] prtr1
                     group by 
                                     ReportingYear,
                                     LOV_CountryID
      ) m
      on         m.LOV_CountryID = prtr.LOV_CountryID
      and m.ReportingYear = prtr.ReportingYear
      and m.ReleasedDate = prtr.CdrReleased) as t2


where t1.PollutantReleaseAndTransferReportID = t2.PollutantReleaseAndTransferReportID
        and t2.LOV_CountryID = t3.LOV_CountryID
GO
