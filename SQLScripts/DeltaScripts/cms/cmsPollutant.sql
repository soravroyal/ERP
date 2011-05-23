
INSERT INTO [ReviseResourceKey]([ResourceKey],[ResourceType],[AllowHTML],[KeyDescription],[KeyTitle],[ContentsGroupID])
     VALUES('PollutantPageContent',	'Library',1,'Temporare replacement of pollutant information page','Temporary pollutant content',	2)

INSERT INTO [ReviseResourceValue]([ResourceKeyID],[CultureCode],[ResourceValue])
	VALUES((select ResourceKeyID from [EPRTRcms].[dbo].[ReviseResourceKey] where ResourceType='Library' and ResourceKey='PollutantPageContent'),
	'en-GB','<h1>Pollutant Descriptions</h1>
<p>Content goes here...</p>')

