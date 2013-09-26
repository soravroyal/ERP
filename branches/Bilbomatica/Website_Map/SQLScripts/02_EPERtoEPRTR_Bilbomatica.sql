--------------------------------------------------------------------------------
--  The following script copys data FROM the EPER to the EPRTR Database       --
--                                                                            --
--  Source tables in EPER:        Report                                      --
--                                Facility                                    --
--                                AnnexIActivity                              --
--                                Activity                                    --
--                                Emission                                    --
--  Target tables in EPRTR:       POLLUTANTRELEASEANDTRANSFERREPORT           --
--                                ADDRESS                                     --
--                                FACILITY                                    --
--                                FACILITYLOG                                 --
--                                PRODUCTIONVOLUME                            --
--															                  --
--                                FACILITYREPORT                              --
--                                POLLUTANTRELEASE                            --
--                                ACTIVITY                                    --
--                                LOV_ANNEXIACTIVITY                          --
--                                POLLUTANTTRANSFER                           --
--                                LOV_POLLUTANT                               --
--                                                                            --
-- In the EPRTR database all index keys are generated automatically. Under    --
-- the transformation processing of data FROM the EPER database to the EPRTR  --
-- database it is necessary to keep track of index keys used by EPER. Thus    --
-- additional auxiliary columns are added to selected tables in the EPRTR     --
-- database. Once the process has terminated, these columns are deleted       --
-- again. Before being deleted these index key relations are saved into a     --
-- special dedicated table for historical reasons.           
-- -
-- This SQL procedure has been modified by Bilbomatica to upload the updated data
-- of EPER into E-PRTR:
		--1. SE 2001 & 2004
		--3. EE 2004
		--2. ES 2001 & 2004
		--4. BE 2004
		--5. UK 2004
--
--------------------------------------------------------------------------------

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


--1st SQL Script of EPER2EPRTR
-- Add tables and columns ------------------------------------------------------
--------------------------------------------------------------------------------

IF object_id('[EPRTRmaster].[dbo].[EPERCONTACTINFORMATION]') IS NOT NULL
    DROP TABLE [EPRTRmaster].[dbo].[EPERCONTACTINFORMATION]
CREATE TABLE [EPRTRmaster].[dbo].[EPERCONTACTINFORMATION]
(
    eperFacilityID [int] NOT NULL,
    RegulatoryBodies  [nvarchar](255) NULL,
    ContactName  [nvarchar](255) NULL,
    PhoneNumber  [nvarchar](50) NULL,
    FaxNumber  [nvarchar](50) NULL,
    Email  [nvarchar](255) NULL
)

IF object_id('[EPRTRmaster].[dbo].[EPER_TO_EPRTR_IDS]') IS NOT NULL
    DROP TABLE [EPRTRmaster].[dbo].[EPER_TO_EPRTR_IDS]
CREATE TABLE [EPRTRmaster].[dbo].[EPER_TO_EPRTR_IDS]
(
    TableName  [nvarchar](255) NULL,
    EPRTRID  [int] NULL,
    EPERID  [int] NULL
)

IF NOT EXISTS ( SELECT * FROM [EPRTRmaster].[INFORMATION_SCHEMA].[COLUMNS]
    WHERE
        TABLE_NAME='POLLUTANTRELEASEANDTRANSFERREPORT' AND
        COLUMN_NAME='eperReportID'
)
 ALTER TABLE [EPRTRmaster].[dbo].[POLLUTANTRELEASEANDTRANSFERREPORT]
    ADD eperReportID [int]

IF NOT EXISTS ( SELECT * FROM [EPRTRmaster].[INFORMATION_SCHEMA].[COLUMNS]
    WHERE
        TABLE_NAME='ADDRESS' AND
        COLUMN_NAME='eperFacilityID'
)
 ALTER TABLE [EPRTRmaster].[dbo].[ADDRESS]
    ADD eperFacilityID [int]

IF NOT EXISTS ( SELECT * FROM [EPRTRmaster].[INFORMATION_SCHEMA].[COLUMNS]
    WHERE
        TABLE_NAME='FACILITYLOG' AND
        COLUMN_NAME='eperFacilityID'
)
 ALTER TABLE [EPRTRmaster].[dbo].[FACILITYLOG]
    ADD eperFacilityID [int]

IF NOT EXISTS ( SELECT * FROM [EPRTRmaster].[INFORMATION_SCHEMA].[COLUMNS]
    WHERE
        TABLE_NAME='PRODUCTIONVOLUME' AND
        COLUMN_NAME='eperFacilityID'
)
 ALTER TABLE [EPRTRmaster].[dbo].[PRODUCTIONVOLUME]
    ADD eperFacilityID [int]

IF NOT EXISTS ( SELECT * FROM [EPRTRmaster].[INFORMATION_SCHEMA].[COLUMNS]
    WHERE
        TABLE_NAME='FACILITYREPORT' AND
        COLUMN_NAME='eperFacilityID'
)
 ALTER TABLE [EPRTRmaster].[dbo].[FACILITYREPORT]
    ADD eperFacilityID [int]

IF NOT EXISTS ( SELECT * FROM [EPRTRmaster].[INFORMATION_SCHEMA].[COLUMNS]
    WHERE
        TABLE_NAME='LOV_ANNEXIACTIVITY' AND
        COLUMN_NAME='eperAnnex3_ID'
)
 ALTER TABLE [EPRTRmaster].[dbo].[LOV_ANNEXIACTIVITY]
    ADD eperAnnex3_ID [int]

IF NOT EXISTS ( SELECT * FROM [EPRTRmaster].[INFORMATION_SCHEMA].[COLUMNS]
    WHERE
        TABLE_NAME='LOV_POLLUTANT' AND
        COLUMN_NAME='eperPollutant_ID'
)
 ALTER TABLE [EPRTRmaster].[dbo].[LOV_POLLUTANT]
    ADD eperPollutant_ID [int]

GO

----2nd SQL Script of EPER2EPRTR
--------------------------------------------------------------------------------
-- Fill POLLUTANTRELEASEANDTRANSFERREPORT --------------------------------------
--------------------------------------------------------------------------------
DECLARE @countryCode [char](2)
DECLARE @dtnow [datetime]
DECLARE @dt0 [datetime]
DECLARE @dt1 [datetime]
DECLARE @dt2 [datetime]
DECLARE @dt3 [datetime]
DECLARE @URL [nvarchar](255)
SET @dtnow = GETDATE()
SET @dt0 = CAST(2000-01-01 AS datetime)
SET @dt1 = CAST(2004-02-23 AS datetime)
SET @dt2 = CAST(2005-03-31 AS datetime)
SET @dt3 = CAST(2006-11-23 AS datetime)
SET @URL  = 'Transferred from EPER' 

INSERT INTO [EPRTRmaster].[dbo].[POLLUTANTRELEASEANDTRANSFERREPORT]
SELECT
    CAST(ReportYear AS int) AS ReportingYear,
	CAST(LOV_CountryID AS int) AS LOV_CountryID,
    CAST(LOV_CoordinateSystemID AS int) AS LOV_CoordinateSystemID,
    CAST(Comment AS nvarchar(MAX)) AS RemarkText,
    @URL AS CdrUrl,
    CAST(SubmissionDate AS datetime) AS CdrUploaded,
    CAST(SubmissionDate AS datetime) AS CdrReleased,
    CAST(CASE
        WHEN ISNULL(Datestamp, @dt0) = @dt0 THEN
            CASE
                WHEN ISNULL(SubmissionDate, @dt0) < @dt1 THEN @dt1
                WHEN ISNULL(SubmissionDate, @dtnow) >= '2010-11-01' THEN @dt3
                ELSE @dt2
            END
        ELSE Datestamp
    END AS datetime) AS ForReview,
    CAST(CASE
        WHEN ISNULL(Datestamp, @dt0) = @dt0 THEN
            CASE
                WHEN ISNULL(SubmissionDate, @dt0) < @dt1 THEN @dt1
                WHEN ISNULL(SubmissionDate, @dtnow) >= '2010-11-01' THEN @dt3
                ELSE @dt2
            END
        ELSE Datestamp
    END AS datetime) AS Published,
    CAST(NULL AS nvarchar(max)) AS ResubmitReason,
    1 as LOV_StatusID,
    NULL AS Imported, 
    NULL AS xmlReportID,
    CAST(ReportID AS int) AS eperReportID
