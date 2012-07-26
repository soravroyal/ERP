IF EXISTS 
	(
		SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS
		WHERE TABLE_NAME = 'RDF_ACTIVITY'
	)
    DROP VIEW RDF_ACTIVITY;
GO

CREATE VIEW dbo.RDF_ACTIVITY AS
SELECT activityID
	,FacilityReportID as facilityReport
	,LOV_AnnexIActivityID as annexIActivity
	,rankingNumeric
	,mainActivityIndicator
FROM dbo.ACTIVITY
GO


IF EXISTS 
	(
		SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS
		WHERE TABLE_NAME = 'RDF_FACILITYREPORT'
	)
    DROP VIEW RDF_FACILITYREPORT;
GO

CREATE VIEW dbo.RDF_FACILITYREPORT AS
SELECT fr.FacilityReportID
	,fr.PollutantReleaseAndTransferReportID
	,fr.FacilityID as forFacility
	,fr.NationalID
	,CASE 
		WHEN ConfidentialIndicator = 1
			AND fr.ParentCompanyName IS NULL
			THEN 'CONFIDENTIAL'
		ELSE fr.ParentCompanyName
		END AS ParentCompanyName
	,CASE 
		WHEN ConfidentialIndicator = 1
			AND fr.FacilityName IS NULL
			THEN 'CONFIDENTIAL'
		ELSE fr.FacilityName
		END AS FacilityName
	,CASE 
		WHEN ConfidentialIndicator = 1
			AND f_address.StreetName IS NULL
			THEN 'CONFIDENTIAL'
		ELSE f_address.StreetName
		END AS StreetName
	,f_address.BuildingNumber
	,CASE 
		WHEN ConfidentialIndicator = 1
			AND f_address.City IS NULL
			THEN 'CONFIDENTIAL'
		ELSE f_address.City
		END AS City
	,CASE 
		WHEN ConfidentialIndicator = 1
			AND f_address.PostalCode IS NULL
			THEN 'CONFIDENTIAL'
		ELSE f_address.PostalCode
		END AS PostalCode
	,f_country.Code AS inCountry
	,fr.GeographicalCoordinate.STY AS Lat
	,fr.GeographicalCoordinate.STX AS Long
	,fr.LOV_RiverBasinDistrictID AS forRBD
	,fr.LOV_NUTSRegionID AS forNUTS
	,fr.LOV_NACEMainEconomicActivityID as nACEActivity
	,ca.NAME AS CompetentAuthorityName
	,ca_address.StreetName AS CompetentAuthorityAddressStreetName
	,ca_address.BuildingNumber AS CompetentAuthorityAddressBuildingNumber
	,ca_address.City AS CompetentAuthorityAddressCity
	,ca_address.PostalCode AS CompetentAuthorityAddressPostalCode
	,ca_country.Code AS CompetentAuthorityAddressCountryCode
	,ca_country.NAME AS CompetentAuthorityAddressCountryName
	,ca.TelephoneCommunication AS CompetentAuthorityTelephoneCommunication
	,ca.FaxCommunication AS CompetentAuthorityFaxCommunication
	,ca.EmailCommunication AS CompetentAuthorityEmailCommunication
	,ca.ContactPersonName AS CompetentAuthorityContactPersonName
	,CASE 
		WHEN fr.ProtectVoluntaryData = 0
			THEN pvol.ProductName
		END AS ProductionVolumeProductName
	,CASE 
		WHEN fr.ProtectVoluntaryData = 0
			THEN pvol.Quantity
		END AS ProductionVolumeQuantity
	,CASE 
		WHEN fr.ProtectVoluntaryData = 0
			THEN unit.Code
		END AS ProductionVolumeUnitCode
	,CASE 
		WHEN fr.ProtectVoluntaryData = 0
			THEN unit.NAME
		END AS ProductionVolumeUnitName
	,CASE 
		WHEN fr.ProtectVoluntaryData = 0
			THEN fr.TotalIPPCInstallationQuantity
		END AS TotalIPPCInstallationQuantity
	,CASE 
		WHEN fr.ProtectVoluntaryData = 0
			THEN fr.OperatingHours
		END AS OperatingHours
	,CASE 
		WHEN fr.ProtectVoluntaryData = 0
			THEN fr.TotalEmployeeQuantity
		END AS TotalEmployeeQuantity
	,fr.WebsiteCommunication
	,fr.PublicInformation
	,fr.ConfidentialIndicator
	,conf.Code AS ConfidentialityReasonCode
	,conf.NAME AS ConfidentialityReasonName
	,fr.ProtectVoluntaryData
	,aXact.LOV_AnnexIActivityID as annexIActivity
