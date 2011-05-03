-- ********************** Add unique constraints **************'

ALTER TABLE [EPRTRcms].[dbo].[LOV_ContentsGroup]
ADD CONSTRAINT LOV_ContentsGroup_code_unique UNIQUE (CODE)

ALTER TABLE [EPRTRcms].[dbo].[ReviseResourceKey]
ADD CONSTRAINT ReviseResourceKey_unique UNIQUE (ResourceType, ResourceKey)


-- ********************** Group **************'
-- Rename original diffuse group
UPDATE [EPRTRcms].[dbo].[LOV_ContentsGroup]
   SET [Code] = 'DIFSRC_WATER'
      ,[Name] = 'Diffuse Sources Water'
 WHERE Code = 'DIFSRC'
GO

-- Insert new group for air
IF NOT EXISTS (SELECT * FROM [EPRTRcms].[dbo].[LOV_ContentsGroup] WHERE CODE = 'DIFSRC_AIR')
BEGIN 
  INSERT INTO [EPRTRcms].[dbo].[LOV_ContentsGroup]([Code],[Name],[StartYear],[EndYear])
     VALUES('DIFSRC_AIR', 'Diffuse Sources Air', 2007, NULL)
END 

-- ********************** Subheadline **************'

update [EPRTRcms].[dbo].[ReviseResourceKey]
set ContentsGroupID = (select LOV_ContentsGroupID from LOV_ContentsGroup where Code = 'DIFSRC_AIR')
where KeyTitle='Air: Subheadline'



-- MAP_01 ****************** AirNOx_NonIndustrialCombustion ******************************************
-- Air NOx Non-industrial Combustion 

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('AirNOx_NonIndustrialCombustion.TitleShort', 'DiffuseSources',0,'','NOx Non-industrial Combustion - Short title',	(select LOV_ContentsGroupID from LOV_ContentsGroup where Code = 'DIFSRC_AIR'))

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('AirNOx_NonIndustrialCombustion.TitleFull',	'DiffuseSources',0,'','NOx Non-industrial Combustion - Full title',	(select LOV_ContentsGroupID from LOV_ContentsGroup where Code = 'DIFSRC_AIR'))

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('AirNOx_NonIndustrialCombustion.GeneralInformation',	'DiffuseSources',1,'','NOx Non-industrial Combustion - General Information',	(select LOV_ContentsGroupID from LOV_ContentsGroup where Code = 'DIFSRC_AIR'))

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('AirNOx_NonIndustrialCombustion.Methodology',	'DiffuseSources',1,'','NOx Non-industrial Combustion - Methodology',	(select LOV_ContentsGroupID from LOV_ContentsGroup where Code = 'DIFSRC_AIR'))

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('AirNOx_NonIndustrialCombustion.SourceData', 'DiffuseSources',1,'','NOx Non-industrial Combustion - Source Data',	(select LOV_ContentsGroupID from LOV_ContentsGroup where Code = 'DIFSRC_AIR'))


INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirNOx_NonIndustrialCombustion.TitleShort'),
	'en-GB','NOx emissions from non-industrial combustion, t/grid')

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirNOx_NonIndustrialCombustion.TitleFull'),
	'en-GB','Nitrogen oxides (NOx) emissions to air from non-industrial combustion plants (in tonnes per year per grid cell)')

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirNOx_NonIndustrialCombustion.GeneralInformation'),
	'en-GB','AirNOx_NonIndustrialCombustion.GeneralInformation')

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirNOx_NonIndustrialCombustion.Methodology'),
	'en-GB','AirNOx_NonIndustrialCombustion.Methodology')

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirNOx_NonIndustrialCombustion.SourceData'),
	'en-GB','AirNOx_NonIndustrialCombustion.SourceData')

	
	
-- MAP_02 ****************** AirNOx_RoadTransport ******************************************
INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('AirNOx_RoadTransport.TitleShort', 'DiffuseSources',0,'','NOx Road Transport - Short title',	(select LOV_ContentsGroupID from LOV_ContentsGroup where Code = 'DIFSRC_AIR'))

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('AirNOx_RoadTransport.TitleFull',	'DiffuseSources',0,'','NOx Road Transport - Full title',	(select LOV_ContentsGroupID from LOV_ContentsGroup where Code = 'DIFSRC_AIR'))

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('AirNOx_RoadTransport.GeneralInformation',	'DiffuseSources',1,'','NOx Road Transport - General Information',	(select LOV_ContentsGroupID from LOV_ContentsGroup where Code = 'DIFSRC_AIR'))

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('AirNOx_RoadTransport.Methodology',	'DiffuseSources',1,'','NOx Road Transport - Methodology',	(select LOV_ContentsGroupID from LOV_ContentsGroup where Code = 'DIFSRC_AIR'))

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('AirNOx_RoadTransport.SourceData', 'DiffuseSources',1,'','NOx Road Transport - Source Data',	(select LOV_ContentsGroupID from LOV_ContentsGroup where Code = 'DIFSRC_AIR'))


INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirNOx_RoadTransport.TitleShort'),
	'en-GB','NOx emissions from road transport, t/grid')

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirNOx_RoadTransport.TitleFull'),
	'en-GB','Nitrogen oxides (NOx) emissions to air from road transport (in tons per year per grid cell)')

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirNOx_RoadTransport.GeneralInformation'),
	'en-GB','AirNOx_RoadTransport.GeneralInformation')

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirNOx_RoadTransport.Methodology'),
	'en-GB','AirNOx_RoadTransport.Methodology')

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirNOx_RoadTransport.SourceData'),
	'en-GB','AirNOx_RoadTransport.SourceData')

		
	
-- MAP_03****************** AirNOx_OtherMobileSources ******************************************
INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('AirNOx_OtherMobileSources.TitleShort', 'DiffuseSources',0,'','NOx Other Mobile Sources - Short title',	(select LOV_ContentsGroupID from LOV_ContentsGroup where Code = 'DIFSRC_AIR'))

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('AirNOx_OtherMobileSources.TitleFull',	'DiffuseSources',0,'','NOx Other Mobile Sources - Full title',	(select LOV_ContentsGroupID from LOV_ContentsGroup where Code = 'DIFSRC_AIR'))

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('AirNOx_OtherMobileSources.GeneralInformation',	'DiffuseSources',1,'','NOx Other Mobile Sources - General Information',	(select LOV_ContentsGroupID from LOV_ContentsGroup where Code = 'DIFSRC_AIR'))

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('AirNOx_OtherMobileSources.Methodology',	'DiffuseSources',1,'','NOx Other Mobile Sources - Methodology',	(select LOV_ContentsGroupID from LOV_ContentsGroup where Code = 'DIFSRC_AIR'))

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('AirNOx_OtherMobileSources.SourceData', 'DiffuseSources',1,'','NOx Other Mobile Sources - Source Data',	(select LOV_ContentsGroupID from LOV_ContentsGroup where Code = 'DIFSRC_AIR'))


INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirNOx_OtherMobileSources.TitleShort'),
	'en-GB','NOx emissions from other mobile sources, t/grid')

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirNOx_OtherMobileSources.TitleFull'),
	'en-GB','Nitrogen oxides (NOx) emissions into the air from other mobile sources (in tonnes per year per grid cell)')

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirNOx_OtherMobileSources.GeneralInformation'),
	'en-GB','AirNOx_OtherMobileSources.GeneralInformation')

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirNOx_OtherMobileSources.Methodology'),
	'en-GB','AirNOx_OtherMobileSources.Methodology')

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirNOx_OtherMobileSources.SourceData'),
	'en-GB','AirNOx_OtherMobileSources.SourceData')


	
-- MAP_04 ****************** AirSO2_NonIndustrialCombustion ******************************************
INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('AirSO2_NonIndustrialCombustion.TitleShort', 'DiffuseSources',0,'','SO2 Non-industrial Combustion - Short title',	(select LOV_ContentsGroupID from LOV_ContentsGroup where Code = 'DIFSRC_AIR'))

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('AirSO2_NonIndustrialCombustion.TitleFull',	'DiffuseSources',0,'','SO2 Non-industrial Combustion - Full title',	(select LOV_ContentsGroupID from LOV_ContentsGroup where Code = 'DIFSRC_AIR'))

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('AirSO2_NonIndustrialCombustion.GeneralInformation',	'DiffuseSources',1,'','SO2 Non-industrial Combustion - General Information',	(select LOV_ContentsGroupID from LOV_ContentsGroup where Code = 'DIFSRC_AIR'))

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('AirSO2_NonIndustrialCombustion.Methodology',	'DiffuseSources',1,'','SO2 Non-industrial Combustion - Methodology',	(select LOV_ContentsGroupID from LOV_ContentsGroup where Code = 'DIFSRC_AIR'))

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('AirSO2_NonIndustrialCombustion.SourceData', 'DiffuseSources',1,'','SO2 Non-industrial Combustion - Source Data',	(select LOV_ContentsGroupID from LOV_ContentsGroup where Code = 'DIFSRC_AIR'))


INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirSO2_NonIndustrialCombustion.TitleShort'),
	'en-GB','SO2 emissions from non-industrial combustion, t/grid')

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirSO2_NonIndustrialCombustion.TitleFull'),
	'en-GB','Sulphur dioxide (SO2) emissions to air from non-industrial combustion plants (in tonnes per year per grid cell)')

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirSO2_NonIndustrialCombustion.GeneralInformation'),
	'en-GB','AirSO2_NonIndustrialCombustion.GeneralInformation')

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirSO2_NonIndustrialCombustion.Methodology'),
	'en-GB','AirSO2_NonIndustrialCombustion.Methodology')

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirSO2_NonIndustrialCombustion.SourceData'),
	'en-GB','AirSO2_NonIndustrialCombustion.SourceData')
	

	
-- MAP_05 ****************** AirSO2_RoadTransport ******************************************
INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('AirSO2_RoadTransport.TitleShort', 'DiffuseSources',0,'','SO2 Road Transport - Short title',	(select LOV_ContentsGroupID from LOV_ContentsGroup where Code = 'DIFSRC_AIR'))

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('AirSO2_RoadTransport.TitleFull',	'DiffuseSources',0,'','SO2 Road Transport - Full title',	(select LOV_ContentsGroupID from LOV_ContentsGroup where Code = 'DIFSRC_AIR'))

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('AirSO2_RoadTransport.GeneralInformation',	'DiffuseSources',1,'','SO2 Road Transport - General Information',	(select LOV_ContentsGroupID from LOV_ContentsGroup where Code = 'DIFSRC_AIR'))

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('AirSO2_RoadTransport.Methodology',	'DiffuseSources',1,'','SO2 Road Transport - Methodology',	(select LOV_ContentsGroupID from LOV_ContentsGroup where Code = 'DIFSRC_AIR'))

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('AirSO2_RoadTransport.SourceData', 'DiffuseSources',1,'','SO2 Road Transport - Source Data',	(select LOV_ContentsGroupID from LOV_ContentsGroup where Code = 'DIFSRC_AIR'))


INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirSO2_RoadTransport.TitleShort'),
	'en-GB','SO2 emissions from road transport, t/grid')

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirSO2_RoadTransport.TitleFull'),
	'en-GB','Sulphur dioxide (SO2) emissions to air from road transport (in tonnes per year per grid cell)')

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirSO2_RoadTransport.GeneralInformation'),
	'en-GB','AirSO2_RoadTransport.GeneralInformation')

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirSO2_RoadTransport.Methodology'),
	'en-GB','AirSO2_RoadTransport.Methodology')

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirSO2_RoadTransport.SourceData'),
	'en-GB','AirSO2_RoadTransport.SourceData')
	
	
		
-- MAP_06 ****************** AirSO2_OtherMobileSources ******************************************
INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('AirSO2_OtherMobileSources.TitleShort', 'DiffuseSources',0,'','SO2 Other Mobile Source - Short title',	(select LOV_ContentsGroupID from LOV_ContentsGroup where Code = 'DIFSRC_AIR'))

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('AirSO2_OtherMobileSources.TitleFull',	'DiffuseSources',0,'','SO2 Other Mobile Source - Full title',	(select LOV_ContentsGroupID from LOV_ContentsGroup where Code = 'DIFSRC_AIR'))

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('AirSO2_OtherMobileSources.GeneralInformation',	'DiffuseSources',1,'','SO2 Other Mobile Source - General Information',	(select LOV_ContentsGroupID from LOV_ContentsGroup where Code = 'DIFSRC_AIR'))

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('AirSO2_OtherMobileSources.Methodology',	'DiffuseSources',1,'','SO2 Other Mobile Source - Methodology',	(select LOV_ContentsGroupID from LOV_ContentsGroup where Code = 'DIFSRC_AIR'))

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('AirSO2_OtherMobileSources.SourceData', 'DiffuseSources',1,'','SO2 Other Mobile Source - Source Data',	(select LOV_ContentsGroupID from LOV_ContentsGroup where Code = 'DIFSRC_AIR'))


INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirSO2_OtherMobileSources.TitleShort'),
	'en-GB','SO2 emissions from other mobile sources, t/grid')

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirSO2_OtherMobileSources.TitleFull'),
	'en-GB','Sulphur dioxide (SO2) emissions to air from other mobile sources (in tonnes per year per grid cell)')

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirSO2_OtherMobileSources.GeneralInformation'),
	'en-GB','AirSO2_OtherMobileSources.GeneralInformation')

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirSO2_OtherMobileSources.Methodology'),
	'en-GB','AirSO2_OtherMobileSources.Methodology')

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirSO2_OtherMobileSources.SourceData'),
	'en-GB','AirSO2_OtherMobileSources.SourceData')
	

	
-- MAP_07 ****************** AirCO_NonIndustrialCombustion ******************************************
INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('AirCO_NonIndustrialCombustion.TitleShort', 'DiffuseSources',0,'','CO Non-industrial Combustion - Short title',	(select LOV_ContentsGroupID from LOV_ContentsGroup where Code = 'DIFSRC_AIR'))

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('AirCO_NonIndustrialCombustion.TitleFull',	'DiffuseSources',0,'','CO Non-industrial Combustion - Full title',	(select LOV_ContentsGroupID from LOV_ContentsGroup where Code = 'DIFSRC_AIR'))

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('AirCO_NonIndustrialCombustion.GeneralInformation',	'DiffuseSources',1,'','CO Non-industrial Combustion - General Information',	(select LOV_ContentsGroupID from LOV_ContentsGroup where Code = 'DIFSRC_AIR'))

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('AirCO_NonIndustrialCombustion.Methodology',	'DiffuseSources',1,'','CO Non-industrial Combustion - Methodology',	(select LOV_ContentsGroupID from LOV_ContentsGroup where Code = 'DIFSRC_AIR'))

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('AirCO_NonIndustrialCombustion.SourceData', 'DiffuseSources',1,'','CO Non-industrial Combustion - Source Data',	(select LOV_ContentsGroupID from LOV_ContentsGroup where Code = 'DIFSRC_AIR'))


INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirCO_NonIndustrialCombustion.TitleShort'),
	'en-GB','CO emissions from non-industrial combustion, t/grid')

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirCO_NonIndustrialCombustion.TitleFull'),
	'en-GB','Carbon monoxide (CO) emissions to air from non-industrial combustion plants (in tonnes per year per grid cell)')

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirCO_NonIndustrialCombustion.GeneralInformation'),
	'en-GB','AirCO_NonIndustrialCombustion.GeneralInformation')

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirCO_NonIndustrialCombustion.Methodology'),
	'en-GB','AirCO_NonIndustrialCombustion.Methodology')

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirCO_NonIndustrialCombustion.SourceData'),
	'en-GB','AirCO_NonIndustrialCombustion.SourceData')
	
	
	
-- MAP_08 ****************** AirCO_RoadTransport ******************************************
INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('AirCO_RoadTransport.TitleShort', 'DiffuseSources',0,'','CO Road Transport - Short title',	(select LOV_ContentsGroupID from LOV_ContentsGroup where Code = 'DIFSRC_AIR'))

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('AirCO_RoadTransport.TitleFull',	'DiffuseSources',0,'','CO Road Transport - Full title',	(select LOV_ContentsGroupID from LOV_ContentsGroup where Code = 'DIFSRC_AIR'))

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('AirCO_RoadTransport.GeneralInformation',	'DiffuseSources',1,'','CO Road Transport - General Information',	(select LOV_ContentsGroupID from LOV_ContentsGroup where Code = 'DIFSRC_AIR'))

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('AirCO_RoadTransport.Methodology',	'DiffuseSources',1,'','CO Road Transport - Methodology',	(select LOV_ContentsGroupID from LOV_ContentsGroup where Code = 'DIFSRC_AIR'))

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('AirCO_RoadTransport.SourceData', 'DiffuseSources',1,'','CO Road Transport - Source Data',	(select LOV_ContentsGroupID from LOV_ContentsGroup where Code = 'DIFSRC_AIR'))


INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirCO_RoadTransport.TitleShort'),
	'en-GB','CO emissions from road transport, t/grid')

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirCO_RoadTransport.TitleFull'),
	'en-GB','Carbon monoxide (CO) emissions to air from road transport (in tonnes per year per grid cell)')

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirCO_RoadTransport.GeneralInformation'),
	'en-GB','AirCO_RoadTransport.GeneralInformation')

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirCO_RoadTransport.Methodology'),
	'en-GB','AirCO_RoadTransport.Methodology')

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirCO_RoadTransport.SourceData'),
	'en-GB','AirCO_RoadTransport.SourceData')
	
		
	
