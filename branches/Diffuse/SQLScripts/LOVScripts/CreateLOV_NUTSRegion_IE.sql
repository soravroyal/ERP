-- NUTS 1 ---------------------------------------------------------------------
DECLARE @COUNTRY INT
SELECT @COUNTRY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='IE'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'IE0', 'IRELAND', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'IEZ', 'EXTRA-REGIO', 2007, NULL, @COUNTRY
GO

-- NUTS 2 ---------------------------------------------------------------------
DECLARE @COUNTRY INT, @NUTSIE0 INT, @NUTSIEZ INT
SELECT @COUNTRY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='IE'
SELECT @NUTSIE0=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='IE0'
SELECT @NUTSIEZ=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='IEZ'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'IE01', 'Border, Midland and Western', 2007, @NUTSIE0, @COUNTRY
  UNION ALL
 SELECT 'IE02', 'Southern and Eastern', 2007, @NUTSIE0, @COUNTRY
  UNION ALL
 SELECT 'IEZZ', 'Extra-Regio', 2007, @NUTSIEZ, @COUNTRY
GO

-- NUTS 3 ---------------------------------------------------------------------
DECLARE @COUNTRY INT, @NUTS2 INT
SELECT @COUNTRY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='IE'
SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='IE01'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'IE011', 'Border', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'IE012', 'Midland', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'IE013', 'West', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='IE02'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'IE021', 'Dublin', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'IE022', 'Mid-East', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'IE023', 'Mid-West', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'IE024', 'South-East (IRL)', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'IE025', 'South-West (IRL)', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='IEZZ'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'IEZZZ', 'Extra-Regio', 2007, @NUTS2, @COUNTRY

GO
