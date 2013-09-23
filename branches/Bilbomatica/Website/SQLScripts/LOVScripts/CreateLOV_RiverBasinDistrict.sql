DECLARE @AT INT
SELECT @AT=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='AT'
DECLARE @BE INT
SELECT @BE=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='BE'
DECLARE @BG INT
SELECT @BG=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='BG'
DECLARE @CH INT
SELECT @CH=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='CH'
DECLARE @CY INT
SELECT @CY=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='CY'
DECLARE @CZ INT
SELECT @CZ=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='CZ'
DECLARE @DE INT
SELECT @DE=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='DE'
DECLARE @DK INT
SELECT @DK=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='DK'
DECLARE @EE INT
SELECT @EE=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='EE'
DECLARE @ES INT
SELECT @ES=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='ES'
DECLARE @FI INT
SELECT @FI=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='FI'
DECLARE @FR INT
SELECT @FR=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='FR'
DECLARE @GR INT
SELECT @GR=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='GR'
DECLARE @HU INT
SELECT @HU=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='HU'
DECLARE @IE INT
SELECT @IE=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='IE'
DECLARE @IS INT
SELECT @IS=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='IS'
DECLARE @IT INT
SELECT @IT=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='IT'
DECLARE @LT INT
SELECT @LT=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='LT'
DECLARE @LU INT
SELECT @LU=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='LU'
DECLARE @LV INT
SELECT @LV=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='LV'
DECLARE @MT INT
SELECT @MT=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='MT'
DECLARE @NL INT
SELECT @NL=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='NL'
DECLARE @NO INT
SELECT @NO=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='NO'
DECLARE @PL INT
SELECT @PL=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='PL'
DECLARE @PT INT
SELECT @PT=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='PT'
DECLARE @RO INT
SELECT @RO=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='RO'
DECLARE @SE INT
SELECT @SE=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='SE'
DECLARE @SI INT
SELECT @SI=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='SI'
DECLARE @SK INT
SELECT @SK=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='SK'
DECLARE @UK INT
SELECT @UK=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='UK'

