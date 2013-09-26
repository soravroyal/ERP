-- NUTS 1 ---------------------------------------------------------------------
DECLARE @COUNTRY INT
SELECT @COUNTRY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='LT'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'LT0', 'LIETUVA', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'LTZ', 'EXTRA-REGIO', 2007, NULL, @COUNTRY
GO

-- NUTS 2 ---------------------------------------------------------------------
DECLARE @COUNTRY INT, @NUTSLT0 INT, @NUTSLTZ INT
SELECT @COUNTRY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='LT'
SELECT @NUTSLT0=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='LT0'
SELECT @NUTSLTZ=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='LTZ'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'LT00', 'Lietuva', 2007, @NUTSLT0, @COUNTRY
  UNION ALL
 SELECT 'LTZZ', 'Extra-Regio', 2007, @NUTSLTZ, @COUNTRY
GO

-- NUTS 3 ---------------------------------------------------------------------
DECLARE @COUNTRY INT, @NUTS2 INT
SELECT @COUNTRY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='LT'
SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='LT00'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'LT001', 'Alytaus apskritis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'LT002', 'Kauno apskritis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'LT003', 'Klaipedos apskritis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'LT004', 'Marijampoles apskritis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'LT005', 'Panevezio apskritis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'LT006', 'Siauliu apskritis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'LT007', 'Taurages apskritis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'LT008', 'Telsiu apskritis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'LT009', 'Utenos apskritis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'LT00A', 'Vilniaus apskritis', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='LTZZ'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'LTZZZ', 'Extra-Regio', 2007, @NUTS2, @COUNTRY

GO