FROM dbo.FACILITYREPORT AS fr
INNER JOIN dbo.vAT_POLLUTANTRELEASEANDTRANSFERREPORT AS prtr
	ON prtr.PollutantReleaseAndTransferReportID = fr.PollutantReleaseAndTransferReportID
LEFT JOIN dbo.ADDRESS AS f_address
	ON fr.AddressID = f_address.AddressID
LEFT JOIN dbo.LOV_COUNTRY AS f_country
	ON prtr.LOV_CountryID = f_country.LOV_CountryID
LEFT JOIN dbo.COMPETENTAUTHORITYPARTY AS ca
	ON fr.CompetentAuthorityPartyID = ca.CompetentAuthorityPartyID
LEFT JOIN dbo.ADDRESS AS ca_address
	ON ca.AddressID = ca_address.AddressID
LEFT JOIN dbo.LOV_COUNTRY AS ca_country
	ON ca_address.LOV_CountryID = ca_country.LOV_CountryID
LEFT JOIN dbo.PRODUCTIONVOLUME AS pvol
	ON fr.ProductionVolumeID = pvol.ProductionVolumeID
LEFT JOIN dbo.LOV_UNIT AS unit
	ON pvol.LOV_UnitID = unit.LOV_UnitID
LEFT JOIN dbo.LOV_CONFIDENTIALITY AS conf
	ON fr.LOV_ConfidentialityID = conf.LOV_ConfidentialityID
LEFT JOIN dbo.ACTIVITY AS act
	ON fr.FacilityReportID = act.FacilityReportID
		AND act.MainActivityIndicator = 1
LEFT JOIN dbo.vAT_ANNEXIACTIVITY AS aXact
	ON aXact.LOV_AnnexIActivityID = act.LOV_AnnexIActivityID
GO

IF EXISTS 
	(
		SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS
		WHERE TABLE_NAME = 'RDF_POLLUTANTRELEASE'
	)
    DROP VIEW RDF_POLLUTANTRELEASE;
GO

CREATE VIEW dbo.RDF_POLLUTANTRELEASE AS
SELECT pr.PollutantReleaseID
	,pr.FacilityReportID AS facilityReport
	,pr.LOV_MediumID AS forMedium
	,pr.LOV_PollutantID AS forPollutant
	,pr.LOV_MethodBasisID AS forMethod
	,pr.TotalQuantity
	,pr.AccidentalQuantity
	,tot_unit.LOV_UnitID as unit
	,pr.ConfidentialIndicator
	,conf.Code AS ConfidentialityReasonCode
	,conf.NAME AS ConfidentialityReasonName
FROM dbo.vAT_POLLUTANTRELEASE AS pr
INNER JOIN dbo.FACILITYREPORT AS fr
	ON fr.FacilityReportID = pr.FacilityReportID
INNER JOIN dbo.vAT_POLLUTANTRELEASEANDTRANSFERREPORT AS prtr
	ON prtr.PollutantReleaseAndTransferReportID = fr.PollutantReleaseAndTransferReportID
LEFT JOIN dbo.LOV_UNIT AS tot_unit
	ON pr.LOV_TotalQuantityUnitID = tot_unit.LOV_UnitID