INSERT INTO [dbo].[LOV_RIVERBASINDISTRICT](
	[Code],
	[Name],
	[StartYear],
	[LOV_CountryID]
)
 SELECT 'CH90', 'Adige', 2007, @CH
  UNION ALL
 SELECT 'FRF', 'Adour, Garonne, Dordogne, Charente and coastal waters of Aquitania', 2007, @FR
  UNION ALL
 SELECT 'GR14', 'Aegean Islands', 2007, @GR
  UNION ALL
 SELECT 'FIWDA', 'Aland Islands', 2007, @FI
  UNION ALL
 SELECT 'PTRH8', 'Algarve Basins', 2007, @PT
  UNION ALL
 SELECT 'ES062', 'Andalusia Atlantic Basins', 2007, @ES
  UNION ALL
 SELECT 'ES060', 'Andalusia Mediterranean Basins', 2007, @ES
  UNION ALL
 SELECT 'UK05', 'Anglian', 2007, @UK
  UNION ALL
 SELECT 'GR06', 'Attica', 2007, @GR
  UNION ALL
 SELECT 'PTRH9', 'Azores', 2007, @PT
  UNION ALL
 SELECT 'ES110', 'Balearic Islands', 2007, @ES
  UNION ALL
 SELECT 'ES015', 'Basque County Internal Basins', 2007, @ES
  UNION ALL
 SELECT 'BG2000', 'Black Sea Basin District', 2007, @BG
  UNION ALL
 SELECT 'DK3', 'Bornholm', 2007, @DK
  UNION ALL
 SELECT 'NOSEFI1', 'Bothnian Bay', 2007, @NO
  UNION ALL
 SELECT 'SE1', 'Bothnian Bay', 2007, @SE
  UNION ALL
 SELECT 'NOSE2', 'Bothnian Sea', 2007, @NO
  UNION ALL
 SELECT 'SE2', 'Bothnian Sea', 2007, @SE
  UNION ALL
 SELECT 'PTRH2', 'Cavado, Ave and Leca', 2007, @PT
  UNION ALL
 SELECT 'GR10', 'Central Macedonia', 2007, @GR
  UNION ALL
 SELECT 'ES150', 'Ceuta', 2007, @ES
  UNION ALL
 SELECT 'FRE', 'Corsica', 2007, @FR
  UNION ALL
 SELECT 'GR13', 'Crete', 2007, @GR
  UNION ALL
 SELECT 'CY001', 'Cyprus', 2007, @CY
  UNION ALL
 SELECT 'BG1000', 'Danube Region Basin District', 2007, @BG
  UNION ALL
 SELECT 'AT1000', 'Danube', 2007, @AT
  UNION ALL
 SELECT 'CH80', 'Danube', 2007, @CH
  UNION ALL
 SELECT 'CZ_RB_1000', 'Danube', 2007, @CZ
  UNION ALL
 SELECT 'DE1000', 'Danube', 2007, @DE
  UNION ALL
 SELECT 'HU1000', 'Danube', 2007, @HU
  UNION ALL
 SELECT 'PL1000', 'Danube', 2007, @PL
  UNION ALL
 SELECT 'RO1000', 'Danube', 2007, @RO
  UNION ALL
 SELECT 'SI_RBD_1', 'Danube', 2007, @SI
  UNION ALL
 SELECT 'SK40000', 'Danube', 2007, @SK
  UNION ALL
 SELECT 'LT4500', 'Daugava', 2007, @LT
  UNION ALL
 SELECT 'LVDUBA', 'Daugava', 2007, @LV
  UNION ALL
 SELECT 'UK11', 'Dee', 2007, @UK
  UNION ALL
 SELECT 'PL9000', 'Dniestr', 2007, @PL
  UNION ALL
 SELECT 'PTRH3', 'Douro', 2007, @PT
  UNION ALL
 SELECT 'ES020', 'Duero', 2007, @ES
  UNION ALL
 SELECT 'BG3000', 'East Aegean Region Basin District', 2007, @BG
  UNION ALL
 SELECT 'EE2', 'East Estonia', 2007, @EE
  UNION ALL
 SELECT 'ITA', 'Eastern Alps', 2007, @IT
  UNION ALL
 SELECT 'GR11', 'Eastern Macedonia', 2007, @GR
  UNION ALL
 SELECT 'GR03', 'Eastern Peloponnese', 2007, @GR
  UNION ALL
 SELECT 'GR07', 'Eastern Sterea Ellada', 2007, @GR
  UNION ALL
 SELECT 'IEEA', 'Eastern', 2007, @IE
  UNION ALL
 SELECT 'ES091', 'Ebro', 2007, @ES
  UNION ALL
 SELECT 'DE9500', 'Eider', 2007, @DE
  UNION ALL
 SELECT 'ES127', 'El Hierro', 2007, @ES
  UNION ALL
 SELECT 'AT5000', 'Elbe', 2007, @AT
  UNION ALL
 SELECT 'CZ_RB_5000', 'Elbe', 2007, @CZ
  UNION ALL
 SELECT 'DE5000', 'Elbe', 2007, @DE
  UNION ALL
 SELECT 'PL5000', 'Elbe', 2007, @PL
  UNION ALL
 SELECT 'DE3000', 'Ems', 2007, @DE
  UNION ALL
 SELECT 'NLEM', 'Ems', 2007, @NL
  UNION ALL
 SELECT 'GR05', 'Epirus', 2007, @GR
  UNION ALL
 SELECT 'NO1105', 'Finnmark', 2007, @NO
  UNION ALL
 SELECT 'ES122', 'Fuerteventura', 2007, @ES
  UNION ALL
 SELECT 'ES014', 'Galician Coast', 2007, @ES
  UNION ALL
 SELECT 'EE3', 'Gauja', 2007, @EE
  UNION ALL
 SELECT 'LVGUBA', 'Gauja', 2007, @LV
  UNION ALL
 SELECT 'UKGI17', 'Gibraltar', 2007, @UK
  UNION ALL
 SELECT 'NO5101', 'Glomma', 2007, @NO
  UNION ALL
 SELECT 'SENO5101', 'Glomma', 2007, @SE
  UNION ALL
 SELECT 'ES120', 'Gran Canaria', 2007, @ES
  UNION ALL
 SELECT 'ES050', 'Guadalquivir', 2007, @ES
  UNION ALL
 SELECT 'FRI', 'Guadeloupe', 2007, @FR
  UNION ALL
 SELECT 'ES040', 'Guadiana', 2007, @ES
  UNION ALL
 SELECT 'PTRH7', 'Guadiana', 2007, @PT
  UNION ALL
 SELECT 'FRK', 'Guyana (French)', 2007, @FR
  UNION ALL
 SELECT 'UK04', 'Humber', 2007, @UK
  UNION ALL
 SELECT 'ES100', 'Internal Basins of Catalonia', 2007, @ES
  UNION ALL
 SELECT 'IS1', 'Iceland', 2007, @IS
  UNION ALL
 SELECT 'PL4000', 'Jarft', 2007, @PL
  UNION ALL
 SELECT 'ES080', 'Jucar', 2007, @ES
  UNION ALL
 SELECT 'DK1', 'Jutland and Funen', 2007, @DK
  UNION ALL
 SELECT 'FIVHA5', 'Kemijoki', 2007, @FI
  UNION ALL
 SELECT 'NOFIVHA5', 'Kemijoki', 2007, @NO
  UNION ALL
 SELECT 'FIVHA3', 'Kokemäenjoki-Archipelago Sea-Bothnian Sea', 2007, @FI
  UNION ALL
 SELECT 'FIVHA2', 'Kymijoki-Gulf of Finland', 2007, @FI
  UNION ALL
 SELECT 'ES126', 'La Gomera', 2007, @ES
  UNION ALL
 SELECT 'ES125', 'La Palma', 2007, @ES
  UNION ALL
 SELECT 'ES123', 'Lanzarote', 2007, @ES
  UNION ALL
 SELECT 'LT3400', 'Lielupe', 2007, @LT
  UNION ALL
 SELECT 'LVLUBA', 'Lielupe', 2007, @LV
  UNION ALL
 SELECT 'FRG', 'Loire, Brittany and Vendee coastal waters', 2007, @FR
  UNION ALL
 SELECT 'PTRH10', 'Madeira', 2007, @PT
  UNION ALL
 SELECT 'MTMalta', 'Malta', 2007, @MT
  UNION ALL
 SELECT 'FRJ', 'Martinique', 2007, @FR
  UNION ALL
 SELECT 'ES160', 'Melilla', 2007, @ES
  UNION ALL
 SELECT 'BE_Meuse_RW', 'Meuse in Wallonia', 2007, @BE
  UNION ALL
 SELECT 'BEMaas_VL', 'Meuse in Flanders', 2007, @BE
  UNION ALL
 SELECT 'DE7000', 'Meuse', 2007, @DE
  UNION ALL
 SELECT 'FRB1', 'Meuse', 2007, @FR
  UNION ALL
 SELECT 'LU7000', 'Meuse', 2007, @LU
  UNION ALL
 SELECT 'NLMS', 'Meuse', 2007, @NL
  UNION ALL
 SELECT 'ITE', 'Middle Appenines', 2007, @IT
  UNION ALL
 SELECT 'PTRH1', 'Minho and Lima', 2007, @PT
  UNION ALL
 SELECT 'ES010', 'Minho', 2007, @ES
  UNION ALL
 SELECT 'NO1101', 'Moere and Romsdal', 2007, @NO
  UNION ALL
 SELECT 'GBNIIENB', 'Neagh Bann', 2007, @UK
  UNION ALL
 SELECT 'IEGBNIIENB', 'Neagh Bann', 2007, @IE
  UNION ALL
 SELECT 'LT1100', 'Nemunas', 2007, @LT
  UNION ALL
 SELECT 'PL8000', 'Nemunas', 2007, @PL
  UNION ALL
 SELECT 'NO1103', 'Nordland', 2007, @NO
  UNION ALL
 SELECT 'SENO1103', 'Nordland', 2007, @SE
  UNION ALL
 SELECT 'SI_RBD_2', 'North Adriatic', 2007, @SI
  UNION ALL
 SELECT 'SE3', 'North Baltic', 2007, @SE
  UNION ALL
 SELECT 'GBNINE', 'North Eastern', 2007, @UK
  UNION ALL
 SELECT 'UK12', 'North West', 2007, @UK
  UNION ALL
 SELECT 'GBNIIENW', 'North Western', 2007, @UK
  UNION ALL
 SELECT 'IEGBNIIENW', 'North Western', 2007, @IE
  UNION ALL
 SELECT 'ITC', 'Northern Appenines', 2007, @IT
  UNION ALL
 SELECT 'GR02', 'Northern Peloponnese', 2007, @GR
  UNION ALL
 SELECT 'ES016', 'Northern Spain', 2007, @ES
  UNION ALL
 SELECT 'UK03', 'Northumbria', 2007, @UK
  UNION ALL
 SELECT 'CZ_RB_6000', 'Oder', 2007, @CZ
  UNION ALL
 SELECT 'DE6000', 'Odra', 2007, @DE
  UNION ALL
 SELECT 'PL6000', 'Odra', 2007, @PL
  UNION ALL
 SELECT 'FIVHA4', 'Oulujoki-Iijoki', 2007, @FI
  UNION ALL
 SELECT 'ITB', 'Po Basin', 2007, @IT
  UNION ALL
 SELECT 'CH60', 'Po', 2007, @CH
  UNION ALL
 SELECT 'PL7000', 'Pregolya', 2007, @PL
  UNION ALL
 SELECT 'FRL', 'Reunion Island', 2007, @FR
  UNION ALL
 SELECT 'AT2000', 'Rhine', 2007, @AT
  UNION ALL
 SELECT 'BE_Rhin_RW', 'Rhine', 2007, @BE
  UNION ALL
 SELECT 'CH10', 'Rhine', 2007, @CH
  UNION ALL
 SELECT 'DE2000', 'Rhine', 2007, @DE
  UNION ALL
 SELECT 'FRC', 'Rhine', 2007, @FR
  UNION ALL
 SELECT 'LU2000', 'Rhine', 2007, @LU
  UNION ALL
 SELECT 'NLRN', 'Rhine', 2007, @NL
  UNION ALL
 SELECT 'FRD', 'Rhone and Coastal Mediterranean', 2007, @FR
  UNION ALL
 SELECT 'CH50', 'Rhone', 2007, @CH
  UNION ALL
 SELECT 'PTRH6', 'Sado and Mira', 2007, @PT
  UNION ALL
 SELECT 'FRB2', 'Sambre', 2007, @FR
  UNION ALL
 SELECT 'ITG', 'Sardinia', 2007, @IT
  UNION ALL
 SELECT 'BE_Escaut_BR', 'Scheldt (Brussels Area)', 2007, @BE
  UNION ALL
 SELECT 'BESchelde_VL', 'Scheldt in Flanders', 2007, @BE
  UNION ALL
 SELECT 'BE_Escaut_RW', 'Scheldt in Wallonia', 2007, @BE
  UNION ALL
 SELECT 'NLSC', 'Scheldt', 2007, @NL
  UNION ALL
 SELECT 'FRA', 'Scheldt, Somme and coastal waters of the Channel and the North Sea', 2007, @FR
  UNION ALL
 SELECT 'DE9610', 'Schlei/Trave', 2007, @DE
  UNION ALL
 SELECT 'UK01', 'Scotland', 2007, @UK
  UNION ALL
 SELECT 'ES070', 'Segura', 2007, @ES
  UNION ALL
 SELECT 'FRH', 'Seine and Normandy coastal waters', 2007, @FR
  UNION ALL
 SELECT 'BE_Seine_RW', 'Seine', 2007, @BE
  UNION ALL
 SELECT 'ITD', 'Serchio', 2007, @IT
  UNION ALL
 SELECT 'UK09', 'Severn', 2007, @UK
  UNION ALL
 SELECT 'IEGBNISH', 'Shannon', 2007, @IE
  UNION ALL
 SELECT 'UKIEGBNISH', 'Shannon', 2007, @UK
  UNION ALL
 SELECT 'ITH', 'Sicily', 2007, @IT
  UNION ALL
 SELECT 'NOSE5', 'Skagerrak and Kattegat', 2007, @NO
  UNION ALL
 SELECT 'SE5', 'Skagerrak and Kattegat', 2007, @SE
  UNION ALL
 SELECT 'UK02', 'Solway Tweed', 2007, @UK
  UNION ALL
 SELECT 'SE4', 'South Baltic', 2007, @SE
  UNION ALL
 SELECT 'UK07', 'South East', 2007, @UK
  UNION ALL
 SELECT 'IESE', 'South Eastern', 2007, @IE
  UNION ALL
 SELECT 'NO5103', 'South West', 2007, @NO
  UNION ALL
 SELECT 'UK08', 'South West', 2007, @UK
  UNION ALL
 SELECT 'IESW', 'South Western', 2007, @IE
  UNION ALL
 SELECT 'ITF', 'Southern Appenines', 2007, @IT
  UNION ALL
 SELECT 'PL3000', 'Swieza', 2007, @PL
  UNION ALL
 SELECT 'PTRH5', 'Tagus and Western Basins', 2007, @PT
  UNION ALL
 SELECT 'ES030', 'Tagus', 2007, @ES
  UNION ALL
 SELECT 'ES124', 'Tenerife', 2007, @ES
  UNION ALL
 SELECT 'FIVHA7', 'Teno-, Näätämö- and Paatsjoki (Finnish part)', 2007, @FI
  UNION ALL
 SELECT 'UK06', 'Thames', 2007, @UK
  UNION ALL
 SELECT 'GR08', 'Thessalia', 2007, @GR
  UNION ALL
 SELECT 'GR12', 'Thrace', 2007, @GR
  UNION ALL
 SELECT 'NOFIVHA6', 'Tornionjoen (Finnish part)', 2007, @NO
  UNION ALL
 SELECT 'FIVHA6', 'Tornionjoki (Finnish part)', 2007, @FI
  UNION ALL
 SELECT 'NO1102', 'Troendelag', 2007, @NO
  UNION ALL
 SELECT 'SENO1102', 'Troendelag', 2007, @SE
  UNION ALL
 SELECT 'NO1104', 'Troms', 2007, @NO
  UNION ALL
 SELECT 'SENO1104', 'Troms', 2007, @SE
  UNION ALL
 SELECT 'PL6700', 'Ucker', 2007, @PL
  UNION ALL
 SELECT 'LT2300', 'Venta', 2007, @LT
  UNION ALL
 SELECT 'LVVUBA', 'Venta', 2007, @LV
  UNION ALL
 SELECT 'DK4', 'Vidaa-Krusaa', 2007, @DK
  UNION ALL
 SELECT 'PL2000', 'Vistula', 2007, @PL
  UNION ALL
 SELECT 'SK30000', 'Vistula', 2007, @SK
  UNION ALL
 SELECT 'PTRH4', 'Vouga, Mondego and Lis', 2007, @PT
  UNION ALL
 SELECT 'FIVHA1', 'Vuoksi', 2007, @FI
  UNION ALL
 SELECT 'DE9650', 'Warnow/Peene', 2007, @DE
  UNION ALL
 SELECT 'DE4000', 'Weser', 2007, @DE
  UNION ALL
 SELECT 'BG4000', 'West Aegean Region Basin District', 2007, @BG
  UNION ALL
 SELECT 'NO5102', 'West Bay', 2007, @NO
  UNION ALL
 SELECT 'EE1', 'West Estonia', 2007, @EE
  UNION ALL
 SELECT 'NO5104', 'West', 2007, @NO
  UNION ALL
 SELECT 'GR09', 'Western Macedonia', 2007, @GR
  UNION ALL
 SELECT 'GR01', 'Western Peloponnese', 2007, @GR
  UNION ALL
 SELECT 'GR04', 'Western Sterea Ellada', 2007, @GR
  UNION ALL
 SELECT 'UK10', 'Western Wales', 2007, @UK
  UNION ALL
 SELECT 'IEWE', 'Western', 2007, @IE
  UNION ALL
 SELECT 'DK2', 'Zealand', 2007, @DK
  UNION ALL
 SELECT 'GNSEA', 'North Sea', 2007, NULL
GO

-- Added after launch:
DECLARE @LI INT
SELECT @LI=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='LI'

INSERT INTO [dbo].[LOV_RIVERBASINDISTRICT](
	[Code],
	[Name],
	[StartYear],
    [EndYear],
	[LOV_CountryID]
)
 VALUES ('LI1', 'Rhine', 2007, NULL, @LI)
GO

-- Needed for EPER data:
INSERT INTO [dbo].[LOV_RIVERBASINDISTRICT](
	[Code],
	[Name],
	[StartYear],
    [EndYear],
	[LOV_CountryID]
)
 VALUES ('UNKNOWN', 'N/A', 2001, 2004, NULL)
GO
