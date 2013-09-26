-- NUTS 1 ---------------------------------------------------------------------
DECLARE @COUNTRY INT
SELECT @COUNTRY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='ES'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'ES1', 'NOROESTE', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'ES2', 'NORESTE', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'ES3', 'COMUNIDAD DE MADRID', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'ES4', 'CENTRO (E)', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'ES5', 'ESTE', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'ES6', 'SUR', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'ES7', 'CANARIAS', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'ESZ', 'EXTRA-REGIO', 2007, NULL, @COUNTRY
GO

-- NUTS 2 ---------------------------------------------------------------------
DECLARE @COUNTRY INT, @NUTSES1 INT, @NUTSES2 INT, @NUTSES3 INT, @NUTSES4 INT, @NUTSES5 INT, @NUTSES6 INT, @NUTSES7 INT, @NUTSESZ INT
SELECT @COUNTRY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='ES'
SELECT @NUTSES1=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='ES1'
SELECT @NUTSES2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='ES2'
SELECT @NUTSES3=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='ES3'
SELECT @NUTSES4=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='ES4'
SELECT @NUTSES5=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='ES5'
SELECT @NUTSES6=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='ES6'
SELECT @NUTSES7=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='ES7'
SELECT @NUTSESZ=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='ESZ'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'ES11', 'Galicia', 2007, @NUTSES1, @COUNTRY
  UNION ALL
 SELECT 'ES12', 'Principado de Asturias', 2007, @NUTSES1, @COUNTRY
  UNION ALL
 SELECT 'ES13', 'Cantabria', 2007, @NUTSES1, @COUNTRY
  UNION ALL
 SELECT 'ES21', 'País Vasco', 2007, @NUTSES2, @COUNTRY
  UNION ALL
 SELECT 'ES22', 'Comunidad Foral de Navarra', 2007, @NUTSES2, @COUNTRY
  UNION ALL
 SELECT 'ES23', 'La Rioja', 2007, @NUTSES2, @COUNTRY
  UNION ALL
 SELECT 'ES24', 'Aragón', 2007, @NUTSES2, @COUNTRY
  UNION ALL
 SELECT 'ES30', 'Comunidad de Madrid', 2007, @NUTSES3, @COUNTRY
  UNION ALL
 SELECT 'ES41', 'Castilla y León', 2007, @NUTSES4, @COUNTRY
  UNION ALL
 SELECT 'ES42', 'Castilla-La Mancha', 2007, @NUTSES4, @COUNTRY
  UNION ALL
 SELECT 'ES43', 'Extremadura', 2007, @NUTSES4, @COUNTRY
  UNION ALL
 SELECT 'ES51', 'Cataluña', 2007, @NUTSES5, @COUNTRY
  UNION ALL
 SELECT 'ES52', 'Comunidad Valenciana', 2007, @NUTSES5, @COUNTRY
  UNION ALL
 SELECT 'ES53', 'Illes Balears', 2007, @NUTSES5, @COUNTRY
  UNION ALL
 SELECT 'ES61', 'Andalucía', 2007, @NUTSES6, @COUNTRY
  UNION ALL
 SELECT 'ES62', 'Región de Murcia', 2007, @NUTSES6, @COUNTRY
  UNION ALL
 SELECT 'ES63', 'Ciudad Autónoma de Ceuta', 2007, @NUTSES6, @COUNTRY
  UNION ALL
 SELECT 'ES64', 'Ciudad Autónoma de Melilla', 2007, @NUTSES6, @COUNTRY
  UNION ALL
 SELECT 'ES70', 'Canarias', 2007, @NUTSES7, @COUNTRY
  UNION ALL
 SELECT 'ESZZ', 'Extra-Regio', 2007, @NUTSESZ, @COUNTRY
GO

-- NUTS 3 ---------------------------------------------------------------------
DECLARE @COUNTRY INT, @NUTS2 INT
SELECT @COUNTRY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='ES'
SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='ES11'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'ES111', 'A Coruña', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ES112', 'Lugo', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ES113', 'Ourense', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ES114', 'Pontevedra', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='ES12'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'ES120', 'Asturias', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='ES13'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'ES130', 'Cantabria', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='ES21'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'ES211', 'Álava', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ES212', 'Guipúzcoa', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ES213', 'Vizcaya', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='ES22'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'ES220', 'Navarra', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='ES23'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'ES230', 'La Rioja', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='ES24'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'ES241', 'Huesca', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ES242', 'Teruel', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ES243', 'Zaragoza', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='ES30'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'ES300', 'Madrid', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='ES41'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'ES411', 'Ávila', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ES412', 'Burgos', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ES413', 'León', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ES414', 'Palencia', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ES415', 'Salamanca', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ES416', 'Segovia', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ES417', 'Soria', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ES418', 'Valladolid', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ES419', 'Zamora', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='ES42'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'ES421', 'Albacete', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ES422', 'Ciudad Real', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ES423', 'Cuenca', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ES424', 'Guadalajara', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ES425', 'Toledo', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='ES43'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'ES431', 'Badajoz', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ES432', 'Cáceres', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='ES51'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'ES511', 'Barcelona', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ES512', 'Girona', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ES513', 'Lleida', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ES514', 'Tarragona', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='ES52'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'ES521', 'Alicante / Alacant', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ES522', 'Castellón / Castelló', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ES523', 'Valencia / València', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='ES53'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'ES531', 'Eivissa y Formentera', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ES532', 'Mallorca', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ES533', 'Menorca', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='ES61'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'ES611', 'Almería', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ES612', 'Cádiz', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ES613', 'Córdoba', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ES614', 'Granada', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ES615', 'Huelva', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ES616', 'Jaén', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ES617', 'Málaga', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ES618', 'Sevilla', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='ES62'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'ES620', 'Murcia', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='ES63'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'ES630', 'Ceuta', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='ES64'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'ES640', 'Melilla', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='ES70'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'ES703', 'El Hierro', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ES704', 'Fuerteventura', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ES705', 'Gran Canaria', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ES706', 'La Gomera', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ES707', 'La Palma', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ES708', 'Lanzarote', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ES709', 'Tenerife', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='ESZZ'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'ESZZZ', 'Extra-Regio', 2007, @NUTS2, @COUNTRY

GO
