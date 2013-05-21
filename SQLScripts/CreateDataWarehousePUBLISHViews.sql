------------------------------------------------------------------------------
--	This script creates export views for data published on the web 
--
--	the public data set does not include:
--		Values below threshold
--		Protected voluntary data
--		RemarkText 
--		The CDRfields except CDRReleased
------------------------------------------------------------------------------

USE EPRTRmaster
GO


------------------------------------------------------------------------------
--		create View for POLLUTANTRELEASEANDTRANSFERREPORT
------------------------------------------------------------------------------

if object_id('PUBLISH_POLLUTANTRELEASEANDTRANSFERREPORT')is not null DROP view PUBLISH_POLLUTANTRELEASEANDTRANSFERREPORT
go
CREATE VIEW PUBLISH_POLLUTANTRELEASEANDTRANSFERREPORT(
    PollutantReleaseAndTransferReportID,
    CountryCode,
    CountryName,
    ReportingYear,
    CoordinateSystemCode,
    CoordinateSystemName,
    CdrReleased,
    Published
)
AS
SELECT
    report.PollutantReleaseAndTransferReportID,
    country.Code,
    country.Name,
    report.ReportingYear,
    cs.Code,
    cs.Name,
    report.CdrReleased,
    report.Published
FROM
    dbo.vAT_POLLUTANTRELEASEANDTRANSFERREPORT AS report
LEFT JOIN
    dbo.LOV_COUNTRY AS country
    ON report.LOV_CountryID = country.LOV_CountryID
LEFT JOIN
    dbo.LOV_COORDINATESYSTEM AS cs
    ON report.LOV_CoordinateSystemID = cs.LOV_CoordinateSystemID
go

--select * from PUBLISH_POLLUTANTRELEASEANDTRANSFERREPORT

------------------------------------------------------------------------------
--		create View for FACILITYREPORT
------------------------------------------------------------------------------

if object_id('PUBLISH_FACILITYREPORT')is not null DROP view PUBLISH_FACILITYREPORT
go
CREATE VIEW PUBLISH_FACILITYREPORT(
    FacilityReportID,
    PollutantReleaseAndTransferReportID,
    FacilityID,
    NationalID,
    ParentCompanyName,
    FacilityName,
    StreetName,
    BuildingNumber,
    City,
    PostalCode,
    CountryCode,
    CountryName,
    Lat,
    Long,
    RBDGeoCode,
    RBDGeoName,
    NUTSRegionGeoCode,
    NUTSRegionGeoName,
    RBDSourceCode,
    RBDSourceName,
    NUTSRegionSourceCode,
    NUTSRegionSourceName,   
    NACEMainEconomicActivityCode,
    NACEMainEconomicActivityName,
    CompetentAuthorityName,
    CompetentAuthorityAddressStreetName,
    CompetentAuthorityAddressBuildingNumber,
    CompetentAuthorityAddressCity,
    CompetentAuthorityAddressPostalCode,
    CompetentAuthorityAddressCountryCode,
    CompetentAuthorityAddressCountryName,
    CompetentAuthorityTelephoneCommunication,
    CompetentAuthorityFaxCommunication,
    CompetentAuthorityEmailCommunication,
    CompetentAuthorityContactPersonName, 
    ProductionVolumeProductName,
    ProductionVolumeQuantity,
    ProductionVolumeUnitCode,
    ProductionVolumeUnitName,
    TotalIPPCInstallationQuantity,
    OperatingHours,
    TotalEmployeeQuantity,
    WebsiteCommunication,
    PublicInformation,
    ConfidentialIndicator,
    ConfidentialityReasonCode,
    ConfidentialityReasonName,
    ProtectVoluntaryData,
	MainIASectorCode,	
	MainIASectorName,	
	MainIAActivityCode,	
	MainIAActivityName,	
	MainIASubActivityCode,	
	MainIASubActivityName	
)
AS
SELECT
    fr.FacilityReportID,
    fr.PollutantReleaseAndTransferReportID,
    fr.FacilityID,
    fr.NationalID,
	case when ConfidentialIndicator = 1 and fr.ParentCompanyName is null then 'CONFIDENTIAL' else fr.ParentCompanyName end,
	case when ConfidentialIndicator = 1 and fr.FacilityName is null then 'CONFIDENTIAL' else fr.FacilityName end,
	case when ConfidentialIndicator = 1 and f_address.StreetName is null then 'CONFIDENTIAL' else f_address.StreetName end,
    f_address.BuildingNumber,
	case when ConfidentialIndicator = 1 and f_address.City is null then 'CONFIDENTIAL' else f_address.City end,
	case when ConfidentialIndicator = 1 and f_address.PostalCode is null then 'CONFIDENTIAL' else f_address.PostalCode end,
    f_country.Code,
    f_country.Name,
    fr.GeographicalCoordinate.STY,
    fr.GeographicalCoordinate.STX,
    rbd.Code,
    rbd.Name,
    nuts.Code,
    nuts.Name,
    rbds.Code,
    rbds.Name,
    nutss.Code,
    nutss.Name,
    nace.Code,
    nace.Name,
    ca.Name,
    ca_address.StreetName,
    ca_address.BuildingNumber,
    ca_address.City,
    ca_address.PostalCode,
    ca_country.Code,
    ca_country.Name,
    ca.TelephoneCommunication,
    ca.FaxCommunication,
    ca.EmailCommunication,
    ca.ContactPersonName,
    case when fr.ProtectVoluntaryData = 0 then pvol.ProductName end,
    case when fr.ProtectVoluntaryData = 0 then pvol.Quantity end,
    case when fr.ProtectVoluntaryData = 0 then unit.Code end,
    case when fr.ProtectVoluntaryData = 0 then unit.Name end,
    case when fr.ProtectVoluntaryData = 0 then fr.TotalIPPCInstallationQuantity end,
    case when fr.ProtectVoluntaryData = 0 then fr.OperatingHours end,
    case when fr.ProtectVoluntaryData = 0 then fr.TotalEmployeeQuantity end,
    fr.WebsiteCommunication,
    fr.PublicInformation,
    fr.ConfidentialIndicator,
    conf.Code,
    conf.Name,
    fr.ProtectVoluntaryData,
    aXact.SectorCode,
	aXact.SectorName,
	aXact.ActivityCode,
	aXact.ActivityName,
	aXact.SubActivityCode,
	aXact.SubActivityName
FROM
    FACILITYREPORT AS fr
inner join 
	vAT_POLLUTANTRELEASEANDTRANSFERREPORT prtr
on	prtr.PollutantReleaseAndTransferReportID = fr.PollutantReleaseAndTransferReportID
LEFT JOIN
    dbo.ADDRESS AS f_address
on	fr.AddressID = f_address.AddressID
LEFT JOIN
    dbo.LOV_COUNTRY AS f_country
on	prtr.LOV_CountryID = f_country.LOV_CountryID
LEFT JOIN
    dbo.COMPETENTAUTHORITYPARTY AS ca
on	fr.CompetentAuthorityPartyID = ca.CompetentAuthorityPartyID
LEFT JOIN
    dbo.ADDRESS AS ca_address
on	ca.AddressID = ca_address.AddressID
LEFT JOIN
    dbo.LOV_COUNTRY AS ca_country
on	ca_address.LOV_CountryID = ca_country.LOV_CountryID
LEFT JOIN
    dbo.LOV_RIVERBASINDISTRICT AS rbd
on	fr.LOV_RiverBasinDistrictID = rbd.LOV_RiverBasinDistrictID
LEFT JOIN
    dbo.LOV_RIVERBASINDISTRICT AS rbds
on	fr.LOV_RiverBasinDistrictID_Source = rbds.LOV_RiverBasinDistrictID
LEFT JOIN
    dbo.LOV_NACEACTIVITY AS nace
on	fr.LOV_NACEMainEconomicActivityID = nace.LOV_NACEActivityID
LEFT JOIN
    dbo.PRODUCTIONVOLUME AS pvol
on	fr.ProductionVolumeID = pvol.ProductionVolumeID
LEFT JOIN
    dbo.LOV_UNIT AS unit
