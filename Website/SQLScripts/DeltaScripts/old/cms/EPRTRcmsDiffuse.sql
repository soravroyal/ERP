
-- ********************** Group **************'

INSERT INTO [EPRTRcms].[dbo].[LOV_ContentsGroup]([Code],[Name],[StartYear],[EndYear])
     VALUES('DIFSRC', 'Diffuse Sources', 2007, NULL)

-- ********************** Subheadline **************'

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('Subheadline',	'DiffuseSources',0,'This text is presented at the top of the diffuse sources page','Subheadline',	4)

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceType='DiffuseSources' and ResourceKey='Subheadline'),
	'en-GB','Diffuse subheadline')


-- ****************** N - RBD ******************************************
INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('nrbd.TitleShort',	'DiffuseSources',0,'','N (RBD) - Short title',	4)

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('nrbd.TitleFull',	'DiffuseSources',0,'','N (RBD) - Full title',	4)

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('nrbd.GeneralInformation',	'DiffuseSources',1,'','N (RBD) - General Information',	4)

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('nrbd.Methodology',	'DiffuseSources',1,'','N (RBD) - Methodology',	4)

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('nrbd.SourceData',	'DiffuseSources',1,'','N (RBD) - Source Data',	4)



INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='nrbd.TitleShort'),
	'en-GB','Nitrogen loss from agriculture, kg per total RBD area')

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='nrbd.TitleFull'),
	'en-GB','Agricultural N loss to surface water bodies (in kg N/ha RBD land area/year)')

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='nrbd.GeneralInformation'),
	'en-GB','n rbd general info')

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='nrbd.Methodology'),
	'en-GB','n rbd methodology')

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='nrbd.SourceData'),
	'en-GB','n rbd data source')



-- ****************** N - Aggriculture ha ******************************************
INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('naggr.TitleShort',	'DiffuseSources',0,'','N (agr. land) - Short title',	4)

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('naggr.TitleFull',	'DiffuseSources',0,'','N (agr. land) - Full title',	4)

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('naggr.GeneralInformation',	'DiffuseSources',1,'','N (agr. land) - General Information',	4)

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('naggr.Methodology',	'DiffuseSources',1,'','N (agr. land) - Methodology',	4)

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('naggr.SourceData',	'DiffuseSources',1,'','N (agr. land) - Source Data',	4)


INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='naggr.TitleShort'),
	'en-GB','Nitrogen loss from agriculture, kg per agricultural area')

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='naggr.TitleFull'),
	'en-GB','Agricultural N loss to surface water bodies (in kg N/ha agricultural land area/year)')

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='naggr.GeneralInformation'),
	'en-GB','n aggr general info')

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='naggr.Methodology'),
	'en-GB','n aggr methodology')

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='naggr.SourceData'),
	'en-GB','n aggr data source')



-- ****************** P - RBD ******************************************
INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('prbd.TitleShort',	'DiffuseSources',0,'','P (RBD) - Short title',	4)

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('prbd.TitleFull',	'DiffuseSources',0,'','P (RBD) - Full title',	4)

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('prbd.GeneralInformation',	'DiffuseSources',1,'','P (RBD) - General Information',	4)

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('prbd.Methodology',	'DiffuseSources',1,'','P (RBD) - Methodology',	4)

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('prbd.SourceData',	'DiffuseSources',1,'','P (RBD) - Source Data',	4)


INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='prbd.TitleShort'),
	'en-GB','Phosphorus loss from agriculture, kg per total RBD area')

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='prbd.TitleFull'),
	'en-GB','Agricultural P loss to surface water bodies (in kg P/ha RBD land area/year)')

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='prbd.GeneralInformation'),
	'en-GB','p rbd general info')

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='prbd.Methodology'),
	'en-GB','p rbd methodology')

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='prbd.SourceData'),
	'en-GB','p rbd data source')



--****************** N - Aggriculture ha ******************************************
INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('paggr.TitleShort',	'DiffuseSources',0,'','P (agr. land) - Short title',	4)

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('paggr.TitleFull',	'DiffuseSources',0,'','P (agr. land) - Full title',	4)

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('paggr.GeneralInformation',	'DiffuseSources',1,'','P (agr. land) - General Information',	4)

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('paggr.Methodology',	'DiffuseSources',1,'','P (agr. land) - Methodology',	4)

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('paggr.SourceData',	'DiffuseSources',1,'','P (agr. land) - Source Data',	4)

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='paggr.TitleShort'),
	'en-GB','Phosphorus loss from agriculture, kg per agricultural area')

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='paggr.TitleFull'),
	'en-GB','Agricultural P loss to surface water bodies (in kg P/ha agricultural land area/year)')

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='paggr.GeneralInformation'),
	'en-GB','p aggr general info')

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='paggr.Methodology'),
	'en-GB','p aggr methodology')

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceKey='paggr.SourceData'),
	'en-GB','p aggr data source')


GO
