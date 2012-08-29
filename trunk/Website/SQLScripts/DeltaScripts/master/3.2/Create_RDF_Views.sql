IF EXISTS 
	(
		SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS
		WHERE TABLE_NAME = 'RDF_ACTIVITY'
	)
    DROP VIEW RDF_ACTIVITY;
GO

CREATE VIEW dbo.RDF_ACTIVITY AS
SELECT a.ActivityID
	,a.FacilityReportID AS inReport
	,aia.Code AS annexIActivity
	,aia.IPPCCode AS AnnexIActivityIPPCCode
	,a.RankingNumeric
	,a.MainActivityIndicator
	,aia.Code + ' - ' + aia.Name + 
	CASE a.MainActivityIndicator
		WHEN 1 THEN ' (main)'
		ELSE ''
	END AS 'rdfs:label' 
FROM dbo.ACTIVITY AS a INNER JOIN
	dbo.FACILITYREPORT AS fr ON fr.FacilityReportID = a.FacilityReportID INNER JOIN
	dbo.vAT_POLLUTANTRELEASEANDTRANSFERREPORT AS prtr ON 
	prtr.PollutantReleaseAndTransferReportID = fr.PollutantReleaseAndTransferReportID 
LEFT OUTER JOIN
    dbo.LOV_ANNEXIACTIVITY AS aia ON a.LOV_AnnexIActivityID = aia.LOV_AnnexIActivityID
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
	,prtr.ReportingYear
	,prtr.CdrReleased
	,prtr.Published
	,f_country.Code AS inCountry
	,fr.GeographicalCoordinate.STY AS "geo:lat"
	,fr.GeographicalCoordinate.STX AS "geo:long"
	,rbd.Code AS forRBD
	,nuts.Code AS forNUTS
	,nace.Code as nACEActivity
	,fr.CompetentAuthorityPartyID as competentAuthority
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
	,conf.Code AS confidentiality
	,fr.ProtectVoluntaryData
	,aXact.SectorCode as annexIActivity
	,CASE 
		WHEN ConfidentialIndicator = 1
			OR fr.FacilityName IS NULL
			THEN 'CONFIDENTIAL'
		ELSE fr.FacilityName
		END 
		+ ' for year ' + CAST(prtr.ReportingYear AS NVARCHAR(4)) AS 'rdfs:label'
FROM dbo.FACILITYREPORT AS fr
INNER JOIN dbo.vAT_POLLUTANTRELEASEANDTRANSFERREPORT AS prtr
	ON prtr.PollutantReleaseAndTransferReportID = fr.PollutantReleaseAndTransferReportID
LEFT JOIN dbo.ADDRESS AS f_address
	ON fr.AddressID = f_address.AddressID
LEFT JOIN dbo.LOV_COUNTRY AS f_country
	ON prtr.LOV_CountryID = f_country.LOV_CountryID
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
LEFT JOIN dbo.LOV_RiverBasinDistrict AS rbd
	ON fr.LOV_RiverBasinDistrictID = rbd.LOV_RiverBasinDistrictID
LEFT JOIN dbo.LOV_NUTSRegion AS nuts
	ON fr.LOV_NUTSRegionID = nuts.LOV_NUTSRegionID	
LEFT JOIN dbo.LOV_NACEActivity nace
	ON fr.LOV_NACEMainEconomicActivityID = nace.LOV_NACEActivityID
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
	,medium.Code AS forMedium
	,pollutant.Code AS forPollutant
	,mb.Code AS forMethod
	,pr.TotalQuantity
	,pr.AccidentalQuantity
	,tot_unit.Code as unit
	,pr.ConfidentialIndicator
	,conf.Code AS confidentiality
	,pollutant.Code + ', ' + medium.Code AS 'rdfs:label'
FROM dbo.vAT_POLLUTANTRELEASE AS pr
INNER JOIN dbo.FACILITYREPORT AS fr
	ON fr.FacilityReportID = pr.FacilityReportID
INNER JOIN dbo.vAT_POLLUTANTRELEASEANDTRANSFERREPORT AS prtr
	ON prtr.PollutantReleaseAndTransferReportID = fr.PollutantReleaseAndTransferReportID
LEFT JOIN dbo.LOV_UNIT AS tot_unit
	ON pr.LOV_TotalQuantityUnitID = tot_unit.LOV_UnitID
LEFT JOIN dbo.LOV_CONFIDENTIALITY AS conf
	ON pr.LOV_ConfidentialityID = conf.LOV_ConfidentialityID