FROM [sdeims_subset].[dbo].[Report]
INNER JOIN
    [EPRTRmaster].[dbo].[LOV_COUNTRY]
    ON CountryID COLLATE database_default = Code
INNER JOIN (
    SELECT
        DISTINCT CountryID AS ID,
        GeographicCoordinateSystem AS geoCord
    FROM [sdeims_subset].[dbo].[Facility] AS f
    INNER JOIN
        [sdeims_subset].[dbo].[Report] AS r
        ON f.ReportID = r.ReportID
    ) AS m
    ON CountryID COLLATE database_default = m.ID
INNER JOIN
    [EPRTRmaster].[dbo].[LOV_COORDINATESYSTEM] AS c
    ON SUBSTRING(m.geoCord COLLATE database_default, 0, 4) = SUBSTRING(c.Name, 0, 4)



----3rd SQL Script of EPER2EPRTR
--------------------------------------------------------------------------------
-- Fill ADDRESS ----------------------------------------------------------------
--------------------------------------------------------------------------------


-- Copy addresses from Facility
INSERT INTO [EPRTRmaster].[dbo].[ADDRESS]
SELECT
    f.Address AS StreetName,
    NULL AS BuildingNumber,
    f.City AS City,
    f.PostCode AS PostalCode,
    c.LOV_CountryID AS LOV_CountryID,
    NULL AS XMLCOMPETENTID,
    NULL AS XMLFACILITYID,
    NULL AS XMLWASTEID,
    NULL AS XMLWASTESITEID,
    f.FacilityID AS eperFacilityID
FROM [sdeims_subset].[dbo].[FACILITY] AS f
INNER JOIN
    [sdeims_subset].[dbo].[Report] AS r
    ON r.ReportID = f.ReportID
INNER JOIN
    [EPRTRmaster].[dbo].[LOV_COUNTRY] AS c
    ON CountryID COLLATE database_default = Code

-- Generate dummy addresses for CompetentAuthorityParty
/*INSERT INTO [EPRTRmaster].[dbo].[ADDRESS]
SELECT distinct
    NULL AS StreetName,
    NULL AS BuildingNumber,
    NULL AS City,
    NULL AS PostalCode,
    c.LOV_CountryID AS LOV_CountryID,
    NULL AS XMLCOMPETENTID,
    NULL AS XMLFACILITYID,
    NULL AS XMLWASTEID,
    NULL AS XMLWASTESITEID,
    NULL AS eperFacilityID
FROM [sdeims_subset].[dbo].[Report] AS r
INNER JOIN
    [EPRTRmaster].[dbo].[LOV_COUNTRY] AS c
    ON CountryID COLLATE database_default = Code
 */

 -- Fill COMPETENTAUTHORITYPARTY with default values
/*INSERT INTO [EPRTRmaster].[dbo].[COMPETENTAUTHORITYPARTY]            
SELECT DISTINCT
    c.LOV_CountryID AS LOV_CountryID,
    r.ReportYear AS ReportingYear,
    'Not transferred from EPER' AS Name,
    a.AddressID AS AddressID,
    0 AS TelephoneCommunication,
    0 AS FaxCommunication,
    '' AS EmailCommunication,
    NULL AS ContactPersonName,
    NULL AS xmlCompetentAuthorityPartyID
FROM [EPRTRmaster].[dbo].[LOV_COUNTRY] AS c
INNER JOIN
    [sdeims_subset].[dbo].[Report] AS r
    ON c.Code COLLATE database_default = r.CountryID
INNER JOIN
    [EPRTRmaster].[dbo].[ADDRESS] AS a
    ON a.LOV_CountryID = c.LOV_CountryID
WHERE
    ISNULL(a.StreetName, '') = '' AND
    ISNULL(a.BuildingNumber, '') = '' AND
    ISNULL(a.City, '') = '' AND
    ISNULL(a.PostalCode, 0) = 0
*/
--END
 
----4th SQL Script of EPER2EPRTR
--------------------------------------------------------------------------------
-- Fill FACILITY and FACILITYLOG -----------------------------------------------
--------------------------------------------------------------------------------

GO

DECLARE @FacilityID nvarchar(255)

DECLARE FACILITYid CURSOR FOR    
    SELECT DISTINCT(FacilityID) FROM [sdeims_subset].[dbo].[FACILITY]
	where EPRTRFacilityID is NULL
	order by FacilityID
BEGIN 
      OPEN FACILITYid;
      Fetch next from FACILITYid into @FacilityID
      while @@FETCH_STATUS = 0
      BEGIN 
          DECLARE @NewFacilityID int
          SELECT @NewFacilityID = ISNULL(MAX(FacilityID), 0)+1 FROM [EPRTRmaster].[dbo].[FACILITY] 
          print @NewFacilityID
			 INSERT INTO [EPRTRmaster].[dbo].[FACILITY]
				SELECT
					@NewFacilityID AS FacilityID,  null AS xmlFacilityReportID
				FROM [sdeims_subset].[dbo].[FACILITY] AS f
				WHERE FacilityID = @FacilityID
				order by FacilityID

			  UPDATE [sdeims_subset].[dbo].[FACILITY]
			  set EPRTRFacilityID = @NewFacilityID,
			  FacilityID = @NewFacilityID
			  WHERE FacilityID = @FacilityID
			  
			  UPDATE [sdeims_subset].[dbo].[AnnexIActivity]
			  set EPRTRFacilityID = @NewFacilityID,
			  FacilityID = @NewFacilityID
			  WHERE FacilityID = @FacilityID
			  
			  UPDATE [sdeims_subset].[dbo].Emission
			  set EPRTRFacilityID = @NewFacilityID,
			  FacilityID = @NewFacilityID
			  WHERE FacilityID = @FacilityID
		  
		  
		  
      FETCH NEXT from FACILITYid into @FacilityID
End
CLOSE FACILITYid;
END;
DEALLOCATE FACILITYid

--SELECT * FROM [EPRTRmaster].[dbo].[FACILITY]

-- FACILITYLOG
INSERT INTO [EPRTRmaster].[dbo].[FACILITYLOG]
SELECT
    f.ReportID as FacilityReportID,
    f.FacilityID AS FacilityID,
    NationalID AS NationalID,
    ReportYear AS ReportingYear,
    Published AS Published,
    f.FacilityID AS eperFacilityID
FROM [sdeims_subset].[dbo].[FACILITY] AS f
INNER JOIN
    [sdeims_subset].[dbo].[Report] AS r
    ON r.ReportID = f.ReportID
INNER JOIN (
    SELECT
        m.nID,
        m.cID,
        Row_Number() OVER (ORDER BY m.nID) AS RowIndex
    FROM (
        SELECT DISTINCT f.NationalID AS nID, r.CountryID AS cID
        FROM
            [sdeims_subset].[dbo].[FACILITY] AS f,
            [sdeims_subset].[dbo].[Report] AS r
        WHERE f.ReportID = r.ReportID
        ) AS m
    ) AS n
    ON n.nID = NationalID AND n.cID = r.CountryID
INNER JOIN
    [EPRTRmaster].[dbo].[POLLUTANTRELEASEANDTRANSFERREPORT] p
    ON r.ReportID = p.eperReportID
