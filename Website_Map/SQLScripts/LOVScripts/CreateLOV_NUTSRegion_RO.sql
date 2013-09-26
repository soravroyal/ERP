-- NUTS 1 ---------------------------------------------------------------------
DECLARE @COUNTRY INT
SELECT @COUNTRY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='RO'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'RO1', 'Macroregiunea unu', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'RO2', 'Macroregiunea doi', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'RO3', 'Macroregiunea trei', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'RO4', 'Macroregiunea patru', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'ROZ', 'EXTRA-REGIO', 2007, NULL, @COUNTRY
GO

-- NUTS 2 ---------------------------------------------------------------------
DECLARE @COUNTRY INT, @NUTSRO1 INT, @NUTSRO2 INT, @NUTSRO3 INT, @NUTSRO4 INT, @NUTSROZ INT
SELECT @COUNTRY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='RO'
SELECT @NUTSRO1=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='RO1'
SELECT @NUTSRO2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='RO2'
SELECT @NUTSRO3=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='RO3'
SELECT @NUTSRO4=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='RO4'
SELECT @NUTSROZ=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='ROZ'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'RO11', 'Nord-Vest', 2007, @NUTSRO1, @COUNTRY
  UNION ALL
 SELECT 'RO12', 'Centru', 2007, @NUTSRO1, @COUNTRY
  UNION ALL
 SELECT 'RO21', 'Nord-Est', 2007, @NUTSRO2, @COUNTRY
  UNION ALL
 SELECT 'RO22', 'Sud-Est', 2007, @NUTSRO2, @COUNTRY
  UNION ALL
 SELECT 'RO31', 'Sud - Muntenia', 2007, @NUTSRO3, @COUNTRY
  UNION ALL
 SELECT 'RO32', 'Bucuresti - Ilfov', 2007, @NUTSRO3, @COUNTRY
  UNION ALL
 SELECT 'RO41', 'Sud-Vest Oltenia', 2007, @NUTSRO4, @COUNTRY
  UNION ALL
 SELECT 'RO42', 'Vest', 2007, @NUTSRO4, @COUNTRY
  UNION ALL
 SELECT 'ROZZ', 'Extra-Regio', 2007, @NUTSROZ, @COUNTRY
GO

-- NUTS 3 ---------------------------------------------------------------------
DECLARE @COUNTRY INT, @NUTS2 INT
SELECT @COUNTRY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='RO'
SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='RO11'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'RO111', 'Bihor', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'RO112', 'Bistrita-Nasaud', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'RO113', 'Cluj', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'RO114', 'Maramures', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'RO115', 'Satu Mare', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'RO116', 'Salaj', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='RO12'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'RO121', 'Alba', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'RO122', 'Brasov', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'RO123', 'Covasna', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'RO124', 'Harghita', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'RO125', 'Mures', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'RO126', 'Sibiu', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='RO21'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'RO211', 'Bacau', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'RO212', 'Botosani', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'RO213', 'Iasi', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'RO214', 'Neamt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'RO215', 'Suceava', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'RO216', 'Vaslui', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='RO22'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'RO221', 'Braila', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'RO222', 'Buzau', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'RO223', 'Constanta', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'RO224', 'Galati', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'RO225', 'Tulcea', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'RO226', 'Vrancea', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='RO31'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'RO311', 'Arges', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'RO312', 'Calarasi', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'RO313', 'Dambovita', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'RO314', 'Giurgiu', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'RO315', 'Ialomita', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'RO316', 'Prahova', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'RO317', 'Teleorman', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='RO32'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'RO321', 'Bucuresti', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'RO322', 'Ilfov', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='RO41'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'RO411', 'Dolj', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'RO412', 'Gorj', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'RO413', 'Mehedinti', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'RO414', 'Olt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'RO415', 'Valcea', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='RO42'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'RO421', 'Arad', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'RO422', 'Caras-Severin', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'RO423', 'Hunedoara', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'RO424', 'Timis', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='ROZZ'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'ROZZZ', 'Extra-Regio', 2007, @NUTS2, @COUNTRY

GO
