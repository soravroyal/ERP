-- NUTS 1 ---------------------------------------------------------------------
DECLARE @COUNTRY INT
SELECT @COUNTRY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='IS'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'IS0', 'ÍSLAND', 2007, NULL, @COUNTRY
GO

-- NUTS 2 ---------------------------------------------------------------------
DECLARE @COUNTRY INT, @NUTSIS0 INT, @NUTSISZ INT
SELECT @COUNTRY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='IS'
SELECT @NUTSIS0=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='IS0'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'IS00', 'Ísland', 2007, @NUTSIS0, @COUNTRY
GO

-- NUTS 3 ---------------------------------------------------------------------
DECLARE @COUNTRY INT, @NUTS2 INT
SELECT @COUNTRY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='IS'
SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='IS00'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'IS001', 'Höfuðborgarsvæði', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'IS002', 'Landsbyggð', 2007, @NUTS2, @COUNTRY

GO
