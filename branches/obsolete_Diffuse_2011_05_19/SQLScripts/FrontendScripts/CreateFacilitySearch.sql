SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF EXISTS (SELECT name FROM sysobjects WHERE name = N'WEB_FACILITYSEARCH' AND type = 'V')
    DROP VIEW [dbo].[WEB_FACILITYSEARCH]
GO
CREATE VIEW [dbo].[WEB_FACILITYSEARCH](
    [FacilityReportID],
    [FacilityName],
    [Address],
    [City],
    [PostalCode],
    [Country],
    [CountryID],
    [ParentCompanyName],
    [ReportingYear],
    [MainActivity],
    [RiverBasinDistrictID],
    [NUTSRegionID]/*,
    [ReleasePollutantID],
    [ReleaseMediumID],
    [TransferPollutantID],
    [WasteTypeID],
    [WasteTreatmentID],
    [ReceivingCountry]*/
)
 WITH SCHEMABINDING
 AS
    SELECT
        f_rep.[FacilityReportID],
        f_rep.[FacilityName],
        RTRIM(f_addr.[StreetName] + ' ' + CASE WHEN f_addr.[BuildingNumber] IS NULL THEN '' ELSE f_addr.[BuildingNumber] END),
        f_addr.[City],
        f_addr.[PostalCode],
        f_country.[Name],
        f_country.[LOV_CountryID],
        f_rep.[ParentCompanyName],
        prtr.[ReportingYear],
        annexiact.[Name],
        rbd.[LOV_RiverBasinDistrictID],
        nuts.[LOV_NUTSRegionID]/*,
        pr.[LOV_PollutantID],
        pr.[LOV_MediumID],
        pt.[LOV_PollutantID],
        wt.[LOV_WasteTypeID],
        wt.[LOV_WasteTreatmentID],
        whp_addr.[LOV_CountryID]*/
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
    JOIN
        [dbo].[LOV_RIVERBASINDISTRICT] AS rbd
        ON f_rep.[LOV_RiverBasinDistrictID] = rbd.[LOV_RiverBasinDistrictID]
    LEFT JOIN -- left join accomodates for facilities without NUTS
        [dbo].[LOV_NUTSREGION] AS nuts
        ON f_rep.[LOV_NUTSRegionID] = nuts.[LOV_NUTSRegionID]
    LEFT JOIN -- left join accomodates for facilities without activities
        [dbo].[ACTIVITY] AS act
        ON f_rep.[FacilityReportID] = act.[FacilityReportID] AND act.[MainActivityIndicator] = 1
    LEFT JOIN -- left join accomodates for facilities without activities
        [dbo].[LOV_ANNEXIACTIVITY] AS annexiact
        ON act.[LOV_AnnexIActivityID] = annexiact.[LOV_AnnexIActivityID]/*
    RIGHT JOIN
        [dbo].[POLLUTANTRELEASE] AS pr
        ON f_rep.[FacilityReportID] = pr.[FacilityReportID]
    RIGHT JOIN
        [dbo].[POLLUTANTTRANSFER] AS pt
        ON f_rep.[FacilityReportID] = pr.[FacilityReportID]
    RIGHT JOIN
        [dbo].[WASTETRANSFER] AS wt
        ON f_rep.[FacilityReportID] = wt.[FacilityReportID]
    LEFT JOIN
        [dbo].[WASTEHANDLERPARTY] AS whp
        ON wt.[WasteHandlerPartyID] = whp.[WasteHandlerPartyID]
    LEFT JOIN
        [dbo].[ADDRESS] AS whp_addr
        ON whp.[SiteAddressID] = whp_addr.[AddressID]*/
GO
