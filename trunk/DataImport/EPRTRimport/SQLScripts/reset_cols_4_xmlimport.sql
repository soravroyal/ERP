SET ANSI_NULLS ON
SET ANSI_PADDING ON
SET QUOTED_IDENTIFIER ON

if exists ( select * from EPRTRmaster.INFORMATION_SCHEMA.COLUMNS
	where TABLE_NAME='POLLUTANTRELEASEANDTRANSFERREPORT' and COLUMN_NAME='xmlReportID' )
alter table EPRTRmaster.dbo.POLLUTANTRELEASEANDTRANSFERREPORT drop column xmlReportID
alter table EPRTRmaster.dbo.POLLUTANTRELEASEANDTRANSFERREPORT add xmlReportID int ;

if exists ( select * from EPRTRmaster.INFORMATION_SCHEMA.COLUMNS
	where TABLE_NAME='ADDRESS' and COLUMN_NAME='xmlCompetentID' )
alter table EPRTRmaster.dbo.ADDRESS drop column xmlCompetentID
alter table EPRTRmaster.dbo.ADDRESS add xmlCompetentID int ;

if exists ( select * from EPRTRmaster.INFORMATION_SCHEMA.COLUMNS
	where TABLE_NAME='ADDRESS' and COLUMN_NAME='xmlFacilityID' )
alter table EPRTRmaster.dbo.ADDRESS drop column xmlFacilityID
alter table EPRTRmaster.dbo.ADDRESS add xmlFacilityID int ;

if exists ( select * from EPRTRmaster.INFORMATION_SCHEMA.COLUMNS
	where TABLE_NAME='ADDRESS' and COLUMN_NAME='xmlWasteID' )
alter table EPRTRmaster.dbo.ADDRESS drop column xmlWasteID
alter table EPRTRmaster.dbo.ADDRESS add xmlWasteID int ;

if exists ( select * from EPRTRmaster.INFORMATION_SCHEMA.COLUMNS
	where TABLE_NAME='ADDRESS' and COLUMN_NAME='xmlWasteSiteID' )
alter table EPRTRmaster.dbo.ADDRESS drop column xmlWasteSiteID
alter table EPRTRmaster.dbo.ADDRESS add xmlWasteSiteID int ;

if exists ( select * from EPRTRmaster.INFORMATION_SCHEMA.COLUMNS
	where TABLE_NAME='COMPETENTAUTHORITYPARTY' and COLUMN_NAME='xmlCompetentAuthorityPartyID' )
alter table EPRTRmaster.dbo.COMPETENTAUTHORITYPARTY drop column xmlCompetentAuthorityPartyID
alter table EPRTRmaster.dbo.COMPETENTAUTHORITYPARTY add xmlCompetentAuthorityPartyID int ;

if exists ( select * from EPRTRmaster.INFORMATION_SCHEMA.COLUMNS
	where TABLE_NAME='FACILITY' and COLUMN_NAME='xmlFacilityReportID' )
alter table EPRTRmaster.dbo.FACILITY drop column xmlFacilityReportID
alter table EPRTRmaster.dbo.FACILITY add xmlFacilityReportID int ;

if exists ( select * from EPRTRmaster.INFORMATION_SCHEMA.COLUMNS
	where TABLE_NAME='FACILITYREPORT' and COLUMN_NAME='xmlFacilityReportID' )
alter table EPRTRmaster.dbo.FACILITYREPORT drop column xmlFacilityReportID
alter table EPRTRmaster.dbo.FACILITYREPORT add xmlFacilityReportID int ;

if exists ( select * from EPRTRmaster.INFORMATION_SCHEMA.COLUMNS
	where TABLE_NAME='METHODLIST' and COLUMN_NAME='xmlPollutantReleaseID' )
alter table EPRTRmaster.dbo.METHODLIST drop column xmlPollutantReleaseID
alter table EPRTRmaster.dbo.METHODLIST add xmlPollutantReleaseID int ;

