-- NUTS 1 ---------------------------------------------------------------------
DECLARE @COUNTRY INT
SELECT @COUNTRY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='FR'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'FR1', 'ÎLE DE FRANCE', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'FR2', 'BASSIN PARISIEN', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'FR3', 'NORD - PAS-DE-CALAIS', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'FR4', 'EST', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'FR5', 'OUEST', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'FR6', 'SUD-OUEST', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'FR7', 'CENTRE-EST', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'FR8', 'MÉDITERRANÉE', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'FR9', 'DÉPARTEMENTS D''OUTRE-MER', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'FRZ', 'EXTRA-REGIO', 2007, NULL, @COUNTRY
GO

-- NUTS 2 ---------------------------------------------------------------------
DECLARE @COUNTRY INT, @NUTSFR1 INT, @NUTSFR2 INT, @NUTSFR3 INT, @NUTSFR4 INT, @NUTSFR5 INT, @NUTSFR6 INT, @NUTSFR7 INT, @NUTSFR8 INT, @NUTSFR9 INT, @NUTSFRZ INT
SELECT @COUNTRY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='FR'
SELECT @NUTSFR1=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='FR1'
SELECT @NUTSFR2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='FR2'
SELECT @NUTSFR3=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='FR3'
SELECT @NUTSFR4=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='FR4'
SELECT @NUTSFR5=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='FR5'
SELECT @NUTSFR6=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='FR6'
SELECT @NUTSFR7=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='FR7'
SELECT @NUTSFR8=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='FR8'
SELECT @NUTSFR9=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='FR9'
SELECT @NUTSFRZ=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='FRZ'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'FR10', 'Île de France', 2007, @NUTSFR1, @COUNTRY
  UNION ALL
 SELECT 'FR21', 'Champagne-Ardenne', 2007, @NUTSFR2, @COUNTRY
  UNION ALL
 SELECT 'FR22', 'Picardie', 2007, @NUTSFR2, @COUNTRY
  UNION ALL
 SELECT 'FR23', 'Haute-Normandie', 2007, @NUTSFR2, @COUNTRY
  UNION ALL
 SELECT 'FR24', 'Centre', 2007, @NUTSFR2, @COUNTRY
  UNION ALL
 SELECT 'FR25', 'Basse-Normandie', 2007, @NUTSFR2, @COUNTRY
  UNION ALL
 SELECT 'FR26', 'Bourgogne', 2007, @NUTSFR2, @COUNTRY
  UNION ALL
 SELECT 'FR30', 'Nord - Pas-de-Calais', 2007, @NUTSFR3, @COUNTRY
  UNION ALL
 SELECT 'FR41', 'Lorraine', 2007, @NUTSFR4, @COUNTRY
  UNION ALL
 SELECT 'FR42', 'Alsace', 2007, @NUTSFR4, @COUNTRY
  UNION ALL
 SELECT 'FR43', 'Franche-Comté', 2007, @NUTSFR4, @COUNTRY
  UNION ALL
 SELECT 'FR51', 'Pays de la Loire', 2007, @NUTSFR5, @COUNTRY
  UNION ALL
 SELECT 'FR52', 'Bretagne', 2007, @NUTSFR5, @COUNTRY
  UNION ALL
 SELECT 'FR53', 'Poitou-Charentes', 2007, @NUTSFR5, @COUNTRY
  UNION ALL
 SELECT 'FR61', 'Aquitaine', 2007, @NUTSFR6, @COUNTRY
  UNION ALL
 SELECT 'FR62', 'Midi-Pyrénées', 2007, @NUTSFR6, @COUNTRY
  UNION ALL
 SELECT 'FR63', 'Limousin', 2007, @NUTSFR6, @COUNTRY
  UNION ALL
 SELECT 'FR71', 'Rhône-Alpes', 2007, @NUTSFR7, @COUNTRY
  UNION ALL
 SELECT 'FR72', 'Auvergne', 2007, @NUTSFR7, @COUNTRY
  UNION ALL
 SELECT 'FR81', 'Languedoc-Roussillon', 2007, @NUTSFR8, @COUNTRY
  UNION ALL
 SELECT 'FR82', 'Provence-Alpes-Côte d''Azur', 2007, @NUTSFR8, @COUNTRY
  UNION ALL
 SELECT 'FR83', 'Corse', 2007, @NUTSFR8, @COUNTRY
  UNION ALL
 SELECT 'FR91', 'Guadeloupe', 2007, @NUTSFR9, @COUNTRY
  UNION ALL
 SELECT 'FR92', 'Martinique', 2007, @NUTSFR9, @COUNTRY
  UNION ALL
 SELECT 'FR93', 'Guyane', 2007, @NUTSFR9, @COUNTRY
  UNION ALL
 SELECT 'FR94', 'Réunion', 2007, @NUTSFR9, @COUNTRY
  UNION ALL
 SELECT 'FRZZ', 'Extra-Regio', 2007, @NUTSFRZ, @COUNTRY
