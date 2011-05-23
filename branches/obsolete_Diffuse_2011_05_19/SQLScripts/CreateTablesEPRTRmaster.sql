USE [EPRTRweb]

GO
/****** Object:  Table [dbo].[ACTIVITY]    Script Date: 01/27/2009 17:48:15 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ACTIVITY]') AND type in (N'U'))
DROP TABLE [dbo].[ACTIVITY]
GO
/****** Object:  Table [dbo].[ADDRESS]    Script Date: 01/27/2009 17:48:15 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ADDRESS]') AND type in (N'U'))
DROP TABLE [dbo].[ADDRESS]
GO
/****** Object:  Table [dbo].[COMPETENTAUTHORITY]    Script Date: 01/27/2009 17:48:15 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[COMPETENTAUTHORITY]') AND type in (N'U'))
DROP TABLE [dbo].[COMPETENTAUTHORITY]
GO
/****** Object:  Table [dbo].[FACILITY]    Script Date: 01/27/2009 17:48:15 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FACILITY]') AND type in (N'U'))
DROP TABLE [dbo].[FACILITY]
GO
/****** Object:  Table [dbo].[FACILITYLOG]    Script Date: 01/27/2009 17:48:15 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FACILITYLOG]') AND type in (N'U'))
DROP TABLE [dbo].[FACILITYLOG]
GO
/****** Object:  Table [dbo].[FACILITYREPORT]    Script Date: 01/27/2009 17:48:15 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FACILITYREPORT]') AND type in (N'U'))
DROP TABLE [dbo].[FACILITYREPORT]
GO
/****** Object:  Table [dbo].[LOV_ANNEXIACTIVITY]    Script Date: 01/27/2009 17:48:15 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LOV_ANNEXIACTIVITY]') AND type in (N'U'))
DROP TABLE [dbo].[LOV_ANNEXIACTIVITY]
GO
/****** Object:  Table [dbo].[LOV_AREAGROUP]    Script Date: 01/27/2009 17:48:15 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LOV_AREAGROUP]') AND type in (N'U'))
DROP TABLE [dbo].[LOV_AREAGROUP]
GO
/****** Object:  Table [dbo].[LOV_CONFIDENTIALITY]    Script Date: 01/27/2009 17:48:15 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LOV_CONFIDENTIALITY]') AND type in (N'U'))
DROP TABLE [dbo].[LOV_CONFIDENTIALITY]
GO
/****** Object:  Table [dbo].[LOV_COORDINATESYSTEM]    Script Date: 01/27/2009 17:48:15 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LOV_COORDINATESYSTEM]') AND type in (N'U'))
DROP TABLE [dbo].[LOV_COORDINATESYSTEM]
GO
/****** Object:  Table [dbo].[LOV_COUNTRY]    Script Date: 01/27/2009 17:48:15 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LOV_COUNTRY]') AND type in (N'U'))
DROP TABLE [dbo].[LOV_COUNTRY]
GO
/****** Object:  Table [dbo].[LOV_COUNTRYAREAGROUP]    Script Date: 01/27/2009 17:48:16 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LOV_COUNTRYAREAGROUP]') AND type in (N'U'))
DROP TABLE [dbo].[LOV_COUNTRYAREAGROUP]
GO
/****** Object:  Table [dbo].[LOV_MEDIUM]    Script Date: 01/27/2009 17:48:16 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LOV_MEDIUM]') AND type in (N'U'))
DROP TABLE [dbo].[LOV_MEDIUM]
GO
/****** Object:  Table [dbo].[LOV_METHODBASIS]    Script Date: 01/27/2009 17:48:16 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LOV_METHODBASIS]') AND type in (N'U'))
DROP TABLE [dbo].[LOV_METHODBASIS]
GO
/****** Object:  Table [dbo].[LOV_METHODTYPE]    Script Date: 01/27/2009 17:48:16 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LOV_METHODTYPE]') AND type in (N'U'))
DROP TABLE [dbo].[LOV_METHODTYPE]
GO
/****** Object:  Table [dbo].[LOV_NACEACTIVITYCODE]    Script Date: 01/27/2009 17:48:16 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LOV_NACEACTIVITYCODE]') AND type in (N'U'))
DROP TABLE [dbo].[LOV_NACEACTIVITYCODE]
GO
/****** Object:  Table [dbo].[LOV_NUTSREGION]    Script Date: 01/27/2009 17:48:16 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LOV_NUTSREGION]') AND type in (N'U'))
DROP TABLE [dbo].[LOV_NUTSREGION]
GO
/****** Object:  Table [dbo].[LOV_POLLUTANT]    Script Date: 01/27/2009 17:48:16 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LOV_POLLUTANT]') AND type in (N'U'))
DROP TABLE [dbo].[LOV_POLLUTANT]
GO
/****** Object:  Table [dbo].[LOV_POLLUTANTTHRESHOLD]    Script Date: 01/27/2009 17:48:16 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LOV_POLLUTANTTHRESHOLD]') AND type in (N'U'))
DROP TABLE [dbo].[LOV_POLLUTANTTHRESHOLD]
GO
/****** Object:  Table [dbo].[LOV_RIVERBASINDISTRICT]    Script Date: 01/27/2009 17:48:16 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LOV_RIVERBASINDISTRICT]') AND type in (N'U'))
DROP TABLE [dbo].[LOV_RIVERBASINDISTRICT]
GO
/****** Object:  Table [dbo].[LOV_UNIT]    Script Date: 01/27/2009 17:48:16 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LOV_UNIT]') AND type in (N'U'))
DROP TABLE [dbo].[LOV_UNIT]
GO
/****** Object:  Table [dbo].[LOV_WASTETHRESHOLD]    Script Date: 01/27/2009 17:48:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LOV_WASTETHRESHOLD]') AND type in (N'U'))
DROP TABLE [dbo].[LOV_WASTETHRESHOLD]
GO
/****** Object:  Table [dbo].[LOV_WASTETREATMENT]    Script Date: 01/27/2009 17:48:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LOV_WASTETREATMENT]') AND type in (N'U'))
DROP TABLE [dbo].[LOV_WASTETREATMENT]
GO
/****** Object:  Table [dbo].[LOV_WASTETYPE]    Script Date: 01/27/2009 17:48:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LOV_WASTETYPE]') AND type in (N'U'))
DROP TABLE [dbo].[LOV_WASTETYPE]
GO
/****** Object:  Table [dbo].[METHODLIST]    Script Date: 01/27/2009 17:48:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[METHODLIST]') AND type in (N'U'))
DROP TABLE [dbo].[METHODLIST]
GO
/****** Object:  Table [dbo].[METHODUSED]    Script Date: 01/27/2009 17:48:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[METHODUSED]') AND type in (N'U'))
DROP TABLE [dbo].[METHODUSED]
GO
/****** Object:  Table [dbo].[POLLUTANTRELEASE]    Script Date: 01/27/2009 17:48:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[POLLUTANTRELEASE]') AND type in (N'U'))
DROP TABLE [dbo].[POLLUTANTRELEASE]
GO
/****** Object:  Table [dbo].[POLLUTANTRELEASEANDTRANSFERREPORT]    Script Date: 01/27/2009 17:48:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[POLLUTANTRELEASEANDTRANSFERREPORT]') AND type in (N'U'))
DROP TABLE [dbo].[POLLUTANTRELEASEANDTRANSFERREPORT]
GO
/****** Object:  Table [dbo].[POLLUTANTTRANSFER]    Script Date: 01/27/2009 17:48:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[POLLUTANTTRANSFER]') AND type in (N'U'))
DROP TABLE [dbo].[POLLUTANTTRANSFER]
GO
/****** Object:  Table [dbo].[PRODUCTIONVOLUME]    Script Date: 01/27/2009 17:48:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PRODUCTIONVOLUME]') AND type in (N'U'))
DROP TABLE [dbo].[PRODUCTIONVOLUME]
GO
/****** Object:  Table [dbo].[WASTEHANDLERPARTY]    Script Date: 01/27/2009 17:48:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[WASTEHANDLERPARTY]') AND type in (N'U'))
DROP TABLE [dbo].[WASTEHANDLERPARTY]
GO
/****** Object:  Table [dbo].[WASTETRANSFER]    Script Date: 01/27/2009 17:48:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[WASTETRANSFER]') AND type in (N'U'))
DROP TABLE [dbo].[WASTETRANSFER]
GO
/****** Object:  Table [dbo].[WASTETRANSFER]    Script Date: 01/27/2009 17:48:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[WASTETRANSFER]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[WASTETRANSFER](
	[WasteTransferID] [int] IDENTITY(1,1) NOT NULL,
	[FacilityReportID] [int] NULL,
	[LOV_WasteTypeID] [int] NULL,
	[LOV_WasteTreatmentID] [int] NULL,
	[LOV_MethodBasisID] [int] NULL,
	[MethodListID] [int] NULL,
	[Quantity] [float] NULL,
	[LOV_QuantityUnitID] [int] NULL,
	[WasteHandlerPartyID] [int] NULL,
	[ConfidentialIndicator] [bit] NULL,
	[LOV_ConfidentialityID] [int] NULL,
	[RemarkText] [nvarchar](max) NULL,
 CONSTRAINT [WasteTransferID] PRIMARY KEY CLUSTERED 
(
	[WasteTransferID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[WASTEHANDLERPARTY]    Script Date: 01/27/2009 17:48:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
/****** Object:  Table [dbo].[PRODUCTIONVOLUME]    Script Date: 01/27/2009 17:48:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PRODUCTIONVOLUME]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PRODUCTIONVOLUME](
	[ProductionVolumeID] [int] IDENTITY(1,1) NOT NULL,
	[ProductName] [nvarchar](255) NULL,
	[Quantity] [float] NULL,
	[LOV_UnitID] [int] NULL,
 CONSTRAINT [ProductionVolumeID] PRIMARY KEY CLUSTERED 
(
	[ProductionVolumeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[POLLUTANTTRANSFER]    Script Date: 01/27/2009 17:48:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[POLLUTANTTRANSFER]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[POLLUTANTTRANSFER](
	[PollutantTransferID] [int] IDENTITY(1,1) NOT NULL,
	[FacilityReportID] [int] NULL,
	[LOV_PollutantID] [int] NULL,
	[LOV_MethodBasisID] [int] NULL,
	[MethodListID] [int] NULL,
	[Quantity] [float] NULL,
	[LOV_QuantityUnitID] [int] NULL,
	[ConfidentialIndicator] [bit] NULL,
	[LOV_ConfidentialityID] [int] NULL,
	[Remarktext] [nvarchar](max) NULL,
 CONSTRAINT [PollutantTransferID] PRIMARY KEY CLUSTERED 
(
	[PollutantTransferID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[POLLUTANTRELEASEANDTRANSFERREPORT]    Script Date: 01/27/2009 17:48:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[POLLUTANTRELEASEANDTRANSFERREPORT]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[POLLUTANTRELEASEANDTRANSFERREPORT](
	[PollutantReleaseAndTransferReportID] [int] IDENTITY(1,1) NOT NULL,
	[ReportingYear] [int] NULL,
	[LOV_CountryID] [int] NULL,
	[LOV_CoordinateSystemID] [int] NULL,
	[RemarkText] [nvarchar](max) NULL,
	[CdrUrl] [nvarchar](255) NULL,
	[Uploaded] [datetime] NULL,
	[Released] [datetime] NULL,
	[Published] [datetime] NULL,
	[ResubmitReason] [nvarchar](max) NULL,
 CONSTRAINT [PollutantReleaseAndTransferReportID] PRIMARY KEY CLUSTERED 
(
	[PollutantReleaseAndTransferReportID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[POLLUTANTRELEASE]    Script Date: 01/27/2009 17:48:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[POLLUTANTRELEASE]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[POLLUTANTRELEASE](
	[PollutantReleaseID] [int] IDENTITY(1,1) NOT NULL,
	[FacilityReportID] [int] NULL,
	[LOV_MediumID] [int] NULL,
	[LOV_PollutantID] [int] NULL,
	[LOV_MethodBasisID] [int] NULL,
	[MethodListID] [int] NULL,
	[TotalQuantity] [float] NULL,
	[LOV_TotalQuantityUnitID] [int] NULL,
	[AccidentalQuantity] [float] NULL,
	[LOV_AccidentalQuantityUnitID] [int] NULL,
	[ConfidentialIndicator] [bit] NULL,
	[LOV_ConfidentialityID] [int] NULL,
	[RemarkText] [nvarchar](max) NULL,
 CONSTRAINT [PollutantReleaseID] PRIMARY KEY CLUSTERED 
(
	[PollutantReleaseID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[METHODUSED]    Script Date: 01/27/2009 17:48:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[METHODUSED]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[METHODUSED](
	[MethodUsedID] [int] IDENTITY(1,1) NOT NULL,
	[MethodListID] [int] NULL,
	[LOV_MethodTypeID] [int] NULL,
	[MethodDesignation] [nvarchar](255) NULL,
 CONSTRAINT [MethodUsedID] PRIMARY KEY CLUSTERED 
(
	[MethodUsedID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[METHODLIST]    Script Date: 01/27/2009 17:48:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[METHODLIST]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[METHODLIST](
	[MethodListID] [int] IDENTITY(1,1) NOT NULL,
 CONSTRAINT [MethodListID] PRIMARY KEY CLUSTERED 
(
	[MethodListID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[LOV_WASTETYPE]    Script Date: 01/27/2009 17:48:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LOV_WASTETYPE]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[LOV_WASTETYPE](
	[LOV_WasteTypeID] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](255) NULL,
	[Name] [nvarchar](255) NULL,
	[StartYear] [int] NULL,
	[EndYear] [int] NULL,
	[ParentID] [int] NULL,
 CONSTRAINT [LOV_WasteTypeID] PRIMARY KEY CLUSTERED 
(
	[LOV_WasteTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[LOV_WASTETREATMENT]    Script Date: 01/27/2009 17:48:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LOV_WASTETREATMENT]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[LOV_WASTETREATMENT](
	[LOV_WasteTreatmentID] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](255) NULL,
	[Name] [nvarchar](255) NULL,
	[StartYear] [int] NULL,
	[EndYear] [int] NULL,
 CONSTRAINT [LOV_WasteTreatmentID] PRIMARY KEY CLUSTERED 
(
	[LOV_WasteTreatmentID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[LOV_WASTETHRESHOLD]    Script Date: 01/27/2009 17:48:17 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LOV_WASTETHRESHOLD]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[LOV_WASTETHRESHOLD](
	[LOV_WasteThresholdID] [int] IDENTITY(1,1) NOT NULL,
	[LOV_WasteTypeID] [int] NULL,
	[Threshold] [float] NULL,
	[StartYear] [int] NULL,
	[EndYear] [int] NULL,
 CONSTRAINT [LOV_WasteThresholdID] PRIMARY KEY CLUSTERED 
(
	[LOV_WasteThresholdID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[LOV_UNIT]    Script Date: 01/27/2009 17:48:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LOV_UNIT]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[LOV_UNIT](
	[LOV_UnitID] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](255) NULL,
	[Name] [nvarchar](255) NULL,
	[StartYear] [int] NULL,
	[EndYear] [int] NULL,
 CONSTRAINT [LOV_UnitID] PRIMARY KEY CLUSTERED 
(
	[LOV_UnitID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[LOV_RIVERBASINDISTRICT]    Script Date: 01/27/2009 17:48:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LOV_RIVERBASINDISTRICT]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[LOV_RIVERBASINDISTRICT](
	[LOV_RiverBasinDistrictID] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](255) NULL,
	[Name] [nvarchar](255) NULL,
	[StartYear] [int] NULL,
	[EndYear] [int] NULL,
	[LOV_CountryID] [int] NULL,
 CONSTRAINT [LOV_RiverBasinDistrictID] PRIMARY KEY CLUSTERED 
(
	[LOV_RiverBasinDistrictID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[LOV_POLLUTANTTHRESHOLD]    Script Date: 01/27/2009 17:48:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LOV_POLLUTANTTHRESHOLD]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[LOV_POLLUTANTTHRESHOLD](
	[LOV_PollutantThresholdID] [int] IDENTITY(1,1) NOT NULL,
	[LOV_PollutantID] [int] NULL,
	[LOV_MediumID] [int] NULL,
	[Threshold] [float] NULL,
	[StartYear] [int] NULL,
	[EndYear] [int] NULL,
 CONSTRAINT [LOV_PollutantThresholdID] PRIMARY KEY CLUSTERED 
(
	[LOV_PollutantThresholdID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[LOV_POLLUTANT]    Script Date: 01/27/2009 17:48:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LOV_POLLUTANT]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[LOV_POLLUTANT](
	[LOV_PollutantID] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](255) NULL,
	[Name] [nvarchar](255) NULL,
	[StartYear] [int] NULL,
	[EndYear] [int] NULL,
	[ParentID] [int] NULL,
	[CAS] [nvarchar](20) NULL,
 CONSTRAINT [LOV_PollutantID] PRIMARY KEY CLUSTERED 
(
	[LOV_PollutantID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[LOV_NUTSREGION]    Script Date: 01/27/2009 17:48:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LOV_NUTSREGION]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[LOV_NUTSREGION](
	[LOV_NUTSRegionID] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](255) NULL,
	[Name] [nvarchar](255) NULL,
	[StartYear] [int] NULL,
	[EndYear] [int] NULL,
	[ParentID] [int] NULL,
	[LOV_CountryID] [int] NULL,
 CONSTRAINT [LOV_NUTSRegionID] PRIMARY KEY CLUSTERED 
(
	[LOV_NUTSRegionID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[LOV_NACEACTIVITYCODE]    Script Date: 01/27/2009 17:48:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LOV_NACEACTIVITYCODE]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[LOV_NACEACTIVITYCODE](
	[LOV_NACEActivityCodeID] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](255) NULL,
	[Name] [nvarchar](255) NULL,
	[StartYear] [int] NULL,
	[EndYear] [int] NULL,
	[ParentID] [int] NULL,
 CONSTRAINT [LOV_NACEActivityCodeID] PRIMARY KEY CLUSTERED 
(
	[LOV_NACEActivityCodeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[LOV_METHODTYPE]    Script Date: 01/27/2009 17:48:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LOV_METHODTYPE]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[LOV_METHODTYPE](
	[LOV_MethodTypeID] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](255) NULL,
	[Name] [nvarchar](255) NULL,
	[StartYear] [int] NULL,
	[EndYear] [int] NULL,
 CONSTRAINT [LOV_MethodTypeID] PRIMARY KEY CLUSTERED 
(
	[LOV_MethodTypeID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[LOV_METHODBASIS]    Script Date: 01/27/2009 17:48:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LOV_METHODBASIS]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[LOV_METHODBASIS](
	[LOV_MethodBasisID] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](255) NULL,
	[Name] [nvarchar](255) NULL,
	[StartYear] [int] NULL,
	[EndYear] [int] NULL,
 CONSTRAINT [LOV_MethodBasisID] PRIMARY KEY CLUSTERED 
(
	[LOV_MethodBasisID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[LOV_MEDIUM]    Script Date: 01/27/2009 17:48:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LOV_MEDIUM]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[LOV_MEDIUM](
	[LOV_MediumID] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](255) NULL,
	[Name] [nvarchar](255) NULL,
	[StartYear] [int] NULL,
	[EndYear] [int] NULL,
 CONSTRAINT [LOV_MediumID] PRIMARY KEY CLUSTERED 
(
	[LOV_MediumID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[LOV_COUNTRYAREAGROUP]    Script Date: 01/27/2009 17:48:16 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LOV_COUNTRYAREAGROUP]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[LOV_COUNTRYAREAGROUP](
	[LOV_AreaGroupID] [int] NULL,
	[LOV_CountryID] [int] NULL
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[LOV_COUNTRY]    Script Date: 01/27/2009 17:48:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LOV_COUNTRY]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[LOV_COUNTRY](
	[LOV_CountryID] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](255) NULL,
	[Name] [nvarchar](255) NULL,
	[StartYear] [int] NULL,
	[EndYear] [int] NULL,
 CONSTRAINT [LOV_CountryID] PRIMARY KEY CLUSTERED 
(
	[LOV_CountryID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[LOV_COORDINATESYSTEM]    Script Date: 01/27/2009 17:48:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LOV_COORDINATESYSTEM]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[LOV_COORDINATESYSTEM](
	[LOV_CoordinateSystemID] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](255) NULL,
	[Name] [nvarchar](255) NULL,
	[StartYear] [int] NULL,
	[EndYear] [int] NULL,
 CONSTRAINT [LOV_CoordinateSystemID] PRIMARY KEY CLUSTERED 
(
	[LOV_CoordinateSystemID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[LOV_CONFIDENTIALITY]    Script Date: 01/27/2009 17:48:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LOV_CONFIDENTIALITY]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[LOV_CONFIDENTIALITY](
	[LOV_ConfidentialityID] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](255) NULL,
	[Name] [nvarchar](255) NULL,
	[StartYear] [int] NULL,
	[EndYear] [int] NULL,
 CONSTRAINT [LOV_ConfidentialityID] PRIMARY KEY CLUSTERED 
(
	[LOV_ConfidentialityID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[LOV_AREAGROUP]    Script Date: 01/27/2009 17:48:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LOV_AREAGROUP]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[LOV_AREAGROUP](
	[LOV_AreaGroupID] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](255) NULL,
	[Name] [nvarchar](255) NULL,
 CONSTRAINT [LOV_AreaGroupID] PRIMARY KEY CLUSTERED 
(
	[LOV_AreaGroupID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[LOV_ANNEXIACTIVITY]    Script Date: 01/27/2009 17:48:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LOV_ANNEXIACTIVITY]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[LOV_ANNEXIACTIVITY](
	[LOV_AnnexiActivityID] [int] IDENTITY(1,1) NOT NULL,
	[Code] [nvarchar](255) NULL,
	[Name] [nvarchar](255) NULL,
	[StartYear] [int] NULL,
	[EndYear] [int] NULL,
	[ParentID] [int] NULL,
	[IPPCCode] [nvarchar](255) NULL,
 CONSTRAINT [LOV_AnnexiActivityID] PRIMARY KEY CLUSTERED 
(
	[LOV_AnnexiActivityID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[FACILITYREPORT]    Script Date: 01/27/2009 17:48:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FACILITYREPORT]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[FACILITYREPORT](
	[FacilityReportID] [int] IDENTITY(1,1) NOT NULL,
	[PollutantReleaseAndTransferReportID] [int] NULL,
	[FacilityID] [int] NULL,
	[NationalID] [nvarchar](255) NULL,
	[ParentCompanyName] [nvarchar](255) NULL,
	[FacilityName] [nvarchar](255) NULL,
	[AddressID] [int] NULL,
	[GeographicalCoordinate] [geometry] NULL,
	[LOV_RiverBasinDistrictID] [int] NULL,
	[LOV_NACEMainEconomicActivityID] [int] NULL,
	[MainEconomicActivityName] [nvarchar](255) NULL,
	[CompetentAuthorityPartyID] [int] NULL,
	[ProductionVolumeID] [int] NULL,
	[TotalIPPCInstallationQuantity] [int] NULL,
	[OperatingHours] [int] NULL,
	[TotalEmployeeQuantity] [int] NULL,
	[LOV_NUTSRegionID] [int] NULL,
	[WebsiteCommunication] [nvarchar](255) NULL,
	[PublicInformation] [nvarchar](255) NULL,
	[ConfidentialIndicator] [int] NULL,
	[LOV_ConfidentialityID] [int] NULL,
	[ProctectVoluntaryData] [int] NULL,
	[RemarkText] [varchar](255) NULL,
 CONSTRAINT [PK_FACILITYREPORT] PRIMARY KEY CLUSTERED 
(
	[FacilityReportID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[FACILITYLOG]    Script Date: 01/27/2009 17:48:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FACILITYLOG]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[FACILITYLOG](
	[FacilityLogID] [int] IDENTITY(1,1) NOT NULL,
	[FacilityID] [int] NULL,
	[NationalID] [nvarchar](255) NULL,
	[ReportingYear] [int] NULL,
	[Published] [datetime] NULL,
 CONSTRAINT [FacilityLogID] PRIMARY KEY CLUSTERED 
(
	[FacilityLogID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[FACILITY]    Script Date: 01/27/2009 17:48:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
/****** Object:  Table [dbo].[COMPETENTAUTHORITY]    Script Date: 01/27/2009 17:48:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[COMPETENTAUTHORITY]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[COMPETENTAUTHORITY](
	[CompetentAuthorityID] [int] IDENTITY(1,1) NOT NULL,
	[LOV_CountryID] [int] NULL,
	[ReportingYear] [int] NULL,
	[Name] [nvarchar](255) NULL,
	[AddressID] [int] NULL,
	[TelephoneCommunication] [nvarchar](50) NULL,
	[FaxCommunication] [nvarchar](50) NULL,
	[EmailCommunication] [nvarchar](255) NULL,
	[ContactPersonName] [nvarchar](255) NULL,
 CONSTRAINT [CompetentAuthorityID] PRIMARY KEY CLUSTERED 
(
	[CompetentAuthorityID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
/****** Object:  Table [dbo].[ADDRESS]    Script Date: 01/27/2009 17:48:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
/****** Object:  Table [dbo].[ACTIVITY]    Script Date: 01/27/2009 17:48:15 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ACTIVITY]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ACTIVITY](
	[ActivityID] [int] IDENTITY(1,1) NOT NULL,
	[FacilityReportID] [int] NULL,
	[RankingNumeric] [int] NULL,
	[LOV_AnnexIActivityID] [int] NULL,
	[MainActivityIndicator] [bit] NULL,
 CONSTRAINT [ActivityID] PRIMARY KEY CLUSTERED 
(
	[ActivityID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO
