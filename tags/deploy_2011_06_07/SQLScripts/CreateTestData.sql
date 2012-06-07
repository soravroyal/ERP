SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET QUOTED_IDENTIFIER ON
GO

INSERT INTO [dbo].[POLLUTANTRELEASEANDTRANSFERREPORT] (
    [ReportingYear], [LOV_CountryID], [LOV_CoordinateSystemID],
    [RemarkText],
    [CdrUrl],
    [Uploaded],
    [Released],
    [Published], [ResubmitReason]
)
 SELECT 2010, 15, 1,
    'Test AT submission',
    'http://example.org/',
    CAST('20090203 10:00:00' AS [datetime]),
    CAST('20090203 10:02:30' AS [datetime]),
    NULL, NULL

INSERT INTO [dbo].[FACILITY]([FacilityID])
 SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4

INSERT INTO [dbo].[FACILITYLOG](FacilityID, NationalID, ReportingYear, Published)
 SELECT 1, '1027410217', 2010, CAST('20090204 12:00:01' AS [datetime])
  UNION ALL
 SELECT 2, '1023110179', 2010, CAST('20090204 12:00:02' AS [datetime])
  UNION ALL
 SELECT 3, '1036010311', 2010, CAST('20090204 12:00:03' AS [datetime])
  UNION ALL
 SELECT 4, '1046510475', 2010, CAST('20090204 12:00:04' AS [datetime])

INSERT INTO [dbo].[ADDRESS](
    [StreetName], [BuildingNumber], [City], [PostalCode], [LOV_CountryID]
)
 SELECT 'Bleichestraße', '11', 'Bludenz', '6700', 15
  UNION ALL
 SELECT 'Schweizerstraße', '52', 'Hohenems', '6845', 15
  UNION ALL
 SELECT 'Königswiesen', 'keine', 'Königswiesen', '6890', 15
  UNION ALL
 SELECT 'Alte Landstraße', '11', 'Lauterach', '6923', 15
  UNION ALL
 SELECT 'Spittelauer Lände', '2', 'Vienna', '1090', 15
  UNION ALL
 SELECT 'Ejby Mosevej', '219', 'Glostrup', '2600', 59
  UNION ALL
 SELECT 'Lervangen', '1-3', 'Taastrup', '2630', 59
GO

INSERT INTO [dbo].[COMPETENTAUTHORITYPARTY](
    [LOV_CountryID], [ReportingYear],
    [Name], [AddressID],
    [TelephoneCommunication],
    [FaxCommunication],
    [EmailCommunication]
)
 SELECT 15, 2010, 'Umweltbundesamt', 5,
    '+43-(0)1-313 04', '+43-(0)1-313 04', 'office@umweltbundesamt.at'
GO

INSERT INTO [dbo].[PRODUCTIONVOLUME]([ProductName], [Quantity], [LOV_UnitID])
 SELECT 'Indigo dye', 200.5, 2
  UNION ALL
 SELECT 'Manure', 4.1, 3
GO

DECLARE @RBD INT
SELECT @RBD=[LOV_RiverBasinDistrictID] FROM [dbo].[LOV_RIVERBASINDISTRICT]
    WHERE [Code] = 'AT2000'
INSERT INTO [dbo].[FACILITYREPORT](
    [PollutantReleaseAndTransferReportID], [FacilityID], [NationalID],
    [ParentCompanyName],
    [FacilityName],
    [AddressID], [GeographicalCoordinate],
    [LOV_RiverBasinDistrictID], [LOV_NACEMainEconomicActivityID], [MainEconomicActivityName], [CompetentAuthorityPartyID], [ProductionVolumeID], [LOV_NUTSRegionID],
    [ConfidentialIndicator], [ProtectVoluntaryData], [RemarkText]
)
 SELECT 1, 1, '1027410217',
    'Anders Ente und Cie, Bregenz',
    'Ente Textil AG, Werk Bauch, Färberei',
    1, geometry::STGeomFromText('POINT (9.8 47.2)', 4326),
    @RBD, 21, 'Redundant text', 1, 1, 48,
    0, 0, 'Test AT Facility 1'
  UNION ALL
 SELECT 1, 2, '1023110179',
    'Unterflächentechnik Aktiengesellschaft',
    'Catalloni GmbH',
    2, geometry::STGeomFromText('POINT (9.7 47.4)', 4326),
    @RBD, 22, 'Redundant text', 1, NULL, 49,
    0, 0, 'Test AT Facility 2'
  UNION ALL
 SELECT 1, 3, '1036010311',
    'XYZ-AG',
    'Herbert Hoffmann GmbH',
    3, geometry::STGeomFromText('POINT (9.650000 47.416667)', 4326),
    @RBD, 21, 'Redundant text', 1, 2, 49,
    0, 0, 'Test AT Facility 3'
  UNION ALL
 SELECT 1, 4, '1046510475',
    'Anlage zur Herstellung von Nahrungsmittelerzeugnissen aus pflanzlichen Rohstoffen',
    'Anlage zur Herstellung von Nahrungsmittelerzeugnissen aus pflanzlichen Rohstoffen',
    4, geometry::STGeomFromText('POINT (9.7 47.5)', 4326),
    @RBD, 22, 'Redundant text', 1, NULL, 49,
    0, 0, 'Test AT Facility 4'