ORDER BY 1


------5th SQL Script of EPER2EPRTR
--------------------------------------------------------------------------------
-- Fill PRODUCTIONVOLUME -------------------------------------------------------
--------------------------------------------------------------------------------

INSERT INTO [EPRTRmaster].[dbo].[PRODUCTIONVOLUME]
SELECT
    '' AS ProductName,
    CAST(ProductionVolume AS [float]) AS Quantity,
    LOV_UnitID,
    null AS xmlFacilityReportID,
    FacilityID AS eperFacilityID
FROM
    [sdeims_subset].[dbo].[FACILITY],
    [EPRTRmaster].[dbo].[LOV_UNIT]
WHERE [ProductionVolume] NOT IN (
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
    'null') AND
    [ProductionVolume] > '' AND
    [Code] = 'UNKNOWN'
ORDER BY 1 ASC

INSERT INTO [EPRTRmaster].[dbo].[PRODUCTIONVOLUME]
    VALUES ('Ultramarine Pigments', 10120, 3, 186030, null)
INSERT INTO [EPRTRmaster].[dbo].[PRODUCTIONVOLUME]
    VALUES ('LEAD AND SILVER BULLION', 248514, 3, 186530, null)
INSERT INTO [EPRTRmaster].[dbo].[PRODUCTIONVOLUME]
    VALUES ('landfilling', 3000, 3, 186129, null)
INSERT INTO [EPRTRmaster].[dbo].[PRODUCTIONVOLUME]
    VALUES ('', 5500000, 3, 186372, null)
INSERT INTO [EPRTRmaster].[dbo].[PRODUCTIONVOLUME]
    VALUES ('Generation of electricity', 6548213800, 4, 186248, null)
INSERT INTO [EPRTRmaster].[dbo].[PRODUCTIONVOLUME]
    VALUES ('<', 120000, 3, 186740, null)
INSERT INTO [EPRTRmaster].[dbo].[PRODUCTIONVOLUME]
    VALUES ('', 1300000, 12, 186829, null)
INSERT INTO [EPRTRmaster].[dbo].[PRODUCTIONVOLUME]
    VALUES ('', 138, 9, 186767, null)
INSERT INTO [EPRTRmaster].[dbo].[PRODUCTIONVOLUME]
    VALUES ('', 180, 3, 186786, null)
INSERT INTO [EPRTRmaster].[dbo].[PRODUCTIONVOLUME]
    VALUES ('', 230000, 3, 186755, null)
INSERT INTO [EPRTRmaster].[dbo].[PRODUCTIONVOLUME]
    VALUES ('', 245000, 3, 186798, null)
INSERT INTO [EPRTRmaster].[dbo].[PRODUCTIONVOLUME]
    VALUES ('', 300000, 3, 186811, null)
INSERT INTO [EPRTRmaster].[dbo].[PRODUCTIONVOLUME]
    VALUES ('', 40000, 3, 186771, null)
INSERT INTO [EPRTRmaster].[dbo].[PRODUCTIONVOLUME]
    VALUES ('laying hens', 499000, 1, 186812, null)
INSERT INTO [EPRTRmaster].[dbo].[PRODUCTIONVOLUME]
    VALUES ('', 50000, 3, 186802, null)
INSERT INTO [EPRTRmaster].[dbo].[PRODUCTIONVOLUME]
    VALUES ('approx (sale-able)',30000, 3, 186828, null)
    
    
--6th SQL Script of EPER2EPRTR
--------------------------------------------------------------------------------
-- Fill COMPETENTAUTHORITYPARTY ------------------------------------------------
--------------------------------------------------------------------------------

/*INSERT INTO [EPRTRmaster].[dbo].[EPERCONTACTINFORMATION]
SELECT
    f.FacilityID,
    f.RegulatoryBodies,
    f.ContactName,
    f.PhoneNumber,
    f.FaxNumber,
    f.Email
FROM [sdeims_subset].[dbo].[FACILITY] AS f
*/
--SELECT * FROM [EPRTRmaster].[dbo].[EPERCONTACTINFORMATION]



--7th SQL Script of EPER2EPRTR
--------------------------------------------------------------------------------
-- Fill FACILITYREPORT ---------------------------------------------------------
--------------------------------------------------------------------------------

DECLARE @UNKNOWN [int]
SELECT @UNKNOWN = [LOV_RiverBasinDistrictID]
    FROM [EPRTRmaster].[dbo].[LOV_RIVERBASINDISTRICT]
    WHERE [Code] = 'UNKNOWN'

INSERT INTO [EPRTRmaster].[dbo].[FACILITYREPORT]
SELECT
    p.PollutantReleaseAndTransferReportID,
    fl.FacilityID AS FacilityID,
    f.NationalID AS NationalID,
    f.ParentCompanyName AS ParentCompanyName,
    f.FacilityName AS FacilityName,
    --a.AddressID AS AddressID,
    (select min(AddressID) From [EPRTRmaster].[dbo].[ADDRESS] AS a where a.eperFacilityID = f.FacilityID)
     AS AddressID,
    geometry::STGeomFromText('POINT(' +
        CAST(f.Latitude AS varchar(32)) + ' '+
        CAST(f.Longitude AS varchar(32)) + ')', 0) AS GeographicalCoordinate,
    1 AS LOV_StatusID,
    @UNKNOWN AS LOV_RiverBasinDistrictID,
    --NULL AS LOV_RiverBasinDistrictID_Source,
    '' AS LOV_RiverBasinDistrictID_Source,
    -- mapping of f.NaceCodeID (still missing), ex:fishing
    --1 AS LOV_NACEMainEconomicActivityID, 
    f.NaceCodeID AS LOV_NACEMainEconomicActivityID, 
    -- read FROM table LOV_NaceActivity
    '' AS MainEconomicActivityName,
    --ap.CompetentAuthorityPartyID AS CompetentAuthorityPartyID,
    (select MIN(CompetentAuthorityPartyID) from [EPRTRmaster].[dbo].[COMPETENTAUTHORITYPARTY] AS ap
    where ap.LOV_CountryID = p.LOV_CountryID AND
       (ap.ReportingYear = 2001 or ap.ReportingYear = 2004))AS CompetentAuthorityPartyID,
    pv.ProductionVolumeID AS ProductionVolumeID,
    f.NoOfInstallations AS TotalIPPCInstallationQuantity,
    f.OperatingHours AS OperatingHours,
    f.Employees AS TotalEmployeeQuantity,
    --added by geocoding
    NULL AS LOV_NUTSRegionID,
    NULL AS LOV_NUTSRegionID_Source,
    f.WebAddress AS WebsiteCommunication,
    NULL AS PublicInformation,
    0 AS ConfidentialIndicator,
    NULL AS LOV_ConfidentialityID,
    0 AS ProtectVoluntaryData,
    NULL AS RemarkText,
    NULL AS xmlFacilityReportID,
    f.FacilityID AS eperFacilityID
FROM [sdeims_subset].[dbo].[FACILITY] AS f
INNER JOIN
    [sdeims_subset].[dbo].[Report] AS r
    ON r.ReportID = f.ReportID
INNER JOIN
    [EPRTRmaster].[dbo].[POLLUTANTRELEASEANDTRANSFERREPORT] AS p
    ON p.eperReportID =  r.ReportID
/*INNER JOIN
    [EPRTRmaster].[dbo].[ADDRESS] AS a
    ON a.eperFacilityID = f.FacilityID*/
 
INNER JOIN
    [EPRTRmaster].[dbo].[FACILITYLOG] AS fl
    ON fl.eperFacilityID = f.FacilityID
/*INNER JOIN
    [EPRTRmaster].[dbo].[COMPETENTAUTHORITYPARTY] AS ap
    ON ap.LOV_CountryID = p.LOV_CountryID AND
       ap.ReportingYear = p.ReportingYear*/