-- MAP_09 ****************** AirCO_OtherMobileSources ******************************************
INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('AirCO_OtherMobileSources.TitleShort', 'DiffuseSources',0,'','CO Other Mobile Sources - Short title',	(select LOV_ContentsGroupID from LOV_ContentsGroup where Code = 'DIFSRC_AIR'))

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('AirCO_OtherMobileSources.TitleFull',	'DiffuseSources',0,'','CO Other Mobile Sources - Full title',	(select LOV_ContentsGroupID from LOV_ContentsGroup where Code = 'DIFSRC_AIR'))

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('AirCO_OtherMobileSources.GeneralInformation',	'DiffuseSources',1,'','CO Other Mobile Sources - General Information',	(select LOV_ContentsGroupID from LOV_ContentsGroup where Code = 'DIFSRC_AIR'))

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('AirCO_OtherMobileSources.Methodology',	'DiffuseSources',1,'','CO Other Mobile Sources - Methodology',	(select LOV_ContentsGroupID from LOV_ContentsGroup where Code = 'DIFSRC_AIR'))

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('AirCO_OtherMobileSources.SourceData', 'DiffuseSources',1,'','CO Other Mobile Sources - Source Data',	(select LOV_ContentsGroupID from LOV_ContentsGroup where Code = 'DIFSRC_AIR'))


INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirCO_OtherMobileSources.TitleShort'),
	'en-GB','CO emissions from other mobile sources, t/grid')

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirCO_OtherMobileSources.TitleFull'),
	'en-GB','Carbon monoxide (CO) emissions to air from other mobile sources (in tonnes per year per grid cell)')

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirCO_OtherMobileSources.GeneralInformation'),
	'en-GB','AirCO_OtherMobileSources.GeneralInformation')

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirCO_OtherMobileSources.Methodology'),
	'en-GB','AirCO_OtherMobileSources.Methodology')

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirCO_OtherMobileSources.SourceData'),
	'en-GB','AirCO_OtherMobileSources.SourceData')
		
		
	
-- MAP_10 ****************** AirPM10_NonIndustrialCombustion ******************************************
INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('AirPM10_NonIndustrialCombustion.TitleShort', 'DiffuseSources',0,'','PM10 Non-industrial Combustion - Short title',	(select LOV_ContentsGroupID from LOV_ContentsGroup where Code = 'DIFSRC_AIR'))

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('AirPM10_NonIndustrialCombustion.TitleFull',	'DiffuseSources',0,'','PM10 Non-industrial Combustion - Full title',	(select LOV_ContentsGroupID from LOV_ContentsGroup where Code = 'DIFSRC_AIR'))

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('AirPM10_NonIndustrialCombustion.GeneralInformation',	'DiffuseSources',1,'','PM10 Non-industrial Combustion - General Information',	(select LOV_ContentsGroupID from LOV_ContentsGroup where Code = 'DIFSRC_AIR'))

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('AirPM10_NonIndustrialCombustion.Methodology',	'DiffuseSources',1,'','PM10 Non-industrial Combustion - Methodology',	(select LOV_ContentsGroupID from LOV_ContentsGroup where Code = 'DIFSRC_AIR'))

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('AirPM10_NonIndustrialCombustion.SourceData', 'DiffuseSources',1,'','PM10 Non-industrial Combustion - Source Data',	(select LOV_ContentsGroupID from LOV_ContentsGroup where Code = 'DIFSRC_AIR'))


INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirPM10_NonIndustrialCombustion.TitleShort'),
	'en-GB','PM10 emissions from non-industrial combustion, t/grid')

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirPM10_NonIndustrialCombustion.TitleFull'),
	'en-GB','PM10 emissions to air from agricultural sources (in tonnes per year per grid cell)')

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirPM10_NonIndustrialCombustion.GeneralInformation'),
	'en-GB','AirPM10_NonIndustrialCombustion.GeneralInformation')

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirPM10_NonIndustrialCombustion.Methodology'),
	'en-GB','AirPM10_NonIndustrialCombustion.Methodology')

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirPM10_NonIndustrialCombustion.SourceData'),
	'en-GB','AirPM10_NonIndustrialCombustion.SourceData')
	
		
	
-- MAP_11 ****************** AirPM10_RoadTransport ******************************************
INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('AirPM10_RoadTransport.TitleShort', 'DiffuseSources',0,'','PM10 Road Transport - Short title',	(select LOV_ContentsGroupID from LOV_ContentsGroup where Code = 'DIFSRC_AIR'))

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('AirPM10_RoadTransport.TitleFull',	'DiffuseSources',0,'','PM10 Road Transport - Full title',	(select LOV_ContentsGroupID from LOV_ContentsGroup where Code = 'DIFSRC_AIR'))

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('AirPM10_RoadTransport.GeneralInformation',	'DiffuseSources',1,'','PM10 Road Transport - General Information',	(select LOV_ContentsGroupID from LOV_ContentsGroup where Code = 'DIFSRC_AIR'))

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('AirPM10_RoadTransport.Methodology',	'DiffuseSources',1,'','PM10 Road Transport - Methodology',	(select LOV_ContentsGroupID from LOV_ContentsGroup where Code = 'DIFSRC_AIR'))

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('AirPM10_RoadTransport.SourceData', 'DiffuseSources',1,'','PM10 Road Transport - Source Data',	(select LOV_ContentsGroupID from LOV_ContentsGroup where Code = 'DIFSRC_AIR'))


INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirPM10_RoadTransport.TitleShort'),
	'en-GB','PM10 emissions from road transport, t/grid')

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirPM10_RoadTransport.TitleFull'),
	'en-GB','PM10 emissions to air from road transport (in tonnes per year per grid cell)')

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirPM10_RoadTransport.GeneralInformation'),
	'en-GB','AirPM10_RoadTransport.GeneralInformation')

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirPM10_RoadTransport.Methodology'),
	'en-GB','AirPM10_RoadTransport.Methodology')

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirPM10_RoadTransport.SourceData'),
	'en-GB','AirPM10_RoadTransport.SourceData')
	
	
	
-- MAP_12 ****************** AirPM10_OtherMobileSources ******************************************
INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('AirPM10_OtherMobileSources.TitleShort', 'DiffuseSources',0,'','PM10 Other Mobile Sources - Short title',	(select LOV_ContentsGroupID from LOV_ContentsGroup where Code = 'DIFSRC_AIR'))

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('AirPM10_OtherMobileSources.TitleFull',	'DiffuseSources',0,'','PM10 Other Mobile Sources - Full title',	(select LOV_ContentsGroupID from LOV_ContentsGroup where Code = 'DIFSRC_AIR'))

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('AirPM10_OtherMobileSources.GeneralInformation',	'DiffuseSources',1,'','PM10 Other Mobile Sources - General Information',	(select LOV_ContentsGroupID from LOV_ContentsGroup where Code = 'DIFSRC_AIR'))

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('AirPM10_OtherMobileSources.Methodology',	'DiffuseSources',1,'','PM10 Other Mobile Sources - Methodology',	(select LOV_ContentsGroupID from LOV_ContentsGroup where Code = 'DIFSRC_AIR'))

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('AirPM10_OtherMobileSources.SourceData', 'DiffuseSources',1,'','PM10 Other Mobile Sources - Source Data',	(select LOV_ContentsGroupID from LOV_ContentsGroup where Code = 'DIFSRC_AIR'))


INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirPM10_OtherMobileSources.TitleShort'),
	'en-GB','PM10 emissions from other mobile sources, t/grid')

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirPM10_OtherMobileSources.TitleFull'),
	'en-GB','PM10 emissions to air from other mobile sources (in tonnes per year per grid cell)')

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirPM10_OtherMobileSources.GeneralInformation'),
	'en-GB','AirPM10_OtherMobileSources.GeneralInformation')

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirPM10_OtherMobileSources.Methodology'),
	'en-GB','AirPM10_OtherMobileSources.Methodology')

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirPM10_OtherMobileSources.SourceData'),
	'en-GB','AirPM10_OtherMobileSources.SourceData')
	
	
		
-- MAP_13 ****************** AirPM10_Agriculture ******************************************
INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('AirPM10_Agriculture.TitleShort', 'DiffuseSources',0,'','PM10 Agriculture - Short title',	(select LOV_ContentsGroupID from LOV_ContentsGroup where Code = 'DIFSRC_AIR'))

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('AirPM10_Agriculture.TitleFull',	'DiffuseSources',0,'','PM10 Agriculture - Full title',	(select LOV_ContentsGroupID from LOV_ContentsGroup where Code = 'DIFSRC_AIR'))

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('AirPM10_Agriculture.GeneralInformation',	'DiffuseSources',1,'','PM10 Agriculture - General Information',	(select LOV_ContentsGroupID from LOV_ContentsGroup where Code = 'DIFSRC_AIR'))

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('AirPM10_Agriculture.Methodology',	'DiffuseSources',1,'','PM10 Agriculture - Methodology',	(select LOV_ContentsGroupID from LOV_ContentsGroup where Code = 'DIFSRC_AIR'))

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('AirPM10_Agriculture.SourceData', 'DiffuseSources',1,'','PM10 Agriculture - Source Data',	(select LOV_ContentsGroupID from LOV_ContentsGroup where Code = 'DIFSRC_AIR'))


INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirPM10_Agriculture.TitleShort'),
	'en-GB','PM10 emissions from agricultural sources t/grid')

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirPM10_Agriculture.TitleFull'),
	'en-GB','PM10 emissions to air from agricultural sources (in tonnes per year per grid cell)')

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirPM10_Agriculture.GeneralInformation'),
	'en-GB','AirPM10_Agriculture.GeneralInformation')

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirPM10_Agriculture.Methodology'),
	'en-GB','AirPM10_Agriculture.Methodology')

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirPM10_Agriculture.SourceData'),
	'en-GB','AirPM10_Agriculture.SourceData')
	
	
		
-- MAP_14 ****************** AirNH3_Agriculture ******************************************
INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('AirNH3_Agriculture.TitleShort', 'DiffuseSources',0,'','NH3 Agriculture - Short title',	(select LOV_ContentsGroupID from LOV_ContentsGroup where Code = 'DIFSRC_AIR'))

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('AirNH3_Agriculture.TitleFull',	'DiffuseSources',0,'','NH3 Agriculture - Full title',	(select LOV_ContentsGroupID from LOV_ContentsGroup where Code = 'DIFSRC_AIR'))

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('AirNH3_Agriculture.GeneralInformation',	'DiffuseSources',1,'','NH3 Agriculture - General Information',	(select LOV_ContentsGroupID from LOV_ContentsGroup where Code = 'DIFSRC_AIR'))

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('AirNH3_Agriculture.Methodology',	'DiffuseSources',1,'','NH3 Agriculture - Methodology',	(select LOV_ContentsGroupID from LOV_ContentsGroup where Code = 'DIFSRC_AIR'))

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('AirNH3_Agriculture.SourceData', 'DiffuseSources',1,'','NH3 Agriculture - Source Data',	(select LOV_ContentsGroupID from LOV_ContentsGroup where Code = 'DIFSRC_AIR'))


INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirNH3_Agriculture.TitleShort'),
	'en-GB','NH3 emissions from agricultural sources t/grid')

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirNH3_Agriculture.TitleFull'),
	'en-GB','Ammonia (NH3) emissions to air from agricultural sources (in tonnes per year per grid cell)')

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirNH3_Agriculture.GeneralInformation'),
	'en-GB','AirNH3_Agriculture.GeneralInformation')

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirNH3_Agriculture.Methodology'),
	'en-GB','AirNH3_Agriculture.Methodology')

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirNH3_Agriculture.SourceData'),
	'en-GB','AirNH3_Agriculture.SourceData')
	
	
-- *********************************************************************************************
-- Insert long HTML texts into General info, Methdology and Source columns
-- *********************************************************************************************