LEFT JOIN dbo.LOV_CONFIDENTIALITY AS conf
	ON pr.LOV_ConfidentialityID = conf.LOV_ConfidentialityID
GO

IF EXISTS 
	(
		SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS
		WHERE TABLE_NAME = 'RDF_POLLUTANTTRANSFER'
	)
    DROP VIEW RDF_POLLUTANTTRANSFER;
GO

CREATE VIEW dbo.RDF_POLLUTANTTRANSFER AS
SELECT pt.PollutantTransferID
	,pt.FacilityReportID as facilityReport
	,pt.LOV_PollutantID as forPollutant
	,pt.LOV_MethodBasisID as forMethod
	,pt.Quantity
	,unit.LOV_UnitID as unit
	,pt.ConfidentialIndicator
	,conf.Code AS ConfidentialityReasonCode
	,conf.NAME AS ConfidentialityReasonName
FROM dbo.vAT_POLLUTANTTRANSFER AS pt
INNER JOIN dbo.FACILITYREPORT AS fr
	ON fr.FacilityReportID = pt.FacilityReportID
INNER JOIN dbo.vAT_POLLUTANTRELEASEANDTRANSFERREPORT AS prtr
	ON prtr.PollutantReleaseAndTransferReportID = fr.PollutantReleaseAndTransferReportID
LEFT JOIN dbo.LOV_UNIT AS unit
	ON pt.LOV_QuantityUnitID = unit.LOV_UnitID
LEFT JOIN dbo.LOV_CONFIDENTIALITY AS conf
	ON pt.LOV_ConfidentialityID = conf.LOV_ConfidentialityID
GO

IF EXISTS 
	(
		SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS
		WHERE TABLE_NAME = 'RDF_UPLOADEDREPORTS'
	)
    DROP VIEW RDF_UPLOADEDREPORTS;
GO

CREATE VIEW dbo.RDF_UPLOADEDREPORTS AS
SELECT p.PollutantReleaseAndTransferReportID
	,l.Code as inCountry
	,p.ReportingYear
	,CASE 
		WHEN isnull(v.PollutantReleaseAndTransferReportID, 0) > 0
			THEN 1
		ELSE 0
		END AS CurrentlyShown
	,p.RemarkText
	,p.CdrUrl
	,p.CdrUploaded
	,p.CdrReleased
	,p.ForReview
	,p.Published
	,p.ResubmitReason
	,p.Imported AS ImportedToEPRTRMaster
FROM dbo.POLLUTANTRELEASEANDTRANSFERREPORT AS p
INNER JOIN dbo.LOV_COUNTRY AS l
	ON p.LOV_CountryID = l.LOV_CountryID
LEFT JOIN dbo.vAT_POLLUTANTRELEASEANDTRANSFERREPORT AS v
	ON v.PollutantReleaseAndTransferReportID = p.PollutantReleaseAndTransferReportID
WHERE (p.CdrReleased > '2000-01-01 00:00:00.000')
GO

IF EXISTS 
	(
		SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS
		WHERE TABLE_NAME = 'RDF_WASTETRANSFER'
	)
    DROP VIEW RDF_WASTETRANSFER;
GO