LEFT OUTER JOIN
    [EPRTRmaster].[dbo].[PRODUCTIONVOLUME] AS pv
    ON pv.eperFacilityID = f.FacilityID
    
   
   
  
--8th SQL Script of EPER2EPRTR
--------------------------------------------------------------------------------
-- Add values to LOV_ANNEXIACTIVITY and map it to EPER-DB ----------------------
--------------------------------------------------------------------------------

UPDATE [EPRTRmaster].[dbo].[LOV_ANNEXIACTIVITY]
   SET eperAnnex3_ID = 1 WHERE [Code] = 'EPER_1'
   
UPDATE [EPRTRmaster].[dbo].[LOV_ANNEXIACTIVITY]
    SET eperAnnex3_ID = 2 WHERE [Code] = 'EPER_1.1'

UPDATE [EPRTRmaster].[dbo].[LOV_ANNEXIACTIVITY]
   SET eperAnnex3_ID = 3 WHERE [Code] = 'EPER_1.2'

UPDATE [EPRTRmaster].[dbo].[LOV_ANNEXIACTIVITY]
   SET eperAnnex3_ID = 4 WHERE [Code] = 'EPER_1.3'

UPDATE [EPRTRmaster].[dbo].[LOV_ANNEXIACTIVITY]
    SET eperAnnex3_ID = 5 WHERE [Code] = 'EPER_1.4'

UPDATE [EPRTRmaster].[dbo].[LOV_ANNEXIACTIVITY]
   SET eperAnnex3_ID = 6 WHERE [Code] = 'EPER_2'
 
UPDATE [EPRTRmaster].[dbo].[LOV_ANNEXIACTIVITY]
    SET eperAnnex3_ID = 7 WHERE [Code] = 'EPER_2.1/2.2/2.3/2.4/2.5/2.6' 

UPDATE [EPRTRmaster].[dbo].[LOV_ANNEXIACTIVITY]
   SET eperAnnex3_ID = 8 WHERE [Code] = 'EPER_3'

UPDATE [EPRTRmaster].[dbo].[LOV_ANNEXIACTIVITY]
    SET eperAnnex3_ID = 9 WHERE [Code] = 'EPER_3.1/3.3/3.4/3.5'
    
UPDATE [EPRTRmaster].[dbo].[LOV_ANNEXIACTIVITY]
    SET eperAnnex3_ID = 10 WHERE [Code] ='EPER_3.2'

UPDATE [EPRTRmaster].[dbo].[LOV_ANNEXIACTIVITY]
   SET eperAnnex3_ID = 11 WHERE [Code] = 'EPER_4'

UPDATE [EPRTRmaster].[dbo].[LOV_ANNEXIACTIVITY]
    SET eperAnnex3_ID = 12 WHERE [Code] = 'EPER_4.1'

UPDATE [EPRTRmaster].[dbo].[LOV_ANNEXIACTIVITY]
    SET eperAnnex3_ID = 13 WHERE [Code] = 'EPER_4.2/4.3'
    
UPDATE [EPRTRmaster].[dbo].[LOV_ANNEXIACTIVITY]
    SET eperAnnex3_ID = 14 WHERE [Code] = 'EPER_4.4/4.6'

UPDATE [EPRTRmaster].[dbo].[LOV_ANNEXIACTIVITY]
    SET eperAnnex3_ID = 15 WHERE [Code] = 'EPER_4.5'

UPDATE [EPRTRmaster].[dbo].[LOV_ANNEXIACTIVITY]
   SET eperAnnex3_ID = 16 WHERE [Code] = 'EPER_5'
 
UPDATE [EPRTRmaster].[dbo].[LOV_ANNEXIACTIVITY]

    SET eperAnnex3_ID = 17 WHERE [Code] = 'EPER_5.1/5.2'

UPDATE [EPRTRmaster].[dbo].[LOV_ANNEXIACTIVITY]

    SET eperAnnex3_ID = 18 WHERE [Code] = 'EPER_5.3/5.4'

UPDATE [EPRTRmaster].[dbo].[LOV_ANNEXIACTIVITY]
   SET eperAnnex3_ID = 19 WHERE [Code] = 'EPER_6'

UPDATE [EPRTRmaster].[dbo].[LOV_ANNEXIACTIVITY]
    SET eperAnnex3_ID = 20 WHERE [Code] = 'EPER_6.1'

UPDATE [EPRTRmaster].[dbo].[LOV_ANNEXIACTIVITY]
    SET eperAnnex3_ID = 21 WHERE [Code] = 'EPER_6.2'
     
UPDATE [EPRTRmaster].[dbo].[LOV_ANNEXIACTIVITY]
    SET eperAnnex3_ID = 22 WHERE [Code] ='EPER_6.3'

UPDATE [EPRTRmaster].[dbo].[LOV_ANNEXIACTIVITY]
    SET eperAnnex3_ID = 23 WHERE [Code] = 'EPER_6.4'    
     
UPDATE [EPRTRmaster].[dbo].[LOV_ANNEXIACTIVITY]
    SET eperAnnex3_ID = 24 WHERE [Code] = 'EPER_6.5'
   
UPDATE [EPRTRmaster].[dbo].[LOV_ANNEXIACTIVITY]
    SET eperAnnex3_ID = 25 WHERE [Code] = 'EPER_6.6'
   
UPDATE [EPRTRmaster].[dbo].[LOV_ANNEXIACTIVITY]
    SET eperAnnex3_ID = 26 WHERE [Code] = 'EPER_6.7'
    
UPDATE [EPRTRmaster].[dbo].[LOV_ANNEXIACTIVITY]
    SET eperAnnex3_ID = 27 WHERE [Code] = 'EPER_6.8'   
    
    
   
    
--9th SQL Script of EPER2EPRTR
--------------------------------------------------------------------------------
-- Fill ACTIVITY ---------------------------------------------------------------
--------------------------------------------------------------------------------

IF object_id('tempdb..#T') IS NOT NULL DROP TABLE #T
CREATE TABLE #T(fID [int], aID [int], ma [int], rn [int])

INSERT INTO #T
SELECT
    FacilityID AS fID,
    ActivityID AS aID,
    MainActivity AS ma,
    Row_Number() OVER (ORDER BY FacilityID) AS rn
FROM [sdeims_subset].[dbo].[AnnexIActivity]

INSERT INTO [EPRTRmaster].[dbo].[ACTIVITY] (
    FacilityReportID,
    RankingNumeric,
    LOV_AnnexIActivityID
)
SELECT
    FacilityReportID AS FacilityReportID,
    --t2.rn - t1.rn + 1 AS RankingNumeric,
    1 AS RankingNumeric,
    LOV_AnnexIActivityID AS LOV_AnnexIActivityID
    
FROM #T t1
/*INNER JOIN
    #T t2
    ON t1.fID = t2.fID AND t2.ma = 1*/
INNER JOIN
    [EPRTRmaster].[dbo].[FACILITYREPORT]
    ON eperFacilityID = t1.fID
INNER JOIN
    [sdeims_subset].[dbo].[Activity] a
    ON a.ActivityID = t1.aID
INNER JOIN
    [EPRTRmaster].[dbo].[LOV_ANNEXIACTIVITY]
    ON a.Annex3ID = eperAnnex3_ID
 
 
 
 
    
----10th SQL Script of EPER2EPRTR
--------------------------------------------------------------------------------
-- Map LOV_POLLUTANT to EPER-DB ------------------------------------------------
--------------------------------------------------------------------------------

UPDATE [EPRTRmaster].[dbo].[LOV_POLLUTANT]
    SET eperPollutant_ID = 3 WHERE [Code] = 'CH4'
UPDATE [EPRTRmaster].[dbo].[LOV_POLLUTANT]
    SET eperPollutant_ID = 4 WHERE [Code] = 'CO'
