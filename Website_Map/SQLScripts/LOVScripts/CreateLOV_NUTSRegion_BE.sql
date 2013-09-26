-- NUTS 1 ---------------------------------------------------------------------
DECLARE @COUNTRY INT
SELECT @COUNTRY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='BE'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'BE1', 'RÉGION DE BRUXELLES-CAPITALE / BRUSSELS HOOFDSTEDELIJK GEWEST', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'BE2', 'VLAAMS GEWEST', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'BE3', 'RÉGION WALLONNE', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'BEZ', 'EXTRA-REGIO', 2007, NULL, @COUNTRY
GO

-- NUTS 2 ---------------------------------------------------------------------
DECLARE @COUNTRY INT, @NUTSBE1 INT, @NUTSBE2 INT, @NUTSBE3 INT, @NUTSBEZ INT
SELECT @COUNTRY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='BE'
SELECT @NUTSBE1=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='BE1'
SELECT @NUTSBE2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='BE2'
SELECT @NUTSBE3=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='BE3'
SELECT @NUTSBEZ=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='BEZ'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'BE10', 'Région de Bruxelles-Capitale / Brussels Hoofdstedelijk Gewest', 2007, @NUTSBE1, @COUNTRY
  UNION ALL
 SELECT 'BE21', 'Prov. Antwerpen', 2007, @NUTSBE2, @COUNTRY
  UNION ALL
 SELECT 'BE22', 'Prov. Limburg (B)', 2007, @NUTSBE2, @COUNTRY
  UNION ALL
 SELECT 'BE23', 'Prov. Oost-Vlaanderen', 2007, @NUTSBE2, @COUNTRY
  UNION ALL
 SELECT 'BE24', 'Prov. Vlaams-Brabant', 2007, @NUTSBE2, @COUNTRY
  UNION ALL
 SELECT 'BE25', 'Prov. West-Vlaanderen', 2007, @NUTSBE2, @COUNTRY
  UNION ALL
 SELECT 'BE31', 'Prov. Brabant Wallon', 2007, @NUTSBE3, @COUNTRY
  UNION ALL
 SELECT 'BE32', 'Prov. Hainaut', 2007, @NUTSBE3, @COUNTRY
  UNION ALL
 SELECT 'BE33', 'Prov. Liège', 2007, @NUTSBE3, @COUNTRY
  UNION ALL
 SELECT 'BE34', 'Prov. Luxembourg (B)', 2007, @NUTSBE3, @COUNTRY
  UNION ALL
 SELECT 'BE35', 'Prov. Namur', 2007, @NUTSBE3, @COUNTRY
  UNION ALL
 SELECT 'BEZZ', 'Extra-Regio', 2007, @NUTSBEZ, @COUNTRY
GO

-- NUTS 3 ---------------------------------------------------------------------
DECLARE @COUNTRY INT, @NUTS2 INT
SELECT @COUNTRY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='BE'
SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='BE10'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'BE100', 'Arr. de Bruxelles-Capitale / Arr. van Brussel-Hoofdstad', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='BE21'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'BE211', 'Arr. Antwerpen', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'BE212', 'Arr. Mechelen', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'BE213', 'Arr. Turnhout', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='BE22'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'BE221', 'Arr. Hasselt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'BE222', 'Arr. Maaseik', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'BE223', 'Arr. Tongeren', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='BE23'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'BE231', 'Arr. Aalst', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'BE232', 'Arr. Dendermonde', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'BE233', 'Arr. Eeklo', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'BE234', 'Arr. Gent', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'BE235', 'Arr. Oudenaarde', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'BE236', 'Arr. Sint-Niklaas', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='BE24'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'BE241', 'Arr. Halle-Vilvoorde', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'BE242', 'Arr. Leuven', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='BE25'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'BE251', 'Arr. Brugge', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'BE252', 'Arr. Diksmuide', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'BE253', 'Arr. Ieper', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'BE254', 'Arr. Kortrijk', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'BE255', 'Arr. Oostende', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'BE256', 'Arr. Roeselare', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'BE257', 'Arr. Tielt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'BE258', 'Arr. Veurne', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='BE31'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'BE310', 'Arr. Nivelles', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='BE32'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'BE321', 'Arr. Ath', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'BE322', 'Arr. Charleroi', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'BE323', 'Arr. Mons', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'BE324', 'Arr. Mouscron', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'BE325', 'Arr. Soignies', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'BE326', 'Arr. Thuin', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'BE327', 'Arr. Tournai', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='BE33'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'BE331', 'Arr. Huy', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'BE332', 'Arr. Liège', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'BE334', 'Arr. Waremme', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'BE335', 'Arr. Verviers - communes francophones', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'BE336', 'Bezirk Verviers - Deutschsprachige Gemeinschaft', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='BE34'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'BE341', 'Arr. Arlon', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'BE342', 'Arr. Bastogne', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'BE343', 'Arr. Marche-en-Famenne', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'BE344', 'Arr. Neufchâteau', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'BE345', 'Arr. Virton', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='BE35'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'BE351', 'Arr. Dinant', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'BE352', 'Arr. Namur', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'BE353', 'Arr. Philippeville', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='BEZZ'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'BEZZZ', 'Extra-Regio', 2007, @NUTS2, @COUNTRY

GO
