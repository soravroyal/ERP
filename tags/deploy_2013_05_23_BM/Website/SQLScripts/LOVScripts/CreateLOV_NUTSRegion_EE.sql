-- NUTS 1 ---------------------------------------------------------------------
DECLARE @COUNTRY INT
SELECT @COUNTRY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='EE'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'EE0', 'EESTI', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'EEZ', 'EXTRA-REGIO', 2007, NULL, @COUNTRY
GO

-- NUTS 2 ---------------------------------------------------------------------
DECLARE @COUNTRY INT, @NUTSEE0 INT, @NUTSEEZ INT
SELECT @COUNTRY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='EE'
SELECT @NUTSEE0=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='EE0'
SELECT @NUTSEEZ=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='EEZ'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'EE00', 'Eesti', 2007, @NUTSEE0, @COUNTRY
  UNION ALL
 SELECT 'EEZZ', 'Extra-Regio', 2007, @NUTSEEZ, @COUNTRY
GO

-- NUTS 3 ---------------------------------------------------------------------
DECLARE @COUNTRY INT, @NUTS2 INT
SELECT @COUNTRY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='EE'
SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='EE00'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'EE001', 'Pıhja-Eesti', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'EE004', 'L‰‰ne-Eesti', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'EE006', 'Kesk-Eesti', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'EE007', 'Kirde-Eesti', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'EE008', 'Lıuna-Eesti', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='EEZZ'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'EEZZZ', 'Extra-Regio', 2007, @NUTS2, @COUNTRY

GO