UPDATE [EPRTRmaster].[dbo].[LOV_POLLUTANT]
    SET eperPollutant_ID = 5 WHERE [Code] = 'CO2'
UPDATE [EPRTRmaster].[dbo].[LOV_POLLUTANT]
    SET eperPollutant_ID = 6 WHERE [Code] = 'HFCS'
UPDATE [EPRTRmaster].[dbo].[LOV_POLLUTANT]
    SET eperPollutant_ID = 7 WHERE [Code] = 'N2O'
UPDATE [EPRTRmaster].[dbo].[LOV_POLLUTANT]
    SET eperPollutant_ID = 8 WHERE [Code] = 'NH3'
UPDATE [EPRTRmaster].[dbo].[LOV_POLLUTANT]
    SET eperPollutant_ID = 9 WHERE [Code] = 'NMVOC'
UPDATE [EPRTRmaster].[dbo].[LOV_POLLUTANT]
    SET eperPollutant_ID = 10 WHERE [Code] = 'NOX'
UPDATE [EPRTRmaster].[dbo].[LOV_POLLUTANT]
    SET eperPollutant_ID = 11 WHERE [Code] = 'PFCS'
UPDATE [EPRTRmaster].[dbo].[LOV_POLLUTANT]
    SET eperPollutant_ID = 12 WHERE [Code] = 'SF6'
UPDATE [EPRTRmaster].[dbo].[LOV_POLLUTANT]
    SET eperPollutant_ID = 13 WHERE [Code] = 'SOX'
UPDATE [EPRTRmaster].[dbo].[LOV_POLLUTANT]
    SET eperPollutant_ID = 14 WHERE [Code] = 'TOTAL - NITROGEN'
UPDATE [EPRTRmaster].[dbo].[LOV_POLLUTANT]
    SET eperPollutant_ID = 15 WHERE [Code] = 'TOTAL - PHOSPHORUS'
UPDATE [EPRTRmaster].[dbo].[LOV_POLLUTANT]
    SET eperPollutant_ID = 17 WHERE [Code] = 'AS AND COMPOUNDS'
UPDATE [EPRTRmaster].[dbo].[LOV_POLLUTANT]
    SET eperPollutant_ID = 18 WHERE [Code] = 'CD AND COMPOUNDS'
UPDATE [EPRTRmaster].[dbo].[LOV_POLLUTANT]
    SET eperPollutant_ID = 19 WHERE [Code] = 'CR AND COMPOUNDS'
UPDATE [EPRTRmaster].[dbo].[LOV_POLLUTANT]
    SET eperPollutant_ID = 20 WHERE [Code] = 'CU AND COMPOUNDS'
UPDATE [EPRTRmaster].[dbo].[LOV_POLLUTANT]
    SET eperPollutant_ID = 21 WHERE [Code] = 'HG AND COMPOUNDS'
UPDATE [EPRTRmaster].[dbo].[LOV_POLLUTANT]
    SET eperPollutant_ID = 22 WHERE [Code] = 'NI AND COMPOUNDS'
UPDATE [EPRTRmaster].[dbo].[LOV_POLLUTANT]
    SET eperPollutant_ID = 23 WHERE [Code] = 'PB AND COMPOUNDS'
UPDATE [EPRTRmaster].[dbo].[LOV_POLLUTANT]
    SET eperPollutant_ID = 24 WHERE [Code] = 'ZN AND COMPOUNDS'
UPDATE [EPRTRmaster].[dbo].[LOV_POLLUTANT]
    SET eperPollutant_ID = 26 WHERE [Code] = 'DICHLOROETHANE-1,2 (DCE)'
UPDATE [EPRTRmaster].[dbo].[LOV_POLLUTANT]
    SET eperPollutant_ID = 27 WHERE [Code] = 'DICHLOROMETHANE (DCM)'
UPDATE [EPRTRmaster].[dbo].[LOV_POLLUTANT]
    SET eperPollutant_ID = 28 WHERE [Code] = 'CHLORO-ALKANES (C10-13)'
UPDATE [EPRTRmaster].[dbo].[LOV_POLLUTANT]
    SET eperPollutant_ID = 29 WHERE [Code] = 'HEXACHLOROBENZENE (HCB)'
UPDATE [EPRTRmaster].[dbo].[LOV_POLLUTANT]
    SET eperPollutant_ID = 30 WHERE [Code] = 'HEXACHLOROBUTADIENE (HCBD)'
UPDATE [EPRTRmaster].[dbo].[LOV_POLLUTANT]
    SET eperPollutant_ID = 31 WHERE [Code] = 'HEXACHLOROCYCLOHEXANE(HCH)'
UPDATE [EPRTRmaster].[dbo].[LOV_POLLUTANT]
    SET eperPollutant_ID = 32 WHERE [Code] = 'HALOGENATED ORGANIC COMPOUNDS'
UPDATE [EPRTRmaster].[dbo].[LOV_POLLUTANT]
    SET eperPollutant_ID = 33 WHERE [Code] = 'PCDD+PCDF (DIOXINS+FURANS)'
UPDATE [EPRTRmaster].[dbo].[LOV_POLLUTANT]
    SET eperPollutant_ID = 34 WHERE [Code] = 'PENTACHLOROPHENOL (PCP)'
UPDATE [EPRTRmaster].[dbo].[LOV_POLLUTANT]
    SET eperPollutant_ID = 35 WHERE [Code] = 'TETRACHLOROETHYLENE (PER)'
UPDATE [EPRTRmaster].[dbo].[LOV_POLLUTANT]
    SET eperPollutant_ID = 36 WHERE [Code] = 'TETRACHLOROMETHANE (TCM)'
UPDATE [EPRTRmaster].[dbo].[LOV_POLLUTANT]
    SET eperPollutant_ID = 37 WHERE [Code] = 'TRICHLOROBENZENES (TCB)'
UPDATE [EPRTRmaster].[dbo].[LOV_POLLUTANT]
    SET eperPollutant_ID = 38 WHERE [Code] = 'TRICHLOROETHANE-1,1,1 (TCE)'
UPDATE [EPRTRmaster].[dbo].[LOV_POLLUTANT]
    SET eperPollutant_ID = 39 WHERE [Code] = 'TRICHLOROETHYLENE (TRI)'
UPDATE [EPRTRmaster].[dbo].[LOV_POLLUTANT]
    SET eperPollutant_ID = 40 WHERE [Code] = 'TRICHLOROMETHANE'
UPDATE [EPRTRmaster].[dbo].[LOV_POLLUTANT]
    SET eperPollutant_ID = 42 WHERE [Code] = 'BENZENE'
UPDATE [EPRTRmaster].[dbo].[LOV_POLLUTANT]
    SET eperPollutant_ID = 43 WHERE [Code] = 'BTEX'
UPDATE [EPRTRmaster].[dbo].[LOV_POLLUTANT]
    SET eperPollutant_ID = 44 WHERE [Code] = 'BROMINATED DIPHENYLETHER'
UPDATE [EPRTRmaster].[dbo].[LOV_POLLUTANT]
    SET eperPollutant_ID = 45 WHERE [Code] = 'ORGANOTIN - COMPOUNDS'
UPDATE [EPRTRmaster].[dbo].[LOV_POLLUTANT]
    SET eperPollutant_ID = 46 WHERE [Code] = 'PAHs in EPER'
UPDATE [EPRTRmaster].[dbo].[LOV_POLLUTANT]
    SET eperPollutant_ID = 47 WHERE [Code] = 'PHENOLS'
UPDATE [EPRTRmaster].[dbo].[LOV_POLLUTANT]
    SET eperPollutant_ID = 48 WHERE [Code] = 'TOTAL ORGANIC CARBON (TOC)'
