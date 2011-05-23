use EPRTRmaster
go
--DROP INDEX TestIndex ON [dbo].[vAT_POLLUTANTRELEASEANDTRANSFERREPORT] WITH ( ONLINE = OFF )
--go
--CREATE UNIQUE CLUSTERED INDEX [TestIndex] ON [dbo].[vAT_POLLUTANTRELEASEANDTRANSFERREPORT]  
--( 
--	PollutantReleaseAndTransferReportID
--) 
--GO  


use EPRTRweb
go

DROP INDEX [speedo] ON [dbo].FACILITYSEARCH_ALL WITH ( ONLINE = OFF )
go

CREATE INDEX [speedo] ON [dbo].FACILITYSEARCH_ALL 
(
FacilityReportID,
LOV_PollutantGroupID,
LOV_PollutantID,
LOV_WasteTypeID,
LOV_WasteTreatmentID,
WHPCountryID,
LOV_CountryID,
LOV_RiverBasinDistrictID,
LOV_NUTSRLevel1ID,
LOV_NUTSRLevel2ID,
LOV_IASectorID,
LOV_IAActivityID,
LOV_IASubActivityID,
LOV_NACESectorID,
LOV_NACEActivityID,
LOV_NACESubActivityID  
)WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF) ON [PRIMARY]
go

declare @ts datetime
SELECT CONVERT(VARCHAR(12), GETDATE(), 114) AS [HH:MI:SS:MMM(24H)]
select FacilityReportID from FACILITYSEARCH_ALL where LOV_CountryID = 57
SELECT CONVERT(VARCHAR(12), GETDATE(), 114) AS [HH:MI:SS:MMM(24H)]

--DROP INDEX FACILITY_GEOM_IDX ON [dbo].[FACILITYREPORT]
--go
--CREATE SPATIAL INDEX FACILITY_GEOM_IDX
-- ON [dbo].[FACILITYREPORT]([GeographicalCoordinate])
-- WITH (BOUNDING_BOX=(XMIN=-180.0, YMIN=-90.0, XMAX=180.0, YMAX=90.0))
--GO



--CREATE UNIQUE CLUSTERED INDEX [WEB_FACILITYSEARCH_MAINACTIVITY_INDEX] 
--ON [dbo].WEB_FACILITYSEARCH_MAINACTIVITY (FacilityReportID asc)

--create index IX_MEASUREMENT__EXTRACT_LTO on giseditor.measurement
--(
--    mAdded asc
--  , fk_station_id asc
--  , mDateTime asc
--)
--include (pk_measurement_id, mValue, fk_component_id, mIs_valid)

--CREATE NONCLUSTERED INDEX [IX_MEASUREMENT__XC_SNAPSHOT] ON [giseditor].[measurement] 
--(
--    [fk_station_id] ASC,
--    [fk_component_id] ASC,
--    [mDateTime] ASC
--)
--INCLUDE ( [mIs_valid]) WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
--go

--CREATE NONCLUSTERED INDEX [IX_XC_MEASUREMENT_LTO] ON [giseditor].[XC_MEASUREMENT_LTO] 
--(
--    [fk_station_id] ASC,
--    [mDateTime] ASC,
--    [qc_check] ASC,
--    [pk_measurement_id] ASC,
--    [lto_value] ASC
--)WITH (SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]
--go

--DROP INDEX [IX_measurementOzone_insert] ON [giseditor].[measurement] WITH ( ONLINE = OFF )
--go

--CREATE STATISTICS [STAT_PARAMETER_PK_NAME_UNIQ] ON [giseditor].[parameter]([pk_parameter_id], [parameterName], [parameterUniqueidentifier])
--go

