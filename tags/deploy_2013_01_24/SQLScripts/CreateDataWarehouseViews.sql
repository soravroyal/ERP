CREATE VIEW [dbo].[DUMP_POLLUTANTRELEASEANDTRANSFERREPORT](
    [PollutantReleaseAndTransferReportID],
    [Country],
    [ReportingYear],
    [CoordinateSystem],
    [RemarkText],
    [CdrUrl],
    [CdrUploaded],
    [CdrReleased],
	[ForReview],
    [Published],
    [ResubmitReason]
)
 WITH SCHEMABINDING
 AS
    SELECT
        report.[PollutantReleaseAndTransferReportID],
        country.[Name],
        report.[ReportingYear],
        cs.[Name],
        report.[RemarkText],
        report.[CdrUrl],
        report.[CdrUploaded],
        report.[CdrReleased],
        report.[ForReview],
        report.[Published],
        report.[ResubmitReason]
    FROM
        [dbo].[POLLUTANTRELEASEANDTRANSFERREPORT] AS report
    LEFT JOIN
        [dbo].[LOV_COUNTRY] AS country
        ON report.[LOV_CountryID] = country.[LOV_CountryID]
    LEFT JOIN
        [dbo].[LOV_COORDINATESYSTEM] AS cs
        ON report.[LOV_CoordinateSystemID] = cs.[LOV_CoordinateSystemID]
GO

CREATE VIEW [dbo].[DUMP_FACILITYREPORT](
    [FacilityReportID],
    [PollutantReleaseAndTransferReportID],
    [FacilityID],
    [NationalID],
    [ParentCompanyName],
    [FacilityName],
    [StreetName],
    [BuildingNumber],
    [City],
    [PostalCode],
    [Country],
    [Lat],
    [Lon],
    [RBDCode],
    [RBDName],
    [NACEMainEconomicActivityCode],
    [MainEconomicActivityName],
    [CompetentAuthorityName],
    [CompetentAuthorityAddressStreetName],
    [CompetentAuthorityAddressBuildingNumber],
    [CompetentAuthorityAddressCity],
    [CompetentAuthorityAddressPostalCode],
    [CompetentAuthorityAddressCountry],
    [CompetentAuthorityTelephoneCommunication],
    [CompetentAuthorityFaxCommunication],
    [CompetentAuthorityEmailCommunication],
    [CompetentAuthorityContactPersonName],
    [ProductionVolumeProductName],
    [ProductionVolumeQuantity],
    [ProductionVolumeUnit],
    [TotalIPPCInstallationQuantity],
    [OperatingHours],
    [TotalEmployeeQuantity],
    [NUTSRegionCode],
    [NUTSRegionName],
    [WebsiteCommunication],
    [PublicInformation],
    [ConfidentialIndicator],
    [ConfidentialityReason],
    [ProtectVoluntaryData],
    [RemarkText]
)
 WITH SCHEMABINDING
 AS
    SELECT
        fr.[FacilityReportID],
        fr.[PollutantReleaseAndTransferReportID],
        fr.[FacilityID],
        fr.[NationalID],
        fr.[ParentCompanyName],
        fr.[FacilityName],
        f_address.[StreetName],
        f_address.[BuildingNumber],
        f_address.[City],
        f_address.[PostalCode],
        f_country.[Name],
        fr.[GeographicalCoordinate].STY,
        fr.[GeographicalCoordinate].STX,
        rbd.[Code],
        rbd.[Name],
        nace.[Code],
        fr.[MainEconomicActivityName],
        ca.[Name],
        ca_address.[StreetName],
        ca_address.[BuildingNumber],
        ca_address.[City],
        ca_address.[PostalCode],
        ca_country.[Name],
        ca.[TelephoneCommunication],
        ca.[FaxCommunication],
        ca.[EmailCommunication],
        ca.[ContactPersonName],
        pvol.[ProductName],
        pvol.[Quantity],
        unit.[Name],
        fr.[TotalIPPCInstallationQuantity],
        fr.[OperatingHours],
        fr.[TotalEmployeeQuantity],
        nuts.[Code],
        nuts.[Name],
        fr.[WebsiteCommunication],
        fr.[PublicInformation],
        fr.[ConfidentialIndicator],
        conf.[Name],
        fr.[ProtectVoluntaryData],
        fr.[RemarkText]
    FROM
        [dbo].[FACILITYREPORT] AS fr
    LEFT JOIN
        [dbo].[ADDRESS] AS f_address
        ON fr.[AddressID] = f_address.[AddressID]
    LEFT JOIN
        [dbo].[LOV_COUNTRY] AS f_country
        ON f_address.[LOV_CountryID] = f_country.[LOV_CountryID]
    LEFT JOIN
        [dbo].[COMPETENTAUTHORITYPARTY] AS ca
        ON fr.[CompetentAuthorityPartyID] = ca.[CompetentAuthorityPartyID]
    LEFT JOIN
        [dbo].[ADDRESS] AS ca_address
        ON ca.[AddressID] = ca_address.[AddressID]
    LEFT JOIN
        [dbo].[LOV_COUNTRY] AS ca_country
        ON ca_address.[LOV_CountryID] = ca_country.[LOV_CountryID]
    LEFT JOIN
        [dbo].[LOV_RIVERBASINDISTRICT] AS rbd
        ON fr.[LOV_RiverBasinDistrictID] = rbd.[LOV_RiverBasinDistrictID]
    LEFT JOIN
        [dbo].[LOV_NACEACTIVITY] AS nace
        ON fr.[LOV_NACEMainEconomicActivityID] = nace.[LOV_NACEActivityID]
    LEFT JOIN
        [dbo].[PRODUCTIONVOLUME] AS pvol
        ON fr.[ProductionVolumeID] = pvol.[ProductionVolumeID]
    LEFT JOIN
        [dbo].[LOV_UNIT] AS unit
        ON pvol.[LOV_UnitID] = unit.[LOV_UnitID]
    LEFT JOIN
        [dbo].[LOV_NUTSREGION] AS nuts
        ON fr.[LOV_NUTSRegionID] = nuts.[LOV_NUTSRegionID]
    LEFT JOIN
        [dbo].[LOV_CONFIDENTIALITY] AS conf
        ON fr.[LOV_ConfidentialityID] = conf.[LOV_ConfidentialityID]
