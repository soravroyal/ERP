-- NUTS 1 ---------------------------------------------------------------------
DECLARE @COUNTRY INT
SELECT @COUNTRY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='BG'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'BG3', 'SEVERNA I IZTOCHNA BULGARIA', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'BG4', 'YUGOZAPADNA I YUZHNA TSENTRALNA BULGARIA', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'BGZ', 'EXTRA-REGIO', 2007, NULL, @COUNTRY
GO

-- NUTS 2 ---------------------------------------------------------------------
DECLARE @COUNTRY INT, @NUTSBG3 INT, @NUTSBG4 INT, @NUTSBGZ INT
SELECT @COUNTRY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='BG'
SELECT @NUTSBG3=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='BG3'
SELECT @NUTSBG4=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='BG4'
SELECT @NUTSBGZ=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='BGZ'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'BG31', 'Severozapaden', 2007, @NUTSBG3, @COUNTRY
  UNION ALL
 SELECT 'BG32', 'Severen tsentralen', 2007, @NUTSBG3, @COUNTRY
  UNION ALL
 SELECT 'BG33', 'Severoiztochen', 2007, @NUTSBG3, @COUNTRY
  UNION ALL
 SELECT 'BG34', 'Yugoiztochen', 2007, @NUTSBG3, @COUNTRY
  UNION ALL
 SELECT 'BG41', 'Yugozapaden', 2007, @NUTSBG4, @COUNTRY
  UNION ALL
 SELECT 'BG42', 'Yuzhen tsentralen', 2007, @NUTSBG4, @COUNTRY
  UNION ALL
 SELECT 'BGZZ', 'Extra-Regio', 2007, @NUTSBGZ, @COUNTRY
GO

-- NUTS 3 ---------------------------------------------------------------------
DECLARE @COUNTRY INT, @NUTS2 INT
SELECT @COUNTRY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='BG'
SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='BG31'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'BG311', 'Vidin', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'BG312', 'Montana', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'BG313', 'Vratsa', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'BG314', 'Pleven', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'BG315', 'Lovech', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='BG32'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'BG321', 'Veliko Tarnovo', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'BG322', 'Gabrovo', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'BG323', 'Ruse', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'BG324', 'Razgrad', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'BG325', 'Silistra', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='BG33'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'BG331', 'Varna', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'BG332', 'Dobrich', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'BG333', 'Shumen', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'BG334', 'Targovishte', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='BG34'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'BG341', 'Burgas', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'BG342', 'Sliven', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'BG343', 'Yambol', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'BG344', 'Stara Zagora', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='BG41'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'BG411', 'Sofia (stolitsa)', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'BG412', 'Sofia', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'BG413', 'Blagoevgrad', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'BG414', 'Pernik', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'BG415', 'Kyustendil', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='BG42'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'BG421', 'Plovdiv', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'BG422', 'Haskovo', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'BG423', 'Pazardzhik', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'BG424', 'Smolyan', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'BG425', 'Kardzhali', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='BGZZ'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'BGZZZ', 'Extra-Regio', 2007, @NUTS2, @COUNTRY

GO
