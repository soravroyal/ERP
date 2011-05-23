SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT name FROM sysobjects WHERE name = N'WEB_FACILITYLEVELDETAILS' AND type = 'V')
    DROP VIEW [dbo].[WEB_FACILITYLEVELDETAILS]
GO
CREATE VIEW [dbo].[WEB_FACILITYLEVELDETAILS](
    [FacilityID],
    [FacilityName],
    [Address],
    [City],
    [PostalCode],
    [Country],
    [ReportingYear],
    [Published],
    [ParentCompanyName],
    [Coordinates],
    [NUTSRegion],
    --[NUTSDate], TODO
    [RiverBasinDistrict],
    --[RiverBasinDistrictDate], TODO
    [MainActivity],
    [ProductionVolumeProductName],
    [ProductionVolumeQuantity],
    [ProductionVolumeUnitName],
    [TotalIPPCInstallationQuantity],
    [TotalEmployeeQuantity],
    [OperatingHours],
    [WebsiteCommunication]/*TODO,
    [CAName],
    [CAAddress],
    [CACity],
    [CAPostalCode],
    [CATelephoneCommunication],
    [CAFaxCommunication],
    [CAEmailCommunication],
    [CAContactPersonName],
    [CADate]*/
)
 WITH SCHEMABINDING
 AS
    SELECT
        f_rep.[FacilityID],
        f_rep.[FacilityName],
        RTRIM(f_addr.[StreetName] + ' ' + CASE WHEN f_addr.[BuildingNumber] IS NULL THEN '' ELSE f_addr.[BuildingNumber] END),
        f_addr.[City],
        f_addr.[PostalCode],
        f_country.[Name],
        prtr.[ReportingYear],
        prtr.[Published],
        f_rep.[ParentCompanyName],
        CASE
            WHEN f_rep.[GeographicalCoordinate] IS NULL THEN 'Coordinates outside country' --TODO: add function column that checks country buffer
            WHEN f_rep.[GeographicalCoordinate].STDistance(geometry::STGeomFromText('POINT(0 0)', 4326)) < 1.0 THEN 'No coordinates available'
            ELSE f_rep.[GeographicalCoordinate].ToString() --TODO: nicer text representation
        END,
        nuts.[Name],
        rbd.[Name],
        nace.[Name],
        pv.[ProductName],
        pv.[Quantity],
        pv_unit.[Name],
        f_rep.[TotalIPPCInstallationQuantity],
        f_rep.[TotalEmployeeQuantity],
        f_rep.[OperatingHours],
        f_rep.[WebsiteCommunication]
    FROM
        [dbo].[FACILITYREPORT] AS f_rep
    JOIN
        [dbo].[POLLUTANTRELEASEANDTRANSFERREPORT] AS prtr
        ON f_rep.[PollutantReleaseAndTransferReportID] = prtr.[PollutantReleaseAndTransferReportID]
    JOIN
        [dbo].[ADDRESS] AS f_addr
        ON f_rep.[AddressID] = f_addr.[AddressID]
    JOIN
        [dbo].[LOV_COUNTRY] AS f_country
        ON f_addr.[LOV_CountryID] = f_country.[LOV_CountryID]
    LEFT JOIN -- left join accomodates for facilities without NUTS
        [dbo].[LOV_NUTSREGION] AS nuts
        ON f_rep.[LOV_NUTSRegionID] = nuts.[LOV_NUTSRegionID]
    JOIN
        [dbo].[LOV_RIVERBASINDISTRICT] AS rbd
        ON f_rep.[LOV_RiverBasinDistrictID] = rbd.[LOV_RiverBasinDistrictID]
    JOIN
        [dbo].[LOV_NACEACTIVITY] AS nace
        ON f_rep.[LOV_NACEMainEconomicActivityID] = nace.[LOV_NACEActivityID]
    LEFT JOIN
        [dbo].[PRODUCTIONVOLUME] AS pv
        ON f_rep.[ProductionVolumeID] = pv.[ProductionVolumeID]
    LEFT JOIN
        [dbo].[LOV_UNIT] AS pv_unit
        ON pv.[LOV_UnitID] = pv_unit.[LOV_UnitID]
GO

IF EXISTS (SELECT name FROM sysobjects WHERE name = N'WEB_FACILITYLEVELPR' AND type = 'V')
    DROP VIEW [dbo].[WEB_FACILITYLEVELPR]
GO
--TODO

IF EXISTS (SELECT name FROM sysobjects WHERE name = N'WEB_FACILITYLEVELPT' AND type = 'V')
    DROP VIEW [dbo].[WEB_FACILITYLEVELPT]
GO
--TODO

IF EXISTS (SELECT name FROM sysobjects WHERE name = N'WEB_FACILITYLEVELWT' AND type = 'V')
    DROP VIEW [dbo].[WEB_FACILITYLEVELWT]
GO
--TODO

IF EXISTS (SELECT name FROM sysobjects WHERE name = N'WEB_FACILITYLEVELCONFIDENTIALITY' AND type = 'V')
    DROP VIEW [dbo].[WEB_FACILITYLEVELCONFIDENTIALITY]
GO
--TODO

