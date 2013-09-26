-- NUTS 1 ---------------------------------------------------------------------
DECLARE @COUNTRY INT
SELECT @COUNTRY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='NO'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'NO0', 'NORGE', 2007, NULL, @COUNTRY
GO

-- NUTS 2 ---------------------------------------------------------------------
DECLARE @COUNTRY INT, @NUTSNO0 INT, @NUTSNOZ INT
SELECT @COUNTRY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='NO'
SELECT @NUTSNO0=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='NO0'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'NO01', 'Oslo og Akershus', 2007, @NUTSNO0, @COUNTRY
  UNION ALL
 SELECT 'NO02', 'Hedmark og Oppland', 2007, @NUTSNO0, @COUNTRY
  UNION ALL
 SELECT 'NO03', 'Sør-Østlandet', 2007, @NUTSNO0, @COUNTRY
  UNION ALL
 SELECT 'NO04', 'Agder og Rogaland', 2007, @NUTSNO0, @COUNTRY
  UNION ALL
 SELECT 'NO05', 'Vestlandet', 2007, @NUTSNO0, @COUNTRY
  UNION ALL
 SELECT 'NO06', 'Trøndelag', 2007, @NUTSNO0, @COUNTRY
  UNION ALL
 SELECT 'NO07', 'Nord-Norge', 2007, @NUTSNO0, @COUNTRY
GO

-- NUTS 3 ---------------------------------------------------------------------
DECLARE @COUNTRY INT, @NUTS2 INT
SELECT @COUNTRY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='NO'
SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='NO01'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'NO011', 'Oslo', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'NO012', 'Akershus', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='NO02'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'NO021', 'Hedmark', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'NO022', 'Oppland', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='NO03'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'NO031', 'Østfold', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'NO032', 'Buskerud', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'NO033', 'Vestfold', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'NO034', 'Telemark', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='NO04'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'NO041', 'Aust-Agder', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'NO042', 'Vest-Agder', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'NO043', 'Rogaland', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='NO05'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'NO051', 'Hordaland', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'NO052', 'Sogn og Fjordane', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'NO053', 'Møre og Romsdal', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='NO06'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'NO061', 'Sør-Trøndelag', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'NO062', 'Nord-Trøndelag', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='NO07'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'NO071', 'Nordland', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'NO072', 'Troms', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'NO073', 'Finnmark', 2007, @NUTS2, @COUNTRY

GO
