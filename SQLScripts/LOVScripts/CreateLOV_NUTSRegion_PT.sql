-- NUTS 1 ---------------------------------------------------------------------
DECLARE @COUNTRY INT
SELECT @COUNTRY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='PT'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'PT1', 'CONTINENTE', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'PT2', 'Região Autónoma dos AÇORES', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'PT3', 'Região Autónoma da MADEIRA', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'PTZ', 'EXTRA-REGIO', 2007, NULL, @COUNTRY
GO

-- NUTS 2 ---------------------------------------------------------------------
DECLARE @COUNTRY INT, @NUTSPT1 INT, @NUTSPT2 INT, @NUTSPT3 INT, @NUTSPTZ INT
SELECT @COUNTRY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='PT'
SELECT @NUTSPT1=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='PT1'
SELECT @NUTSPT2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='PT2'
SELECT @NUTSPT3=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='PT3'
SELECT @NUTSPTZ=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='PTZ'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'PT11', 'Norte', 2007, @NUTSPT1, @COUNTRY
  UNION ALL
 SELECT 'PT15', 'Algarve', 2007, @NUTSPT1, @COUNTRY
  UNION ALL
 SELECT 'PT16', 'Centro (P)', 2007, @NUTSPT1, @COUNTRY
  UNION ALL
 SELECT 'PT17', 'Lisboa', 2007, @NUTSPT1, @COUNTRY
  UNION ALL
 SELECT 'PT18', 'Alentejo', 2007, @NUTSPT1, @COUNTRY
  UNION ALL
 SELECT 'PT20', 'Região Autónoma dos Açores', 2007, @NUTSPT2, @COUNTRY
  UNION ALL
 SELECT 'PT30', 'Região Autónoma da Madeira', 2007, @NUTSPT3, @COUNTRY
  UNION ALL
 SELECT 'PTZZ', 'Extra-Regio', 2007, @NUTSPTZ, @COUNTRY
GO

-- NUTS 3 ---------------------------------------------------------------------
DECLARE @COUNTRY INT, @NUTS2 INT
SELECT @COUNTRY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='PT'
SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='PT11'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'PT111', 'Minho-Lima', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'PT112', 'Cávado', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'PT113', 'Ave', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'PT114', 'Grande Porto', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'PT115', 'Tâmega', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'PT116', 'Entre Douro e Vouga', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'PT117', 'Douro', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'PT118', 'Alto Trás-os-Montes', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='PT15'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'PT150', 'Algarve', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='PT16'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'PT161', 'Baixo Vouga', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'PT162', 'Baixo Mondego', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'PT163', 'Pinhal Litoral', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'PT164', 'Pinhal Interior Norte', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'PT165', 'Dâo-Lafôes', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'PT166', 'Pinhal Interior Sul', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'PT167', 'Serra da Estrela', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'PT168', 'Beira Interior Norte', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'PT169', 'Beira Interior Sul', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'PT16A', 'Cova da Beira', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'PT16B', 'Oeste', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'PT16C', 'Médio Tejo', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='PT17'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'PT171', 'Grande Lisboa', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'PT172', 'Península de Setúbal', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='PT18'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'PT181', 'Alentejo Litoral', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'PT182', 'Alto Alentejo', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'PT183', 'Alentejo Central', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'PT184', 'Baixo Alentejo', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'PT185', 'Lezíria do Tejo', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='PT20'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'PT200', 'Região Autónoma dos Açores', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='PT30'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'PT300', 'Região Autónoma da Madeira', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='PTZZ'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'PTZZZ', 'Extra-Regio', 2007, @NUTS2, @COUNTRY

GO
