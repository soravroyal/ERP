INSERT INTO [ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
 VALUES('ConfidentialityExplanation','AreaOverview',1,'General description of confidentiality. Will be shown in menu: Area overview, Sheet: Confidentiality.','Areaoverview',3)

INSERT INTO [ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [dbo].[ReviseResourceKey] where ResourceType='AreaOverview' and ResourceKey='ConfidentialityExplanation'),
	'en-GB','To be delivered by COM')
	