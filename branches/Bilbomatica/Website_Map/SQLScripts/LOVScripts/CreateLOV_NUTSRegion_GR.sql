-- NUTS 1 ---------------------------------------------------------------------
DECLARE @COUNTRY INT
SELECT @COUNTRY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='GR'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'GR1', 'VOREIA ELLADA', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'GR2', 'KENTRIKI ELLADA', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'GR3', 'ATTIKI', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'GR4', 'NISIA AIGAIOU, KRITI', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'GRZ', 'EXTRA-REGIO', 2007, NULL, @COUNTRY
GO

-- NUTS 2 ---------------------------------------------------------------------
DECLARE @COUNTRY INT, @NUTSGR1 INT, @NUTSGR2 INT, @NUTSGR3 INT, @NUTSGR4 INT, @NUTSGRZ INT
SELECT @COUNTRY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='GR'
SELECT @NUTSGR1=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='GR1'
SELECT @NUTSGR2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='GR2'
SELECT @NUTSGR3=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='GR3'
SELECT @NUTSGR4=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='GR4'
SELECT @NUTSGRZ=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='GRZ'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'GR11', 'Anatoliki Makedonia, Thraki', 2007, @NUTSGR1, @COUNTRY
  UNION ALL
 SELECT 'GR12', 'Kentriki Makedonia', 2007, @NUTSGR1, @COUNTRY
  UNION ALL
 SELECT 'GR13', 'Dytiki Makedonia', 2007, @NUTSGR1, @COUNTRY
  UNION ALL
 SELECT 'GR14', 'Thessalia', 2007, @NUTSGR1, @COUNTRY
  UNION ALL
 SELECT 'GR21', 'Ipeiros', 2007, @NUTSGR2, @COUNTRY
  UNION ALL
 SELECT 'GR22', 'Ionia Nisia', 2007, @NUTSGR2, @COUNTRY
  UNION ALL
 SELECT 'GR23', 'Dytiki Ellada', 2007, @NUTSGR2, @COUNTRY
  UNION ALL
 SELECT 'GR24', 'Sterea Ellada', 2007, @NUTSGR2, @COUNTRY
  UNION ALL
 SELECT 'GR25', 'Peloponnisos', 2007, @NUTSGR2, @COUNTRY
  UNION ALL
 SELECT 'GR30', 'Attiki', 2007, @NUTSGR3, @COUNTRY
  UNION ALL
 SELECT 'GR41', 'Voreio Aigaio', 2007, @NUTSGR4, @COUNTRY
  UNION ALL
 SELECT 'GR42', 'Notio Aigaio', 2007, @NUTSGR4, @COUNTRY
  UNION ALL
 SELECT 'GR43', 'Kriti', 2007, @NUTSGR4, @COUNTRY
  UNION ALL
 SELECT 'GRZZ', 'Extra-Regio', 2007, @NUTSGRZ, @COUNTRY
GO

-- NUTS 3 ---------------------------------------------------------------------
DECLARE @COUNTRY INT, @NUTS2 INT
SELECT @COUNTRY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='GR'
SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='GR11'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'GR111', 'Evros', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'GR112', 'Xanthi', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'GR113', 'Rodopi', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'GR114', 'Drama', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'GR115', 'Kavala', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='GR12'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'GR121', 'Imathia', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'GR122', 'Thessaloniki', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'GR123', 'Kilkis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'GR124', 'Pella', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'GR125', 'Pieria', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'GR126', 'Serres', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'GR127', 'Chalkidiki', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='GR13'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'GR131', 'Grevena', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'GR132', 'Kastoria', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'GR133', 'Kozani', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'GR134', 'Florina', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='GR14'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'GR141', 'Karditsa', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'GR142', 'Larisa', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'GR143', 'Magnisia', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'GR144', 'Trikala', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='GR21'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'GR211', 'Arta', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'GR212', 'Thesprotia', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'GR213', 'Ioannina', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'GR214', 'Preveza', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='GR22'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'GR221', 'Zakynthos', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'GR222', 'Kerkyra', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'GR223', 'Kefallinia', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'GR224', 'Lefkada', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='GR23'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'GR231', 'Aitoloakarnania', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'GR232', 'Achaia', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'GR233', 'Ileia', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='GR24'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'GR241', 'Voiotia', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'GR242', 'Evvoia', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'GR243', 'Evrytania', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'GR244', 'Fthiotida', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'GR245', 'Fokida', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='GR25'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'GR251', 'Argolida', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'GR252', 'Arkadia', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'GR253', 'Korinthia', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'GR254', 'Lakonia', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'GR255', 'Messinia', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='GR30'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'GR300', 'Attiki', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='GR41'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'GR411', 'Lesvos', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'GR412', 'Samos', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'GR413', 'Chios', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='GR42'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'GR421', 'Dodekanisos', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'GR422', 'Kyklades', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='GR43'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'GR431', 'Irakleio', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'GR432', 'Lasithi', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'GR433', 'Rethymni', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'GR434', 'Chania', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='GRZZ'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'GRZZZ', 'Extra-Regio', 2007, @NUTS2, @COUNTRY

GO
