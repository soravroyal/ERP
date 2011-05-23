-- NUTS 1 ---------------------------------------------------------------------
DECLARE @COUNTRY INT
SELECT @COUNTRY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='CH'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'CH0', 'SCHWEIZ/SUISSE/SVIZZERA', 2007, NULL, @COUNTRY
GO

-- NUTS 2 ---------------------------------------------------------------------
DECLARE @COUNTRY INT, @NUTSCH0 INT, @NUTSCHZ INT
SELECT @COUNTRY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='CH'
SELECT @NUTSCH0=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='CH0'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'CH01', 'Région lémanique', 2007, @NUTSCH0, @COUNTRY
  UNION ALL
 SELECT 'CH02', 'Espace Mittelland', 2007, @NUTSCH0, @COUNTRY
  UNION ALL
 SELECT 'CH03', 'Nordwestschweiz', 2007, @NUTSCH0, @COUNTRY
  UNION ALL
 SELECT 'CH04', 'Zürich', 2007, @NUTSCH0, @COUNTRY
  UNION ALL
 SELECT 'CH05', 'Ostschweiz', 2007, @NUTSCH0, @COUNTRY
  UNION ALL
 SELECT 'CH06', 'Zentralschweiz', 2007, @NUTSCH0, @COUNTRY
  UNION ALL
 SELECT 'CH07', 'Ticino', 2007, @NUTSCH0, @COUNTRY
GO

-- NUTS 3 ---------------------------------------------------------------------
DECLARE @COUNTRY INT, @NUTS2 INT
SELECT @COUNTRY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='CH'
SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='CH01'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'CH011', 'Vaud', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'CH012', 'Valais', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'CH013', 'Genève', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='CH02'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'CH021', 'Bern', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'CH022', 'Freiburg', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'CH023', 'Solothurn', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'CH024', 'Neuchâtel', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'CH025', 'Jura', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='CH03'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'CH031', 'Basel-Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'CH032', 'Basel-Landschaft', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'CH033', 'Aargau', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='CH04'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'CH040', 'Zürich', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='CH05'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'CH051', 'Glarus', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'CH052', 'Schaffhausen', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'CH053', 'Appenzell Ausserrhoden', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'CH054', 'Appenzell Innerrhoden', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'CH055', 'St. Gallen', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'CH056', 'Graubünden', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'CH057', 'Thurgau', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='CH06'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'CH061', 'Luzern', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'CH062', 'Uri', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'CH063', 'Schwyz', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'CH064', 'Obwalden', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'CH065', 'Nidwalden', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'CH066', 'Zug', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='CH07'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'CH070', 'Ticino', 2007, @NUTS2, @COUNTRY

GO