if exists ( select * from EPRTRmaster.INFORMATION_SCHEMA.COLUMNS
	where TABLE_NAME='METHODLIST' and COLUMN_NAME='xmlPollutantTransferID' )
alter table EPRTRmaster.dbo.METHODLIST drop column xmlPollutantTransferID
alter table EPRTRmaster.dbo.METHODLIST add xmlPollutantTransferID int ;

if exists ( select * from EPRTRmaster.INFORMATION_SCHEMA.COLUMNS
	where TABLE_NAME='METHODLIST' and COLUMN_NAME='xmlWasteTransferID' )
alter table EPRTRmaster.dbo.METHODLIST drop column xmlWasteTransferID
alter table EPRTRmaster.dbo.METHODLIST add xmlWasteTransferID int ;

if exists ( select * from EPRTRmaster.INFORMATION_SCHEMA.COLUMNS
	where TABLE_NAME='PRODUCTIONVOLUME' and COLUMN_NAME='xmlFacilityReportID' )
alter table EPRTRmaster.dbo.PRODUCTIONVOLUME drop column xmlFacilityReportID
alter table EPRTRmaster.dbo.PRODUCTIONVOLUME add xmlFacilityReportID int ;

if exists ( select * from EPRTRmaster.INFORMATION_SCHEMA.COLUMNS
	where TABLE_NAME='WASTEHANDLERPARTY' and COLUMN_NAME='xmlWasteTransferID' )
alter table EPRTRmaster.dbo.WASTEHANDLERPARTY drop column xmlWasteTransferID
alter table EPRTRmaster.dbo.WASTEHANDLERPARTY add xmlWasteTransferID int ;


--Add extra tables for tables that don't use autonumber
declare @maxIndex int,
@SQL NVARCHAR(MAX)
select @maxIndex = isnull(MAX(MethodListID),0)+1 from EPRTRmaster.dbo.MethodList

IF EXISTS (SELECT * FROM EPRTRmaster.sys.objects WHERE object_id = OBJECT_ID(N'[EPRTRmaster].[dbo].[XMLMETHODLIST]') AND type in (N'U'))
drop table [EPRTRmaster].[dbo].[XMLMETHODLIST]
SET @SQL = 'CREATE TABLE [EPRTRmaster].[dbo].[XMLMETHODLIST](
	[MethodListID] [int] IDENTITY(' +cast(@maxIndex as char)+ ',1) NOT NULL,
	[xmlPollutantReleaseID] [int] NULL,
	[xmlPollutantTransferID] [int] NULL,
	[xmlWasteTransferID] [int] NULL,
 CONSTRAINT [XMLMethodListID] PRIMARY KEY CLUSTERED 
(
	[MethodListID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]'
EXEC(@SQL)


select @maxIndex = isnull(MAX(FacilityID),0)+1 from EPRTRmaster.dbo.FACILITY

IF EXISTS (SELECT * FROM EPRTRmaster.sys.objects WHERE object_id = OBJECT_ID(N'[EPRTRmaster].[dbo].[XMLFACILITY]') AND type in (N'U'))
drop table [EPRTRmaster].[dbo].[XMLFACILITY]

SET @SQL = 'CREATE TABLE [EPRTRmaster].[dbo].[XMLFACILITY](
	[FacilityID] [int] IDENTITY(' +cast(@maxIndex as char)+ ',1) NOT NULL,
	[xmlFacilityReportID] [int] NULL,
 CONSTRAINT [XMLFacilityID] PRIMARY KEY CLUSTERED 
(
	[FacilityID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]'
EXEC(@SQL) ;

if object_id('EPRTRmaster.dbo.HAS_PREVIOUS_ID')is not null DROP TABLE EPRTRmaster.dbo.HAS_PREVIOUS_ID
create table EPRTRmaster.dbo.HAS_PREVIOUS_ID(
	FacilityReportID int, 
	FacilityID int 
) ;