--MAP_01
update [EPRTRcms].[dbo].[ReviseResourceValue]
set ResourceValue = '<p>The map shows the nitrogen oxides (NO<sub>x</sub>) emissions to air from non-industrial combustion plants per 50 x 50 km<sup>2</sup> grid cell for the year 2007. The emissions are expressed in tonnes per year per grid cell.</p>'
where ResourceKeyID =(select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirNOx_NonIndustrialCombustion.GeneralInformation')
		
update [EPRTRcms].[dbo].[ReviseResourceValue]
set ResourceValue = '<h3>Geographic Information System overlay</h3>
<p>Nitrogen oxides (NO<sub>x</sub>) emissions to air from non-industrial combustion plants have been distributed according to the gridded emissions EMEP (European Monitoring and Evaluation Program) datasets officially reported by countries. The dataset covers the whole geographical area of Europe in a metric square resolution of 50x50 km&sup2; resolution. This dataset has been transformed into vector polygons and projected into the E-PRTR WGS84 standard projection.</p>
<h3>Comparability</h3>
<p>Considerable spatial variation is apparent. The main reason for the difference is:</p>
<ul>
<li>The spatial pattern of emissions from non-industrial combustion plants is dependent on the population density.</li>
</ul>'
where ResourceKeyID =(select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirNOx_NonIndustrialCombustion.Methodology')
	
update [EPRTRcms].[dbo].[ReviseResourceValue]
set ResourceValue = '<h3>Emissions data</h3>
<p>Nitrogen oxide (NO<sub>x</sub>) emissions to air from non-industrial combustion plants (mainly boilers in households, institutional and commercial premises) for the year 2007 are based on datasets officially reported by countries to the <a href="http://www.unece.org/env/lrtap/welcome.html" target="_blank">United Nations Economic Commission for Europe (UNECE) Convention on Long-range Transboundary Air Pollution (CLRTAP)</a>. Each year, the Convention&rsquo;s <a href="http://www.ceip.at/" target="_blank">EMEP Centre on Emission Inventories and Projections (CEIP)</a> prepares gridded emission maps for certain pollutants and sectors. Specific EMEP/CEIP maps have been re-projected for use in this website.</p>
<p>When producing their maps, EMEP/CEIP firstly converts the detailed annual emissions data from countries into eleven aggregated sector groups. Where data is not available from countries or is considered inconsistent, EMEP/CEIP performs a gap-filling process to improve the data quality. Emissions for recent years, such as 2007, are then spatially disaggregated on the basis of gridded data sets reported for the reference year 2005 using the EMEP &lsquo;Grid Scaler&rsquo;.</p>'
where ResourceKeyID =(select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirNOx_NonIndustrialCombustion.SourceData')
																										

--MAP_02
update [EPRTRcms].[dbo].[ReviseResourceValue]
set ResourceValue = '<p>The map shows the nitrogen oxides (NO<sub>x</sub>) emissions to air from road transport per 50 x 50 km<sup>2</sup> grid cell for the year 2007. The emissions are expressed in tonnes per year per grid cell.</p>'
where ResourceKeyID =(select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirNOx_RoadTransport.GeneralInformation')
		
update [EPRTRcms].[dbo].[ReviseResourceValue]
set ResourceValue = '<h3>Geographic Information System overlay</h3>
<p>Nitrogen oxides (NO<sub>x</sub>) emissions to air from road transport have been distributed according to the gridded emissions EMEP (European Monitoring and Evaluation Program) datasets officially reported by countries. The dataset covers the whole geographical area of Europe in a metric square resolution of 50x50 km&sup2;. This dataset has been transformed into vector polygons and projected into the E-PRTR WGS84 standard projection.</p>
<h3>Comparability</h3>
<p>Considerable spatial variation is apparent. The main reasons for the differences are:</p>
<ul>
<li>The emissions from road transport are dependent on the density of the road network</li>
<li>The emissions from road transport are allocated by road class-specific mileages of different vehicle categories.</li>
</ul>'
where ResourceKeyID =(select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirNOx_RoadTransport.Methodology')
	
update [EPRTRcms].[dbo].[ReviseResourceValue]
set ResourceValue = '<h3>Emissions data</h3>
<p>Nitrogen oxides (NO<sub>x</sub>) emissions to air from road transport for the year 2007 are based on datasets officially reported by countries to the <a href="http://www.unece.org/env/lrtap/welcome.html" target="_blank">United Nations Economic Commission for Europe (UNECE) Convention on Long-range Transboundary Air Pollution (LRTAP)</a>. Each year, the Convention&rsquo;s <a href="http://www.ceip.at/" target="_blank">EMEP Centre on Emission Inventories and Projections (CEIP)</a> prepares gridded emission maps for certain pollutants and sectors. Specific EMEP/CEIP maps have been re-projected for use in this website.</p>
<p>When producing their maps, EMEP/CEIP firstly converts the detailed annual emissions data from countries into eleven aggregated sector groups. Where data is not available from countries or is considered inconsistent, EMEP/CEIP also performs a gap-filling process to improve the data quality. Emissions for recent years, such as 2007, are then spatially disaggregated on the basis of gridded data sets reported for the reference year 2005 using the EMEP &lsquo;Grid Scaler&rsquo;.</p>
<p>A technical overview of the gridding process performed by EMEP/CEIP is available <a href="http://www.ceip.at/fileadmin/inhalte/emep/pdf/gridding_process.pdf" target="_blank">here</a>. Additional information concerning the EMEP/CEIP gap-filling and gridding procedures, together with a download facility for the original maps (in the EMEP projection), is available <a href="http://www.ceip.at/emission-data-webdab/emissions-used-in-emep-models/" target="_blank">here</a>.</p>'
where ResourceKeyID =(select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirNOx_RoadTransport.SourceData')
																										

--MAP_03
update [EPRTRcms].[dbo].[ReviseResourceValue]
set ResourceValue = '<p>The map shows the nitrogen oxides (NO<sub>x</sub>) emissions per 50 x 50 km<sup>2</sup> grid cell for the year 2007. The emissions are expressed in tonnes per year per grid cell.</p>'
where ResourceKeyID =(select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirNOx_OtherMobileSources.GeneralInformation')
		
update [EPRTRcms].[dbo].[ReviseResourceValue]
set ResourceValue = '<h3>Geographic Information System overlay</h3>
<p>Nitrogen oxides (NO<sub>x</sub>) emissions to air from other mobile sources have been distributed according to the gridded emissions EMEP (European Monitoring and Evaluation Program) datasets officially reported by countries. The dataset covers the whole geographical area of Europe in a metric square resolution of 50x50 km&sup2;. This dataset has been transformed into vector polygons and projected into the E-PRTR WGS84 standard projection.</p>
<h3>Comparability</h3>
<p>Considerable spatial variation is apparent. The main reason for the difference is:&nbsp;</p>
<ul>
<li>The emissions from other mobile sources are dependent on population density, number of aircraft landings and take-offs, inland waterway networks, traffic volume on inland waterways, international shipping routes as well as shipping activities of international ships. </li>
</ul>'
where ResourceKeyID =(select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirNOx_OtherMobileSources.Methodology')
	
update [EPRTRcms].[dbo].[ReviseResourceValue]
set ResourceValue = '<h3>Emissions data</h3>
<p>Nitrogen oxides (NO<sub>x</sub>) emissions to air from other mobile sources for the year 2007 are based on datasets officially reported by countries to the <a href="http://www.unece.org/env/lrtap/welcome.html" target="_blank">United Nations Economic Commission for Europe (UNECE) Convention on Long-range Transboundary Air Pollution (CLRTAP)</a>. Each year, the Convention&rsquo;s <a href="http://www.ceip.at/" target="_blank">EMEP Centre on Emission Inventories and Projections (CEIP)</a> prepares gridded emission maps for certain pollutants and sectors. Specific EMEP/CEIP maps have been re-projected for use in this website.</p>
<p>When producing their maps, EMEP/CEIP firstly converts and detailed annual emissions data from countries into 11 aggregated sector groups. Where data is not available from countries or is considered inconsistent, EMEP/CEIP also performs a gap-filling process to improve the data quality. Emissions for recent years, such as 2007, are then spatially disaggregated on the basis of gridded data sets reported for the reference year 2005 using the EMEP &lsquo;Grid Scaler&rsquo;.</p>
<p>A technical overview of the gridding process performed by EMEP/CEIP is available <a href="http://www.ceip.at/fileadmin/inhalte/emep/pdf/gridding_process.pdf" target="_blank">here</a>. Additional information concerning the EMEP/CEIP gap-filling and gridding procedures, together with a download facility for the original maps (in the EMEP projection), is available <a href="http://www.ceip.at/emission-data-webdab/emissions-used-in-emep-models/" target="_blank">here</a>.</p>'
where ResourceKeyID =(select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirNOx_OtherMobileSources.SourceData')

																									
--MAP_04
update [EPRTRcms].[dbo].[ReviseResourceValue]
set ResourceValue = '<p>The map shows the sulphur dioxide (SO<sub>2</sub>) emissions per 50 x 50 km<sup>2</sup> grid cell for the year 2007. The emissions are expressed in tonnes per year per grid cell.</p>'
where ResourceKeyID =(select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirSO2_NonIndustrialCombustion.GeneralInformation')
		
update [EPRTRcms].[dbo].[ReviseResourceValue]
set ResourceValue = '<h3>Geographic Information System overlay</h3>
<p>Sulphur dioxide (SO<sub>2</sub>) emissions to air from non-industrial combustion plants have been distributed according to the gridded emissions EMEP (European Monitoring and Evaluation Program) datasets officially reported by countries. The dataset covers the whole geographical area of Europe in a metric square resolution of 50x50 km&sup2;. This dataset has been transformed into vector polygons and projected into the E-PRTR WGS84 standard projection.</p>
<h3>Comparability</h3>
<p>Considerable spatial variation is apparent. The main reason for the difference is:</p>
<ul>
<li>The spatial pattern of emissions from non-industrial combustion plants is dependent on the population density</li>
</ul>'
where ResourceKeyID =(select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirSO2_NonIndustrialCombustion.Methodology')
	
update [EPRTRcms].[dbo].[ReviseResourceValue]
set ResourceValue = '<h3>Emission data</h3>
<p>Sulphur dioxide (SO<sub>2</sub>) emissions to air from non-industrial combustion plants (mainly boilers in households, institutional and commercial premises) for the year 2007 are based on datasets officially reported by countries to the <a href="http://www.unece.org/env/lrtap/welcome.html" target="_blank">United Nations Economic Commission for Europe (UNECE) Convention on Long-range Transboundary Air Pollution (CLRTAP)</a>. Each year, the Convention&rsquo;s <a href="http://www.ceip.at/" target="_blank">EMEP Centre on Emission Inventories and Projections (CEIP)</a> prepares gridded emission maps for certain pollutants and sectors. Specific EMEP/CEIP maps have been re-projected for use in this website.</p>
<p>&nbsp;When producing their maps, EMEP/CEIP first converts the detailed annual emissions data from countries into 11 aggregated sector groups. Where data is not available from countries or is considered inconsistent, EMEP/CEIP also performs a gap-filling process to improve the data quality. Emissions for recent years, such as 2007, are then spatially disaggregated on the basis of gridded data sets reported for the reference year 2005 using the EMEP &lsquo;Grid Scaler&rsquo;.</p>
<p>A technical overview of the gridding process performed by EMEP/CEIP is available <a href="http://www.ceip.at/fileadmin/inhalte/emep/pdf/gridding_process.pdf" target="_blank">here</a>. Additional information concerning the EMEP/CEIP gap-filling and gridding procedures, together with a download facility for the original maps (in the EMEP projection), is available <a href="http://www.ceip.at/emission-data-webdab/emissions-used-in-emep-models/" target="_blank">here</a>.</p>'
where ResourceKeyID =(select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirSO2_NonIndustrialCombustion.SourceData')


--MAP_05
update [EPRTRcms].[dbo].[ReviseResourceValue]
set ResourceValue = '<p>The map shows the sulphur dioxide (SO<sub>2</sub>) emissions per 50 x 50 km<sup>2</sup> grid cell for the year 2007. The emissions are expressed in tonnes per year per grid cell.</p>'
where ResourceKeyID =(select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirSO2_RoadTransport.GeneralInformation')
		
update [EPRTRcms].[dbo].[ReviseResourceValue]
set ResourceValue = '<h3>Geographic Information System overlay</h3>
<p>Sulphur dioxide (SO<sub>2</sub>) emissions to air from road transport have been distributed according to the gridded emissions EMEP (European Monitoring and Evaluation Program) datasets officially reported by countries. The dataset covers the whole geographical area of Europe in a metric square resolution of 50x50 km&sup2;. This dataset has been transformed into vector polygons and projected into the E-PRTR WGS84 standard projection.</p>
<h3>Comparability&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;</h3>
<p>Considerable spatial variation is apparent. The main reasons for the difference are:</p>
<ul>
<li>The emissions from road transport are dependent on road network density</li>
<li>The emissions from road transport are allocated by road class-specific mileages of different vehicle categories</li>
</ul>'
where ResourceKeyID =(select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirSO2_RoadTransport.Methodology')
	
update [EPRTRcms].[dbo].[ReviseResourceValue]
set ResourceValue = '<h3>Emissions data</h3>
<p>Sulphur dioxide (SO<sub>2</sub>) emissions to air from road transport based for the year 2007 are based on datasets officially reported by countries to the <a href="http://www.unece.org/env/lrtap/welcome.html" target="_blank">United Nations Economic Commission for Europe (UNECE) Convention on Long-range Transboundary Air Pollution (CLRTAP)</a>. Each year, the Convention&rsquo;s <a href="http://www.ceip.at/" target="_blank">EMEP Centre on Emission Inventories and Projections (CEIP)</a> prepares gridded emission maps for certain pollutants and sectors. Specific EMEP/CEIP maps have been re-projected for use in this website.</p>
<p>When producing these maps, EMEP/CEIP firstly converts the detailed annual emissions data from countries into 11 aggregated sector groups. Where data is not available from countries or is considered inconsistent, EMEP/CEIP also performs a gap-filling process to improve the data quality. Emissions for recent years, such as 2007, are then spatially disaggregated on the basis of gridded data sets reported for the reference year 2005 using the EMEP &lsquo;Grid Scaler&rsquo;.</p>
<p>A technical overview of the gridding process performed by EMEP/CEIP is available <a href="http://www.ceip.at/fileadmin/inhalte/emep/pdf/gridding_process.pdf" target="_blank">here</a>. Additional information concerning the EMEP/CEIP gap-filling and gridding procedures, together with a download facility for the original maps (in the EMEP projection), is available <a href="http://www.ceip.at/emission-data-webdab/emissions-used-in-emep-models/" target="_blank">here</a>.</p>'
where ResourceKeyID =(select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirSO2_RoadTransport.SourceData')
																										

--MAP_06
update [EPRTRcms].[dbo].[ReviseResourceValue]
set ResourceValue = '<p>The map shows the sulphur dioxide (SO<sub>2</sub>) emissions per 50 x 50 km<sup>2</sup> grid cell. The emissions to air are expressed in tonnes per year per grid cell.</p>'
where ResourceKeyID =(select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirSO2_OtherMobileSources.GeneralInformation')
		
update [EPRTRcms].[dbo].[ReviseResourceValue]
set ResourceValue = '<h3>Geographic Information System overlay&nbsp;</h3>
<p>Sulphur dioxide (SO<sub>2</sub>) emissions into the air from other mobile sources have been distributed according to the gridded emissions EMEP (European Monitoring and Evaluation Program) datasets officially reported by countries. The dataset covers the whole geographical area of Europe in a metric square resolution of 50x50 km&sup2;. This dataset has been transformed into vector polygons and projected into the E-PRTR WGS84 standard projection.</p>
<h3>Comparibility</h3>
<p>Considerable spatial variation is apparent. The main reason for the difference is:</p>
<ul>
<li>Emissions from other mobile sources are dependent on population density, the number of aircraft landings and take-offs inland waterway networks and traffic volume and international shipping routes and shipping activity. </li>
</ul>'
where ResourceKeyID =(select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirSO2_OtherMobileSources.Methodology')
	
update [EPRTRcms].[dbo].[ReviseResourceValue]
set ResourceValue = '<p>Sulphur dioxide (SO<sub>2</sub>) emissions to air from other mobile sources for the year 2007 are based on datasets officially reported by countries to the <a href="http://www.unece.org/env/lrtap/welcome.html" target="_blank">United Nations Economic Commission for Europe (UNECE) Convention on Long-range Transboundary Air Pollution (CLRTAP)</a>. Each year, the Convention&rsquo;s <a href="http://www.ceip.at/" target="_blank">EMEP Centre on Emission Inventories and Projections (CEIP)</a> prepares gridded emission maps for certain pollutants and sectors. Specific EMEP/CEIP maps have been re-projected for use in this website.</p>
<p>When producing their maps, EMEP/CEIP firstly converts the detailed annual emissions data from countries into 11 aggregated sector groups.. Where data is not available from countries or is considered inconsistent, EMEP/CEIP also performs a gap-filling process to improve the data quality. Emissions for recent years, such as 2007, are then spatially disaggregated on the basis of gridded data sets reported for the reference year 2005 using the EMEP &lsquo;Grid Scaler&rsquo;.</p>
<p>A technical overview of the gridding process performed by EMEP/CEIP is available <a href="http://www.ceip.at/fileadmin/inhalte/emep/pdf/gridding_process.pdf" target="_blank">here</a>. Additional information concerning the EMEP/CEIP gap-filling and gridding procedures, together with a download facility for the original maps (in the EMEP projection), is available <a href="http://www.ceip.at/emission-data-webdab/emissions-used-in-emep-models/" target="_blank">here</a>.</p>'
where ResourceKeyID =(select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirSO2_OtherMobileSources.SourceData')


--MAP_07
update [EPRTRcms].[dbo].[ReviseResourceValue]
set ResourceValue = '<p>The map shows the carbon monoxide (CO) emissions per 50 x 50 km<sup>2</sup> grid cell for the year 2007. The emissions are expressed in tonnes per year per grid cell.</p>'
where ResourceKeyID =(select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirCO_NonIndustrialCombustion.GeneralInformation')
		
update [EPRTRcms].[dbo].[ReviseResourceValue]
set ResourceValue = '<h3>Geographic Information System overlay</h3>
<p>Carbon monoxide (CO) emissions into the air from non-industrial combustion plants have been distributed according to the gridded emissions EMEP (European Monitoring and Evaluation Program) datasets officially reported by countries. The dataset covers the whole geographical area of Europe in a metric square resolution of 50x50 km&sup2;. This dataset has been transformed into vector polygons and projected into the E-PRTR WGS84 standard projection.</p>
<h3>Comparability</h3>
<p>Considerable spatial variation is apparent. The main reason for the difference is:</p>
<ul>
<li>The spatial pattern of emissions from non-industrial combustion plants is dependent on population density.</li>
</ul>'
where ResourceKeyID =(select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirCO_NonIndustrialCombustion.Methodology')
	
update [EPRTRcms].[dbo].[ReviseResourceValue]
set ResourceValue = '<h3>Emissions data</h3>
<p>Carbon monoxide (CO) emissions to air from non-industrial combustion plants (mainly boilers in households, institutional and commercial premises) for the year 2007 are based on datasets officially reported by countries to the <a href="http://www.unece.org/env/lrtap/welcome.html" target="_blank">United Nations Economic Commission for Europe (UNECE) Convention on Long-range Transboundary Air Pollution (CLRTAP)</a>. Each year, the Convention&rsquo;s <a href="http://www.ceip.at/" target="_blank">EMEP Centre on Emission Inventories and Projections (CEIP)</a> prepares gridded emission maps for certain pollutants and sectors. Specific EMEP/CEIP maps have been re-projected for use in this website.</p>
<p>When producing their maps, EMEP/CEIP firstly converts the detailed annual emissions data from countries into 11 aggregated sector groups. Where data is not available from countries or is considered inconsistent, EMEP/CEIP also performs a gap-filling process to improve the data quality. Emissions for recent years, such as 2007, are then spatially disaggregated on the basis of gridded data sets reported for the reference year 2005 using the EMEP &lsquo;Grid Scaler&rsquo;.</p>
<p>A technical overview of the gridding process performed by EMEP/CEIP is available <a href="http://www.ceip.at/fileadmin/inhalte/emep/pdf/gridding_process.pdf" target="_blank">here</a>. Additional information concerning the EMEP/CEIP gap-filling and gridding procedures, together with a download facility for the original maps (in the EMEP projection), is available <a href="http://www.ceip.at/emission-data-webdab/emissions-used-in-emep-models/" target="_blank">here</a>.</p>'
where ResourceKeyID =(select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirCO_NonIndustrialCombustion.SourceData')
			

--MAP_08
update [EPRTRcms].[dbo].[ReviseResourceValue]
set ResourceValue = '<p>The map shows the carbon monoxide (CO) emissions per 50 x 50 km<sup>2</sup> grid cell for the year 2007. The emissions are expressed in tonnes per year per grid cell.</p>'
where ResourceKeyID =(select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirCO_RoadTransport.GeneralInformation')
		
update [EPRTRcms].[dbo].[ReviseResourceValue]
set ResourceValue = '<h3>Geographic Information System overlay</h3>
<p>Carbon monoxide (CO) emissions into the air from road transport have been distributed according to the gridded emissions EMEP (European Monitoring and Evaluation Program) datasets officially reported by countries. The dataset covers the whole geographical area of Europe in a metric square resolution of 50x50 km&sup2;. This dataset has been transformed into vector polygons and projected into the E-PRTR WGS84 standard projection.</p>
<h3>Comparability</h3>
<p>Considerable spatial variation is apparent. The main reasons for the difference are:</p>
<ul>
<li>The emissions from road transport are mainly dependent on road network density,</li>
<li>The emissions from road transport are allocated by road class-specific mileages of different vehicle categories.</li>
</ul>'
where ResourceKeyID =(select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirCO_RoadTransport.Methodology')
	
update [EPRTRcms].[dbo].[ReviseResourceValue]
set ResourceValue = '<h3>Emissions data</h3>
<p>Carbon monoxide (CO) emissions to air from road transport for the year 2007 are based on datasets officially reported by countries to the <a href="http://www.unece.org/env/lrtap/welcome.html" target="_blank">United Nations Economic Commission for Europe (UNECE) Convention on Long-range Transboundary Air Pollution (CLRTAP)</a>. Each year, the Convention&rsquo;s <a href="http://www.ceip.at/" target="_blank">EMEP Centre on Emission Inventories and Projections (CEIP)</a> prepares gridded emission maps for certain pollutants and sectors. Specific EMEP/CEIP maps have been re-projected for use in this website.</p>
<p>When producing their maps, EMEP/CEIP firstly converts the detailed annual emissions data from countries into 11 aggregated sector groups. Where data is not available from countries or is considered inconsistent, EMEP/CEIP also performs a gap-filling process to improve the data quality. Emissions for recent years, such as 2007, are then spatially disaggregated on the basis of gridded data sets reported for the reference year 2005 using the EMEP &lsquo;Grid Scaler&rsquo;.</p>
<p>A technical overview of the gridding process performed by EMEP/CEIP is available <a href="http://www.ceip.at/fileadmin/inhalte/emep/pdf/gridding_process.pdf" target="_blank">here</a>. Additional information concerning the EMEP/CEIP gap-filling and gridding procedures, together with a download facility for the original maps (in the EMEP projection), is available <a href="http://www.ceip.at/emission-data-webdab/emissions-used-in-emep-models/" target="_blank">here</a>.</p>
<p>&nbsp;</p>'
where ResourceKeyID =(select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirCO_RoadTransport.SourceData')


--MAP_09
update [EPRTRcms].[dbo].[ReviseResourceValue]
set ResourceValue = '<p>The map shows the carbon monoxide (CO) emissions per 50 x 50 km<sup>2</sup> grid cell for the year 2007. The carbon monoxide (CO) emissions to air are expressed in tonnes per year per grid cell.</p>'
where ResourceKeyID =(select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirCO_OtherMobileSources.GeneralInformation')
		
update [EPRTRcms].[dbo].[ReviseResourceValue]
set ResourceValue = '<h3>Geographic Information System overlay</h3>
<p>Carbon monoxide (CO) emissions to air from other mobile sources have been distributed according to the gridded emissions EMEP (European Monitoring and Evaluation Program) datasets officially reported by countries. The dataset covers the whole geographical area of Europe in a metric square resolution of 50x50 km&sup2;. This dataset has been transformed into vector polygons and projected into the E-PRTR WGS84 standard projection.</p>
<h3>Comparability</h3>
<p>Considerable spatial variation is apparent. The main reason for the difference is:</p>
<ul>
<li>Emissions from other mobile sources are dependent on population density, the number of aircraft landings and take-offs inland waterway networks and traffic volume and international shipping routes and shipping activity. </li>
</ul>'
where ResourceKeyID =(select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirCO_OtherMobileSources.Methodology')
	
update [EPRTRcms].[dbo].[ReviseResourceValue]
set ResourceValue = '<h3>Emissions data</h3>
<p>Carbon monoxide (CO) emissions to air from other mobile sources for the year 2007 are based on datasets officially reported by countries to the <a href="http://www.unece.org/env/lrtap/welcome.html" target="_blank">United Nations Economic Commission for Europe (UNECE) Convention on Long-range Transboundary Air Pollution (CLRTAP)</a>. Each year, the Convention&rsquo;s <a href="http://www.ceip.at/" target="_blank">EMEP Centre on Emission Inventories and Projections (CEIP)</a> prepares gridded emission maps for certain pollutants and sectors. Specific EMEP/CEIP maps have been re-projected for use in this website.</p>
<p>When producing their maps, EMEP/CEIP firstly converts the detailed annual emissions data from countries into 11 aggregated sector groups. Where data is not available from countries or is considered inconsistent, EMEP/CEIP also performs a gap-filling process to improve the data quality.</p>'
where ResourceKeyID =(select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirCO_OtherMobileSources.SourceData')


--MAP_10
update [EPRTRcms].[dbo].[ReviseResourceValue]
set ResourceValue = '<p>The map shows the PM<sub>10</sub> emissions per 50 x 50 km<sup>2</sup> grid cell for the year 2007. The PM<sub>10</sub> emissions to air are expressed in tonnes per year per grid cell.</p>'
where ResourceKeyID =(select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirPM10_NonIndustrialCombustion.GeneralInformation')
		
update [EPRTRcms].[dbo].[ReviseResourceValue]
set ResourceValue = '<h3>Geographic Information System overlay</h3>
<p>PM<sub>10</sub> emissions into the air from non-industrial combustion plants have been distributed according to gridded emissions EMEP (European Monitoring and Evaluation Program) datasets officially reported by countries. EMEP does not provide gridded data sets for PM<sub>10</sub>, therefore the PM<sub>10</sub> gridded data sets were compiled on the basis of the PM<sub>2.5</sub> and PM(coarse) gridded data sets available from EMEP (the assumption is that PM<sub>2.5</sub> + PM(coarse) is almost equivalent to PM<sub>10</sub>). The dataset covers the whole geographical area of Europe in a metric square resolution of 50x50 km&sup2;. This dataset has been transformed into vector polygons and projected into the E-PRTR WGS84 standard projection.</p>
<h3>Comparability</h3>
<p>Considerable spatial variation is apparent. The main reason for the difference is:&nbsp;</p>
<ul>
<li>The spatial pattern of emissions from non-industrial combustion plants is dependent on the population density</li>
</ul>'
where ResourceKeyID =(select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirPM10_NonIndustrialCombustion.Methodology')
	
update [EPRTRcms].[dbo].[ReviseResourceValue]
set ResourceValue = '<h3>Emissions data</h3>
<p>PM<sub>10</sub> emissions to air from non-industrial combustion plants (mainly boilers in households, institutional and commercial premises) for the year 2007 are based on datasets officially reported by countries to the <a href="http://www.unece.org/env/lrtap/welcome.html" target="_blank">United Nations Economic Commission for Europe (UNECE) Convention on Long-range Transboundary Air Pollution (CLRTAP)</a>. Each year, the Convention&rsquo;s <a href="http://www.ceip.at/" target="_blank">EMEP Centre on Emission Inventories and Projections (CEIP)</a> prepares gridded emission maps for certain pollutants and sectors. Specific EMEP/CEIP maps have been re-projected for use in this website.</p>
<p>When producing their maps, EMEP/CEIP firstly converts the detailed annual emissions data from countries into 11 aggregated sector groups. Where data is not available from countries or is considered inconsistent, EMEP/CEIP also performs a gap-filling process to improve the data quality.<span id="_marker">&nbsp;</span></p>'
where ResourceKeyID =(select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirPM10_NonIndustrialCombustion.SourceData')


--MAP_11
update [EPRTRcms].[dbo].[ReviseResourceValue]
set ResourceValue = '<p>The map shows the PM<sub>10</sub> emissions per 50 x 50 km<sup>2</sup> grid cell for the year 2007. The emissions are expressed in tonnes per year per grid cell.</p>'
where ResourceKeyID =(select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirPM10_RoadTransport.GeneralInformation')
		
update [EPRTRcms].[dbo].[ReviseResourceValue]
set ResourceValue = '<h3>Geographic Information System overlay</h3>
<p>PM<sub>10</sub> emissions into the air from non-industrial combustion plants have been distributed according to the gridded emissions EMEP (European Monitoring and Evaluation Program) datasets officially reported by countries. EMEP does not provide gridded data sets for PM<sub>10</sub>, therefore the PM<sub>10</sub> gridded data sets were compiled on the basis of the PM<sub>2.5</sub> and PM (coarse) gridded data sets available from EMEP (the assumption is that PM<sub>2.5</sub> + PM(coarse) is almost equivalent to PM<sub>10</sub>).</p>
<p>The dataset covers the whole geographical area of Europe in a metric square resolution of 50x50 km&sup2;. This dataset has been transformed into vector polygons and projected into the E-PRTR WGS84 standard projection.</p>
<h3>Comparability</h3>
<p>Considerable spatial variation is apparent. The main reasons for the differences are:</p>
<ul>
<li>The emissions from road transport are dependent on road network density,</li>
<li>The emissions from road transport are allocated by road class-specific mileages of different vehicle categories.</li>
</ul>'
where ResourceKeyID =(select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirPM10_RoadTransport.Methodology')
	
update [EPRTRcms].[dbo].[ReviseResourceValue]
set ResourceValue = '<h3>Emissions data</h3>
<p>PM<sub>10</sub> emissions to air from road transport for the year 2007 are based on datasets officially reported by countries to the <a href="http://www.unece.org/env/lrtap/welcome.html" target="_blank">United Nations Economic Commission for Europe (UNECE) Convention on Long-range Transboundary Air Pollution (CLRTAP)</a>. Each year, the Convention&rsquo;s <a href="http://www.ceip.at/" target="_blank">EMEP Centre on Emission Inventories and Projections (CEIP)</a> prepares gridded emission maps for certain pollutants and sectors. Specific EMEP/CEIP maps have been re-projected for use in this website.</p>
<p>&nbsp;When producing these maps, EMEP/CEIP firstly converts the detailed annual emissions data from countries into 11 aggregated sector groups. Where data is not available from countries or is considered inconsistent, EMEP/CEIP also performs a gap-filling process to improve the data quality. Emissions for recent years, such as 2007, are then spatially disaggregated on the basis of gridded data sets reported for the reference year 2005 using the EMEP &lsquo;Grid Scaler&rsquo;.</p>
<p>A technical overview of the gridding process performed by EMEP/CEIP is available <a href="http://www.ceip.at/fileadmin/inhalte/emep/pdf/gridding_process.pdf" target="_blank">here</a>. Additional information concerning the EMEP/CEIP gap-filling and gridding procedures, together with a download facility for the original maps (in the EMEP projection), is available <a href="http://www.ceip.at/emission-data-webdab/emissions-used-in-emep-models/" target="_blank">here</a>.</p>'
where ResourceKeyID =(select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirPM10_RoadTransport.SourceData')


--MAP_12
update [EPRTRcms].[dbo].[ReviseResourceValue]
set ResourceValue = '<p>The map shows the PM<sub>10</sub> emissions per 50 x 50 km<sup>2</sup> grid cell for the year 2007. The emissions are expressed in tonnes per year per grid cell.</p>'
where ResourceKeyID =(select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirPM10_OtherMobileSources.GeneralInformation')
		
update [EPRTRcms].[dbo].[ReviseResourceValue]
set ResourceValue = '<h3>Geographic Information System overlay</h3>
<p>PM<sub>10</sub> emissions to air from other mobile sources have been distributed according to the gridded emissions EMEP (European Monitoring and Evaluation Program) datasets officially reported by countries. EMEP does not provide gridded data sets for PM<sub>10</sub>, therefore the PM<sub>10</sub> gridded data sets were compiled on the basis of the PM<sub>2.5</sub> and PM (coarse) gridded data sets available from EMEP EMEP (the assumption is that PM<sub>2.5</sub> + PM(coarse) is almost equivalent to PM<sub>10</sub>).</p>
<p>The dataset covers the whole geographical area of Europe in a metric square resolution of 50x50 km&sup2;. This dataset has been transformed into vector polygons and projected into the E-PRTR WGS84 standard projection.</p>
<h3>Comparability</h3>
<p>Considerable spatial variation is apparent. The main reason for the difference is:</p>
<ul>
<li>The emissions from other mobile sources are dependent on population density, number of aircraft landings and take-offs, inland waterway networks, traffic volume on inland waterways, international shipping routes as well as shipping activities of international ships.</li>
</ul>'
where ResourceKeyID =(select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirPM10_OtherMobileSources.Methodology')
	
update [EPRTRcms].[dbo].[ReviseResourceValue]
set ResourceValue = '<h3>Emission data</h3>
<p>PM<sub>10</sub> emissions to air from other mobile sources for the year 2007 are based on datasets officially reported by countries to the <a href="http://www.unece.org/env/lrtap/welcome.html" target="_blank">United Nations Economic Commission for Europe (UNECE) Convention on Long-range Transboundary Air Pollution (CLRTAP)</a>. Each year, the Convention&rsquo;s <a href="http://www.ceip.at/" target="_blank">EMEP Centre on Emission Inventories and Projections (CEIP)</a> prepares gridded emission maps for certain pollutants and sectors. Specific EMEP/CEIP maps have been re-projected for use in this website.</p>
<p>&nbsp;</p>
<p>When producing these maps, EMEP/CEIP firstly converts the detailed annual emissions data from countries into 11 aggregated sector groups. Where data is not available from countries or is considered inconsistent, EMEP/CEIP also performs a gap-filling process to improve the data quality. Emissions for recent years, such as 2007, are then spatially disaggregated on the basis of gridded data sets reported for the reference year 2005 using the EMEP &lsquo;Grid Scaler&rsquo;.</p>
<p>A technical overview of the gridding process performed by EMEP/CEIP is available <a href="http://www.ceip.at/fileadmin/inhalte/emep/pdf/gridding_process.pdf" target="_blank">here</a>. Additional information concerning the EMEP/CEIP gap-filling and gridding procedures, together with a download facility for the original maps (in the EMEP projection), is available <a href="http://www.ceip.at/emission-data-webdab/emissions-used-in-emep-models/" target="_blank">here</a>.</p>'
where ResourceKeyID =(select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirPM10_OtherMobileSources.SourceData')


--MAP_13
update [EPRTRcms].[dbo].[ReviseResourceValue]
set ResourceValue = '<p>The map shows the PM<sub>10</sub> emissions to air from agricultural sources per 50 x 50 km<sup>2</sup> grid for the year 2007. The emissions are expressed in tonnes per year per grid cell.</p>'
where ResourceKeyID =(select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirPM10_Agriculture.GeneralInformation')
		
update [EPRTRcms].[dbo].[ReviseResourceValue]
set ResourceValue = '<h3>Geographic Information System overlay</h3>
<p>PM<sub>10</sub> emissions to air from agricultural sources have been distributed according to the gridded emissions EMEP (European Monitoring and Evaluation Program) datasets officially reported by countries. EMEP does not provide gridded data sets for PM<sub>10</sub>, therefore the PM<sub>10</sub> gridded data sets were compiled on the basis of the PM<sub>2.5</sub> and PM (coarse) gridded data sets available from EMEP.</p>
<p>The dataset covers the whole geographical area of Europe in a metric square resolution of 50x50 km&sup2;. This dataset has been transformed into vector polygons and projected into the E-PRTR WGS84 standard projection.</p>
<h3>Comparability</h3>
<p>Considerable spatial variation is apparent. The main reason for the difference is:</p>
<ul>
<li>The spatial pattern of emissions from agricultural activities is dependent on the land use data, based on the CORINE Land Cover 2000 data set (<a href="http://www.eea.europa.eu/data-and-maps/data/corine-land-cover-2000-clc2000-seamless-vector-database" target="_blank">CLC2000</a>), the Global Land Cover data set (<a href="http://www.eea.europa.eu/data-and-maps/data/global-land-cover-250m" target="_blank">GLC</a>) or similar country specific data sets.&nbsp; &nbsp;</li>
</ul>'
where ResourceKeyID =(select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirPM10_Agriculture.Methodology')
	
update [EPRTRcms].[dbo].[ReviseResourceValue]
set ResourceValue = '<h3>Emissions data</h3>
<p>PM<sub>10</sub> emissions to air from agricultural sources for the year 2007 are based on datasets officially reported by countries to the <a href="http://www.unece.org/env/lrtap/welcome.html" target="_blank">United Nations Economic Commission for Europe (UNECE) Convention on Long-range Transboundary Air Pollution (CLRTAP)</a>. Each year, the Convention&rsquo;s <a href="http://www.ceip.at/" target="_blank">EMEP Centre on Emission Inventories and Projections (CEIP)</a> prepares gridded emission maps for certain pollutants and sectors. Specific EMEP/CEIP maps have been re-projected for use in this website.</p>
<p>When producing their maps, EMEP/CEIP firstly converts the detailed annual emissions data from countries into 11 aggregated sector groups. Where data is not available from countries or is considered inconsistent, EMEP/CEIP also performs a gap-filling process to improve the data quality. Emissions for recent years, such as 2007, are then spatially disaggregated on the basis of gridded data sets reported for the reference year 2005 using the EMEP &lsquo;Grid Scaler&rsquo;.</p>
<p>A technical overview of the gridding process performed by EMEP/CEIP is available <a href="http://www.ceip.at/fileadmin/inhalte/emep/pdf/gridding_process.pdf" target="_blank">here</a>. Additional information concerning the EMEP/CEIP gap-filling and gridding procedures, together with a download facility for the original maps (in the EMEP projection), is available <a href="http://www.ceip.at/emission-data-webdab/emissions-used-in-emep-models/" target="_blank">here</a>.</p>'
where ResourceKeyID =(select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirPM10_Agriculture.SourceData')


--MAP_14
update [EPRTRcms].[dbo].[ReviseResourceValue]
set ResourceValue = '<p>The map shows ammonia (NH<sub>3</sub>) emissions per 50 x 50 km<sup>2</sup> grid cell for the year 2007. The emissions are expressed in tonnes per year per grid cell.</p>'
where ResourceKeyID =(select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirNH3_Agriculture.GeneralInformation')
		
update [EPRTRcms].[dbo].[ReviseResourceValue]
set ResourceValue = '<h3>Geographic Information System overlay</h3>
<p>Ammonia (NH<sub>3</sub>) emissions to air from agricultural sources have been distributed according to the gridded emissions EMEP (European Monitoring and Evaluation Program) datasets officially reported by countries. The dataset covers the whole geographical area of Europe in a metric square resolution of 50x50 km&sup2;. This dataset has been transformed into vector polygons and projected into the E-PRTR WGS84 standard projection.</p>
<h3>Comparability</h3>
<p>Considerable spatial variation is apparent. The main reason for the difference is:</p>
<ul>
<li>The spatial pattern of emissions from agricultural activities is dependent on the land use data, based on the CORINE Land Cover 2000 data set (<a href="http://www.eea.europa.eu/data-and-maps/data/corine-land-cover-2000-clc2000-seamless-vector-database" target="_blank">CLC2000</a>), the Global Land Cover data set (<a href="http://www.eea.europa.eu/data-and-maps/data/global-land-cover-250m" target="_blank">GLC</a>), or similar country specific data sets and the animal density.</li>
</ul>'
where ResourceKeyID =(select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirNH3_Agriculture.Methodology')
	
update [EPRTRcms].[dbo].[ReviseResourceValue]
set ResourceValue = '<h3>Emissions data</h3>
<p>Ammonia (NH<sub>3</sub>) emissions to air from agricultural activities for the year 2007 are based on datasets officially reported by countries to the <a href="http://www.unece.org/env/lrtap/welcome.html" target="_blank">United Nations Economic Commission for Europe (UNECE) Convention on Long-range Transboundary Air Pollution (CLRTAP)</a>. Each year, the Convention&rsquo;s <a href="http://www.ceip.at/" target="_blank">EMEP Centre on Emission Inventories and Projections (CEIP)</a> prepares gridded emission maps for certain pollutants and sectors. Specific EMEP/CEIP maps have been re-projected for use in this website.</p>
<p>When producing their maps, EMEP/CEIP firstly converts the detailed annual emissions data from countries into 11 aggregated sector groups. Where data is not available from countries or is considered inconsistent, EMEP/CEIP also performs a gap-filling process to improve the data quality. Emissions for recent years, such as 2007, are then spatially disaggregated on the basis of gridded data sets reported for the reference year 2005 using the EMEP &lsquo;Grid Scaler&rsquo;.</p>
<p>A technical overview of the gridding process performed by EMEP/CEIP is available <a href="http://www.ceip.at/fileadmin/inhalte/emep/pdf/gridding_process.pdf" target="_blank">here</a>. Additional information concerning the EMEP/CEIP gap-filling and gridding procedures, together with a download facility for the original maps (in the EMEP projection), is available <a href="http://www.ceip.at/emission-data-webdab/emissions-used-in-emep-models/" target="_blank">here</a>.</p>'
where ResourceKeyID =(select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='AirNH3_Agriculture.SourceData')

GO