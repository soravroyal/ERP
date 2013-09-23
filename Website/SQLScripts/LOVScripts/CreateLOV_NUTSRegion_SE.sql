-- NUTS 1 ---------------------------------------------------------------------
DECLARE @COUNTRY INT
SELECT @COUNTRY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='SE'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'SE1', 'Östra Sverige', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'SE2', 'Södra Sverige', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'SE3', 'Norra Sverige', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'SEZ', 'EXTRA-REGIO', 2007, NULL, @COUNTRY
GO

-- NUTS 2 ---------------------------------------------------------------------
DECLARE @COUNTRY INT, @NUTSSE1 INT, @NUTSSE2 INT, @NUTSSE3 INT, @NUTSSEZ INT
SELECT @COUNTRY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='SE'
SELECT @NUTSSE1=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='SE1'
SELECT @NUTSSE2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='SE2'
SELECT @NUTSSE3=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='SE3'
SELECT @NUTSSEZ=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='SEZ'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'SE11', 'Stockholm', 2007, @NUTSSE1, @COUNTRY
  UNION ALL
 SELECT 'SE12', 'Östra Mellansverige', 2007, @NUTSSE1, @COUNTRY
  UNION ALL
 SELECT 'SE21', 'Småland med öarna', 2007, @NUTSSE2, @COUNTRY
  UNION ALL
 SELECT 'SE22', 'Sydsverige', 2007, @NUTSSE2, @COUNTRY
  UNION ALL
 SELECT 'SE23', 'Västsverige', 2007, @NUTSSE2, @COUNTRY
  UNION ALL
 SELECT 'SE31', 'Norra Mellansverige', 2007, @NUTSSE3, @COUNTRY
  UNION ALL
 SELECT 'SE32', 'Mellersta Norrland', 2007, @NUTSSE3, @COUNTRY
  UNION ALL
 SELECT 'SE33', 'Övre Norrland', 2007, @NUTSSE3, @COUNTRY
  UNION ALL
 SELECT 'SEZZ', 'Extra-Regio', 2007, @NUTSSEZ, @COUNTRY
GO

-- NUTS 3 ---------------------------------------------------------------------
DECLARE @COUNTRY INT, @NUTS2 INT
SELECT @COUNTRY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='SE'
SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='SE11'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'SE110', 'Stockholms län', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='SE12'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'SE121', 'Uppsala län', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'SE122', 'Södermanlands län', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'SE123', 'Östergötlands län', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'SE124', 'Örebro län', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'SE125', 'Västmanlands län', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='SE21'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'SE211', 'Jönköpings län', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'SE212', 'Kronobergs län', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'SE213', 'Kalmar län', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'SE214', 'Gotlands län', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='SE22'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'SE221', 'Blekinge län', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'SE224', 'Skåne län', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='SE23'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'SE231', 'Hallands län', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'SE232', 'Västra Götalands län', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='SE31'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'SE311', 'Värmlands län', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'SE312', 'Dalarnas län', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'SE313', 'Gävleborgs län', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='SE32'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'SE321', 'Västernorrlands län', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'SE322', 'Jämtlands län', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='SE33'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'SE331', 'Västerbottens län', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'SE332', 'Norrbottens län', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='SEZZ'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'SEZZZ', 'Extra-Regio', 2007, @NUTS2, @COUNTRY

GO
