-- NUTS 1 ---------------------------------------------------------------------
DECLARE @COUNTRY INT
SELECT @COUNTRY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='NL'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'NL1', 'NOORD-NEDERLAND', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'NL2', 'OOST-NEDERLAND', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'NL3', 'WEST-NEDERLAND', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'NL4', 'ZUID-NEDERLAND', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'NLZ', 'EXTRA-REGIO', 2007, NULL, @COUNTRY
GO

-- NUTS 2 ---------------------------------------------------------------------
DECLARE @COUNTRY INT, @NUTSNL1 INT, @NUTSNL2 INT, @NUTSNL3 INT, @NUTSNL4 INT, @NUTSNLZ INT
SELECT @COUNTRY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='NL'
SELECT @NUTSNL1=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='NL1'
SELECT @NUTSNL2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='NL2'
SELECT @NUTSNL3=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='NL3'
SELECT @NUTSNL4=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='NL4'
SELECT @NUTSNLZ=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='NLZ'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'NL11', 'Groningen', 2007, @NUTSNL1, @COUNTRY
  UNION ALL
 SELECT 'NL12', 'Friesland (NL)', 2007, @NUTSNL1, @COUNTRY
  UNION ALL
 SELECT 'NL13', 'Drenthe', 2007, @NUTSNL1, @COUNTRY
  UNION ALL
 SELECT 'NL21', 'Overijssel', 2007, @NUTSNL2, @COUNTRY
  UNION ALL
 SELECT 'NL22', 'Gelderland', 2007, @NUTSNL2, @COUNTRY
  UNION ALL
 SELECT 'NL23', 'Flevoland', 2007, @NUTSNL2, @COUNTRY
  UNION ALL
 SELECT 'NL31', 'Utrecht', 2007, @NUTSNL3, @COUNTRY
  UNION ALL
 SELECT 'NL32', 'Noord-Holland', 2007, @NUTSNL3, @COUNTRY
  UNION ALL
 SELECT 'NL33', 'Zuid-Holland', 2007, @NUTSNL3, @COUNTRY
  UNION ALL
 SELECT 'NL34', 'Zeeland', 2007, @NUTSNL3, @COUNTRY
  UNION ALL
 SELECT 'NL41', 'Noord-Brabant', 2007, @NUTSNL4, @COUNTRY
  UNION ALL
 SELECT 'NL42', 'Limburg (NL)', 2007, @NUTSNL4, @COUNTRY
  UNION ALL
 SELECT 'NLZZ', 'Extra-Regio', 2007, @NUTSNLZ, @COUNTRY
GO

-- NUTS 3 ---------------------------------------------------------------------
DECLARE @COUNTRY INT, @NUTS2 INT
SELECT @COUNTRY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='NL'
SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='NL11'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'NL111', 'Oost-Groningen', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'NL112', 'Delfzijl en omgeving', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'NL113', 'Overig Groningen', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='NL12'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'NL121', 'Noord-Friesland', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'NL122', 'Zuidwest-Friesland', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'NL123', 'Zuidoost-Friesland', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='NL13'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'NL131', 'Noord-Drenthe', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'NL132', 'Zuidoost-Drenthe', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'NL133', 'Zuidwest-Drenthe', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='NL21'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'NL211', 'Noord-Overijssel', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'NL212', 'Zuidwest-Overijssel', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'NL213', 'Twente', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='NL22'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'NL221', 'Veluwe', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'NL224', 'Zuidwest-Gelderland', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'NL225', 'Achterhoek', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'NL226', 'Arnhem/Nijmegen', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='NL23'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'NL230', 'Flevoland', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='NL31'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'NL310', 'Utrecht', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='NL32'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'NL321', 'Kop van Noord-Holland', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'NL322', 'Alkmaar en omgeving', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'NL323', 'IJmond', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'NL324', 'Agglomeratie Haarlem', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'NL325', 'Zaanstreek', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'NL326', 'Groot-Amsterdam', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'NL327', 'Het Gooi en Vechtstreek', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='NL33'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'NL331', 'Agglomeratie Leiden en Bollenstreek', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'NL332', 'Agglomeratie ''s-Gravenhage', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'NL333', 'Delft en Westland', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'NL334', 'Oost-Zuid-Holland', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'NL335', 'Groot-Rijnmond', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'NL336', 'Zuidoost-Zuid-Holland', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='NL34'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'NL341', 'Zeeuwsch-Vlaanderen', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'NL342', 'Overig Zeeland', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='NL41'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'NL411', 'West-Noord-Brabant', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'NL412', 'Midden-Noord-Brabant', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'NL413', 'Noordoost-Noord-Brabant', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'NL414', 'Zuidoost-Noord-Brabant', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='NL42'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'NL421', 'Noord-Limburg', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'NL422', 'Midden-Limburg', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'NL423', 'Zuid-Limburg', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='NLZZ'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'NLZZZ', 'Extra-Regio', 2007, @NUTS2, @COUNTRY

GO