CREATE VIEW dbo.RDF_WASTETRANSFER AS
SELECT wt.WasteTransferID
	,wt.FacilityReportID AS facilityReport
	,wt.LOV_WasteTypeID AS forWasteType
	,CASE 
		WHEN wt.ConfidentialIndicator = 1
			AND wtreatment.Code IS NULL
			THEN 'CONFIDENTIAL'
		ELSE wtreatment.Code
		END AS WasteTreatmentCode
	,CASE 
		WHEN wt.ConfidentialIndicator = 1
			AND wtreatment.NAME IS NULL
			THEN 'CONFIDENTIAL'
		ELSE wtreatment.NAME
		END AS WasteTreatmentName
	,CASE 
		WHEN wt.ConfidentialIndicator = 1
			AND mb.Code IS NULL
			THEN 'CONFIDENTIAL'
		ELSE mb.Code
		END AS MethodBasisCode
	,CASE 
		WHEN wt.ConfidentialIndicator = 1
			AND mb.NAME IS NULL
			THEN 'CONFIDENTIAL'
		ELSE mb.NAME
		END AS MethodBasisName
	,wt.Quantity
	,wt.LOV_QuantityUnitID as unit
	,CASE 
		WHEN wt.ConfidentialIndicator = 1
			AND whp.NAME IS NULL
			THEN 'CONFIDENTIAL'
		ELSE whp.NAME
		END AS WasteHandlerPartyName
	,CASE 
		WHEN wt.ConfidentialIndicator = 1
			AND whpa.StreetName IS NULL
			THEN 'CONFIDENTIAL'
		ELSE whpa.StreetName
		END AS WasteHandlerPartyAddressStreetName
	,whpa.BuildingNumber AS WasteHandlerPartyAddressBuildingNumber
	,CASE 
		WHEN wt.ConfidentialIndicator = 1
			AND whpa.City IS NULL
			THEN 'CONFIDENTIAL'
		ELSE whpa.City
		END AS WasteHandlerPartyAddressCity
	,CASE 
		WHEN wt.ConfidentialIndicator = 1
			AND whpa.PostalCode IS NULL
			THEN 'CONFIDENTIAL'
		ELSE whpa.PostalCode
		END AS WasteHandlerPartyAddressPostalCode
	,CASE 
		WHEN wt.ConfidentialIndicator = 1
			AND whpa_country.Code IS NULL
			THEN 'CONFIDENTIAL'
		ELSE whpa_country.Code
		END AS WasteHandlerPartyAddressCountryCode
	,CASE 
		WHEN wt.ConfidentialIndicator = 1
			AND whpa_country.NAME IS NULL
			THEN 'CONFIDENTIAL'
		ELSE whpa_country.NAME
		END AS WasteHandlerPartyAddressCountryName
	,CASE 
		WHEN wt.ConfidentialIndicator = 1
			AND whpsa.StreetName IS NULL
			THEN 'CONFIDENTIAL'
		ELSE whpsa.StreetName
		END AS WasteHandlerPartySiteAddressStreetName
	,whpsa.BuildingNumber AS WasteHandlerPartySiteAddressBuildingNumber
	,CASE 
		WHEN wt.ConfidentialIndicator = 1
			AND whpsa.City IS NULL
			THEN 'CONFIDENTIAL'
		ELSE whpsa.City
		END AS WasteHandlerPartySiteAddressCity
	,CASE 
		WHEN wt.ConfidentialIndicator = 1
			AND whpsa.PostalCode IS NULL
			THEN 'CONFIDENTIAL'
		ELSE whpsa.PostalCode
		END AS WasteHandlerPartySiteAddressPostalCode
	,CASE 
		WHEN wt.ConfidentialIndicator = 1
			AND whpsa_country.Code IS NULL
			THEN 'CONFIDENTIAL'
		ELSE whpsa_country.Code
		END AS WasteHandlerPartySiteAddressCountryCode
	,CASE 
		WHEN wt.ConfidentialIndicator = 1
			AND whpsa_country.NAME IS NULL
			THEN 'CONFIDENTIAL'
		ELSE whpsa_country.NAME
		END AS WasteHandlerPartySiteAddressCountryName
	,wt.ConfidentialIndicator
	,conf.Code AS ConfidentialityReasonCode
	,conf.NAME AS ConfidentialityReasonName
FROM dbo.vAT_WASTETRANSFER AS wt
INNER JOIN dbo.FACILITYREPORT AS fr
	ON fr.FacilityReportID = wt.FacilityReportID
INNER JOIN dbo.vAT_POLLUTANTRELEASEANDTRANSFERREPORT AS prtr
	ON prtr.PollutantReleaseAndTransferReportID = fr.PollutantReleaseAndTransferReportID
