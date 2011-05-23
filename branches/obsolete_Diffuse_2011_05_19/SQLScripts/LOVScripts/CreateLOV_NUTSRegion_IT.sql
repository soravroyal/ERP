-- NUTS 1 ---------------------------------------------------------------------
DECLARE @COUNTRY INT
SELECT @COUNTRY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='IT'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'ITC', 'NORD-OVEST', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'ITD', 'NORD-EST', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'ITE', 'CENTRO (I)', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'ITF', 'SUD', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'ITG', 'ISOLE', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'ITZ', 'EXTRA-REGIO', 2007, NULL, @COUNTRY
GO

-- NUTS 2 ---------------------------------------------------------------------
DECLARE @COUNTRY INT, @NUTSITC INT, @NUTSITD INT, @NUTSITE INT, @NUTSITF INT, @NUTSITG INT, @NUTSITZ INT
SELECT @COUNTRY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='IT'
SELECT @NUTSITC=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='ITC'
SELECT @NUTSITD=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='ITD'
SELECT @NUTSITE=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='ITE'
SELECT @NUTSITF=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='ITF'
SELECT @NUTSITG=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='ITG'
SELECT @NUTSITZ=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='ITZ'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'ITC1', 'Piemonte', 2007, @NUTSITC, @COUNTRY
  UNION ALL
 SELECT 'ITC2', 'Valle d''Aosta/Vallée d''Aoste', 2007, @NUTSITC, @COUNTRY
  UNION ALL
 SELECT 'ITC3', 'Liguria', 2007, @NUTSITC, @COUNTRY
  UNION ALL
 SELECT 'ITC4', 'Lombardia', 2007, @NUTSITC, @COUNTRY
  UNION ALL
 SELECT 'ITD1', 'Provincia Autonoma Bolzano/Bozen', 2007, @NUTSITD, @COUNTRY
  UNION ALL
 SELECT 'ITD2', 'Provincia Autonoma Trento', 2007, @NUTSITD, @COUNTRY
  UNION ALL
 SELECT 'ITD3', 'Veneto', 2007, @NUTSITD, @COUNTRY
  UNION ALL
 SELECT 'ITD4', 'Friuli-Venezia Giulia', 2007, @NUTSITD, @COUNTRY
  UNION ALL
 SELECT 'ITD5', 'Emilia-Romagna', 2007, @NUTSITD, @COUNTRY
  UNION ALL
 SELECT 'ITE1', 'Toscana', 2007, @NUTSITE, @COUNTRY
  UNION ALL
 SELECT 'ITE2', 'Umbria', 2007, @NUTSITE, @COUNTRY
  UNION ALL
 SELECT 'ITE3', 'Marche', 2007, @NUTSITE, @COUNTRY
  UNION ALL
 SELECT 'ITE4', 'Lazio', 2007, @NUTSITE, @COUNTRY
  UNION ALL
 SELECT 'ITF1', 'Abruzzo', 2007, @NUTSITF, @COUNTRY
  UNION ALL
 SELECT 'ITF2', 'Molise', 2007, @NUTSITF, @COUNTRY
  UNION ALL
 SELECT 'ITF3', 'Campania', 2007, @NUTSITF, @COUNTRY
  UNION ALL
 SELECT 'ITF4', 'Puglia', 2007, @NUTSITF, @COUNTRY
  UNION ALL
 SELECT 'ITF5', 'Basilicata', 2007, @NUTSITF, @COUNTRY
  UNION ALL
 SELECT 'ITF6', 'Calabria', 2007, @NUTSITF, @COUNTRY
  UNION ALL
 SELECT 'ITG1', 'Sicilia', 2007, @NUTSITG, @COUNTRY
  UNION ALL
 SELECT 'ITG2', 'Sardegna', 2007, @NUTSITG, @COUNTRY
  UNION ALL
 SELECT 'ITZZ', 'Extra-Regio', 2007, @NUTSITZ, @COUNTRY
GO

