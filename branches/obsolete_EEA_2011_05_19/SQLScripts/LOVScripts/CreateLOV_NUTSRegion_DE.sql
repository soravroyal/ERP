-- NUTS 1 ---------------------------------------------------------------------
DECLARE @COUNTRY INT
SELECT @COUNTRY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='DE'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'DE1', 'BADEN-W�RTTEMBERG', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'DE2', 'BAYERN', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'DE3', 'BERLIN', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'DE4', 'BRANDENBURG', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'DE5', 'BREMEN', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'DE6', 'HAMBURG', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'DE7', 'HESSEN', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'DE8', 'MECKLENBURG-VORPOMMERN', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'DE9', 'NIEDERSACHSEN', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'DEA', 'NORDRHEIN-WESTFALEN', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'DEB', 'RHEINLAND-PFALZ', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'DEC', 'SAARLAND', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'DED', 'SACHSEN', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'DEE', 'SACHSEN-ANHALT', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'DEF', 'SCHLESWIG-HOLSTEIN', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'DEG', 'TH�RINGEN', 2007, NULL, @COUNTRY
  UNION ALL
 SELECT 'DEZ', 'EXTRA-REGIO', 2007, NULL, @COUNTRY
GO

-- NUTS 2 ---------------------------------------------------------------------
DECLARE @COUNTRY INT, @NUTS1 INT
SELECT @COUNTRY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='DE'
SELECT @NUTS1=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='DE1'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'DE11', 'Stuttgart', 2007, @NUTS1, @COUNTRY
  UNION ALL
 SELECT 'DE12', 'Karlsruhe', 2007, @NUTS1, @COUNTRY
  UNION ALL
 SELECT 'DE13', 'Freiburg', 2007, @NUTS1, @COUNTRY
  UNION ALL
 SELECT 'DE14', 'T�bingen', 2007, @NUTS1, @COUNTRY

SELECT @NUTS1=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='DE2'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'DE21', 'Oberbayern', 2007, @NUTS1, @COUNTRY
  UNION ALL
 SELECT 'DE22', 'Niederbayern', 2007, @NUTS1, @COUNTRY
  UNION ALL
 SELECT 'DE23', 'Oberpfalz', 2007, @NUTS1, @COUNTRY
  UNION ALL
 SELECT 'DE24', 'Oberfranken', 2007, @NUTS1, @COUNTRY
  UNION ALL
 SELECT 'DE25', 'Mittelfranken', 2007, @NUTS1, @COUNTRY
  UNION ALL
 SELECT 'DE26', 'Unterfranken', 2007, @NUTS1, @COUNTRY
  UNION ALL
 SELECT 'DE27', 'Schwaben', 2007, @NUTS1, @COUNTRY

SELECT @NUTS1=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='DE3'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'DE30', 'Berlin', 2007, @NUTS1, @COUNTRY

SELECT @NUTS1=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='DE4'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'DE41', 'Brandenburg - Nordost', 2007, @NUTS1, @COUNTRY
  UNION ALL
 SELECT 'DE42', 'Brandenburg - S�dwest', 2007, @NUTS1, @COUNTRY

SELECT @NUTS1=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='DE5'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'DE50', 'Bremen', 2007, @NUTS1, @COUNTRY

SELECT @NUTS1=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='DE6'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'DE60', 'Hamburg', 2007, @NUTS1, @COUNTRY

SELECT @NUTS1=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='DE7'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'DE71', 'Darmstadt', 2007, @NUTS1, @COUNTRY
  UNION ALL
 SELECT 'DE72', 'Gie�en', 2007, @NUTS1, @COUNTRY
  UNION ALL
 SELECT 'DE73', 'Kassel', 2007, @NUTS1, @COUNTRY

SELECT @NUTS1=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='DE8'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'DE80', 'Mecklenburg-Vorpommern', 2007, @NUTS1, @COUNTRY