LEFT JOIN dbo.LOV_WASTETREATMENT AS wtreatment
	ON wt.LOV_WasteTreatmentID = wtreatment.LOV_WasteTreatmentID
LEFT JOIN dbo.LOV_METHODBASIS AS mb
	ON wt.LOV_MethodBasisID = mb.LOV_MethodBasisID
LEFT JOIN dbo.LOV_UNIT AS unit
	ON wt.LOV_QuantityUnitID = unit.LOV_UnitID
LEFT JOIN dbo.WASTEHANDLERPARTY AS whp
	ON wt.WasteHandlerPartyID = whp.WasteHandlerPartyID
LEFT JOIN dbo.ADDRESS AS whpa
	ON whp.AddressID = whpa.AddressID
LEFT JOIN dbo.LOV_COUNTRY AS whpa_country
	ON whpa.LOV_CountryID = whpa_country.LOV_CountryID
LEFT JOIN dbo.ADDRESS AS whpsa
	ON whp.SiteAddressID = whpsa.AddressID
LEFT JOIN dbo.LOV_COUNTRY AS whpsa_country
	ON whpsa.LOV_CountryID = whpsa_country.LOV_CountryID
LEFT JOIN dbo.LOV_CONFIDENTIALITY AS conf
	ON wt.LOV_ConfidentialityID = conf.LOV_ConfidentialityID
GO

IF EXISTS 
	(
		SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS
		WHERE TABLE_NAME = 'RDF_FACILITYID_CHANGES'
	)
    DROP VIEW RDF_FACILITYID_CHANGES;
GO

CREATE VIEW dbo.RDF_FACILITYID_CHANGES AS
SELECT fr.FacilityReportID 
	,fr.FacilityReportID AS facilityReport
	,l.Code AS inCountry
	,prtr.ReportingYear
	,fr.NationalID
	,fr.FacilityID AS newFacility
	,CASE 
		WHEN isnull(fl.OldFacilityID, 0) = 0
			THEN fr.FacilityID
		ELSE fl.OldFacilityID
		END AS oldFacility
FROM dbo.PUBLISH_FACILITYREPORT AS pf
INNER JOIN dbo.FACILITYREPORT AS fr
	ON fr.FacilityReportID = pf.FacilityReportID
INNER JOIN dbo.POLLUTANTRELEASEANDTRANSFERREPORT AS prtr
	ON prtr.PollutantReleaseAndTransferReportID = fr.PollutantReleaseAndTransferReportID
INNER JOIN dbo.LOV_COUNTRY AS l
	ON l.LOV_CountryID = prtr.LOV_CountryID
LEFT JOIN dbo.FACILITYLOG AS fl
	ON fl.FacilityReportID NOT IN (
			SELECT FacilityReportID
			FROM dbo.FACILITYLOG
			GROUP BY FacilityReportID
			HAVING (COUNT(*) > 1)
			)
		AND fl.FacilityReportID = fr.FacilityReportID
GO

IF EXISTS 
	(
		SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS
		WHERE TABLE_NAME = 'RDF_POLLUTANTRELEASEANDTRANSFERREPORT'
	)
    DROP VIEW RDF_POLLUTANTRELEASEANDTRANSFERREPORT;
GO

CREATE VIEW dbo.RDF_POLLUTANTRELEASEANDTRANSFERREPORT AS
SELECT report.PollutantReleaseAndTransferReportID
	,country.Code AS inCountry
	,report.ReportingYear
	,cs.Code AS CoordinateSystemCode
	,cs.NAME AS CoordinateSystemName
	,report.CdrReleased
	,report.Published
FROM dbo.vAT_POLLUTANTRELEASEANDTRANSFERREPORT AS report
LEFT JOIN dbo.LOV_COUNTRY AS country
	ON report.LOV_CountryID = country.LOV_CountryID
LEFT JOIN dbo.LOV_COORDINATESYSTEM AS cs
	ON report.LOV_CoordinateSystemID = cs.LOV_CoordinateSystemID