UPDATE [EPRTRmaster].[dbo].[LOV_POLLUTANT]
    SET eperPollutant_ID = 50 WHERE [Code] = 'CHLORIDES'
UPDATE [EPRTRmaster].[dbo].[LOV_POLLUTANT]
    SET eperPollutant_ID = 51 WHERE [Code] = 'CHLORINE AND INORGANIC COMPOUNDS'
UPDATE [EPRTRmaster].[dbo].[LOV_POLLUTANT]
    SET eperPollutant_ID = 52 WHERE [Code] = 'CYANIDES'
UPDATE [EPRTRmaster].[dbo].[LOV_POLLUTANT]
    SET eperPollutant_ID = 53 WHERE [Code] = 'FLUORIDES'
UPDATE [EPRTRmaster].[dbo].[LOV_POLLUTANT]
    SET eperPollutant_ID = 54 WHERE [Code] = 'FLUORINE AND INORGANIC COMPOUNDS'
UPDATE [EPRTRmaster].[dbo].[LOV_POLLUTANT]
    SET eperPollutant_ID = 55 WHERE [Code] = 'HCN'
UPDATE [EPRTRmaster].[dbo].[LOV_POLLUTANT]
    SET eperPollutant_ID = 56 WHERE [Code] = 'PM10'
UPDATE [EPRTRmaster].[dbo].[LOV_POLLUTANT]
    SET eperPollutant_ID = 487 WHERE [Code] = 'ETHYLBENZENE'
UPDATE [EPRTRmaster].[dbo].[LOV_POLLUTANT]
    SET eperPollutant_ID = 488 WHERE [Code] = 'XYLENES'
UPDATE [EPRTRmaster].[dbo].[LOV_POLLUTANT]
    SET eperPollutant_ID = 489 WHERE [Code] = 'TOLUENE'


