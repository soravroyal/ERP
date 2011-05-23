-- NUTS 1 ---------------------------------------------------------------------
DECLARE @COUNTRY INT
SELECT @COUNTRY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='SI'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'SI0', 'SLOVENIJA', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'SIZ', 'EXTRA-REGIO', 2007, NULL, @COUNTRY
GO

-- NUTS 2 ---------------------------------------------------------------------
DECLARE @COUNTRY INT, @NUTSSI0 INT, @NUTSSIZ INT
SELECT @COUNTRY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='SI'
SELECT @NUTSSI0=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='SI0'
SELECT @NUTSSIZ=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='SIZ'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'SI01', 'Vzhodna Slovenija', 2007, @NUTSSI0, @COUNTRY
  UNION ALL
 SELECT 'SI02', 'Zahodna Slovenija', 2007, @NUTSSI0, @COUNTRY
  UNION ALL
 SELECT 'SIZZ', 'Extra-Regio', 2007, @NUTSSIZ, @COUNTRY
GO

-- NUTS 3 ---------------------------------------------------------------------
DECLARE @COUNTRY INT, @NUTS2 INT
SELECT @COUNTRY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='SI'
SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='SI01'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'SI011', 'Pomurska', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'SI012', 'Podravska', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'SI013', 'Koroska', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'SI014', 'Savinjska', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'SI015', 'Zasavska', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'SI016', 'Spodnjeposavska', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'SI017', 'Jugovzhodna Slovenija', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'SI018', 'Notranjsko-kraska', 2007, @NUTS2, @COUNTRY

SELECT @COUNTRY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='SI'
SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='SI02'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'SI021', 'Osrednjeslovenska', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'SI022', 'Gorenjska', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'SI023', 'Goriska', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'SI024', 'Obalno-kraska', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='SIZZ'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'SIZZZ', 'Extra-Regio', 2007, @NUTS2, @COUNTRY

GO