GO

IF EXISTS 
	(
		SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS
		WHERE TABLE_NAME = 'RDF_POLLUTANTRELEASEMETHODUSED'
	)
    DROP VIEW RDF_POLLUTANTRELEASEMETHODUSED;
GO

CREATE VIEW dbo.RDF_POLLUTANTRELEASEMETHODUSED AS
SELECT pr.MethodListID AS PollutantReleaseMethodUsedID
	,pr.PollutantReleaseID AS forPollutantRelease
	,mt.LOV_MethodTypeID AS methodType
	,mu.MethodDesignation
FROM dbo.POLLUTANTRELEASE AS pr
INNER JOIN dbo.FACILITYREPORT AS fr
	ON fr.FacilityReportID = pr.FacilityReportID
INNER JOIN dbo.vAT_POLLUTANTRELEASEANDTRANSFERREPORT AS prtr
	ON prtr.PollutantReleaseAndTransferReportID = fr.PollutantReleaseAndTransferReportID
LEFT JOIN dbo.METHODUSED AS mu
	ON pr.MethodListID = mu.MethodListID
LEFT JOIN dbo.LOV_METHODTYPE AS mt
	ON mu.LOV_MethodTypeID = mt.LOV_MethodTypeID
WHERE (pr.MethodListID IS NOT NULL)
GO

IF EXISTS 
	(
		SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS
		WHERE TABLE_NAME = 'RDF_POLLUTANTTRANSFERMETHODUSED'
	)
    DROP VIEW RDF_POLLUTANTTRANSFERMETHODUSED;
GO

CREATE VIEW dbo.RDF_POLLUTANTTRANSFERMETHODUSED AS
SELECT pt.MethodListID AS PollutantTransferMethodUsedID
	,pt.PollutantTransferID AS forPollutantTransfer
	,mt.LOV_MethodTypeID AS methodType
	,mu.MethodDesignation
FROM dbo.POLLUTANTTRANSFER AS pt
INNER JOIN dbo.FACILITYREPORT AS fr
	ON fr.FacilityReportID = pt.FacilityReportID
INNER JOIN dbo.vAT_POLLUTANTRELEASEANDTRANSFERREPORT AS prtr
	ON prtr.PollutantReleaseAndTransferReportID = fr.PollutantReleaseAndTransferReportID
LEFT JOIN dbo.METHODUSED AS mu
	ON pt.MethodListID = mu.MethodListID
LEFT JOIN dbo.LOV_METHODTYPE AS mt
	ON mu.LOV_MethodTypeID = mt.LOV_MethodTypeID
WHERE (pt.MethodListID IS NOT NULL)
GO

IF EXISTS 
	(
		SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS
		WHERE TABLE_NAME = 'RDF_WASTETRANSFERMETHODUSED'
	)
    DROP VIEW RDF_WASTETRANSFERMETHODUSED;
GO

CREATE VIEW dbo.RDF_WASTETRANSFERMETHODUSED AS
SELECT wt.MethodListID AS WasteTransferMethodUsedID
	,wt.WasteTransferID AS forWasteTransfer
	,mt.LOV_MethodTypeID AS forMethod
	,mu.MethodDesignation
FROM dbo.WASTETRANSFER AS wt
INNER JOIN dbo.FACILITYREPORT AS fr
	ON fr.FacilityReportID = wt.FacilityReportID
INNER JOIN dbo.vAT_POLLUTANTRELEASEANDTRANSFERREPORT AS prtr
	ON prtr.PollutantReleaseAndTransferReportID = fr.PollutantReleaseAndTransferReportID
LEFT JOIN dbo.METHODUSED AS mu
	ON wt.MethodListID = mu.MethodListID
LEFT JOIN dbo.LOV_METHODTYPE AS mt
	ON mu.LOV_MethodTypeID = mt.LOV_MethodTypeID
WHERE (wt.MethodListID IS NOT NULL)
GO