LEFT JOIN dbo.LOV_Pollutant AS pollutant
	ON pr.LOV_PollutantID = pollutant.LOV_PollutantID
LEFT JOIN dbo.LOV_MEDIUM AS medium
	ON pr.LOV_MediumID = medium.LOV_MediumID
LEFT JOIN dbo.LOV_METHODBASIS AS mb
	ON pr.LOV_MethodBasisID = mb.LOV_MethodBasisID
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
	,pollutant.Code as forPollutant
	,mb.Code as forMethod
	,pt.Quantity
	,unit.Code as unit
	,pt.ConfidentialIndicator
	,conf.Code AS confidentiality
	,pollutant.Code AS 'rdfs:label'
FROM dbo.vAT_POLLUTANTTRANSFER AS pt
INNER JOIN dbo.FACILITYREPORT AS fr
	ON fr.FacilityReportID = pt.FacilityReportID
INNER JOIN dbo.vAT_POLLUTANTRELEASEANDTRANSFERREPORT AS prtr
	ON prtr.PollutantReleaseAndTransferReportID = fr.PollutantReleaseAndTransferReportID
LEFT JOIN dbo.LOV_UNIT AS unit
	ON pt.LOV_QuantityUnitID = unit.LOV_UnitID
LEFT JOIN dbo.LOV_CONFIDENTIALITY AS conf
	ON pt.LOV_ConfidentialityID = conf.LOV_ConfidentialityID
LEFT JOIN dbo.LOV_Pollutant AS pollutant
	ON pt.LOV_PollutantID = pollutant.LOV_PollutantID
LEFT JOIN dbo.LOV_METHODBASIS AS mb
	ON pt.LOV_MethodBasisID = mb.LOV_MethodBasisID	
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
	,wastetype.Code AS forWasteType
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
		END AS forMethod
	,wt.Quantity
	,unit.Code as unit
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
	,conf.Code AS confidentiality
	,wastetype.Code + ', ' + wtreatment.Code AS 'rdfs:label'
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
LEFT JOIN dbo.LOV_WasteType AS wastetype
	ON wt.LOV_WasteTypeID = wastetype.LOV_WasteTypeID
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
	,mt.Code AS methodType
	,mu.MethodDesignation
	,mt.Code + COALESCE(' ' + mu.MethodDesignation,'') AS 'rdfs:label'
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
	,mt.Code AS methodType
	,mu.MethodDesignation
	,mt.Code + COALESCE(' ' + mu.MethodDesignation,'') AS 'rdfs:label'
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
	,mt.Code AS forMethod
	,mu.MethodDesignation
	,mt.Code + COALESCE(' ' + mu.MethodDesignation,'') AS 'rdfs:label'
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

IF EXISTS 
	(
		SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS
		WHERE TABLE_NAME = 'RDF_COMPETENTAUTHORITY'
	)
    DROP VIEW RDF_COMPETENTAUTHORITY;
GO

CREATE VIEW dbo.RDF_COMPETENTAUTHORITY AS
SELECT ca.CompetentAuthorityPartyID
	,country.Code AS inCountry
	,ca.ReportingYear
	,ca.Name
	,ca.Name AS 'rdfs:label'
	,address.StreetName AS Address_StreetName
	,address.BuildingNumber AS Address_BuildingNumber
	,address.City AS Address_City
	,address.PostalCode AS Address_PostalCode
	,ca.TelephoneCommunication
	,ca.FaxCommunication
	,ca.EmailCommunication
	,ca.ContactPersonName
FROM dbo.COMPETENTAUTHORITYPARTY ca
LEFT JOIN dbo.LOV_COUNTRY AS country
	ON ca.LOV_CountryID = country.LOV_CountryID
LEFT JOIN dbo.ADDRESS AS address
	ON ca.AddressID = address.AddressID
GO

IF EXISTS 
	(
		SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS
		WHERE TABLE_NAME = 'RDF_ANNEXIACTIVITY'
	)
    DROP VIEW RDF_ANNEXIACTIVITY;
GO

CREATE VIEW dbo.RDF_ANNEXIACTIVITY AS
SELECT a1.Code
	,a1.Name
	,a1.StartYear
	,a1.EndYear
	,a2.Code AS parentANNEXIActivity
	,a1.IPPCCode
	,a1.Code + ' - ' + a1.Name AS 'rdfs:label'
FROM dbo.LOV_ANNEXIACTIVITY a1
LEFT JOIN dbo.LOV_ANNEXIACTIVITY AS a2
	ON a1.ParentID = a2.LOV_AnnexIActivityID