GO

CREATE VIEW [dbo].[DUMP_ACTIVITY](
    [ActivityID],
    [FacilityReportID],
    [AnnexIActivityCode],
    [AnnexIActivityName],
    [AnnexIActivityIPPCCode],
    [RankingNumeric],
    [MainActivityIndicator]
)
 WITH SCHEMABINDING
 AS
    SELECT       
        a.[ActivityID],
        a.[FacilityReportID],
        aia.[Code],
        aia.[Name],
        aia.[IPPCCode],
        a.[RankingNumeric],
        a.[MainActivityIndicator]
    FROM
        [dbo].[ACTIVITY] AS a
    LEFT JOIN
        [dbo].[LOV_ANNEXIACTIVITY] AS aia
        ON a.[LOV_AnnexIActivityID] = aia.[LOV_AnnexIActivityID]
GO

CREATE VIEW [dbo].[DUMP_POLLUTANTRELEASE](
    [PollutantReleaseID],
    [FacilityReportID],
    [ReleaseMedium],
    [PollutantName],
    [PollutantCAS],
    [PollutantGroup],
    [MethodBasis],
    [TotalQuantity],
    [TotalQuantityUnit],
    [AccidentalQuantity],
    [AccidentalQuantityUnit],
    [ConfidentialIndicator],
    [ConfidentialityReason],
    [RemarkText]
)
 WITH SCHEMABINDING
 AS
    SELECT
        pr.[PollutantReleaseID],
        pr.[FacilityReportID],
        m.[Name],
        p.[Name],
        p.[CAS],
        p_group.[Name],
        mb.[Name],
        pr.[TotalQuantity],
        tot_unit.[Name],
        pr.[AccidentalQuantity],
        acc_unit.[Name],
        pr.[ConfidentialIndicator],
        conf.[Name],
        pr.[RemarkText]
    FROM
        [dbo].[POLLUTANTRELEASE] AS pr
    LEFT JOIN
        [dbo].[LOV_MEDIUM] AS m
        ON pr.[LOV_MediumID] = m.[LOV_MediumID]
    LEFT JOIN
        [dbo].[LOV_POLLUTANT] AS p
        ON pr.[LOV_PollutantID] = p.[LOV_PollutantID]
    LEFT JOIN
        [dbo].[LOV_POLLUTANT] AS p_group
        ON p.[ParentID] = p_group.[LOV_PollutantID]
    LEFT JOIN
        [dbo].[LOV_METHODBASIS] AS mb
        ON pr.[LOV_MethodBasisID] = mb.[LOV_MethodBasisID]
    LEFT JOIN
        [dbo].[LOV_UNIT] AS tot_unit
        ON pr.[LOV_TotalQuantityUnitID] = tot_unit.[LOV_UnitID]
    LEFT JOIN
        [dbo].[LOV_UNIT] AS acc_unit
        ON pr.[LOV_AccidentalQuantityUnitID] = acc_unit.[LOV_UnitID]
    LEFT JOIN
        [dbo].[LOV_CONFIDENTIALITY] AS conf
        ON pr.[LOV_ConfidentialityID] = conf.[LOV_ConfidentialityID]
