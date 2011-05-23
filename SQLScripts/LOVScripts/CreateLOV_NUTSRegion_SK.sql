-- NUTS 1 ---------------------------------------------------------------------
DECLARE @COUNTRY INT
SELECT @COUNTRY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='SK'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'SK0', 'SLOVENSKA REPUBLIKA', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'SKZ', 'EXTRA-REGIO', 2007, NULL, @COUNTRY
GO

-- NUTS 2 ---------------------------------------------------------------------
DECLARE @COUNTRY INT, @NUTSSK0 INT, @NUTSSKZ INT
SELECT @COUNTRY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='SK'
SELECT @NUTSSK0=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='SK0'
SELECT @NUTSSKZ=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='SKZ'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'SK01', 'Bratislavsky kraj', 2007, @NUTSSK0, @COUNTRY
  UNION ALL
 SELECT 'SK02', 'Zapadne Slovensko', 2007, @NUTSSK0, @COUNTRY
  UNION ALL
 SELECT 'SK03', 'Stredne Slovensko', 2007, @NUTSSK0, @COUNTRY
  UNION ALL
 SELECT 'SK04', 'Vychodne Slovensko', 2007, @NUTSSK0, @COUNTRY
  UNION ALL
 SELECT 'SKZZ', 'Extra-Regio', 2007, @NUTSSKZ, @COUNTRY
GO

-- NUTS 3 ---------------------------------------------------------------------
DECLARE @COUNTRY INT, @NUTS2 INT
SELECT @COUNTRY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='SK'
SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='SK01'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'SK010', 'Bratislavsky kraj', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='SK02'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'SK021', 'Trnavsky kraj', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'SK022', 'Trenciansky kraj', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'SK023', 'Nitriansky kraj', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='SK03'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'SK031', 'Zilinsky kraj', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'SK032', 'Banskobystricky kraj', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='SK04'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'SK041', 'Presovsky kraj', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'SK042', 'Kosicky kraj', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='SKZZ'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'SKZZZ', 'Extra-Regio', 2007, @NUTS2, @COUNTRY

GO