GO

-- NUTS 3 ---------------------------------------------------------------------
DECLARE @COUNTRY INT, @NUTS2 INT
SELECT @COUNTRY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='FR'
SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='FR10'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'FR101', 'Paris', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FR102', 'Seine-et-Marne', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FR103', 'Yvelines', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FR104', 'Essonne', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FR105', 'Hauts-de-Seine', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FR106', 'Seine-Saint-Denis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FR107', 'Val-de-Marne', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FR108', 'Val-d''Oise', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='FR21'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'FR211', 'Ardennes', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FR212', 'Aube', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FR213', 'Marne', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FR214', 'Haute-Marne', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='FR22'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'FR221', 'Aisne', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FR222', 'Oise', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FR223', 'Somme', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='FR23'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'FR231', 'Eure', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FR232', 'Seine-Maritime', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='FR24'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'FR241', 'Cher', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FR242', 'Eure-et-Loir', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FR243', 'Indre', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FR244', 'Indre-et-Loire', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FR245', 'Loir-et-Cher', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FR246', 'Loiret', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='FR25'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'FR251', 'Calvados', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FR252', 'Manche', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FR253', 'Orne', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='FR26'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'FR261', 'Côte-d''Or', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FR262', 'Nièvre', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FR263', 'Saône-et-Loire', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FR264', 'Yonne', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='FR30'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'FR301', 'Nord', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FR302', 'Pas-de-Calais', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='FR41'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'FR411', 'Meurthe-et-Moselle', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FR412', 'Meuse', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FR413', 'Moselle', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FR414', 'Vosges', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='FR42'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'FR421', 'Bas-Rhin', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FR422', 'Haut-Rhin', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='FR43'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'FR431', 'Doubs', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FR432', 'Jura', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FR433', 'Haute-Saône', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FR434', 'Territoire de Belfort', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='FR51'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'FR511', 'Loire-Atlantique', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FR512', 'Maine-et-Loire', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FR513', 'Mayenne', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FR514', 'Sarthe', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FR515', 'Vendée', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='FR52'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'FR521', 'Côtes-d''Armor', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FR522', 'Finistère', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FR523', 'Ille-et-Vilaine', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FR524', 'Morbihan', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='FR53'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'FR531', 'Charente', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FR532', 'Charente-Maritime', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FR533', 'Deux-Sèvres', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FR534', 'Vienne', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='FR61'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'FR611', 'Dordogne', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FR612', 'Gironde', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FR613', 'Landes', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FR614', 'Lot-et-Garonne', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FR615', 'Pyrénées-Atlantiques', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='FR62'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'FR621', 'Ariège', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FR622', 'Aveyron', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FR623', 'Haute-Garonne', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FR624', 'Gers', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FR625', 'Lot', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FR626', 'Hautes-Pyrénées', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FR627', 'Tarn', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FR628', 'Tarn-et-Garonne', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='FR63'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'FR631', 'Corrèze', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FR632', 'Creuse', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FR633', 'Haute-Vienne', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='FR71'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'FR711', 'Ain', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FR712', 'Ardèche', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FR713', 'Drôme', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FR714', 'Isère', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FR715', 'Loire', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FR716', 'Rhône', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FR717', 'Savoie', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FR718', 'Haute-Savoie', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='FR72'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'FR721', 'Allier', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FR722', 'Cantal', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FR723', 'Haute-Loire', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FR724', 'Puy-de-Dôme', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='FR81'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'FR811', 'Aude', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FR812', 'Gard', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FR813', 'Hérault', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FR814', 'Lozère', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FR815', 'Pyrénées-Orientales', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='FR82'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'FR821', 'Alpes-de-Haute-Provence', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FR822', 'Hautes-Alpes', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FR823', 'Alpes-Maritimes', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FR824', 'Bouches-du-Rhône', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FR825', 'Var', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FR826', 'Vaucluse', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='FR83'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'FR831', 'Corse-du-Sud', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'FR832', 'Haute-Corse', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='FR91'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'FR910', 'Guadeloupe', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='FR92'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'FR920', 'Martinique', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='FR93'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'FR930', 'Guyane', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='FR94'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'FR940', 'Réunion', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='FRZZ'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'FRZZZ', 'Extra-Regio', 2007, @NUTS2, @COUNTRY

GO
