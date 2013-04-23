SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET QUOTED_IDENTIFIER ON
GO
--CREATE TABLES


CREATE TABLE [dbo].[Activity](
	[FacilityReportID] [int] NOT NULL, 
	[RankingNumeric] bigint  NOT NULL , 
	[AnnexIActivityCode] nvarchar (255)  NOT NULL
	) ;

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Address_Competent]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Address_Competent]( 
	[AddressID] [int] IDENTITY(1,1) NOT NULL,
	[CompetentAuthorityPartyID] [int] NOT NULL,
	[StreetName] nvarchar (255) NULL , 
	[BuildingNumber] nvarchar (255)  NULL ,
	[CityName] nvarchar (255)  NULL , 
	[PostcodeCode] nvarchar (50)  NULL ,
	[CountryID] nvarchar (255)  NULL , 
CONSTRAINT [AddressID_Competent] PRIMARY KEY CLUSTERED 
(
[AddressID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Address_Facility]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Address_Facility]( 
	[AddressID] [int] IDENTITY(1,1) NOT NULL,
	[FacilityReportID] [int] NOT NULL,
	[StreetName] nvarchar (255)  NULL , 
	[BuildingNumber] nvarchar (255)  NULL ,
	[CityName] nvarchar (255)  NULL , 
	[PostcodeCode] nvarchar (50)  NULL ,
	[CountryID] nvarchar (255)  NULL , 
CONSTRAINT [AddressID_Facility] PRIMARY KEY CLUSTERED 
(
[AddressID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Address_Waste]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Address_Waste]( 
	[AddressID] [int] IDENTITY(1,1) NOT NULL,
	[WasteTransferID] [int] NOT NULL,
	[StreetName] nvarchar (255)  NULL , 
	[BuildingNumber] nvarchar (255)  NULL ,
	[CityName] nvarchar (255)  NULL , 
	[PostcodeCode] nvarchar (50)  NULL ,
	[CountryID] nvarchar (255)  NULL , 
CONSTRAINT [AddressID_Waste] PRIMARY KEY CLUSTERED 
(
[AddressID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Address_WasteSite]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Address_WasteSite]( 
	[AddressID] [int] IDENTITY(1,1) NOT NULL,
	[WasteTransferID] [int] NOT NULL,
	[StreetName] nvarchar (255)  NULL , 
	[BuildingNumber] nvarchar (255)  NULL ,
	[CityName] nvarchar (255)  NULL , 
	[PostcodeCode] nvarchar (50)  NULL ,
	[CountryID] nvarchar (255)  NULL , 
CONSTRAINT [AddressID_WasteSite] PRIMARY KEY CLUSTERED 
(
[AddressID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO



IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[COMPETENTAUTHORITYPARTY]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CompetentAuthorityParty](
	[CompetentAuthorityPartyID] [int] IDENTITY(1,1) NOT NULL,
        [PollutantReleaseAndTransferReportID] [int] NOT NULL, 
	[Name] nvarchar (255)  NOT NULL ,  
	[ContactPersonName] nvarchar (255)  NULL,
	--[AddressID] [int] NULL,
	[TelephoneCommunication] [varchar](50) NOT NULL,
	[FaxCommunication] [varchar](50) NOT NULL,
	[EmailCommunication] [varchar](255) NOT NULL,
CONSTRAINT [CompetentAuthorityPartyID] PRIMARY KEY CLUSTERED 
(
	[CompetentAuthorityPartyID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[FACILITYREPORT]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[FacilityReport](
	[FacilityReportID] [int] IDENTITY(1,1) NOT NULL,
	[PollutantReleaseAndTransferReportID] [int] NOT NULL,
	[NationalID] nvarchar (255)  NOT NULL , [ParentCompanyName] nvarchar (255)  NULL ,
	[FacilityName] nvarchar (255)  NULL , 
	[RiverBasinDistrictID] nvarchar (255)  NOT NULL ,
	[NACEMainEconomicActivityCode] nvarchar (255)  NOT NULL ,
	[MainEconomicActivityName] nvarchar (255)  NULL , 
	--[CompetentAuthorityPartyID] [int] NOT NULL, 
	[CompetentAuthorityName] nvarchar (255) NOT NULL, 
	[TotalIPPCInstallationQuantity] int  NULL , 
	[OperationHours] int  NULL ,  
	[TotalEmployeeQuantity] int  NULL ,
	[NutsRegionID] nvarchar (255)  NULL , 
	[PublicInformation] nvarchar (max)  NULL , 
	[ConfidentialIndicator] bit  NOT NULL , 
	[ConfidentialCode] nvarchar (255)  NULL ,
	[ProtectVoluntaryData] bit  NOT NULL , 
	[RemarkText] [varchar](max) NULL,
	[PrevNationalID] nvarchar (255)  NOT NULL , 
	[PrevReportingYear] bigint  NOT NULL,
	--[AddressID] [int] NULL, 
	[LongitudeMeasure] float  NULL , 
	[LatitudeMeasure] float  NULL,
	[ProductName] nvarchar (255)  NULL,
	[Quantity] float NULL,
        [QuantityUnitCode] nvarchar (255) NULL,
	[WebsiteCommunication] [varchar](255) NULL,  
CONSTRAINT [PK_FACILITYREPORT] PRIMARY KEY CLUSTERED 
(
	[FacilityReportID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO


CREATE TABLE [dbo].[MethodUsed_PollutantRelease](
	[PollutantReleaseID] [int] NULL,
	[MethodUsed] [varchar](255) NULL,
	[MethodDesignation] [varchar](255) NULL
	) ;

CREATE TABLE [dbo].[MethodUsed_PollutantTransfer](
	[PollutantTransferID] [int] NULL,
	[MethodUsed] [varchar](255) NULL,
	[MethodDesignation] [varchar](255) NULL
	) ;

CREATE TABLE [dbo].[MethodUsed_WasteTransfer](
	[WasteTransferID] [int] NULL,
	[MethodUsed] [varchar](255) NULL,
	[MethodDesignation] [varchar](255) NULL
	) ;

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[POLLUTANTRELEASE]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PollutantRelease](
	[PollutantReleaseID] [int] IDENTITY(1,1) NOT NULL,
	[FacilityReportID] [int] NOT NULL, 
	[MediumCode] nvarchar (255)  NOT NULL , 
	[PollutantCode] nvarchar (255)  NOT NULL , 
	[MethodBasisCode] nvarchar (255)  NOT NULL ,  
	[ConfidentialIndicator] bit  NULL , 
	[ConfidentialCode] nvarchar (255)  NULL , 
	[RemarkText] [varchar](max) NULL,
	--[MethodUsed] [varchar](255) NULL,
	--[MethodDesignation] [varchar](255) NULL,
	[TotalQuantity] float NOT NULL,
        [TotalQuantityUnitCode] nvarchar (255) NULL default 'KGM',
	[AccidentalQuantity] float NOT NULL,
	[AccidentalQuantityUnitCode] nvarchar (255) NULL default 'KGM',
CONSTRAINT [PK_POLLUTANTRELEASE] PRIMARY KEY CLUSTERED 
(
	[PollutantReleaseID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[POLLUTANTRELEASEANDTRANSFERREPORT]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PollutantReleaseAndTransferReport]( 
	[PollutantReleaseAndTransferReportID] [int] IDENTITY(1,1) NOT NULL,
	[ReportingYear] bigint  NOT NULL ,
	[CountryID] nvarchar (255)  NOT NULL ,
	[CoordinateSystemID] nvarchar (255)  NOT NULL , 
	[RemarkText] [varchar](max) NULL,
CONSTRAINT [PollutantReleaseAndTransferReportID] PRIMARY KEY CLUSTERED 
(
	[PollutantReleaseAndTransferReportID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[POLLUTANTTRANSFER]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PollutantTransfer](
	[PollutantTransferID] [int] IDENTITY(1,1) NOT NULL,
	[FacilityReportID] [int] NOT NULL, 
	[PollutantCode] nvarchar (255)  NOT NULL ,  
	[MethodBasisCode] nvarchar (255)  NOT NULL , 
	[ConfidentialIndicator] bit  NOT NULL , 
	[ConfidentialCode] nvarchar (255)  NULL , 
	[RemarkText] [varchar](max) NULL,
	--[MethodUsed] [varchar](255) NULL,
	--[MethodDesignation] [varchar](255) NULL,
	[Quantity] float NOT NULL,
	[QuantityUnitCode] nvarchar (255) NULL default 'KGM',
CONSTRAINT [PK_POLLUTANTTRANSFER] PRIMARY KEY CLUSTERED 
(
	[PollutantTransferID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO

IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[WASTETRANSFER]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[WasteTransfer](
	[WasteTransferID] [int] IDENTITY(1,1) NOT NULL,
	[FacilityReportID] [int] NOT NULL, 
	[WasteTypeCode] nvarchar (255)  NOT NULL , 
	[WasteTreatmentCode] nvarchar (255)  NULL ,  
	[MethodBasisCode] nvarchar (255)  NULL ,
	[ConfidentialIndicator] bit  NOT NULL , 
	[ConfidentialCode] nvarchar (255)  NULL , 
	[RemarkText] [varchar](max) NULL,
	[Quantity] float NULL,
	[QuantityUnitCode] nvarchar (255) NULL default 'KGM',
	--[MethodUsed] [varchar](255) NULL,
	--[MethodDesignation] [varchar](255) NULL,
	[WasteHandlerPartyName] nvarchar (255)  NULL,
	--[WasteHandlerPartyAddressID] [int]  NULL,
	--[WasteHandlerPartySiteAddressID] [int]  NULL,
CONSTRAINT [WasteTransferID] PRIMARY KEY CLUSTERED 
(
	[WasteTransferID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]
END
GO