on	pvol.LOV_UnitID = unit.LOV_UnitID
LEFT JOIN
    dbo.LOV_NUTSREGION AS nuts
on	fr.LOV_NUTSRegionID = nuts.LOV_NUTSRegionID
LEFT JOIN
    dbo.LOV_NUTSREGION AS nutss
on	fr.LOV_NUTSRegionID_Source = nutss.LOV_NUTSRegionID
LEFT JOIN
    dbo.LOV_CONFIDENTIALITY AS conf
on	fr.LOV_ConfidentialityID = conf.LOV_ConfidentialityID
left join
    dbo.ACTIVITY act
on	fr.FacilityReportID = act.FacilityReportID AND act.MainActivityIndicator = 1
left join
	dbo.vAT_ANNEXIACTIVITY aXact
on	aXact.LOV_AnnexIActivityID = act.LOV_AnnexIActivityID
go

--select * from PUBLISH_FACILITYREPORT order by ProtectVoluntaryData


------------------------------------------------------------------------------
--		create View for ACTIVITY
------------------------------------------------------------------------------

if object_id('PUBLISH_ACTIVITY')is not null DROP view PUBLISH_ACTIVITY
go
CREATE VIEW PUBLISH_ACTIVITY(
    ActivityID,
    FacilityReportID,
    FacilityReportName,
    AnnexIActivityCode,
    AnnexIActivityName,
    AnnexIActivityIPPCCode,
    RankingNumeric,
    MainActivityIndicator
)
AS
SELECT       
    a.ActivityID,
    a.FacilityReportID,
    fr.FacilityName,
    aia.Code,
    aia.Name,
    aia.IPPCCode,
    a.RankingNumeric,
    a.MainActivityIndicator
FROM
    ACTIVITY AS a
inner join 
	FACILITYREPORT fr
on	fr.FacilityReportID = a.FacilityReportID
inner join 
	vAT_POLLUTANTRELEASEANDTRANSFERREPORT prtr
on	prtr.PollutantReleaseAndTransferReportID = fr.PollutantReleaseAndTransferReportID
LEFT JOIN
    LOV_ANNEXIACTIVITY AS aia
on	a.LOV_AnnexIActivityID = aia.LOV_AnnexIActivityID
GO

--select * from PUBLISH_ACTIVITY


------------------------------------------------------------------------------
--		create View for POLLUTANTRELEASE
------------------------------------------------------------------------------

if object_id('PUBLISH_POLLUTANTRELEASE')is not null DROP view PUBLISH_POLLUTANTRELEASE
go
CREATE VIEW dbo.PUBLISH_POLLUTANTRELEASE(
    PollutantReleaseID,
    FacilityReportID,
    ReleaseMediumCode,
    ReleaseMediumName,
	PollutantCode,
    PollutantName,
    PollutantGroupCode,
    PollutantGroupName,
    PollutantCAS,
    MethodBasisCode,
    MethodBasisName,
    TotalQuantity,
    AccidentalQuantity,
    UnitCode,
    UnitName,
    ConfidentialIndicator,
    ConfidentialityReasonCode,
    ConfidentialityReasonName
)
AS
SELECT
    pr.PollutantReleaseID,
    pr.FacilityReportID,
    m.Code,
    m.Name,
	p.PollutantCode,
    p.PollutantName,
    p.PollutantGroupCode,
    p.PollutantGroupName,
    p.CAS,
    mb.Code,
    mb.Name,
    pr.TotalQuantity,
    pr.AccidentalQuantity,
    tot_unit.Code,
    tot_unit.Name,
    pr.ConfidentialIndicator,
	conf.Code,
    conf.Name
FROM
    dbo.vAT_POLLUTANTRELEASE AS pr
inner join 
	FACILITYREPORT fr
on	fr.FacilityReportID = pr.FacilityReportID
inner join 
	vAT_POLLUTANTRELEASEANDTRANSFERREPORT prtr
on	prtr.PollutantReleaseAndTransferReportID = fr.PollutantReleaseAndTransferReportID
LEFT JOIN
    dbo.LOV_MEDIUM AS m
on	pr.LOV_MediumID = m.LOV_MediumID
LEFT JOIN
    dbo.vAT_POLLUTANT AS p
