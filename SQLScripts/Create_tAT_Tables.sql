USE EPRTRmaster
GO

/****** Object:  Table dbo.tAT_ACTIVITYSEARCH_POLLUTANTRELEASE    Script Date: 04/24/2009 10:48:26 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

if object_id('EPRTRmaster.dbo.tAT_ACTIVITYSEARCH_POLLUTANTRELEASE')is not null DROP TABLE EPRTRmaster.dbo.tAT_ACTIVITYSEARCH_POLLUTANTRELEASE
CREATE TABLE EPRTRmaster.dbo.tAT_ACTIVITYSEARCH_POLLUTANTRELEASE(
	FacilityReportID int NULL,
	LOV_PollutantID int NULL,
	PrID1 int NULL,
	PrID2 int NULL,
	PrID3 int NULL,
	QuantityAir float NULL,
	QuantityAccidentalAir float NULL,
	QuantityWater float NULL,
	QuantityAccidentalWater float NULL,
	QuantitySoil float NULL,
	QuantityAccidentalSoil float NULL,
	UnitAir nvarchar(255) NULL,
	UnitAccidentalAir nvarchar(255) NULL,
	UnitWater nvarchar(255) NULL,
	UnitAccidentalWater nvarchar(255) NULL,
	UnitSoil nvarchar(255) NULL,
	UnitAccidentalSoil nvarchar(255) NULL,
	ConfidentialIndicator bit not null,
	LOV_ConfidentialityIDAir int null,
	LOV_ConfidentialityIDWater int null,
	LOV_ConfidentialityIDSoil int null
)
go

if object_id('EPRTRmaster.dbo.tAT_FACILITY_POLLUTANTRELEASE_YEAR')is not null DROP TABLE EPRTRmaster.dbo.tAT_FACILITY_POLLUTANTRELEASE_YEAR
create table EPRTRmaster.dbo.tAT_FACILITY_POLLUTANTRELEASE_YEAR(
	FacilityID int null, 
	PollutantCode nvarchar(255) null, 
	ReportingYear int null
)
go
CREATE UNIQUE CLUSTERED INDEX POLLUTANTRELEASE_YEAR_INDEX 
ON EPRTRmaster.dbo.tAT_FACILITY_POLLUTANTRELEASE_YEAR (FacilityID asc, PollutantCode asc, ReportingYear)
go

if object_id('EPRTRmaster.dbo.tAT_FACILITY_POLLUTANTTRANSFER_YEAR')is not null DROP TABLE EPRTRmaster.dbo.tAT_FACILITY_POLLUTANTTRANSFER_YEAR
create table EPRTRmaster.dbo.tAT_FACILITY_POLLUTANTTRANSFER_YEAR(
	FacilityID int null, 
	PollutantCode nvarchar(255) null, 
	ReportingYear int null
)
go
CREATE UNIQUE CLUSTERED INDEX POLLUTANTTRANSFER_YEAR_INDEX 
ON EPRTRmaster.dbo.tAT_FACILITY_POLLUTANTTRANSFER_YEAR (FacilityID asc, PollutantCode asc, ReportingYear)
go

if object_id('EPRTRmaster.dbo.tAT_WASTETRANSFER')is not null DROP TABLE EPRTRmaster.dbo.tAT_WASTETRANSFER
go
CREATE TABLE EPRTRmaster.dbo.tAT_WASTETRANSFER(
	FacilityReportID int not NULL,
	QuantityRecoveryNONHW float NULL,
	QuantityDisposalNONHW float NULL,
	QuantityUnspecNONHW float NULL,
	UnitCodeNONHW nvarchar(255) NULL,
	QuantityRecoveryHWIC  float NULL,
	QuantityDisposalHWIC  float NULL,
	QuantityUnspecHWIC  float NULL,
	UnitCodeHWIC nvarchar(255) NULL,
	QuantityRecoveryHWOC float NULL,
	QuantityDisposalHWOC float NULL,
	QuantityUnspecHWOC float NULL,
	UnitCodeHWOC nvarchar(255) NULL,
	HasReportedRecovery bit not null,
	HasReportedDisposal bit not null,
	HasReportedUnspecified bit not null,
	ConfidentialIndicator bit not null,
	ConfidentialCodeNONHW nvarchar(255) NULL,
	ConfidentialCodeHWIC nvarchar(255) NULL,
	ConfidentialCodeHWOC nvarchar(255) NULL,
	LOV_ConfidentialityIDNONHW int null,
	LOV_ConfidentialityIDHWIC int null,
	LOV_ConfidentialityIDHWOC int null,
	ConfidentialIndicator_HWIC_R bit null,
	ConfidentialIndicator_HWIC_D bit null,
	ConfidentialIndicator_HWIC_U bit null,
	ConfidentialIndicator_HWOC_R bit null,
	ConfidentialIndicator_HWOC_D bit null,
	ConfidentialIndicator_HWOC_U bit null,
	ConfidentialIndicator_NONHW_R bit null,
	ConfidentialIndicator_NONHW_D bit null,
	ConfidentialIndicator_NONHW_U bit null
)
go

if object_id('EPRTRmaster.dbo.tAT_WASTETRANSFER_RECEIVINGCOUNTRY')is not null DROP TABLE tAT_WASTETRANSFER_RECEIVINGCOUNTRY
CREATE TABLE dbo.tAT_WASTETRANSFER_RECEIVINGCOUNTRY(
	WasteTransferID int not null,
	FacilityReportID int NULL,
	QuantityRecovery float NULL,
	QuantityDisposal float NULL,
	QuantityUnspec float NULL,
	QuantityTotal float NULL,
	LOV_UnitID int NULL,
	LOV_ReceivingCountryID int null,
	ConfidentialIndicator bit not null,
	LOV_ConfidentialityID int null,
)
go

if object_id('EPRTRmaster.dbo.tAT_CONFIDENTIALITY')is not null DROP TABLE EPRTRmaster.dbo.tAT_CONFIDENTIALITY
CREATE TABLE EPRTRmaster.dbo.tAT_CONFIDENTIALITY(
	FacilityReportID int not NULL,
	ConfidentialIndicatorFacility int null,
	ConfidentialIndicatorWaste int null,
	ConfidentialIndicatorPollutantTransfer int null,
	ConfidentialIndicatorPollutantRelease int null
)
go



