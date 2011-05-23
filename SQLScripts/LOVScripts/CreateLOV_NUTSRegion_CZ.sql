-- NUTS 1 ---------------------------------------------------------------------
DECLARE @COUNTRY INT
SELECT @COUNTRY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='CZ'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'CZ0', 'CESKA REPUBLIKA', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'CZZ', 'EXTRA-REGIO', 2007, NULL, @COUNTRY
GO

-- NUTS 2 ---------------------------------------------------------------------
DECLARE @COUNTRY INT, @NUTSCZ0 INT, @NUTSCZZ INT
SELECT @COUNTRY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='CZ'
SELECT @NUTSCZ0=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='CZ0'
SELECT @NUTSCZZ=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='CZZ'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'CZ01', 'Praha', 2007, @NUTSCZ0, @COUNTRY
  UNION ALL
 SELECT 'CZ02', 'Stredni Cechy', 2007, @NUTSCZ0, @COUNTRY
  UNION ALL
 SELECT 'CZ03', 'Jihozapad', 2007, @NUTSCZ0, @COUNTRY
  UNION ALL
 SELECT 'CZ04', 'Severozapad', 2007, @NUTSCZ0, @COUNTRY
  UNION ALL
 SELECT 'CZ05', 'Severovychod', 2007, @NUTSCZ0, @COUNTRY
  UNION ALL
 SELECT 'CZ06', 'Jihovychod', 2007, @NUTSCZ0, @COUNTRY
  UNION ALL
 SELECT 'CZ07', 'Stredni Morava', 2007, @NUTSCZ0, @COUNTRY
  UNION ALL
 SELECT 'CZ08', 'Moravskoslezsko', 2007, @NUTSCZ0, @COUNTRY
  UNION ALL
 SELECT 'CZZZ', 'Extra-Regio', 2007, @NUTSCZZ, @COUNTRY
GO

-- NUTS 3 ---------------------------------------------------------------------
DECLARE @COUNTRY INT, @NUTS2 INT
SELECT @COUNTRY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='CZ'
SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='CZ01'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'CZ010', 'Hlavni mesto Praha', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='CZ02'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'CZ020', 'Stredocesky kraj', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='CZ03'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'CZ031', 'Jihocesky kraj', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'CZ032', 'Plzensky kraj', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='CZ04'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'CZ041', 'Karlovarsky kraj', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'CZ042', 'Ustecky kraj', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='CZ05'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'CZ051', 'Liberecky kraj', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'CZ052', 'Kralovehradecky kraj', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'CZ053', 'Pardubicky kraj', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='CZ06'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'CZ063', 'Vysocina', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'CZ064', 'Jihomoravsky kraj', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='CZ07'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'CZ071', 'Olomoucky kraj', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'CZ072', 'Zlinsky kraj', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='CZ08'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'CZ080', 'Moravskoslezsky kraj', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='CZZZ'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'CZZZZ', 'Extra-Regio', 2007, @NUTS2, @COUNTRY

GO
