
USE [EPRTRxml]

SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT * FROM EPRTRxml.sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[delete_report]') AND type in (N'P'))
drop procedure [dbo].[delete_report]
go

create procedure [dbo].[delete_report]
@PRTR_REPORTID int
as
begin
------------------------------------------------------------------------------------------
--	The following script deletes prtr data corresponding to the							-- 
--  pollutantreleaseandtransferreportid given as input                                  --                          --																			--
------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------
------------------------- delete rows in WASTETRANSFER -----------------------------------
------------------------------------------------------------------------------------------

delete EPRTRmaster.dbo.WASTETRANSFER  
where facilityreportid in 
(select facilityreportid from EPRTRmaster.dbo.facilityreport 
where pollutantreleaseandtransferreportid = @PRTR_REPORTID) 


------------------------------------------------------------------------------------------
------------------------- delete rows in POLLUTANTTRANSFER -------------------------------
------------------------------------------------------------------------------------------

delete EPRTRmaster.dbo.POLLUTANTTRANSFER  
where facilityreportid in 
(select facilityreportid from EPRTRmaster.dbo.facilityreport 
where pollutantreleaseandtransferreportid = @PRTR_REPORTID) 


------------------------------------------------------------------------------------------
------------------------- delete rows in POLLUTANTRELEASE --------------------------------
------------------------------------------------------------------------------------------

delete EPRTRmaster.dbo.POLLUTANTRELEASE  
where facilityreportid in 
(select facilityreportid from EPRTRmaster.dbo.facilityreport 
where pollutantreleaseandtransferreportid = @PRTR_REPORTID) 


------------------------------------------------------------------------------------------
------------------------- delete rows in ACTIVITY ----------------------------------------
------------------------------------------------------------------------------------------

delete EPRTRmaster.dbo.ACTIVITY  
where facilityreportid in 
(select facilityreportid from EPRTRmaster.dbo.facilityreport 
where pollutantreleaseandtransferreportid = @PRTR_REPORTID) 


------------------------------------------------------------------------------------------
------------------------- delete rows in FACILITYLOG -------------------------------------
------------------------------------------------------------------------------------------

delete EPRTRmaster.dbo.FACILITYLOG  
where facilityreportid in 
(select facilityreportid from EPRTRmaster.dbo.facilityreport 
where pollutantreleaseandtransferreportid = @PRTR_REPORTID) 



------------------------------------------------------------------------------------------
------------------------- delete rows in FACILITYREPORT ----------------------------------
------------------------------------------------------------------------------------------

delete EPRTRmaster.dbo.FACILITYREPORT  
where facilityreportid in 
(select facilityreportid from EPRTRmaster.dbo.facilityreport 
where pollutantreleaseandtransferreportid = @PRTR_REPORTID) 


------------------------------------------------------------------------------------------
------------------------- delete row in POLLUTANTRELEASEANDTRANSFERREPORT ----------------------------------
------------------------------------------------------------------------------------------

delete EPRTRmaster.dbo.POLLUTANTRELEASEANDTRANSFERREPORT  
where pollutantreleaseandtransferreportid = @PRTR_REPORTID 

END



--USE [EPRTRxml] EXEC [dbo].[delete_report] @PRTR_REPORTID = 68