GO

CREATE VIEW [dbo].[DUMP_POLLUTANTRELEASEMETHODUSED](
    [PollutantReleaseMethodUsedID],
    [PollutantReleaseID],
    [MethodType],
    [MethodDesignation]
)
 WITH SCHEMABINDING
 AS
    SELECT
        pr.[MethodListID],
        pr.[PollutantReleaseID],
        mt.[Name],
        mu.[MethodDesignation]
    FROM
        [dbo].[POLLUTANTRELEASE] AS pr
    LEFT JOIN
        [dbo].[METHODUSED] AS mu
        ON pr.[MethodListID] = mu.[MethodListID]
    LEFT JOIN
        [dbo].[LOV_METHODTYPE] AS mt
        ON mu.[LOV_MethodTypeID] = mt.[LOV_MethodTypeID]
    WHERE
        pr.[MethodListID] IS NOT NULL
GO

CREATE VIEW [dbo].[DUMP_POLLUTANTTRANSFER](
    [PollutantTransferID],
    [FacilityReportID],
    [PollutantName],
    [PollutantCAS],
    [PollutantGroup],
    [MethodBasis],
    [Quantity],
    [QuantityUnit],
    [ConfidentialIndicator],
    [ConfidentialityReason],
    [RemarkText]
)
 WITH SCHEMABINDING
 AS
    SELECT
        pt.[PollutantTransferID],
        pt.[FacilityReportID],
        p.[Name],
        p.[CAS],
        p_group.[Name],
        mb.[Name],
        pt.[Quantity],
        unit.[Name],
        pt.[ConfidentialIndicator],
        conf.[Name],
        pt.[RemarkText]
    FROM
        [dbo].[POLLUTANTTRANSFER] AS pt
    LEFT JOIN
        [dbo].[LOV_POLLUTANT] AS p
        ON pt.[LOV_PollutantID] = p.[LOV_PollutantID]
    LEFT JOIN
        [dbo].[LOV_POLLUTANT] AS p_group
        ON p.[ParentID] = p_group.[LOV_PollutantID]
    LEFT JOIN
        [dbo].[LOV_METHODBASIS] AS mb
        ON pt.[LOV_MethodBasisID] = mb.[LOV_MethodBasisID]
    LEFT JOIN
        [dbo].[LOV_UNIT] AS unit
        ON pt.[LOV_QuantityUnitID] = unit.[LOV_UnitID]
    LEFT JOIN
        [dbo].[LOV_CONFIDENTIALITY] AS conf
        ON pt.[LOV_ConfidentialityID] = conf.[LOV_ConfidentialityID]
GO

CREATE VIEW [dbo].[DUMP_POLLUTANTTRANSFERMETHODUSED](
    [PollutantTransferMethodUsedID],
    [PollutantTransferID],
    [MethodType],
    [MethodDesignation]
)
 WITH SCHEMABINDING
 AS
    SELECT
        pt.[MethodListID],
        pt.[PollutantTransferID],
        mt.[Name],
        mu.[MethodDesignation]
    FROM
        [dbo].[POLLUTANTTRANSFER] AS pt
    LEFT JOIN
        [dbo].[METHODUSED] AS mu
        ON pt.[MethodListID] = mu.[MethodListID]
    LEFT JOIN
        [dbo].[LOV_METHODTYPE] AS mt
        ON mu.[LOV_MethodTypeID] = mt.[LOV_MethodTypeID]
    WHERE
        pt.[MethodListID] IS NOT NULL
GO