on	pr.LOV_PollutantID = p.LOV_PollutantID
LEFT JOIN
    dbo.LOV_METHODBASIS AS mb
on	pr.LOV_MethodBasisID = mb.LOV_MethodBasisID
LEFT JOIN
    dbo.LOV_UNIT AS tot_unit
on	pr.LOV_TotalQuantityUnitID = tot_unit.LOV_UnitID
LEFT JOIN
    dbo.LOV_CONFIDENTIALITY AS conf
on	pr.LOV_ConfidentialityID = conf.LOV_ConfidentialityID
go

--select * from PUBLISH_POLLUTANTRELEASE


------------------------------------------------------------------------------
--		create View for POLLUTANTRELEASEMETHODUSED
------------------------------------------------------------------------------

if object_id('PUBLISH_POLLUTANTRELEASEMETHODUSED')is not null DROP view PUBLISH_POLLUTANTRELEASEMETHODUSED
go
CREATE VIEW dbo.PUBLISH_POLLUTANTRELEASEMETHODUSED(
    PollutantReleaseMethodUsedID,
    PollutantReleaseID,
    MethodTypeCode,
    MethodTypeName,
    MethodDesignation
)
AS
SELECT
    pr.MethodListID,
    pr.PollutantReleaseID,
    mt.Code,
    mt.Name,
    mu.MethodDesignation
FROM
    dbo.POLLUTANTRELEASE AS pr
inner join 
	FACILITYREPORT fr
on	fr.FacilityReportID = pr.FacilityReportID
inner join 
	vAT_POLLUTANTRELEASEANDTRANSFERREPORT prtr
on	prtr.PollutantReleaseAndTransferReportID = fr.PollutantReleaseAndTransferReportID
LEFT JOIN
    dbo.METHODUSED AS mu
on	pr.MethodListID = mu.MethodListID
LEFT JOIN
    dbo.LOV_METHODTYPE AS mt
on	mu.LOV_MethodTypeID = mt.LOV_MethodTypeID
where
    pr.MethodListID IS NOT NULL
GO

--select * from PUBLISH_POLLUTANTRELEASEMETHODUSED


------------------------------------------------------------------------------
--		create View for POLLUTANTTRANSFER
------------------------------------------------------------------------------

if object_id('PUBLISH_POLLUTANTTRANSFER')is not null DROP view PUBLISH_POLLUTANTTRANSFER
go
CREATE VIEW dbo.PUBLISH_POLLUTANTTRANSFER(
    PollutantTransferID,
    FacilityReportID,
	PollutantCode,
    PollutantName,
    PollutantGroupCode,
    PollutantGroupName,
    PollutantCAS,
    MethodBasisCode,
    MethodBasisName,
    Quantity,
    QuantityUnitCode,
    QuantityUnitName,
    ConfidentialIndicator,
    ConfidentialityReasonCode,
    ConfidentialityReasonName
)
AS
SELECT
	pt.PollutantTransferID,
	pt.FacilityReportID,
	p.PollutantCode,
    p.PollutantName,
    p.PollutantGroupCode,
    p.PollutantGroupName,
    p.CAS,
    mb.Code,
    mb.Name,
	pt.Quantity,
	unit.Code,
	unit.Name,
	pt.ConfidentialIndicator,
	conf.Code,
	conf.Name
FROM
	dbo.vAT_POLLUTANTTRANSFER AS pt
inner join 
	FACILITYREPORT fr
on	fr.FacilityReportID = pt.FacilityReportID
inner join 
	vAT_POLLUTANTRELEASEANDTRANSFERREPORT prtr
on	prtr.PollutantReleaseAndTransferReportID = fr.PollutantReleaseAndTransferReportID
LEFT JOIN
	vAT_POLLUTANT AS p
ON	pt.LOV_PollutantID = p.LOV_PollutantID
LEFT JOIN
	dbo.LOV_METHODBASIS AS mb
ON	pt.LOV_MethodBasisID = mb.LOV_MethodBasisID
LEFT JOIN
	dbo.LOV_UNIT AS unit