-- NUTS 3 ---------------------------------------------------------------------
DECLARE @COUNTRY INT, @NUTS2 INT
SELECT @COUNTRY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='IT'
SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='ITC1'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'ITC11', 'Torino', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITC12', 'Vercelli', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITC13', 'Biella', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITC14', 'Verbano-Cusio-Ossola', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITC15', 'Novara', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITC16', 'Cuneo', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITC17', 'Asti', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITC18', 'Alessandria', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='ITC2'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'ITC20', 'Valle d''Aosta/Vallée d''Aoste', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='ITC3'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'ITC31', 'Imperia', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITC32', 'Savona', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITC33', 'Genova', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITC34', 'La Spezia', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='ITC4'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'ITC41', 'Varese', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITC42', 'Como', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITC43', 'Lecco', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITC44', 'Sondrio', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITC45', 'Milano', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITC46', 'Bergamo', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITC47', 'Brescia', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITC48', 'Pavia', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITC49', 'Lodi', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITC4A', 'Cremona', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITC4B', 'Mantova', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='ITD1'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'ITD10', 'Bolzano-Bozen', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='ITD2'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'ITD20', 'Trento', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='ITD3'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'ITD31', 'Verona', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITD32', 'Vicenza', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITD33', 'Belluno', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITD34', 'Treviso', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITD35', 'Venezia', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITD36', 'Padova', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITD37', 'Rovigo', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='ITD4'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'ITD41', 'Pordenone', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITD42', 'Udine', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITD43', 'Gorizia', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITD44', 'Trieste', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='ITD5'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'ITD51', 'Piacenza', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITD52', 'Parma', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITD53', 'Reggio nell''Emilia', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITD54', 'Modena', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITD55', 'Bologna', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITD56', 'Ferrara', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITD57', 'Ravenna', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITD58', 'Forlì-Cesena', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITD59', 'Rimini', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='ITE1'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'ITE11', 'Massa-Carrara', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITE12', 'Lucca', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITE13', 'Pistoia', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITE14', 'Firenze', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITE15', 'Prato', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITE16', 'Livorno', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITE17', 'Pisa', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITE18', 'Arezzo', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITE19', 'Siena', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITE1A', 'Grosseto', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='ITE2'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'ITE21', 'Perugia', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITE22', 'Terni', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='ITE3'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'ITE31', 'Pesaro e Urbino', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITE32', 'Ancona', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITE33', 'Macerata', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITE34', 'Ascoli Piceno', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='ITE4'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'ITE41', 'Viterbo', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITE42', 'Rieti', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITE43', 'Roma', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITE44', 'Latina', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITE45', 'Frosinone', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='ITF1'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'ITF11', 'L''Aquila', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITF12', 'Teramo', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITF13', 'Pescara', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITF14', 'Chieti', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='ITF2'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'ITF21', 'Isernia', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITF22', 'Campobasso', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='ITF3'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'ITF31', 'Caserta', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITF32', 'Benevento', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITF33', 'Napoli', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITF34', 'Avellino', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITF35', 'Salerno', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='ITF4'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'ITF41', 'Foggia', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITF42', 'Bari', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITF43', 'Taranto', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITF44', 'Brindisi', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITF45', 'Lecce', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='ITF5'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'ITF51', 'Potenza', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITF52', 'Matera', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='ITF6'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'ITF61', 'Cosenza', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITF62', 'Crotone', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITF63', 'Catanzaro', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITF64', 'Vibo Valentia', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITF65', 'Reggio di Calabria', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='ITG1'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'ITG11', 'Trapani', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITG12', 'Palermo', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITG13', 'Messina', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITG14', 'Agrigento', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITG15', 'Caltanissetta', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITG16', 'Enna', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITG17', 'Catania', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITG18', 'Ragusa', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITG19', 'Siracusa', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='ITG2'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'ITG25', 'Sassari', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITG26', 'Nuoro', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITG27', 'Cagliari', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITG28', 'Oristano', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITG29', 'Olbia-Tempio', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITG2A', 'Ogliastra', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITG2B', 'Medio Campidano', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'ITG2C', 'Carbonia-Iglesias', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='ITZZ'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'ITZZZ', 'Extra-Regio', 2007, @NUTS2, @COUNTRY

GO
