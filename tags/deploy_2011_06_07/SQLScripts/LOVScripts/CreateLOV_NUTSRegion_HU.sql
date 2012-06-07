-- NUTS 1 ---------------------------------------------------------------------
DECLARE @COUNTRY INT
SELECT @COUNTRY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='HU'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'HU1', 'KOZEP-MAGYARORSZAG', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'HU2', 'DUNANTUL', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'HU3', 'ALFOLD ES ESZAK', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'HUZ', 'EXTRA-REGIO', 2007, NULL, @COUNTRY
GO

-- NUTS 2 ---------------------------------------------------------------------
DECLARE @COUNTRY INT, @NUTSHU1 INT, @NUTSHU2 INT, @NUTSHU3 INT, @NUTSHUZ INT
SELECT @COUNTRY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='HU'
SELECT @NUTSHU1=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='HU1'
SELECT @NUTSHU2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='HU2'
SELECT @NUTSHU3=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='HU3'
SELECT @NUTSHUZ=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='HUZ'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'HU10', 'Kozep-Magyarorszag', 2007, @NUTSHU1, @COUNTRY
  UNION ALL
 SELECT 'HU21', 'Kozep-Dunantul', 2007, @NUTSHU2, @COUNTRY
  UNION ALL
 SELECT 'HU22', 'Nyugat-Dunantul', 2007, @NUTSHU2, @COUNTRY
  UNION ALL
 SELECT 'HU23', 'Del-Dunantul', 2007, @NUTSHU2, @COUNTRY
  UNION ALL
 SELECT 'HU31', 'Eszak-Magyarorszag', 2007, @NUTSHU3, @COUNTRY
  UNION ALL
 SELECT 'HU32', 'Eszak-Alfold', 2007, @NUTSHU3, @COUNTRY
  UNION ALL
 SELECT 'HU33', 'Del-Alfold', 2007, @NUTSHU3, @COUNTRY
  UNION ALL
 SELECT 'HUZZ', 'Extra-Regio', 2007, @NUTSHUZ, @COUNTRY
GO

-- NUTS 3 ---------------------------------------------------------------------
DECLARE @COUNTRY INT, @NUTS2 INT
SELECT @COUNTRY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='HU'
SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='HU10'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'HU101', 'Budapest', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'HU102', 'Pest', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='HU21'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'HU211', 'Fejer', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'HU212', 'Komarom-Esztergom', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'HU213', 'Veszprem', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='HU22'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'HU221', 'Gyor-Moson-Sopron', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'HU222', 'Vas', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'HU223', 'Zala', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='HU23'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'HU231', 'Baranya', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'HU232', 'Somogy', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'HU233', 'Tolna', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='HU31'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'HU311', 'Borsod-Abauj-Zemplen', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'HU312', 'Heves', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'HU313', 'Nograd', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='HU32'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'HU321', 'Hajdu-Bihar', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'HU322', 'Jasz-Nagykun-Szolnok', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'HU323', 'Szabolcs-Szatmar-Bereg', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='HU33'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'HU331', 'Bacs-Kiskun', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'HU332', 'Bekes', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'HU333', 'Csongrad', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='HUZZ'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'HUZZZ', 'Extra-Regio', 2007, @NUTS2, @COUNTRY

GO
