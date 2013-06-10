-- NUTS 1 ---------------------------------------------------------------------
DECLARE @COUNTRY INT
SELECT @COUNTRY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='FI'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'FI1', 'MANNER-SUOMI', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'FI2', 'ÅLAND', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'FIZ', 'EXTRA-REGIO', 2007, NULL, @COUNTRY
GO

-- NUTS 2 ---------------------------------------------------------------------
DECLARE @COUNTRY INT, @NUTSFI1 INT, @NUTSFI2 INT, @NUTSFIZ INT
SELECT @COUNTRY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='FI'
SELECT @NUTSFI1=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='FI1'
SELECT @NUTSFI2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='FI2'
SELECT @NUTSFIZ=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='FIZ'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'FI13', 'Itä-Suomi', 2007, @NUTSFI1, @COUNTRY
  UNION ALL
 SELECT 'FI18', 'Etelä-Suomi', 2007, @NUTSFI1, @COUNTRY
  UNION ALL
 SELECT 'FI19', 'Länsi-Suomi', 2007, @NUTSFI1, @COUNTRY
  UNION ALL
 SELECT 'FI1A', 'Pohjois-Suomi', 2007, @NUTSFI2, @COUNTRY
  UNION ALL
 SELECT 'FI20', 'Åland', 2007, @NUTSFI2, @COUNTRY
  UNION ALL
 SELECT 'FIZZ', 'Extra-Regio', 2007, @NUTSFIZ, @COUNTRY
GO

-- NUTS 3 ---------------------------------------------------------------------
DECLARE @COUNTRY INT, @NUTS2 INT
SELECT @COUNTRY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='FI'
SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='FI13'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'FI131', 'Etelä-Savo', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FI132', 'Pohjois-Savo', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FI133', 'Pohjois-Karjala', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FI134', 'Kainuu', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='FI18'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'FI181', 'Uusimaa', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FI182', 'Itä-Uusimaa', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FI183', 'Varsinais-Suomi', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FI184', 'Kanta-Häme', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FI185', 'Päijät-Häme', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FI186', 'Kymenlaakso', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FI187', 'Etelä-Karjala', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='FI19'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'FI193', 'Keski-Suomi', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FI194', 'Etelä-Pohjanmaa', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FI195', 'Pohjanmaa', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FI196', 'Satakunta', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FI197', 'Pirkanmaa', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='FI1A'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'FI1A1', 'Keski-Pohjanmaa', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FI1A2', 'Pohjois-Pohjanmaa', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FI1A3', 'Lappi', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='FI20'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'FI200', 'Åland', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='FIZZ'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'FIZZZ', 'Extra-Regio', 2007, @NUTS2, @COUNTRY

GO