GO

IF EXISTS 
	(
		SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS
		WHERE TABLE_NAME = 'RDF_AREAGROUP'
	)
    DROP VIEW RDF_AREAGROUP;
GO

CREATE VIEW dbo.RDF_AREAGROUP AS
SELECT Code
    ,Name
	,Code + ' - ' + Name AS 'rdfs:label'
FROM dbo.LOV_AREAGROUP
GO

IF EXISTS 
	(
		SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS
		WHERE TABLE_NAME = 'RDF_CONFIDENTIALITY'
	)
    DROP VIEW RDF_CONFIDENTIALITY;
GO

CREATE VIEW dbo.RDF_CONFIDENTIALITY AS
SELECT Code
	,Name
	,StartYear
	,EndYear
	,Code + ' - ' + Name AS 'rdfs:label'
FROM dbo.LOV_CONFIDENTIALITY
GO

IF EXISTS 
	(
		SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS
		WHERE TABLE_NAME = 'RDF_COORDINATESYSTEM'
	)
    DROP VIEW RDF_COORDINATESYSTEM;
GO

CREATE VIEW dbo.RDF_COORDINATESYSTEM AS
SELECT Code
	,Name
	,StartYear
	,EndYear
	,Code + ' - ' + Name AS 'rdfs:label'
FROM dbo.LOV_COORDINATESYSTEM
GO

IF EXISTS 
	(
		SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS
		WHERE TABLE_NAME = 'RDF_COUNTRY'
	)
    DROP VIEW RDF_COUNTRY;
GO

CREATE VIEW dbo.RDF_COUNTRY AS
SELECT Code
	,Name
	,StartYear
	,EndYear
	,Code + ' - ' + Name AS 'rdfs:label'
FROM dbo.LOV_COUNTRY
GO

IF EXISTS 
	(
		SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS
		WHERE TABLE_NAME = 'RDF_MEDIUM'
	)
    DROP VIEW RDF_MEDIUM;
GO

CREATE VIEW dbo.RDF_MEDIUM AS
SELECT Code
	,Name
	,StartYear
	,EndYear
	,Code + ' - ' + Name AS 'rdfs:label'
FROM dbo.LOV_MEDIUM
GO

IF EXISTS 
	(
		SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS
		WHERE TABLE_NAME = 'RDF_METHODBASIS'
	)
    DROP VIEW RDF_METHODBASIS;
GO

CREATE VIEW dbo.RDF_METHODBASIS AS
SELECT Code
	,Name
	,StartYear
	,EndYear
	,Code + ' - ' + Name AS 'rdfs:label'
FROM dbo.LOV_METHODBASIS
GO

IF EXISTS 
	(
		SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS
		WHERE TABLE_NAME = 'RDF_METHODTYPE'
	)
    DROP VIEW RDF_METHODTYPE;
GO

CREATE VIEW dbo.RDF_METHODTYPE AS
SELECT Code
	,Name
	,StartYear
	,EndYear
	,Code + ' - ' + Name AS 'rdfs:label'
FROM dbo.LOV_METHODTYPE
GO

IF EXISTS 
	(
		SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS
		WHERE TABLE_NAME = 'RDF_NACEActivity'
	)
    DROP VIEW RDF_NACEActivity;
GO

CREATE VIEW dbo.RDF_NACEActivity AS
SELECT n1.Code
	,n1.Name
	,n1.StartYear
	,n1.EndYear
	,n2.Code AS parentNACEActivity
	,n1.NaceCodeID
	,n1.Section
	,n1.SubSection
	,n1.Code + ' - ' + n1.Name AS 'rdfs:label'
FROM dbo.LOV_NACEActivity n1
LEFT JOIN dbo.LOV_NACEActivity AS n2
	ON n1.ParentID = n2.LOV_NACEActivityID
GO

IF EXISTS 
	(
		SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS
		WHERE TABLE_NAME = 'RDF_POLLUTANT'
	)
    DROP VIEW RDF_POLLUTANT;
GO

CREATE VIEW dbo.RDF_POLLUTANT AS
SELECT p1.Code
	,p1.Name
	,p1.StartYear
	,p1.EndYear
	,p2.Code AS parentPollutant
	,p1.CAS
	,p1.CodeEPER
	,p1.Code + ' - ' + p1.Name AS 'rdfs:label'
FROM dbo.LOV_Pollutant p1
LEFT JOIN dbo.LOV_Pollutant p2
	ON p1.ParentID = p2.LOV_PollutantID
GO