SELECT @NUTS1=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='DE9'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'DE91', 'Braunschweig', 2007, @NUTS1, @COUNTRY
  UNION ALL
 SELECT 'DE92', 'Hannover', 2007, @NUTS1, @COUNTRY
  UNION ALL
 SELECT 'DE93', 'L�neburg', 2007, @NUTS1, @COUNTRY
  UNION ALL
 SELECT 'DE94', 'Weser-Ems', 2007, @NUTS1, @COUNTRY

SELECT @NUTS1=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='DEA'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'DEA1', 'D�sseldorf', 2007, @NUTS1, @COUNTRY
  UNION ALL
 SELECT 'DEA2', 'K�ln', 2007, @NUTS1, @COUNTRY
  UNION ALL
 SELECT 'DEA3', 'M�nster', 2007, @NUTS1, @COUNTRY
  UNION ALL
 SELECT 'DEA4', 'Detmold', 2007, @NUTS1, @COUNTRY
  UNION ALL
 SELECT 'DEA5', 'Arnsberg', 2007, @NUTS1, @COUNTRY

SELECT @NUTS1=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='DEB'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'DEB1', 'Koblenz', 2007, @NUTS1, @COUNTRY
  UNION ALL
 SELECT 'DEB2', 'Trier', 2007, @NUTS1, @COUNTRY
  UNION ALL
 SELECT 'DEB3', 'Rheinhessen-Pfalz', 2007, @NUTS1, @COUNTRY

SELECT @NUTS1=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='DEC'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'DEC0', 'Saarland', 2007, @NUTS1, @COUNTRY

SELECT @NUTS1=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='DED'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'DED1', 'Chemnitz', 2007, @NUTS1, @COUNTRY
  UNION ALL
 SELECT 'DED2', 'Dresden', 2007, @NUTS1, @COUNTRY
  UNION ALL
 SELECT 'DED3', 'Leipzig', 2007, @NUTS1, @COUNTRY

SELECT @NUTS1=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='DEE'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'DEE0', 'Sachsen-Anhalt', 2007, @NUTS1, @COUNTRY

SELECT @NUTS1=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='DEF'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'DEF0', 'Schleswig-Holstein', 2007, @NUTS1, @COUNTRY

SELECT @NUTS1=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='DEG'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'DEG0', 'Thüringen', 2007, @NUTS1, @COUNTRY

SELECT @NUTS1=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='DEZ'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'DEZZ', 'Extra-Regio', 2007, @NUTS1, @COUNTRY
GO