------- UPDATE in FacilityReport for NACECode For EPER
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1343  WHERE LOV_NACEMainEconomicActivityID = 4
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1344  WHERE LOV_NACEMainEconomicActivityID = 5
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1346  WHERE LOV_NACEMainEconomicActivityID = 7
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1349  WHERE LOV_NACEMainEconomicActivityID = 10
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1350  WHERE LOV_NACEMainEconomicActivityID = 11
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1351  WHERE LOV_NACEMainEconomicActivityID = 12
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1352  WHERE LOV_NACEMainEconomicActivityID = 13
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1354  WHERE LOV_NACEMainEconomicActivityID = 15
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1355  WHERE LOV_NACEMainEconomicActivityID = 16
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1356  WHERE LOV_NACEMainEconomicActivityID = 17
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1002  WHERE LOV_NACEMainEconomicActivityID = 30
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1003  WHERE LOV_NACEMainEconomicActivityID = 31
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1005  WHERE LOV_NACEMainEconomicActivityID = 33
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1009  WHERE LOV_NACEMainEconomicActivityID = 37
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1012  WHERE LOV_NACEMainEconomicActivityID = 41
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1013  WHERE LOV_NACEMainEconomicActivityID = 42
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1014  WHERE LOV_NACEMainEconomicActivityID = 43
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1020  WHERE LOV_NACEMainEconomicActivityID = 49
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1021  WHERE LOV_NACEMainEconomicActivityID = 50
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1024  WHERE LOV_NACEMainEconomicActivityID = 53
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1025  WHERE LOV_NACEMainEconomicActivityID = 56
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1026  WHERE LOV_NACEMainEconomicActivityID = 57
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1027  WHERE LOV_NACEMainEconomicActivityID = 58
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1028  WHERE LOV_NACEMainEconomicActivityID = 59
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1029  WHERE LOV_NACEMainEconomicActivityID = 60
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1030  WHERE LOV_NACEMainEconomicActivityID = 61
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1032  WHERE LOV_NACEMainEconomicActivityID = 63
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1033  WHERE LOV_NACEMainEconomicActivityID = 64
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1034  WHERE LOV_NACEMainEconomicActivityID = 65
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1036  WHERE LOV_NACEMainEconomicActivityID = 67
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1037  WHERE LOV_NACEMainEconomicActivityID = 68
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1038  WHERE LOV_NACEMainEconomicActivityID = 69
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1039  WHERE LOV_NACEMainEconomicActivityID = 70
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1040  WHERE LOV_NACEMainEconomicActivityID = 71
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1041  WHERE LOV_NACEMainEconomicActivityID = 72
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1043  WHERE LOV_NACEMainEconomicActivityID = 74
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1044  WHERE LOV_NACEMainEconomicActivityID = 75
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1046  WHERE LOV_NACEMainEconomicActivityID = 77
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1047  WHERE LOV_NACEMainEconomicActivityID = 78
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1049  WHERE LOV_NACEMainEconomicActivityID = 80
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1051  WHERE LOV_NACEMainEconomicActivityID = 82
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1052  WHERE LOV_NACEMainEconomicActivityID = 83
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1057  WHERE LOV_NACEMainEconomicActivityID = 88
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1059  WHERE LOV_NACEMainEconomicActivityID = 90
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1064  WHERE LOV_NACEMainEconomicActivityID = 95
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1065  WHERE LOV_NACEMainEconomicActivityID = 96
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1066  WHERE LOV_NACEMainEconomicActivityID = 97
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1068  WHERE LOV_NACEMainEconomicActivityID = 100
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1070  WHERE LOV_NACEMainEconomicActivityID = 102
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1071  WHERE LOV_NACEMainEconomicActivityID = 103
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1074  WHERE LOV_NACEMainEconomicActivityID = 106
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1076  WHERE LOV_NACEMainEconomicActivityID = 108
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1078  WHERE LOV_NACEMainEconomicActivityID = 110
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1079  WHERE LOV_NACEMainEconomicActivityID = 111
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1083  WHERE LOV_NACEMainEconomicActivityID = 115
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1086  WHERE LOV_NACEMainEconomicActivityID = 118
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1090  WHERE LOV_NACEMainEconomicActivityID = 122
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1105  WHERE LOV_NACEMainEconomicActivityID = 138
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1106  WHERE LOV_NACEMainEconomicActivityID = 139
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1109  WHERE LOV_NACEMainEconomicActivityID = 143
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1111  WHERE LOV_NACEMainEconomicActivityID = 145
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1117  WHERE LOV_NACEMainEconomicActivityID = 152
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1118  WHERE LOV_NACEMainEconomicActivityID = 153
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1119  WHERE LOV_NACEMainEconomicActivityID = 154
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1120  WHERE LOV_NACEMainEconomicActivityID = 155
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1122  WHERE LOV_NACEMainEconomicActivityID = 157
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1123  WHERE LOV_NACEMainEconomicActivityID = 158
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1124  WHERE LOV_NACEMainEconomicActivityID = 159
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1126  WHERE LOV_NACEMainEconomicActivityID = 161
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1127  WHERE LOV_NACEMainEconomicActivityID = 162
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1136  WHERE LOV_NACEMainEconomicActivityID = 171
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1139  WHERE LOV_NACEMainEconomicActivityID = 174
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1144  WHERE LOV_NACEMainEconomicActivityID = 180
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1145  WHERE LOV_NACEMainEconomicActivityID = 181
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1146  WHERE LOV_NACEMainEconomicActivityID = 182
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1148  WHERE LOV_NACEMainEconomicActivityID = 185
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1149  WHERE LOV_NACEMainEconomicActivityID = 186
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1150  WHERE LOV_NACEMainEconomicActivityID = 187
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1151  WHERE LOV_NACEMainEconomicActivityID = 188
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1152  WHERE LOV_NACEMainEconomicActivityID = 189
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1153  WHERE LOV_NACEMainEconomicActivityID = 190
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1154  WHERE LOV_NACEMainEconomicActivityID = 191
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1155  WHERE LOV_NACEMainEconomicActivityID = 192
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1156  WHERE LOV_NACEMainEconomicActivityID = 193
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1157  WHERE LOV_NACEMainEconomicActivityID = 194
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1158  WHERE LOV_NACEMainEconomicActivityID = 195
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1159  WHERE LOV_NACEMainEconomicActivityID = 196
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1160  WHERE LOV_NACEMainEconomicActivityID = 197
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1161  WHERE LOV_NACEMainEconomicActivityID = 198
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1163  WHERE LOV_NACEMainEconomicActivityID = 200
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1165  WHERE LOV_NACEMainEconomicActivityID = 202
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1166  WHERE LOV_NACEMainEconomicActivityID = 203
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1167  WHERE LOV_NACEMainEconomicActivityID = 204
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1169  WHERE LOV_NACEMainEconomicActivityID = 206
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1171  WHERE LOV_NACEMainEconomicActivityID = 208
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1172  WHERE LOV_NACEMainEconomicActivityID = 209
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1173  WHERE LOV_NACEMainEconomicActivityID = 211
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1174  WHERE LOV_NACEMainEconomicActivityID = 212
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1175  WHERE LOV_NACEMainEconomicActivityID = 213
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1176  WHERE LOV_NACEMainEconomicActivityID = 214
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1177  WHERE LOV_NACEMainEconomicActivityID = 215
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1178  WHERE LOV_NACEMainEconomicActivityID = 216
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1179  WHERE LOV_NACEMainEconomicActivityID = 217
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1180  WHERE LOV_NACEMainEconomicActivityID = 218
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1182  WHERE LOV_NACEMainEconomicActivityID = 220
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1183  WHERE LOV_NACEMainEconomicActivityID = 222
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1185  WHERE LOV_NACEMainEconomicActivityID = 224
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1186  WHERE LOV_NACEMainEconomicActivityID = 225
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1187  WHERE LOV_NACEMainEconomicActivityID = 226
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1188  WHERE LOV_NACEMainEconomicActivityID = 227
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1189  WHERE LOV_NACEMainEconomicActivityID = 228
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1192  WHERE LOV_NACEMainEconomicActivityID = 231
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1194  WHERE LOV_NACEMainEconomicActivityID = 233
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1195  WHERE LOV_NACEMainEconomicActivityID = 234
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1196  WHERE LOV_NACEMainEconomicActivityID = 235
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1197  WHERE LOV_NACEMainEconomicActivityID = 236
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1198  WHERE LOV_NACEMainEconomicActivityID = 237
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1200  WHERE LOV_NACEMainEconomicActivityID = 239
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1201  WHERE LOV_NACEMainEconomicActivityID = 240
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1204  WHERE LOV_NACEMainEconomicActivityID = 243
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1213  WHERE LOV_NACEMainEconomicActivityID = 252
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1214  WHERE LOV_NACEMainEconomicActivityID = 254
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1215  WHERE LOV_NACEMainEconomicActivityID = 255
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1217  WHERE LOV_NACEMainEconomicActivityID = 257
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1218  WHERE LOV_NACEMainEconomicActivityID = 258
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1221  WHERE LOV_NACEMainEconomicActivityID = 261
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1223  WHERE LOV_NACEMainEconomicActivityID = 263
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1225  WHERE LOV_NACEMainEconomicActivityID = 265
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1227  WHERE LOV_NACEMainEconomicActivityID = 267
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1228  WHERE LOV_NACEMainEconomicActivityID = 268
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1229  WHERE LOV_NACEMainEconomicActivityID = 269
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1230  WHERE LOV_NACEMainEconomicActivityID = 270
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1232  WHERE LOV_NACEMainEconomicActivityID = 272
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1233  WHERE LOV_NACEMainEconomicActivityID = 273
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1234  WHERE LOV_NACEMainEconomicActivityID = 274
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1235  WHERE LOV_NACEMainEconomicActivityID = 275
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1236  WHERE LOV_NACEMainEconomicActivityID = 276
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1238  WHERE LOV_NACEMainEconomicActivityID = 278
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1239  WHERE LOV_NACEMainEconomicActivityID = 279
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1242  WHERE LOV_NACEMainEconomicActivityID = 282
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1244  WHERE LOV_NACEMainEconomicActivityID = 284
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1245  WHERE LOV_NACEMainEconomicActivityID = 285
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1246  WHERE LOV_NACEMainEconomicActivityID = 286
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1247  WHERE LOV_NACEMainEconomicActivityID = 287
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1250  WHERE LOV_NACEMainEconomicActivityID = 290
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1251  WHERE LOV_NACEMainEconomicActivityID = 291
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1254  WHERE LOV_NACEMainEconomicActivityID = 294
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1255  WHERE LOV_NACEMainEconomicActivityID = 295
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1256  WHERE LOV_NACEMainEconomicActivityID = 296
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1257  WHERE LOV_NACEMainEconomicActivityID = 297
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1262  WHERE LOV_NACEMainEconomicActivityID = 303
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1263  WHERE LOV_NACEMainEconomicActivityID = 304
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1266  WHERE LOV_NACEMainEconomicActivityID = 307
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1267  WHERE LOV_NACEMainEconomicActivityID = 308
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1270  WHERE LOV_NACEMainEconomicActivityID = 311
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1271  WHERE LOV_NACEMainEconomicActivityID = 312
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1275  WHERE LOV_NACEMainEconomicActivityID = 316
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1280  WHERE LOV_NACEMainEconomicActivityID = 321
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1282  WHERE LOV_NACEMainEconomicActivityID = 323
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1287  WHERE LOV_NACEMainEconomicActivityID = 329
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1291  WHERE LOV_NACEMainEconomicActivityID = 333
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1292  WHERE LOV_NACEMainEconomicActivityID = 334
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1295  WHERE LOV_NACEMainEconomicActivityID = 337
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1296  WHERE LOV_NACEMainEconomicActivityID = 338
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1297  WHERE LOV_NACEMainEconomicActivityID = 339
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1303  WHERE LOV_NACEMainEconomicActivityID = 345
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1306  WHERE LOV_NACEMainEconomicActivityID = 349
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1307  WHERE LOV_NACEMainEconomicActivityID = 350
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1308  WHERE LOV_NACEMainEconomicActivityID = 351
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1309  WHERE LOV_NACEMainEconomicActivityID = 352
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1312  WHERE LOV_NACEMainEconomicActivityID = 355
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1315  WHERE LOV_NACEMainEconomicActivityID = 358
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1322  WHERE LOV_NACEMainEconomicActivityID = 366
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1326  WHERE LOV_NACEMainEconomicActivityID = 370
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1327  WHERE LOV_NACEMainEconomicActivityID = 371
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1339  WHERE LOV_NACEMainEconomicActivityID = 383
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1340  WHERE LOV_NACEMainEconomicActivityID = 384
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1364  WHERE LOV_NACEMainEconomicActivityID = 386
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1365  WHERE LOV_NACEMainEconomicActivityID = 387
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1366  WHERE LOV_NACEMainEconomicActivityID = 388
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1367  WHERE LOV_NACEMainEconomicActivityID = 389
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1368  WHERE LOV_NACEMainEconomicActivityID = 390
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1409  WHERE LOV_NACEMainEconomicActivityID = 433
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1503  WHERE LOV_NACEMainEconomicActivityID = 529
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1516  WHERE LOV_NACEMainEconomicActivityID = 542
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1576  WHERE LOV_NACEMainEconomicActivityID = 604
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1583  WHERE LOV_NACEMainEconomicActivityID = 611
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1588  WHERE LOV_NACEMainEconomicActivityID = 616
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1599  WHERE LOV_NACEMainEconomicActivityID = 628
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1622  WHERE LOV_NACEMainEconomicActivityID = 653
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1626  WHERE LOV_NACEMainEconomicActivityID = 658
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1629  WHERE LOV_NACEMainEconomicActivityID = 661
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1635  WHERE LOV_NACEMainEconomicActivityID = 667
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1673  WHERE LOV_NACEMainEconomicActivityID = 705
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1676  WHERE LOV_NACEMainEconomicActivityID = 708
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1677  WHERE LOV_NACEMainEconomicActivityID = 709
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1695  WHERE LOV_NACEMainEconomicActivityID = 727
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1696  WHERE LOV_NACEMainEconomicActivityID = 728
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1697  WHERE LOV_NACEMainEconomicActivityID = 729
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1698  WHERE LOV_NACEMainEconomicActivityID = 730
Update [EPRTRmaster].[dbo].FACILITYREPORT set LOV_NACEMainEconomicActivityID =1699  WHERE LOV_NACEMainEconomicActivityID = 731


    
   