ON	pt.LOV_QuantityUnitID = unit.LOV_UnitID
LEFT JOIN
	dbo.LOV_CONFIDENTIALITY AS conf
ON	pt.LOV_ConfidentialityID = conf.LOV_ConfidentialityID
GO

--select * from PUBLISH_POLLUTANTTRANSFER


------------------------------------------------------------------------------
--		create View for POLLUTANTTRANSFERMETHODUSED
------------------------------------------------------------------------------

if object_id('PUBLISH_POLLUTANTTRANSFERMETHODUSED')is not null DROP view PUBLISH_POLLUTANTTRANSFERMETHODUSED
go
CREATE VIEW PUBLISH_POLLUTANTTRANSFERMETHODUSED(
    PollutantTransferMethodUsedID,
    PollutantTransferID,
    MethodTypeCode,
    MethodTypeName,
    MethodDesignation
)
AS
SELECT
    pt.MethodListID,
    pt.PollutantTransferID,
    mt.Code,
    mt.Name,
    mu.MethodDesignation
FROM
	dbo.POLLUTANTTRANSFER AS pt
inner join 
	FACILITYREPORT fr
on	fr.FacilityReportID = pt.FacilityReportID
inner join 
	vAT_POLLUTANTRELEASEANDTRANSFERREPORT prtr
on	prtr.PollutantReleaseAndTransferReportID = fr.PollutantReleaseAndTransferReportID
LEFT JOIN
	dbo.METHODUSED AS mu
ON	pt.MethodListID = mu.MethodListID
LEFT JOIN
	dbo.LOV_METHODTYPE AS mt
ON	mu.LOV_MethodTypeID = mt.LOV_MethodTypeID
WHERE
	pt.MethodListID IS NOT NULL
GO

--select * from PUBLISH_POLLUTANTTRANSFERMETHODUSED


------------------------------------------------------------------------------
--		create View for WASTETRANSFER
------------------------------------------------------------------------------

if object_id('PUBLISH_WASTETRANSFER')is not null DROP view PUBLISH_WASTETRANSFER
go
CREATE VIEW PUBLISH_WASTETRANSFER(
    WasteTransferID,
    FacilityReportID,
    WasteTypeCode,
    WasteTypeName,
    WasteTreatmentCode,
    WasteTreatmentName,
    MethodBasisCode,
    MethodBasisName,
    Quantity,
    QuantityUnitCode,
    QuantityUnitName,
    WasteHandlerPartyName,
    WasteHandlerPartyAddressStreetName,
    WasteHandlerPartyAddressBuildingNumber,
    WasteHandlerPartyAddressCity,
    WasteHandlerPartyAddressPostalCode,
    WasteHandlerPartyAddressCountryCode,
    WasteHandlerPartyAddressCountryName,
    WasteHandlerPartySiteAddressStreetName,
    WasteHandlerPartySiteAddressBuildingNumber,
    WasteHandlerPartySiteAddressCity,
    WasteHandlerPartySiteAddressPostalCode,
    WasteHandlerPartySiteAddressCountryCode,
    WasteHandlerPartySiteAddressCountryName,
    ConfidentialIndicator,
    ConfidentialityReasonCode,
    ConfidentialityReasonName
)
AS
SELECT
    wt.WasteTransferID,
    wt.FacilityReportID,
    wtype.Code,
    wtype.Name,
	case when wt.ConfidentialIndicator = 1 and wtreatment.Code is null then 'CONFIDENTIAL' else wtreatment.Code end,
	case when wt.ConfidentialIndicator = 1 and wtreatment.Name is null then 'CONFIDENTIAL' else wtreatment.Name end,
	case when wt.ConfidentialIndicator = 1 and mb.Code is null then 'CONFIDENTIAL' else mb.Code end,
	case when wt.ConfidentialIndicator = 1 and mb.Name is null then 'CONFIDENTIAL' else mb.Name end,
    wt.Quantity,
    unit.Name,
    unit.Code,
	case when wt.ConfidentialIndicator = 1 and whp.Name is null then 'CONFIDENTIAL' else whp.Name end,
	case when wt.ConfidentialIndicator = 1 and whpa.StreetName is null then 'CONFIDENTIAL' else whpa.StreetName end,
    whpa.BuildingNumber,
	case when wt.ConfidentialIndicator = 1 and whpa.City is null then 'CONFIDENTIAL' else whpa.City end,
	case when wt.ConfidentialIndicator = 1 and whpa.PostalCode is null then 'CONFIDENTIAL' else whpa.PostalCode end,
	case when wt.ConfidentialIndicator = 1 and whpa_country.Code is null then 'CONFIDENTIAL' else whpa_country.Code end,
	case when wt.ConfidentialIndicator = 1 and whpa_country.Name is null then 'CONFIDENTIAL' else whpa_country.Name end,
	case when wt.ConfidentialIndicator = 1 and whpsa.StreetName is null then 'CONFIDENTIAL' else whpsa.StreetName end,
    whpsa.BuildingNumber,
	case when wt.ConfidentialIndicator = 1 and whpsa.City is null then 'CONFIDENTIAL' else whpsa.City end,
	case when wt.ConfidentialIndicator = 1 and whpsa.PostalCode is null then 'CONFIDENTIAL' else whpsa.PostalCode end,
	case when wt.ConfidentialIndicator = 1 and whpsa_country.Code is null then 'CONFIDENTIAL' else whpsa_country.Code end,
	case when wt.ConfidentialIndicator = 1 and whpsa_country.Name is null then 'CONFIDENTIAL' else whpsa_country.Name end,
    wt.ConfidentialIndicator,
    conf.Code,
    conf.Name