-- NUTS 3 ---------------------------------------------------------------------
DECLARE @COUNTRY INT, @NUTS2 INT
SELECT @COUNTRY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='DE'
SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='DE11'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'DE111', 'Stuttgart, Stadtkreis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE112', 'Böblingen', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE113', 'Esslingen', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE114', 'Göppingen', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE115', 'Ludwigsburg', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE116', 'Rems-Murr-Kreis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE117', 'Heilbronn, Stadtkreis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE118', 'Heilbronn, Landkreis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE119', 'Hohenlohekreis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE11A', 'Schwäbisch Hall', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE11B', 'Main-Tauber-Kreis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE11C', 'Heidenheim', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE11D', 'Ostalbkreis', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='DE12'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'DE121', 'Baden-Baden, Stadtkreis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE122', 'Karlsruhe, Stadtkreis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE123', 'Karlsruhe, Landkreis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE124', 'Rastatt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE125', 'Heidelberg, Stadtkreis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE126', 'Mannheim, Stadtkreis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE127', 'Neckar-Odenwald-Kreis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE128', 'Rhein-Neckar-Kreis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE129', 'Pforzheim, Stadtkreis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE12A', 'Calw', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE12B', 'Enzkreis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE12C', 'Freudenstadt', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='DE13'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'DE131', 'Freiburg im Breisgau, Stadtkreis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE132', 'Breisgau-Hochschwarzwald', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE133', 'Emmendingen', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE134', 'Ortenaukreis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE135', 'Rottweil', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE136', 'Schwarzwald-Baar-Kreis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE137', 'Tuttlingen', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE138', 'Konstanz', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE139', 'Lörrach', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE13A', 'Waldshut', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='DE14'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'DE141', 'Reutlingen', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE142', 'Tübingen, Landkreis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE143', 'Zollernalbkreis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE144', 'Ulm, Stadtkreis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE145', 'Alb-Donau-Kreis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE146', 'Biberach', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE147', 'Bodenseekreis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE148', 'Ravensburg', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE149', 'Sigmaringen', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='DE21'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'DE211', 'Ingolstadt, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE212', 'München, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE213', 'Rosenheim, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE214', 'Altötting', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE215', 'Berchtesgadener Land', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE216', 'Bad Tölz-Wolfratshausen', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE217', 'Dachau', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE218', 'Ebersberg', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE219', 'Eichstätt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE21A', 'Erding', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE21B', 'Freising', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE21C', 'Fürstenfeldbruck', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE21D', 'Garmisch-Partenkirchen', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE21E', 'Landsberg a. Lech', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE21F', 'Miesbach', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE21G', 'Mühldorf a. Inn', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE21H', 'München, Landkreis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE21I', 'Neuburg-Schrobenhausen', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE21J', 'Pfaffenhofen a. d. Ilm', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE21K', 'Rosenheim, Landkreis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE21L', 'Starnberg', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE21M', 'Traunstein', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE21N', 'Weilheim-Schongau', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='DE22'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'DE221', 'Landshut, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE222', 'Passau, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE223', 'Straubing, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE224', 'Deggendorf', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE225', 'Freyung-Grafenau', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE226', 'Kelheim', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE227', 'Landshut, Landkreis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE228', 'Passau, Landkreis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE229', 'Regen', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE22A', 'Rottal-Inn', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE22B', 'Straubing-Bogen', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE22C', 'Dingolfing-Landau', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='DE23'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'DE231', 'Amberg, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE232', 'Regensburg, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE233', 'Weiden i. d. Opf, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE234', 'Amberg-Sulzbach', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE235', 'Cham', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE236', 'Neumarkt i. d. OPf.', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE237', 'Neustadt a. d. Waldnaab', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE238', 'Regensburg, Landkreis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE239', 'Schwandorf', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE23A', 'Tirschenreuth', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='DE24'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'DE241', 'Bamberg, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE242', 'Bayreuth, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE243', 'Coburg, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE244', 'Hof, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE245', 'Bamberg, Landkreis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE246', 'Bayreuth, Landkreis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE247', 'Coburg, Landkreis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE248', 'Forchheim', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE249', 'Hof, Landkreis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE24A', 'Kronach', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE24B', 'Kulmbach', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE24C', 'Lichtenfels', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE24D', 'Wunsiedel i. Fichtelgebirge', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='DE25'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'DE251', 'Ansbach, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE252', 'Erlangen, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE253', 'Fürth, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE254', 'Nürnberg, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE255', 'Schwabach, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE256', 'Ansbach, Landkreis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE257', 'Erlangen-Höchstadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE258', 'Fürth, Landkreis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE259', 'Nürnberger Land', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE25A', 'Neustadt a. d. Aisch-Bad Windsheim', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE25B', 'Roth', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE25C', 'Weißenburg-Gunzenhausen', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='DE26'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'DE261', 'Aschaffenburg, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE262', 'Schweinfurt, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE263', 'Würzburg, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE264', 'Aschaffenburg, Landkreis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE265', 'Bad Kissingen', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE266', 'Rhön-Grabfeld', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE267', 'Haßberge', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE268', 'Kitzingen', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE269', 'Miltenberg', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE26A', 'Main-Spessart', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE26B', 'Schweinfurt, Landkreis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE26C', 'Würzburg, Landkreis', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='DE27'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'DE271', 'Augsburg, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE272', 'Kaufbeuren, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE273', 'Kempten (Allgäu), Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE274', 'Memmingen, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE275', 'Aichach-Friedberg', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE276', 'Augsburg, Landkreis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE277', 'Dillingen a.d. Donau', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE278', 'Günzburg', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE279', 'Neu-Ulm', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE27A', 'Lindau (Bodensee)', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE27B', 'Ostallgäu', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE27C', 'Unterallgäu', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE27D', 'Donau-Ries', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE27E', 'Oberallgäu', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='DE30'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'DE300', 'Berlin', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='DE41'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'DE411', 'Frankfurt (Oder), Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE412', 'Barnim', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE413', 'Märkisch-Oderland', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE414', 'Oberhavel', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE415', 'Oder-Spree', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE416', 'Ostprignitz-Ruppin', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE417', 'Prignitz', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE418', 'Uckermark', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='DE42'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'DE421', 'Brandenburg an der Havel, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE422', 'Cottbus, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE423', 'Potsdam, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE424', 'Dahme-Spreewald', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE425', 'Elbe-Elster', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE426', 'Havelland', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE427', 'Oberspreewald-Lausitz', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE428', 'Potsdam-Mittelmark', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE429', 'Spree-Neiße', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE42A', 'Teltow-Fläming', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='DE50'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'DE501', 'Bremen, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE502', 'Bremerhaven, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='DE60'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'DE600', 'Hamburg', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='DE71'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'DE711', 'Darmstadt, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE712', 'Frankfurt am Main, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE713', 'Offenbach am Main, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE714', 'Wiesbaden, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE715', 'Bergstraße', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE716', 'Darmstadt-Dieburg', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE717', 'Groß-Gerau', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE718', 'Hochtaunuskreis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE719', 'Main-Kinzig-Kreis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE71A', 'Main-Taunus-Kreis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE71B', 'Odenwaldkreis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE71C', 'Offenbach, Landkreis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE71D', 'Rheingau-Taunus-Kreis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE71E', 'Wetteraukreis', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='DE72'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'DE721', 'Gießen, Landkreis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE722', 'Lahn-Dill-Kreis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE723', 'Limburg-Weilburg', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE724', 'Marburg-Biedenkopf', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE725', 'Vogelsbergkreis', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='DE73'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'DE731', 'Kassel, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE732', 'Fulda', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE733', 'Hersfeld-Rotenburg', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE734', 'Kassel, Landkreis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE735', 'Schwalm-Eder-Kreis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE736', 'Waldeck-Frankenberg', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE737', 'Werra-Meißner-Kreis', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='DE80'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'DE801', 'Greifswald, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE802', 'Neubrandenburg, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE803', 'Rostock, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE804', 'Schwerin, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE805', 'Stralsund, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE806', 'Wismar, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE807', 'Bad Doberan', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE808', 'Demmin', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE809', 'Güstrow', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE80A', 'Ludwigslust', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE80B', 'Mecklenburg-Strelitz', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE80C', 'Müritz', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE80D', 'Nordvorpommern', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE80E', 'Nordwestmecklenburg', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE80F', 'Ostvorpommern', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE80G', 'Parchim', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE80H', 'Rügen', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE80I', 'Uecker-Randow', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='DE91'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'DE911', 'Braunschweig, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE912', 'Salzgitter, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE913', 'Wolfsburg, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE914', 'Gifhorn', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE915', 'Göttingen', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE916', 'Goslar', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE917', 'Helmstedt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE918', 'Northeim', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE919', 'Osterode am Harz', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE91A', 'Peine', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE91B', 'Wolfenbüttel', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='DE92'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'DE922', 'Diepholz', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE923', 'Hameln-Pyrmont', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE925', 'Hildesheim', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE926', 'Holzminden', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE927', 'Nienburg (Weser)', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE928', 'Schaumburg', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE929', 'Region Hannover', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='DE93'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'DE931', 'Celle', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE932', 'Cuxhaven', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE933', 'Harburg', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE934', 'Lüchow-Dannenberg', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE935', 'Lüneburg, Landkreis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE936', 'Osterholz', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE937', 'Rotenburg (Wümme)', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE938', 'Soltau-Fallingbostel', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE939', 'Stade', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE93A', 'Uelzen', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE93B', 'Verden', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='DE94'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'DE941', 'Delmenhorst, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE942', 'Emden, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE943', 'Oldenburg (Oldenburg), Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE944', 'Osnabrück, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE945', 'Wilhelmshaven, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE946', 'Ammerland', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE947', 'Aurich', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE948', 'Cloppenburg', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE949', 'Emsland', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE94A', 'Friesland (D)', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE94B', 'Grafschaft Bentheim', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE94C', 'Leer', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE94D', 'Oldenburg, Landkreis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE94E', 'Osnabrück, Landkreis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE94F', 'Vechta', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE94G', 'Wesermarsch', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DE94H', 'Wittmund', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='DEA1'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'DEA11', 'Düsseldorf, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEA12', 'Duisburg, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEA13', 'Essen, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEA14', 'Krefeld, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEA15', 'Mönchengladbach, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEA16', 'Mülheim an der Ruhr,Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEA17', 'Oberhausen, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEA18', 'Remscheid, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEA19', 'Solingen, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEA1A', 'Wuppertal, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEA1B', 'Kleve', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEA1C', 'Mettmann', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEA1D', 'Rhein-Kreis Neuss', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEA1E', 'Viersen', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEA1F', 'Wesel', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='DEA2'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'DEA21', 'Aachen, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEA22', 'Bonn, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEA23', 'Köln, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEA24', 'Leverkusen, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEA25', 'Aachen, Kreis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEA26', 'Düren', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEA27', 'Rhein-Erft-Kreis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEA28', 'Euskirchen', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEA29', 'Heinsberg', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEA2A', 'Oberbergischer Kreis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEA2B', 'Rheinisch-Bergischer Kreis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEA2C', 'Rhein-Sieg-Kreis', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='DEA3'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'DEA31', 'Bottrop, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEA32', 'Gelsenkirchen, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEA33', 'Münster, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEA34', 'Borken', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEA35', 'Coesfeld', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEA36', 'Recklinghausen', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEA37', 'Steinfurt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEA38', 'Warendorf', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='DEA4'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'DEA41', 'Bielefeld, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEA42', 'Gütersloh', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEA43', 'Herford', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEA44', 'Höxter', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEA45', 'Lippe', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEA46', 'Minden-Lübbecke', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEA47', 'Paderborn', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='DEA5'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'DEA51', 'Bochum, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEA52', 'Dortmund, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEA53', 'Hagen, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEA54', 'Hamm, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEA55', 'Herne, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEA56', 'Ennepe-Ruhr-Kreis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEA57', 'Hochsauerlandkreis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEA58', 'Märkischer Kreis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEA59', 'Olpe', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEA5A', 'Siegen-Wittgenstein', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEA5B', 'Soest', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEA5C', 'Unna', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='DEB1'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'DEB11', 'Koblenz, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEB12', 'Ahrweiler', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEB13', 'Altenkirchen (Westerwald)', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEB14', 'Bad Kreuznach', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEB15', 'Birkenfeld', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEB16', 'Cochem-Zell', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEB17', 'Mayen-Koblenz', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEB18', 'Neuwied', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEB19', 'Rhein-Hunsrück-Kreis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEB1A', 'Rhein-Lahn-Kreis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEB1B', 'Westerwaldkreis', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='DEB2'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'DEB21', 'Trier, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEB22', 'Bernkastel-Wittlich', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEB23', 'Bitburg-Prüm', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEB24', 'Daun', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEB25', 'Trier-Saarburg', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='DEB3'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'DEB31', 'Frankenthal (Pfalz), Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEB32', 'Kaiserslautern, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEB33', 'Landau in der Pfalz, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEB34', 'Ludwigshafen am Rhein, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEB35', 'Mainz, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEB36', 'Neustadt an der Weinstraße, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEB37', 'Pirmasens, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEB38', 'Speyer, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEB39', 'Worms, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEB3A', 'Zweibrücken, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEB3B', 'Alzey-Worms', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEB3C', 'Bad Dürkheim', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEB3D', 'Donnersbergkreis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEB3E', 'Germersheim', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEB3F', 'Kaiserslautern, Landkreis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEB3G', 'Kusel', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEB3H', 'Südliche Weinstraße', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEB3I', 'Rhein-Pfalz-Kreis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEB3J', 'Mainz-Bingen', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEB3K', 'Südwestpfalz', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='DEC0'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'DEC01', 'Stadtverband Saarbrücken', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEC02', 'Merzig-Wadern', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEC03', 'Neunkirchen', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEC04', 'Saarlouis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEC05', 'Saarpfalz-Kreis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEC06', 'St. Wendel', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='DED1'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'DED11', 'Chemnitz, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DED12', 'Plauen, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DED13', 'Zwickau, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DED14', 'Annaberg', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DED15', 'Chemnitzer Land', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DED16', 'Freiberg', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DED17', 'Vogtlandkreis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DED18', 'Mittlerer Erzgebirgskreis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DED19', 'Mittweida', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DED1A', 'Stollberg', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DED1B', 'Aue-Schwarzenberg', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DED1C', 'Zwickauer Land', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='DED2'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'DED21', 'Dresden, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DED22', 'Görlitz, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DED23', 'Hoyerswerda, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DED24', 'Bautzen', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DED25', 'Meißen', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DED26', 'Niederschlesischer Oberlausitzkreis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DED27', 'Riesa-Großenhain', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DED28', 'Löbau-Zittau', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DED29', 'Sächsische Schweiz', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DED2A', 'Weißeritzkreis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DED2B', 'Kamenz', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='DED3'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'DED31', 'Leipzig, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DED32', 'Delitzsch', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DED33', 'Döbeln', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DED34', 'Leipziger Land', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DED35', 'Muldentalkreis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DED36', 'Torgau-Oschatz', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='DEE0'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'DEE01', 'Dessau-Roßlau, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEE02', 'Halle (Saale), Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEE03', 'Magdeburg, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEE04', 'Altmarkkreis Salzwedel', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEE05', 'Anhalt-Bitterfeld', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEE06', 'Jerichower Land', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEE07', 'Börde', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEE08', 'Burgenland (D)', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEE09', 'Harz', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEE0A', 'Mansfeld-Südharz', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEE0B', 'Saalekreis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEE0C', 'Salzland', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEE0D', 'Stendal', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEE0E', 'Wittenberg', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='DEF0'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'DEF01', 'Flensburg, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEF02', 'Kiel, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEF03', 'Lübeck, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEF04', 'Neumünster, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEF05', 'Dithmarschen', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEF06', 'Herzogtum Lauenburg', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEF07', 'Nordfriesland', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEF08', 'Ostholstein', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEF09', 'Pinneberg', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEF0A', 'Plön', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEF0B', 'Rendsburg-Eckernförde', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEF0C', 'Schleswig-Flensburg', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEF0D', 'Segeberg', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEF0E', 'Steinburg', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEF0F', 'Stormarn', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='DEG0'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'DEG01', 'Erfurt, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEG02', 'Gera, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEG03', 'Jena, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEG04', 'Suhl, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEG05', 'Weimar, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEG06', 'Eichsfeld', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEG07', 'Nordhausen', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEG09', 'Unstrut-Hainich-Kreis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEG0A', 'Kyffhäuserkreis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEG0B', 'Schmalkalden-Meiningen', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEG0C', 'Gotha', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEG0D', 'Sömmerda', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEG0E', 'Hildburghausen', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEG0F', 'Ilm-Kreis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEG0G', 'Weimarer Land', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEG0H', 'Sonneberg', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEG0I', 'Saalfeld-Rudolstadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEG0J', 'Saale-Holzland-Kreis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEG0K', 'Saale-Orla-Kreis', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEG0L', 'Greiz', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEG0M', 'Altenburger Land', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEG0N', 'Eisenach, Kreisfreie Stadt', 2007, @NUTS2, @COUNTRY
  UNION ALL
 SELECT 'DEG0P', 'Wartburgkreis', 2007, @NUTS2, @COUNTRY

SELECT @NUTS2=[LOV_NUTSRegionID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='DEZZ'
INSERT INTO [dbo].[LOV_NUTSREGION] (
    [Code],
    [Name],
    [StartYear],
    [ParentID],
	[LOV_CountryID]
)
 SELECT 'DEZZZ', 'Extra-Regio', 2007, @NUTS2, @COUNTRY

GO