----11th SQL Script of EPER2EPRTR
--------------------------------------------------------------------------------
-- Fill POLLUTANTRELEASE ---------------------------------------------------------------------------------------------------------------------------------------

DECLARE @uID [int]
SELECT @uID = LOV_UnitID FROM [EPRTRmaster].[dbo].[LOV_UNIT]
    WHERE [Code] = 'KGM'

DECLARE @uID_unknown [int]
SELECT @uID_unknown = LOV_UnitID FROM [EPRTRmaster].[dbo].[LOV_UNIT]
    WHERE [Code] = 'UNKNOWN'

INSERT INTO [EPRTRmaster].[dbo].[POLLUTANTRELEASE]
SELECT
    f.FacilityReportID AS FacilityReportID,
    m.LOV_MediumID AS LOV_MediumID,
    p.LOV_PollutantID AS LOV_PollutantID,
    mb.LOV_MethodBasisID AS LOV_MethodBasisID,
    NULL AS MethodListID,
    e.EmissionValue AS TotalQuantity,
    @uID AS LOV_TotalQuantityUnitID,
    0 AS AccidentalQuantity,
    @uID_unknown AS LOV_AccidentalQuantityUnitID,
    0 AS ConfidentialIndicator,
    NULL AS LOV_ConfidentialityID,
    NULL AS RemarkText
FROM [sdeims_subset].[dbo].[Emission] AS e
INNER JOIN
    [EPRTRmaster].[dbo].[FACILITYREPORT] AS f
    ON f.eperFacilityID = e.FacilityID
INNER JOIN
    [EPRTRmaster].[dbo].[LOV_METHODBASIS] AS mb
    ON mb.Code COLLATE database_default = e.Method
INNER JOIN
    [EPRTRmaster].[dbo].[LOV_MEDIUM] AS m
    ON (e.EmissionTypeID = 1 AND m.Code = 'AIR') OR
       (e.EmissionTypeID = 2 AND m.Code = 'WATER')
INNER JOIN
    [EPRTRmaster].[dbo].[LOV_POLLUTANT] AS p
    ON e.PollutantID = p.eperPollutant_ID
    
    
----12th SQL Script of EPER2EPRTR
--------------------------------------------------------------------------------
-- Fill POLLUTANTTRANSFER ------------------------------------------------------
--------------------------------------------------------------------------------
--DECLARE @uID [int]
--SELECT @uID = LOV_UnitID FROM [EPRTRmaster].[dbo].[LOV_UNIT]
 --   WHERE [Code] = 'KGM'

 
INSERT INTO [EPRTRmaster].[dbo].[POLLUTANTTRANSFER]
SELECT
    f.FacilityReportID AS FacilityReportID,
    p.LOV_PollutantID AS LOV_PollutantID,
    mb.LOV_MethodBasisID AS LOV_MethodBasisID,
    NULL AS MethodListID,
    e.EmissionValue AS Quantity,
    @uID AS LOV_QuantityUnitID,
    0 AS ConfidentialIndicator,
    NULL AS LOV_ConfidentialityID,
    NULL AS RemarkText
FROM [sdeims_subset].[dbo].[Emission] AS e
INNER JOIN
    [EPRTRmaster].[dbo].[FACILITYREPORT] AS f
    ON f.eperFacilityID = e.FacilityID
INNER JOIN
    [EPRTRmaster].[dbo].[LOV_METHODBASIS] AS mb
    ON mb.Code COLLATE database_default = e.Method
INNER JOIN
    [EPRTRmaster].[dbo].[LOV_POLLUTANT] AS p
    ON e.PollutantID = p.eperPollutant_ID
WHERE e.EmissionTypeID = 3

--SELECT * FROM [EPRTRmaster].[dbo].[POLLUTANTTRANSFER]


----13th SQL Script of EPER2EPRTR
--------------------------------------------------------------------------------
-- Clean up and save auxillary columns -----------------------------------------
--------------------------------------------------------------------------------

INSERT INTO [EPRTRmaster].[dbo].[EPER_TO_EPRTR_IDS]
SELECT 'PRODUCTIONVOLUME', [ProductionVolumeID], [eperFacilityID]
FROM [EPRTRmaster].[dbo].[PRODUCTIONVOLUME]

INSERT INTO [EPRTRmaster].[dbo].[EPER_TO_EPRTR_IDS]
SELECT 'FACILITYLOG', [FacilityLogID], [eperFacilityID]
FROM [EPRTRmaster].[dbo].[FACILITYLOG]

INSERT INTO [EPRTRmaster].[dbo].[EPER_TO_EPRTR_IDS]
SELECT 'ADDRESS', [AddressID], [eperFacilityID]
FROM [EPRTRmaster].[dbo].[ADDRESS]

INSERT INTO [EPRTRmaster].[dbo].[EPER_TO_EPRTR_IDS]
SELECT 'POLLUTANTRELEASEANDTRANSFERREPORT',
    [PollutantReleaseAndTransferReportID], [eperReportID]
FROM [EPRTRmaster].[dbo].[POLLUTANTRELEASEANDTRANSFERREPORT]

INSERT INTO [EPRTRmaster].[dbo].[EPER_TO_EPRTR_IDS]
SELECT 'FACILITYREPORT', [FacilityReportID], [eperFacilityID]
FROM [EPRTRmaster].[dbo].[FACILITYREPORT]

INSERT INTO [EPRTRmaster].[dbo].[EPER_TO_EPRTR_IDS]
SELECT 'LOV_ANNEXIACTIVITY', [LOV_AnnexIActivityID], [eperAnnex3_ID]
FROM [EPRTRmaster].[dbo].[LOV_ANNEXIACTIVITY]

INSERT INTO [EPRTRmaster].[dbo].[EPER_TO_EPRTR_IDS]
SELECT 'LOV_POLLUTANT', [LOV_PollutantID], [eperPollutant_ID]
FROM [EPRTRmaster].[dbo].[LOV_POLLUTANT]

ALTER TABLE [EPRTRmaster].[dbo].[POLLUTANTRELEASEANDTRANSFERREPORT]
    DROP COLUMN [eperReportID]
ALTER TABLE [EPRTRmaster].[dbo].[ADDRESS]
    DROP COLUMN [eperFacilityID]
ALTER TABLE [EPRTRmaster].[dbo].[FACILITYLOG]
    DROP COLUMN [eperFacilityID]
ALTER TABLE [EPRTRmaster].[dbo].[PRODUCTIONVOLUME]
    DROP COLUMN [eperFacilityID]
ALTER TABLE [EPRTRmaster].[dbo].[FACILITYREPORT]
    DROP COLUMN [eperFacilityID]
/*
ALTER TABLE [EPRTRmaster].[dbo].[LOV_ANNEXIACTIVITY]
    DROP COLUMN [eperAnnex3_ID]*/
/*ALTER TABLE [EPRTRmaster].[dbo].[LOV_POLLUTANT]
    DROP COLUMN [eperPollutant_ID]*/

GO