CREATE VIEW [dbo].[DUMP_WASTETRANSFER](
    [WasteTransferID],
    [FacilityReportID],
    [WasteType],
    [WasteTreatment],
    [MethodBasis],
    [Quantity],
    [QuantityUnit],
    [WasteHandlerPartyName],
    [WasteHandlerPartyAddressStreetName],
    [WasteHandlerPartyAddressBuildingNumber],
    [WasteHandlerPartyAddressCity],
    [WasteHandlerPartyAddressPostalCode],
    [WasteHandlerPartyAddressCountry],
    [WasteHandlerPartySiteAddressStreetName],
    [WasteHandlerPartySiteAddressBuildingNumber],
    [WasteHandlerPartySiteAddressCity],
    [WasteHandlerPartySiteAddressPostalCode],
    [WasteHandlerPartySiteAddressCountry],
    [ConfidentialIndicator],
    [ConfidentialityReason],
    [RemarkText]
)
 WITH SCHEMABINDING
 AS
    SELECT
        wt.[WasteTransferID],
        wt.[FacilityReportID],
        wtype.[Name],
        wtreatment.[Name],
        mb.[Name],
        wt.[Quantity],
        unit.[Name],
        whp.[Name],
        whpa.[StreetName],
        whpa.[BuildingNumber],
        whpa.[City],
        whpa.[PostalCode],
        whpa_country.[Name],
        whpsa.[StreetName],
        whpsa.[BuildingNumber],
        whpsa.[City],
        whpsa.[PostalCode],
        whpsa_country.[Name],
        wt.[ConfidentialIndicator],
        conf.[Name],
        wt.[RemarkText]
    FROM
        [dbo].[WASTETRANSFER] AS wt
    LEFT JOIN
        [dbo].[LOV_WASTETYPE] AS wtype
        ON wt.[LOV_WasteTypeID] = wtype.[LOV_WasteTypeID]
    LEFT JOIN
        [dbo].[LOV_WASTETREATMENT] AS wtreatment
        ON wt.[LOV_WasteTreatmentID] = wtreatment.[LOV_WasteTreatmentID]
    LEFT JOIN
        [dbo].[LOV_METHODBASIS] AS mb
        ON wt.[LOV_MethodBasisID] = mb.[LOV_MethodBasisID]
    LEFT JOIN
        [dbo].[LOV_UNIT] AS unit
        ON wt.[LOV_QuantityUnitID] = unit.[LOV_UnitID]
    LEFT JOIN
        [dbo].[WASTEHANDLERPARTY] AS whp
        ON wt.[WasteHandlerPartyID] = whp.[WasteHandlerPartyID]
    LEFT JOIN
        [dbo].[ADDRESS] AS whpa
        ON whp.[AddressID] = whpa.[AddressID]
    LEFT JOIN
        [dbo].[LOV_COUNTRY] AS whpa_country
        ON whpa.[LOV_CountryID] = whpa_country.[LOV_CountryID]
    LEFT JOIN
        [dbo].[ADDRESS] AS whpsa
        ON whp.[SiteAddressID] = whpsa.[AddressID]
    LEFT JOIN
        [dbo].[LOV_COUNTRY] AS whpsa_country
        ON whpsa.[LOV_CountryID] = whpsa_country.[LOV_CountryID]
    LEFT JOIN
        [dbo].[LOV_CONFIDENTIALITY] AS conf
        ON wt.[LOV_ConfidentialityID] = conf.[LOV_ConfidentialityID]
GO

CREATE VIEW [dbo].[DUMP_WASTETRANSFERMETHODUSED](
    [WasteTransferMethodUsedID],
    [WasteTransferID],
    [MethodType],
    [MethodDesignation]
)
 WITH SCHEMABINDING
 AS
    SELECT
        wt.[MethodListID],
        wt.[WasteTransferID],
        mt.[Name],
        mu.[MethodDesignation]
    FROM
        [dbo].[WASTETRANSFER] AS wt
    LEFT JOIN
        [dbo].[METHODUSED] AS mu
        ON wt.[MethodListID] = mu.[MethodListID]
    LEFT JOIN
        [dbo].[LOV_METHODTYPE] AS mt
        ON mu.[LOV_MethodTypeID] = mt.[LOV_MethodTypeID]
    WHERE
        wt.[MethodListID] IS NOT NULL
GO