IF EXISTS 
	(
		SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS
		WHERE TABLE_NAME = 'RDF_STATUS'
	)
    DROP VIEW RDF_STATUS;
GO

CREATE VIEW dbo.RDF_STATUS AS
SELECT LOV_StatusID
	,TableName
	,Code
	,Description
	,Code + ' - ' + TableName AS 'rdfs:label'
FROM dbo.LOV_Status
GO

IF EXISTS 
	(
		SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS
		WHERE TABLE_NAME = 'RDF_UNIT'
	)
    DROP VIEW RDF_UNIT;
GO

CREATE VIEW dbo.RDF_UNIT AS
SELECT Code
	,Name
	,StartYear
	,EndYear
	,Code + ' - ' + Name AS 'rdfs:label'
FROM dbo.LOV_Unit
GO

IF EXISTS 
	(
		SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS
		WHERE TABLE_NAME = 'RDF_RIVERBASINDISTRICT'
	)
    DROP VIEW RDF_RIVERBASINDISTRICT;
GO

CREATE VIEW dbo.RDF_RIVERBASINDISTRICT AS
SELECT rbd.Code
	,rbd.Name
	,rbd.StartYear
	,rbd.EndYear
	,country.Code AS inCountry
	,rbd.Code + ' - ' + rbd.Name AS 'rdfs:label'
FROM dbo.LOV_RIVERBASINDISTRICT rbd
LEFT JOIN dbo.LOV_COUNTRY AS country
	ON rbd.LOV_CountryID = country.LOV_CountryID
GO

IF EXISTS 
	(
		SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS
		WHERE TABLE_NAME = 'RDF_NUTSREGION'
	)
    DROP VIEW RDF_NUTSREGION;
GO

CREATE VIEW dbo.RDF_NUTSREGION AS
SELECT nuts1.Code
	,nuts1.Name
	,nuts1.StartYear
	,nuts1.EndYear
	,nuts2.Code AS parentNUTSRegion
	,country.Code AS inCountry
	,nuts1.Code + ' - ' + nuts1.Name AS 'rdfs:label'
  FROM dbo.LOV_NUTSREGION nuts1
LEFT JOIN dbo.LOV_COUNTRY AS country
	ON nuts1.LOV_CountryID = country.LOV_CountryID
LEFT JOIN dbo.LOV_NUTSREGION nuts2
	ON nuts1.ParentID = nuts2.LOV_NUTSRegionID
GO

IF EXISTS 
	(
		SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS
		WHERE TABLE_NAME = 'RDF_WASTETREATMENT'
	)
    DROP VIEW RDF_WASTETREATMENT;
GO

CREATE VIEW dbo.RDF_WASTETREATMENT AS
SELECT Code
	,Name
	,StartYear
	,EndYear
	,Code + ' - ' + Name AS 'rdfs:label'
FROM dbo.LOV_WasteTreatment
GO

IF EXISTS 
	(
		SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS
		WHERE TABLE_NAME = 'RDF_WASTETYPE'
	)
    DROP VIEW RDF_WASTETYPE;
GO

CREATE VIEW dbo.RDF_WASTETYPE AS
SELECT wt1.Code
	,wt1.Name
	,wt1.StartYear
	,wt1.EndYear
	,wt2.Code AS parentType
	,wt1.Code + ' - ' + wt1.Name AS 'rdfs:label'
FROM dbo.LOV_WasteType wt1
LEFT JOIN dbo.LOV_WasteType wt2
	ON wt1.ParentID = wt2.LOV_WasteTypeID
GO

IF EXISTS 
	(
		SELECT TABLE_NAME FROM INFORMATION_SCHEMA.VIEWS
		WHERE TABLE_NAME = 'RDF_FACILITY'
	)
    DROP VIEW RDF_FACILITY;
GO

CREATE VIEW dbo.RDF_FACILITY AS
SELECT f.FacilityID 
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
	,country.Code AS inCountry
	,fr.ConfidentialIndicator
FROM dbo.Facility f
LEFT JOIN dbo.FacilityReport fr ON
	f.FacilityID = fr.FacilityID
LEFT JOIN dbo.ADDRESS AS f_address
	ON fr.AddressID = f_address.AddressID
INNER JOIN dbo.vAT_POLLUTANTRELEASEANDTRANSFERREPORT AS prtr
	ON prtr.PollutantReleaseAndTransferReportID = fr.PollutantReleaseAndTransferReportID
LEFT JOIN dbo.LOV_COUNTRY AS country
	ON prtr.LOV_CountryID = country.LOV_CountryID
GO