FROM
    dbo.vAT_WASTETRANSFER AS wt
inner join 
	FACILITYREPORT fr
on	fr.FacilityReportID = wt.FacilityReportID
inner join 
	vAT_POLLUTANTRELEASEANDTRANSFERREPORT prtr
on	prtr.PollutantReleaseAndTransferReportID = fr.PollutantReleaseAndTransferReportID
LEFT JOIN
    dbo.LOV_WASTETYPE AS wtype
ON wt.LOV_WasteTypeID = wtype.LOV_WasteTypeID
LEFT JOIN
	dbo.LOV_WASTETREATMENT AS wtreatment
ON	wt.LOV_WasteTreatmentID = wtreatment.LOV_WasteTreatmentID
LEFT JOIN
	dbo.LOV_METHODBASIS AS mb
ON	wt.LOV_MethodBasisID = mb.LOV_MethodBasisID
LEFT JOIN
	dbo.LOV_UNIT AS unit
ON	wt.LOV_QuantityUnitID = unit.LOV_UnitID
LEFT JOIN
	dbo.WASTEHANDLERPARTY AS whp
ON	wt.WasteHandlerPartyID = whp.WasteHandlerPartyID
LEFT JOIN
	dbo.ADDRESS AS whpa
ON	whp.AddressID = whpa.AddressID
LEFT JOIN
	dbo.LOV_COUNTRY AS whpa_country
ON	whpa.LOV_CountryID = whpa_country.LOV_CountryID
LEFT JOIN
	dbo.ADDRESS AS whpsa
ON	whp.SiteAddressID = whpsa.AddressID
LEFT JOIN
	dbo.LOV_COUNTRY AS whpsa_country
ON	whpsa.LOV_CountryID = whpsa_country.LOV_CountryID
LEFT JOIN
	dbo.LOV_CONFIDENTIALITY AS conf
ON	wt.LOV_ConfidentialityID = conf.LOV_ConfidentialityID
GO

--select * from PUBLISH_WASTETRANSFER


------------------------------------------------------------------------------
--		create View for WASTETRANSFER
------------------------------------------------------------------------------

if object_id('PUBLISH_WASTETRANSFERMETHODUSED')is not null DROP view PUBLISH_WASTETRANSFERMETHODUSED
go
CREATE VIEW PUBLISH_WASTETRANSFERMETHODUSED(
    WasteTransferMethodUsedID,
    WasteTransferID,
    MethodTypeCode,
    MethodTypeName,
    MethodDesignation
)
AS
SELECT
    wt.MethodListID,
    wt.WasteTransferID,
    mt.Code,
    mt.Name,
    mu.MethodDesignation
