-- NUTS 1 ---------------------------------------------------------------------
DECLARE @COUNTRY INT
SELECT @COUNTRY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]=N'DK'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT N'DK0', N'DANMARK', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT N'DKZ', N'EXTRA-REGIO', 2007, NULL, @COUNTRY
GO

-- NUTS 2 ---------------------------------------------------------------------
DECLARE @COUNTRY INT, @NUTSDK0 INT, @NUTSDKZ INT
SELECT @COUNTRY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]=N'DK'
SELECT @NUTSDK0=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]=N'DK0'
SELECT @NUTSDKZ=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]=N'DKZ'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT N'DK01', N'Hovedstaden', 2007, @NUTSDK0, @COUNTRY
  UNION ALL
 SELECT N'DK02', N'Sjælland', 2007, @NUTSDK0, @COUNTRY
  UNION ALL
 SELECT N'DK03', N'Syddanmark', 2007, @NUTSDK0, @COUNTRY
  UNION ALL
 SELECT N'DK04', N'Midtjylland', 2007, @NUTSDK0, @COUNTRY
  UNION ALL
 SELECT N'DK05', N'Nordjylland', 2007, @NUTSDK0, @COUNTRY
  UNION ALL
 SELECT N'DKZZ', N'Extra-Regio', 2007, @NUTSDKZ, @COUNTRY
GO

-- NUTS 3 ---------------------------------------------------------------------
DECLARE @COUNTRY INT, @NUTS2 INT
SELECT @COUNTRY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]=N'DK'
SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]=N'DK01'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT N'DK011', N'Byen København', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT N'DK012', N'Københavns omegn', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT N'DK013', N'Nordsjælland', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT N'DK014', N'Bornholm', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]=N'DK02'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT N'DK021', N'Østsjælland', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT N'DK022', N'Vest- og Sydsjælland', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]=N'DK03'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT N'DK031', N'Fyn', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT N'DK032', N'Sydjylland', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]=N'DK04'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT N'DK041', N'Vestjylland', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT N'DK042', N'Østjylland', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]=N'DK05'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT N'DK050', N'Nordjylland', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]=N'DKZZ'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT N'DKZZZ', N'Extra-Regio', 2007, @NUTS2, @COUNTRY

GO
