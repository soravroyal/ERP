-- NUTS 1 ---------------------------------------------------------------------
DECLARE @COUNTRY INT
SELECT @COUNTRY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='LV'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'LV0', 'LATVIJA', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'LVZ', 'EXTRA-REGIO', 2007, NULL, @COUNTRY
GO

-- NUTS 2 ---------------------------------------------------------------------
DECLARE @COUNTRY INT, @NUTSLV0 INT, @NUTSLVZ INT
SELECT @COUNTRY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='LV'
SELECT @NUTSLV0=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='LV0'
SELECT @NUTSLVZ=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='LVZ'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'LV00', 'Latvija', 2007, @NUTSLV0, @COUNTRY
  UNION ALL
 SELECT 'LVZZ', 'Extra-Regio', 2007, @NUTSLVZ, @COUNTRY
GO

-- NUTS 3 ---------------------------------------------------------------------
DECLARE @COUNTRY INT, @NUTS2 INT
SELECT @COUNTRY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='LV'
SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='LV00'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'LV003', 'Kurzeme', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'LV005', 'Latgale', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'LV006', 'Riga', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'LV007', 'Pieriga', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'LV008', 'Vidzeme', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'LV009', 'Zemgale', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='LVZZ'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'LVZZZ', 'Extra-Regio', 2007, @NUTS2, @COUNTRY

GO
