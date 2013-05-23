SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET QUOTED_IDENTIFIER ON
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ACTIVITY]') AND type in (N'U'))
DROP TABLE [dbo].[ACTIVITY]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ADDRESS]') AND type in (N'U'))
DROP TABLE [dbo].[ADDRESS]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[COMPETENTAUTHORITYPARTY]') AND type in (N'U'))
DROP TABLE [dbo].[COMPETENTAUTHORITYPARTY]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FACILITY]') AND type in (N'U'))
DROP TABLE [dbo].[FACILITY]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FACILITYLOG]') AND type in (N'U'))
DROP TABLE [dbo].[FACILITYLOG]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FACILITYREPORT]') AND type in (N'U'))
DROP TABLE [dbo].[FACILITYREPORT]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LOV_ANNEXIACTIVITY]') AND type in (N'U'))
DROP TABLE [dbo].[LOV_ANNEXIACTIVITY]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LOV_AREAGROUP]') AND type in (N'U'))
DROP TABLE [dbo].[LOV_AREAGROUP]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LOV_CONFIDENTIALITY]') AND type in (N'U'))
DROP TABLE [dbo].[LOV_CONFIDENTIALITY]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LOV_COORDINATESYSTEM]') AND type in (N'U'))
DROP TABLE [dbo].[LOV_COORDINATESYSTEM]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LOV_COUNTRY]') AND type in (N'U'))
DROP TABLE [dbo].[LOV_COUNTRY]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LOV_COUNTRYAREAGROUP]') AND type in (N'U'))
DROP TABLE [dbo].[LOV_COUNTRYAREAGROUP]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LOV_MEDIUM]') AND type in (N'U'))
DROP TABLE [dbo].[LOV_MEDIUM]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LOV_METHODBASIS]') AND type in (N'U'))
DROP TABLE [dbo].[LOV_METHODBASIS]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LOV_METHODTYPE]') AND type in (N'U'))
DROP TABLE [dbo].[LOV_METHODTYPE]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LOV_NACEACTIVITY]') AND type in (N'U'))
DROP TABLE [dbo].[LOV_NACEACTIVITY]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LOV_NUTSREGION]') AND type in (N'U'))
DROP TABLE [dbo].[LOV_NUTSREGION]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LOV_POLLUTANT]') AND type in (N'U'))
DROP TABLE [dbo].[LOV_POLLUTANT]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LOV_POLLUTANTTHRESHOLD]') AND type in (N'U'))
DROP TABLE [dbo].[LOV_POLLUTANTTHRESHOLD]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LOV_RIVERBASINDISTRICT]') AND type in (N'U'))
DROP TABLE [dbo].[LOV_RIVERBASINDISTRICT]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LOV_UNIT]') AND type in (N'U'))
DROP TABLE [dbo].[LOV_UNIT]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LOV_WASTETHRESHOLD]') AND type in (N'U'))
DROP TABLE [dbo].[LOV_WASTETHRESHOLD]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LOV_WASTETREATMENT]') AND type in (N'U'))
DROP TABLE [dbo].[LOV_WASTETREATMENT]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LOV_WASTETYPE]') AND type in (N'U'))
DROP TABLE [dbo].[LOV_WASTETYPE]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[METHODLIST]') AND type in (N'U'))
DROP TABLE [dbo].[METHODLIST]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[METHODUSED]') AND type in (N'U'))
DROP TABLE [dbo].[METHODUSED]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[POLLUTANTRELEASE]') AND type in (N'U'))
DROP TABLE [dbo].[POLLUTANTRELEASE]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[POLLUTANTRELEASEANDTRANSFERREPORT]') AND type in (N'U'))
DROP TABLE [dbo].[POLLUTANTRELEASEANDTRANSFERREPORT]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[POLLUTANTTRANSFER]') AND type in (N'U'))
DROP TABLE [dbo].[POLLUTANTTRANSFER]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PRODUCTIONVOLUME]') AND type in (N'U'))
DROP TABLE [dbo].[PRODUCTIONVOLUME]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[WASTEHANDLERPARTY]') AND type in (N'U'))
DROP TABLE [dbo].[WASTEHANDLERPARTY]
GO

IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[WASTETRANSFER]') AND type in (N'U'))
DROP TABLE [dbo].[LOV_STATUS]
GO

IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LOV_STATUS]') AND type in (N'U'))
DROP TABLE [dbo].[WASTETRANSFER]
GO


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[WASTETRANSFER]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[WASTETRANSFER](
	[WasteTransferID] [int] IDENTITY(1,1) NOT NULL,
	[FacilityReportID] [int] NOT NULL,
	[LOV_WasteTypeID] [int] NOT NULL,
	[LOV_WasteTreatmentID] [int] NULL,
	[LOV_MethodBasisID] [int] NOT NULL,
	[MethodListID] [int] NULL,
	[Quantity] [float] NULL,
	[LOV_QuantityUnitID] [int] NULL,
	[WasteHandlerPartyID] [int] NULL,
	[ConfidentialIndicator] [bit] NOT NULL,
	[LOV_ConfidentialityID] [int] NULL,
	[RemarkText] [nvarchar](max) NULL,
 CONSTRAINT [WasteTransferID] PRIMARY KEY CLUSTERED 
(
	[WasteTransferID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[WASTEHANDLERPARTY]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[WASTEHANDLERPARTY](
	[WasteHandlerPartyID] [int] IDENTITY(1,1) NOT NULL,
	[Name] [nvarchar](255) NULL,
	[AddressID] [int] NULL,
	[SiteAddressID] [int] NULL,
 CONSTRAINT [WasteHandlerPartyID] PRIMARY KEY CLUSTERED 
(
	[WasteHandlerPartyID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PRODUCTIONVOLUME]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PRODUCTIONVOLUME](
	[ProductionVolumeID] [int] IDENTITY(1,1) NOT NULL,
	[ProductName] [nvarchar](255) NOT NULL,
	[Quantity] [float] NOT NULL,
	[LOV_UnitID] [int] NOT NULL,
 CONSTRAINT [ProductionVolumeID] PRIMARY KEY CLUSTERED 
(
	[ProductionVolumeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[POLLUTANTTRANSFER]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[POLLUTANTTRANSFER](
	[PollutantTransferID] [int] IDENTITY(1,1) NOT NULL,
	[FacilityReportID] [int] NOT NULL,
	[LOV_PollutantID] [int] NOT NULL,
	[LOV_MethodBasisID] [int] NOT NULL,
	[MethodListID] [int] NULL,
	[Quantity] [float] NOT NULL,
	[LOV_QuantityUnitID] [int] NOT NULL,
	[ConfidentialIndicator] [bit] NOT NULL,
	[LOV_ConfidentialityID] [int] NULL,
	[RemarkText] [nvarchar](max) NULL,
 CONSTRAINT [PollutantTransferID] PRIMARY KEY CLUSTERED 
(
	[PollutantTransferID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[POLLUTANTRELEASEANDTRANSFERREPORT]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[POLLUTANTRELEASEANDTRANSFERREPORT](
	[PollutantReleaseAndTransferReportID] [int] IDENTITY(1,1) NOT NULL,
	[ReportingYear] [int] NOT NULL,
	[LOV_CountryID] [int] NOT NULL,
	[LOV_CoordinateSystemID] [int] NULL,
	[RemarkText] [nvarchar](max) NULL,
	[CdrUrl] [nvarchar](255) NOT NULL,
	[CdrUploaded] [datetime] NOT NULL,
	[CdrReleased] [datetime] NOT NULL,
	[ForReview] [datetime] NULL,
	[Published] [datetime] NULL,
	[ResubmitReason] [nvarchar](max) NULL,
	[LOV_StatusID] [int] NULL,
 CONSTRAINT [PollutantReleaseAndTransferReportID] PRIMARY KEY CLUSTERED 
(
	[PollutantReleaseAndTransferReportID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[POLLUTANTRELEASE]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[POLLUTANTRELEASE](
	[PollutantReleaseID] [int] IDENTITY(1,1) NOT NULL,
	[FacilityReportID] [int] NOT NULL,
	[LOV_MediumID] [int] NOT NULL,
	[LOV_PollutantID] [int] NOT NULL,
	[LOV_MethodBasisID] [int] NOT NULL,
	[MethodListID] [int] NULL,
	[TotalQuantity] [float] NOT NULL,
	[LOV_TotalQuantityUnitID] [int] NOT NULL,
	[AccidentalQuantity] [float] NOT NULL,
	[LOV_AccidentalQuantityUnitID] [int] NOT NULL,
	[ConfidentialIndicator] [bit] NOT NULL,
	[LOV_ConfidentialityID] [int] NULL,
	[RemarkText] [nvarchar](max) NULL,
 CONSTRAINT [PollutantReleaseID] PRIMARY KEY CLUSTERED 
(
	[PollutantReleaseID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[METHODUSED]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[METHODUSED](
	[MethodUsedID] [int] IDENTITY(1,1) NOT NULL,
	[MethodListID] [int] NOT NULL,
	[LOV_MethodTypeID] [int] NULL,
	[MethodDesignation] [nvarchar](255) NULL,
 CONSTRAINT [MethodUsedID] PRIMARY KEY CLUSTERED 
(
	[MethodUsedID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[METHODLIST]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[METHODLIST](
	[MethodListID] [int] NOT NULL,
 CONSTRAINT [MethodListID] PRIMARY KEY CLUSTERED 
(
	[MethodListID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LOV_WASTETYPE]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[LOV_WASTETYPE](
	[LOV_WasteTypeID] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](255) NOT NULL,
	[Name] [nvarchar](255) NULL,
	[StartYear] [int] NULL,
	[EndYear] [int] NULL,
	[ParentID] [int] NULL,
 CONSTRAINT [LOV_WasteTypeID] PRIMARY KEY CLUSTERED 
(
	[LOV_WasteTypeID] ASC
),
 CONSTRAINT [LOV_WasteTypeCode] UNIQUE
(
	[Code]
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LOV_WASTETREATMENT]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[LOV_WASTETREATMENT](
	[LOV_WasteTreatmentID] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](255) NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[StartYear] [int] NULL,
	[EndYear] [int] NULL,
 CONSTRAINT [LOV_WasteTreatmentID] PRIMARY KEY CLUSTERED 
(
	[LOV_WasteTreatmentID] ASC
),
 CONSTRAINT [LOV_WasteTreatmentCode] UNIQUE
(
	[Code]
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LOV_WASTETHRESHOLD]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[LOV_WASTETHRESHOLD](
	[LOV_WasteThresholdID] [int] IDENTITY(1,1) NOT NULL,
	[LOV_WasteTypeID] [int] NOT NULL,
	[Threshold] [float] NOT NULL,
	[StartYear] [int] NULL,
	[EndYear] [int] NULL,
 CONSTRAINT [LOV_WasteThresholdID] PRIMARY KEY CLUSTERED 
(
	[LOV_WasteThresholdID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LOV_UNIT]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[LOV_UNIT](
	[LOV_UnitID] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](255) NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[StartYear] [int] NULL,
	[EndYear] [int] NULL,
 CONSTRAINT [LOV_UnitID] PRIMARY KEY CLUSTERED 
(
	[LOV_UnitID] ASC
),
 CONSTRAINT [LOV_UnitCode] UNIQUE
(
	[Code]
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LOV_RIVERBASINDISTRICT]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[LOV_RIVERBASINDISTRICT](
	[LOV_RiverBasinDistrictID] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](255) NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[StartYear] [int] NULL,
	[EndYear] [int] NULL,
	[LOV_CountryID] [int] NULL,
 CONSTRAINT [LOV_RiverBasinDistrictID] PRIMARY KEY CLUSTERED 
(
	[LOV_RiverBasinDistrictID] ASC
),
 CONSTRAINT [LOV_RiverBasinDistrictCode] UNIQUE
(
	[Code]
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LOV_POLLUTANTTHRESHOLD]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[LOV_POLLUTANTTHRESHOLD](
	[LOV_PollutantThresholdID] [int] IDENTITY(1,1) NOT NULL,
	[LOV_PollutantID] [int] NOT NULL,
	[LOV_MediumID] [int] NOT NULL,
	[Threshold] [float] NOT NULL,
	[StartYear] [int] NULL,
	[EndYear] [int] NULL,
 CONSTRAINT [LOV_PollutantThresholdID] PRIMARY KEY CLUSTERED 
(
	[LOV_PollutantThresholdID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LOV_POLLUTANT]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[LOV_POLLUTANT](
	[LOV_PollutantID] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](255) NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[StartYear] [int] NULL,
	[EndYear] [int] NULL,
	[ParentID] [int] NULL,
	[CAS] [nvarchar](20) NULL,
 CONSTRAINT [LOV_PollutantID] PRIMARY KEY CLUSTERED 
(
	[LOV_PollutantID] ASC
),
 CONSTRAINT [LOV_PollutantCode] UNIQUE
(
	[Code]
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LOV_NUTSREGION]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[LOV_NUTSREGION](
	[LOV_NUTSRegionID] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](255) NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[StartYear] [int] NULL,
	[EndYear] [int] NULL,
	[ParentID] [int] NULL,
	[LOV_CountryID] [int] NOT NULL,
 CONSTRAINT [LOV_NUTSRegionID] PRIMARY KEY CLUSTERED 
(
	[LOV_NUTSRegionID] ASC
),
 CONSTRAINT [LOV_NUTSRegionCode] UNIQUE
(
	[Code]
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LOV_NACEACTIVITY]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[LOV_NACEACTIVITY](
	[LOV_NACEActivityID] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](255) NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[StartYear] [int] NULL,
	[EndYear] [int] NULL,
	[ParentID] [int] NULL,
 CONSTRAINT [LOV_NACEActivityID] PRIMARY KEY CLUSTERED 
(
	[LOV_NACEActivityID] ASC
),
 CONSTRAINT [LOV_NACEActivityCode] UNIQUE
(
	[Code]
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LOV_METHODTYPE]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[LOV_METHODTYPE](
	[LOV_MethodTypeID] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](255) NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[StartYear] [int] NULL,
	[EndYear] [int] NULL,
 CONSTRAINT [LOV_MethodTypeID] PRIMARY KEY CLUSTERED 
(
	[LOV_MethodTypeID] ASC
),
 CONSTRAINT [LOV_MethodTypeCode] UNIQUE
(
	[Code]
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LOV_METHODBASIS]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[LOV_METHODBASIS](
	[LOV_MethodBasisID] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](255) NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[StartYear] [int] NULL,
	[EndYear] [int] NULL,
 CONSTRAINT [LOV_MethodBasisID] PRIMARY KEY CLUSTERED 
(
	[LOV_MethodBasisID] ASC
),
 CONSTRAINT [LOV_MethodBasisCode] UNIQUE
(
	[Code]
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LOV_MEDIUM]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[LOV_MEDIUM](
	[LOV_MediumID] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](255) NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[StartYear] [int] NULL,
	[EndYear] [int] NULL,
 CONSTRAINT [LOV_MediumID] PRIMARY KEY CLUSTERED 
(
	[LOV_MediumID] ASC
),
 CONSTRAINT [LOV_MediumCode] UNIQUE
(
	[Code]
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LOV_COUNTRYAREAGROUP]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[LOV_COUNTRYAREAGROUP](
	[LOV_AreaGroupID] [int] NOT NULL,
	[LOV_CountryID] [int] NOT NULL,
 CONSTRAINT [LOV_CountryAreaGroupID] PRIMARY KEY CLUSTERED 
(
	[LOV_AreaGroupID] ASC, [LOV_CountryID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LOV_COUNTRY]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[LOV_COUNTRY](
	[LOV_CountryID] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](255) NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[StartYear] [int] NULL,
	[EndYear] [int] NULL,
 CONSTRAINT [LOV_CountryID] PRIMARY KEY CLUSTERED 
(
	[LOV_CountryID] ASC
),
 CONSTRAINT [LOV_CountryCode] UNIQUE
(
	[Code]
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LOV_COORDINATESYSTEM]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[LOV_COORDINATESYSTEM](
	[LOV_CoordinateSystemID] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](255) NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[StartYear] [int] NULL,
	[EndYear] [int] NULL,
 CONSTRAINT [LOV_CoordinateSystemID] PRIMARY KEY CLUSTERED 
(
	[LOV_CoordinateSystemID] ASC
),
 CONSTRAINT [LOV_CoordinateSystemCode] UNIQUE
(
	[Code]
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LOV_CONFIDENTIALITY]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[LOV_CONFIDENTIALITY](
	[LOV_ConfidentialityID] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](255) NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[StartYear] [int] NULL,
	[EndYear] [int] NULL,
 CONSTRAINT [LOV_ConfidentialityID] PRIMARY KEY CLUSTERED 
(
	[LOV_ConfidentialityID] ASC
),
 CONSTRAINT [LOV_ConfidentialityCode] UNIQUE
(
	[Code]
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LOV_AREAGROUP]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[LOV_AREAGROUP](
	[LOV_AreaGroupID] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](255) NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
 CONSTRAINT [LOV_AreaGroupID] PRIMARY KEY CLUSTERED 
(
	[LOV_AreaGroupID] ASC
),
 CONSTRAINT [LOV_AreaGroupCode] UNIQUE
(
	[Code]
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LOV_ANNEXIACTIVITY]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[LOV_ANNEXIACTIVITY](
	[LOV_AnnexIActivityID] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](255) NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[StartYear] [int] NULL,
	[EndYear] [int] NULL,
	[ParentID] [int] NULL,
	[IPPCCode] [nvarchar](255) NULL,
 CONSTRAINT [LOV_AnnexIActivityID] PRIMARY KEY CLUSTERED 
(
	[LOV_AnnexIActivityID] ASC
),
 CONSTRAINT [LOV_AnnexIActivityCode] UNIQUE
(
	[Code]
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FACILITYREPORT]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[FACILITYREPORT](
	[FacilityReportID] [int] IDENTITY(1,1) NOT NULL,
	[PollutantReleaseAndTransferReportID] [int] NOT NULL,
	[FacilityID] [int] NOT NULL,
	[NationalID] [nvarchar](255) NOT NULL,
	[ParentCompanyName] [nvarchar](255) NULL,
	[FacilityName] [nvarchar](255) NULL,
	[AddressID] [int] NULL,
	[GeographicalCoordinate] [geometry] NOT NULL,
	[LOV_StatusID] [int] NULL,	
	[LOV_RiverBasinDistrictID] [int] NOT NULL,
	[LOV_RiverBasinDistrictID_Source] [int] not null,
	[LOV_NACEMainEconomicActivityID] [int] NOT NULL,
	[MainEconomicActivityName] [nvarchar](255) NOT NULL,
	[CompetentAuthorityPartyID] [int] NOT NULL,
	[ProductionVolumeID] [int] NULL,
	[TotalIPPCInstallationQuantity] [int] NULL,
	[OperatingHours] [int] NULL,
	[TotalEmployeeQuantity] [int] NULL,
	[LOV_NUTSRegionID] [int] NULL,
	[LOV_NUTSRegionID_Source] [int] NULL,
	[WebsiteCommunication] [nvarchar](255) NULL,
	[PublicInformation] [nvarchar](255) NULL,
	[ConfidentialIndicator] [bit] NOT NULL,
	[LOV_ConfidentialityID] [int] NULL,
	[ProtectVoluntaryData] [bit] NOT NULL,
	[RemarkText] [nvarchar](max) NULL,
 CONSTRAINT [PK_FACILITYREPORT] PRIMARY KEY CLUSTERED 
(
	[FacilityReportID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FACILITYLOG]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[FACILITYLOG](
	[FacilityLogID] [int] IDENTITY(1,1) NOT NULL,
	[FacilityReportID] [int] NOT NULL,
	[FacilityID] [int] NOT NULL,
	[NationalID] [nvarchar](255) NOT NULL,
	[ReportingYear] [int] NOT NULL,
	[Published] [datetime] NULL,
 CONSTRAINT [FacilityLogID] PRIMARY KEY CLUSTERED 
(
	[FacilityLogID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FACILITY]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[FACILITY](
	[FacilityID] [int] NOT NULL,
 CONSTRAINT [FacilityID] PRIMARY KEY CLUSTERED 
(
	[FacilityID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[COMPETENTAUTHORITYPARTY]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[COMPETENTAUTHORITYPARTY](
	[CompetentAuthorityPartyID] [int] IDENTITY(1,1) NOT NULL,
	[LOV_CountryID] [int] NOT NULL,
	[ReportingYear] [int] NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[AddressID] [int] NOT NULL,
	[TelephoneCommunication] [nvarchar](50) NOT NULL,
	[FaxCommunication] [nvarchar](50) NOT NULL,
	[EmailCommunication] [nvarchar](255) NOT NULL,
	[ContactPersonName] [nvarchar](255) NULL,
 CONSTRAINT [CompetentAuthorityPartyID] PRIMARY KEY CLUSTERED 
(
	[CompetentAuthorityPartyID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ADDRESS]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ADDRESS](
	[AddressID] [int] IDENTITY(1,1) NOT NULL,
	[StreetName] [nvarchar](255) NULL,
	[BuildingNumber] [nvarchar](255) NULL,
	[City] [nvarchar](255) NULL,
	[PostalCode] [nvarchar](50) NULL,
	[LOV_CountryID] [int] NULL,
 CONSTRAINT [AddressID] PRIMARY KEY CLUSTERED 
(
	[AddressID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ACTIVITY]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ACTIVITY](
	[ActivityID] [int] IDENTITY(1,1) NOT NULL,
	[FacilityReportID] [int] NOT NULL,
	[RankingNumeric] [int] NOT NULL,
	[LOV_AnnexIActivityID] [int] NOT NULL,
	[MainActivityIndicator] AS CAST(CASE WHEN [RankingNumeric] = 1 THEN 1 ELSE 0 END AS [bit]) PERSISTED NOT NULL,
 CONSTRAINT [ActivityID] PRIMARY KEY CLUSTERED 
(
	[ActivityID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO


IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LOV_STATUS]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[LOV_STATUS](
	[LOV_StatusID] [int] IDENTITY(1,1) NOT NULL,
	[TableName] [nvarchar](255) NOT NULL,
	[Code] [nvarchar](255) NOT NULL,
	[Description][nvarchar](255) NULL,	
	CONSTRAINT [LOV_StatusID] PRIMARY KEY CLUSTERED 
		(
			[LOV_StatusID] ASC
		),
	CONSTRAINT [LOV_StatusCode] UNIQUE nonclustered
		(
			[Code]
		)
) ON [PRIMARY]
end
go