FROM
    dbo.WASTETRANSFER AS wt
inner join 
	FACILITYREPORT fr
on	fr.FacilityReportID = wt.FacilityReportID
inner join 
	vAT_POLLUTANTRELEASEANDTRANSFERREPORT prtr
on	prtr.PollutantReleaseAndTransferReportID = fr.PollutantReleaseAndTransferReportID
LEFT JOIN
    dbo.METHODUSED AS mu
ON	wt.MethodListID = mu.MethodListID
LEFT JOIN
    dbo.LOV_METHODTYPE AS mt
ON	mu.LOV_MethodTypeID = mt.LOV_MethodTypeID
WHERE
    wt.MethodListID IS NOT NULL
GO

--select * from PUBLISH_WASTETRANSFERMETHODUSED



------------------------------------------------------------------------------
--		create View for NACEACTIVITY
------------------------------------------------------------------------------

if object_id('PUBLISH_EPER2EPRTR_NACEACTIVITY')is not null DROP view PUBLISH_EPER2EPRTR_NACEACTIVITY
go
CREATE VIEW PUBLISH_EPER2EPRTR_NACEACTIVITY
AS
SELECT 
	Name as EPER_Name,
	substring(Code,10,8) as EPER_Code,
	Section as EPER_Section,
	SubSection as EPER_SubSection,
	LOV_NACEActivityID as LOV_NACEActivityID,
	Name as EPRTR_Name,
	Code as EPRTR_Code ,
	StartYear as EPRTR_StartYear,
	EndYear as EPRTR_EndYear,
	ParentID as EPRTR_ParentID
FROM EPRTRmaster.dbo.LOV_NACEACTIVITY
where EndYear = 2004
go
--select * from PUBLISH_EPER2EPRTR_NACEACTIVITY


------------------------------------------------------------------------------
--		create View for ANNEXIACTIVITY
------------------------------------------------------------------------------

if object_id('PUBLISH_EPER2EPRTR_ANNEXIACTIVITY')is not null DROP view PUBLISH_EPER2EPRTR_ANNEXIACTIVITY
go

CREATE VIEW PUBLISH_EPER2EPRTR_ANNEXIACTIVITY
AS
select 
	SUBSTRING(l2.Code,6,8) as EPER_Code,
	l2.[Name] as EPER_Name,
	l2.[StartYear] as StartYear,
	l2.[EndYear] as EndYear,
	l1.[Code] as EPRTR_Code,
	l1.[Name]as EPRTR_Name,
	l1.[StartYear] as EPRTR_StartYear
from LOV_ANNEXIACTIVITY l1
inner join LOV_ANNEXIACTIVITY l2
on	(l1.Code = '2' and SUBSTRING(l2.Code,6,8) = '2')
or	(l1.Code = '1.(a)' and SUBSTRING(l2.Code,6,8) ='1.2') 
or	(l1.Code = '1.(c)' and SUBSTRING(l2.Code,6,8) ='1.1') 
or	(l1.Code = '1.(d)' and SUBSTRING(l2.Code,6,8) ='1.3') 
or	(l1.Code = '3.(d)' and SUBSTRING(l2.Code,6,8) ='3.2') 
or	(l1.Code = '4.(a)' and SUBSTRING(l2.Code,6,8) ='4.1') 
or	(l1.Code = '4.(e)' and SUBSTRING(l2.Code,6,8) ='4.5') 
or	(l1.Code = '5.(e)' and SUBSTRING(l2.Code,6,8) ='6.5') 
or	(l1.Code = '7.(a)' and SUBSTRING(l2.Code,6,8) ='6.6') 
or	(l1.Code = '9.(a)' and SUBSTRING(l2.Code,6,8) ='6.2') 
or	(l1.Code = '9.(b)' and SUBSTRING(l2.Code,6,8) ='6.3') 
or	(l1.Code = '9.(c)' and SUBSTRING(l2.Code,6,8) ='6.7') 
or	(l1.Code = '9.(d)' and SUBSTRING(l2.Code,6,8) ='6.8') 
go

--select * from PUBLISH_EPER2EPRTR_ANNEXIACTIVITY
