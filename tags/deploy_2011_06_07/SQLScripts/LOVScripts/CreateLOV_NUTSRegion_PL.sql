-- NUTS 1 ---------------------------------------------------------------------
DECLARE @COUNTRY INT
SELECT @COUNTRY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='PL'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'PL1', 'REGION CENTRALNY', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'PL2', 'REGION POLUDNIOWY', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'PL3', 'REGION WSCHODNI', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'PL4', 'REGION POLNOCNO-ZACHODNI', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'PL5', 'REGION POLUDNIOWO-ZACHODNI', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'PL6', 'REGION POLNOCNY', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'PLZ', 'EXTRA-REGIO', 2007, NULL, @COUNTRY
GO

-- NUTS 2 ---------------------------------------------------------------------
DECLARE @COUNTRY INT, @NUTSPL1 INT, @NUTSPL2 INT, @NUTSPL3 INT, @NUTSPL4 INT, @NUTSPL5 INT, @NUTSPL6 INT, @NUTSPLZ INT
SELECT @COUNTRY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='PL'
SELECT @NUTSPL1=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='PL1'
SELECT @NUTSPL2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='PL2'
SELECT @NUTSPL3=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='PL3'
SELECT @NUTSPL4=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='PL4'
SELECT @NUTSPL5=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='PL5'
SELECT @NUTSPL6=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='PL6'
SELECT @NUTSPLZ=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='PLZ'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'PL11', 'Lodzkie', 2007, @NUTSPL1, @COUNTRY
  UNION ALL
 SELECT 'PL12', 'Mazowieckie', 2007, @NUTSPL1, @COUNTRY
  UNION ALL
 SELECT 'PL21', 'Malopolskie', 2007, @NUTSPL2, @COUNTRY
  UNION ALL
 SELECT 'PL22', 'Slaskie', 2007, @NUTSPL2, @COUNTRY
  UNION ALL
 SELECT 'PL31', 'Lubelskie', 2007, @NUTSPL3, @COUNTRY
  UNION ALL
 SELECT 'PL32', 'Podkarpackie', 2007, @NUTSPL3, @COUNTRY
  UNION ALL
 SELECT 'PL33', 'Swietokrzyskie', 2007, @NUTSPL3, @COUNTRY
  UNION ALL
 SELECT 'PL34', 'Podlaskie', 2007, @NUTSPL3, @COUNTRY
  UNION ALL
 SELECT 'PL41', 'Wielkopolskie', 2007, @NUTSPL4, @COUNTRY
  UNION ALL
 SELECT 'PL42', 'Zachodniopomorskie', 2007, @NUTSPL4, @COUNTRY
  UNION ALL
 SELECT 'PL43', 'Lubuskie', 2007, @NUTSPL4, @COUNTRY
  UNION ALL
 SELECT 'PL51', 'Dolnoslaskie', 2007, @NUTSPL5, @COUNTRY
  UNION ALL
 SELECT 'PL52', 'Opolskie', 2007, @NUTSPL5, @COUNTRY
  UNION ALL
 SELECT 'PL61', 'Kujawsko-Pomorskie', 2007, @NUTSPL6, @COUNTRY
  UNION ALL
 SELECT 'PL62', 'Warminsko-Mazurskie', 2007, @NUTSPL6, @COUNTRY
  UNION ALL
 SELECT 'PL63', 'Pomorskie', 2007, @NUTSPL6, @COUNTRY
  UNION ALL
 SELECT 'PLZZ', 'Extra-Regio', 2007, @NUTSPLZ, @COUNTRY
GO

-- NUTS 3 ---------------------------------------------------------------------
DECLARE @COUNTRY INT, @NUTS2 INT
SELECT @COUNTRY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='PL'
SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='PL11'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'PL113', 'Miasto Lodz', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'PL114', 'Lodzki', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'PL115', 'Piotrkowski', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'PL116', 'Sieradzki', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'PL117', 'Skierniewicki', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='PL12'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'PL121', 'Ciechanowsko-plocki', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'PL122', 'Ostrolecko-siedlecki', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'PL127', 'Miasto Warszawa', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'PL128', 'Radomski', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'PL129', 'Warszawski-wschodni', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'PL12A', 'Warszawski-zachodni', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='PL21'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'PL213', 'Miasto Krakow', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'PL214', 'Krakowski', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'PL215', 'Nowosadecki', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'PL216', 'Oswiecimski', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'PL217', 'Tarnowski', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='PL22'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'PL224', 'Czestochowski', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'PL225', 'Bielski', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'PL227', 'Rybnicki', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'PL228', 'Bytomski', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'PL229', 'Gliwicki', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'PL22A', 'Katowicki', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'PL22B', 'Sosnowiecki', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'PL22C', 'Tyski', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='PL31'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'PL311', 'Bialski', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'PL312', 'Chelmsko-zamojski', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'PL314', 'Lubelski', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'PL315', 'Pulawski', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='PL32'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'PL323', 'Krosnienski', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'PL324', 'Przemyski', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'PL325', 'Rzeszowski', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'PL326', 'Tarnobrzeski', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='PL33'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'PL331', 'Kielecki', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'PL332', 'Sandomiersko-jedrzejowski', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='PL34'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'PL343', 'Bialostocki', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'PL344', 'Lomzynski', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'PL345', 'Suwalski', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='PL41'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'PL411', 'Pilski', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'PL414', 'Koninski', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'PL415', 'Miasto Poznan', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'PL416', 'Kaliski', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'PL417', 'Leszczynski', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'PL418', 'Poznanski', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='PL42'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'PL422', 'Koszalinski', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'PL423', 'Stargardzki', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'PL424', 'Miasto Szczecin', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'PL425', 'Szczecinski', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='PL43'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'PL431', 'Gorzowski', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'PL432', 'Zielonogorski', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='PL51'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'PL514', 'Miasto Wroclaw', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'PL515', 'Jeleniogorski', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'PL516', 'Legnicko-Glogowski', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'PL517', 'Walbrzyski', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'PL518', 'Wroclawski', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='PL52'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'PL521', 'Nyski', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'PL522', 'Opolski', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='PL61'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'PL613', 'Bydgosko-Torunski', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'PL614', 'Grudziadzki', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'PL615', 'Wloclawski', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='PL62'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'PL621', 'Elblaski', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'PL622', 'Olsztynski', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'PL623', 'Elcki', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='PL63'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'PL631', 'Slupski', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'PL633', 'Trojmiejski', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'PL634', 'Gdanski', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'PL635', 'Starogardzki', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='PLZZ'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'PLZZZ', 'Extra-Regio', 2007, @NUTS2, @COUNTRY

GO