GO

INSERT INTO [dbo].[METHODLIST](MethodListID)
 SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 UNION ALL SELECT 5
GO

INSERT INTO [dbo].[METHODUSED](
    [MethodListID],
    [LOV_MethodTypeID],
    [MethodDesignation]
)
 SELECT 1, 1, 'EN 14385:2004'
  UNION ALL
 SELECT 2, 3, NULL
  UNION ALL
 SELECT 3, 8, NULL
  UNION ALL
 SELECT 4, 9, NULL
  UNION ALL
 SELECT 5, 1, 'EN 14385:1998'
GO

INSERT INTO [dbo].[POLLUTANTTRANSFER](
    [FacilityReportID],
    [LOV_PollutantID],
    [LOV_MethodBasisID],
    [MethodListID],
    [Quantity],
    [LOV_QuantityUnitID],
    [ConfidentialIndicator]
)
 SELECT 1, 16, 1, 1, 0.223, 2, 0
  UNION ALL
 SELECT 1, 18, 3, 2, 127, 3, 0
GO

INSERT INTO [dbo].[POLLUTANTRELEASE](
    [FacilityReportID],
    [LOV_MediumID],
    [LOV_PollutantID],
    [LOV_MethodBasisID],
    [MethodListID],
    [TotalQuantity],
    [LOV_TotalQuantityUnitID],
    [AccidentalQuantity],
    [LOV_AccidentalQuantityUnitID],
    [ConfidentialIndicator]
)
 SELECT 1, 1, 10, 1, NULL, 100000, 3, 0, 3, 0
  UNION ALL
 SELECT 2, 1, 10, 1, 3, 200000, 3, 0, 3, 0
  UNION ALL
 SELECT 3, 1, 10, 2, NULL, 300000, 3, 10, 3, 0
  UNION ALL
 SELECT 4, 1, 10, 1, 4, 400000, 3, 0, 3, 0
GO

INSERT INTO [dbo].[WASTEHANDLERPARTY](
    [Name],
    [AddressID],
    [SiteAddressID]
)
 SELECT 'Vestforbrændingen', 6, 7
GO

INSERT INTO [dbo].[WASTETRANSFER](
    [FacilityReportID],
    [LOV_WasteTypeID],
    [LOV_WasteTreatmentID],
    [LOV_MethodBasisID],
    [MethodListID],
    [Quantity],
    [LOV_QuantityUnitID],
    [WasteHandlerPartyID],
    [ConfidentialIndicator]
)
 SELECT 1, 1, 1, 1, NULL, 123.4, 3, 1, 0
  UNION ALL
 SELECT 1, 2, 2, 1, 5, 765.4, 3, 1, 0
GO

DECLARE @A1 INT
SELECT @A1=[LOV_AnnexIActivityID] FROM [dbo].[LOV_ANNEXIACTIVITY] WHERE [Code]='1.(d)'
DECLARE @A2 INT
SELECT @A2=[LOV_AnnexIActivityID] FROM [dbo].[LOV_ANNEXIACTIVITY] WHERE [Code]='2.(c)'
DECLARE @A3 INT
SELECT @A3=[LOV_AnnexIActivityID] FROM [dbo].[LOV_ANNEXIACTIVITY] WHERE [Code]='2.(e).(ii)'
DECLARE @A4 INT
SELECT @A4=[LOV_AnnexIActivityID] FROM [dbo].[LOV_ANNEXIACTIVITY] WHERE [Code]='4.(a).(v)'
INSERT INTO [dbo].[ACTIVITY](
    [FacilityReportID],
    [LOV_AnnexIActivityID],
    [RankingNumeric]
)
 SELECT 1, @A1, 1
  UNION ALL
 SELECT 1, @A2, 2
  UNION ALL
 SELECT 1, @A3, 3
  UNION ALL
 SELECT 4, @A4, 1
GO

