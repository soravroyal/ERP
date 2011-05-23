-- NUTS 1 ---------------------------------------------------------------------
DECLARE @COUNTRY INT
SELECT @COUNTRY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='AT'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'AT1', 'OSTÖSTERREICH', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'AT2', 'SÜDÖSTERREICH', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'AT3', 'WESTÖSTERREICH', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'ATZ', 'EXTRA-REGIO', 2007, NULL, @COUNTRY
GO

-- NUTS 2 ---------------------------------------------------------------------
DECLARE @COUNTRY INT, @NUTSAT1 INT, @NUTSAT2 INT, @NUTSAT3 INT, @NUTSATZ INT
SELECT @COUNTRY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='AT'
SELECT @NUTSAT1=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='AT1'
SELECT @NUTSAT2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='AT2'
SELECT @NUTSAT3=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='AT3'
SELECT @NUTSATZ=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='ATZ'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'AT11', 'Burgenland (A)', 2007, @NUTSAT1, @COUNTRY
  UNION ALL
 SELECT 'AT12', 'Niederösterreich', 2007, @NUTSAT1, @COUNTRY
  UNION ALL
 SELECT 'AT13', 'Wien', 2007, @NUTSAT1, @COUNTRY
  UNION ALL
 SELECT 'AT21', 'Kärnten', 2007, @NUTSAT2, @COUNTRY
  UNION ALL
 SELECT 'AT22', 'Steiermark', 2007, @NUTSAT2, @COUNTRY
  UNION ALL
 SELECT 'AT31', 'Oberösterreich', 2007, @NUTSAT3, @COUNTRY
  UNION ALL
 SELECT 'AT32', 'Salzburg', 2007, @NUTSAT3, @COUNTRY
  UNION ALL
 SELECT 'AT33', 'Tirol', 2007, @NUTSAT3, @COUNTRY
  UNION ALL
 SELECT 'AT34', 'Vorarlberg', 2007, @NUTSAT3, @COUNTRY
  UNION ALL
 SELECT 'ATZZ', 'Extra-Regio', 2007, @NUTSATZ, @COUNTRY
GO

-- NUTS 3 ---------------------------------------------------------------------
DECLARE @COUNTRY INT, @NUTS2 INT
SELECT @COUNTRY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='AT'
SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='AT11'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'AT111', 'Mittelburgenland', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'AT112', 'Nordburgenland', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'AT113', 'Südburgenland', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='AT12'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'AT121', 'Mostviertel-Eisenwurzen', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'AT122', 'Niederösterreich-Süd', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'AT123', 'Sankt Pölten', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'AT124', 'Waldviertel', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'AT125', 'Weinviertel', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'AT126', 'Wiener Umland/Nordteil', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'AT127', 'Wiener Umland/Südteil', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='AT13'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'AT130', 'Wien', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='AT21'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'AT211', 'Klagenfurt-Villach', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'AT212', 'Oberkärnten', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'AT213', 'Unterkärnten', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='AT22'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'AT221', 'Graz', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'AT222', 'Liezen', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'AT223', 'Östliche Obersteiermark', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'AT224', 'Oststeiermark', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'AT225', 'West- und Südsteiermark', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'AT226', 'Westliche Obersteiermark', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='AT31'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'AT311', 'Innviertel', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'AT312', 'Linz-Wels', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'AT313', 'Mühlviertel', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'AT314', 'Steyr-Kirchdorf', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'AT315', 'Traunviertel', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='AT32'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'AT321', 'Lungau', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'AT322', 'Pinzgau-Pongau', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'AT323', 'Salzburg und Umgebung', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='AT33'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'AT331', 'Außerfern', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'AT332', 'Innsbruck', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'AT333', 'Osttirol', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'AT334', 'Tiroler Oberland', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'AT335', 'Tiroler Unterland', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='AT34'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'AT341', 'Bludenz-Bregenzer Wald', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'AT342', 'Rheintal-Bodenseegebiet', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='ATZZ'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'ATZZZ', 'Extra-Regio', 2007, @NUTS2, @COUNTRY

GO
