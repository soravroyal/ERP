use EPRTRcms



INSERT INTO [EPRTRcms].[dbo].[LOV_ContentsGroup]
           ([Code]
           ,[Name]
           ,[StartYear]
           ,[EndYear])
     VALUES ('HELP', 'Help Texts', 2007 ,NULL)
GO


INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]
           ([ResourceKey]
           ,[ResourceType]
           ,[AllowHTML]
           ,[KeyDescription]
           ,[KeyTitle]
           ,[ContentsGroupID])
     VALUES
           ('SearchHelpFacilityHeader'
           ,'Help'
           ,0
           ,'This is the header for the help page available from Facility Search'
           ,'Facility Search Help Page Header'
           ,(SELECT LOV_ContentsGroupID FROM LOV_ContentsGroup WHERE Code='HELP'))
GO

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]
           ([ResourceKeyID]
           ,[CultureCode]
           ,[ResourceValue])
     VALUES
           ((SELECT ResourceKeyID FROM ReviseResourceKey WHERE (ResourceType='Help' AND ResourceKey='SearchHelpFacilityHeader'))
           ,'en-GB'
           ,'Facility Search Help')
GO


INSERT INTO [EPRTRcms].[dbo].[ReviseResourceKey]
           ([ResourceKey]
           ,[ResourceType]
           ,[AllowHTML]
           ,[KeyDescription]
           ,[KeyTitle]
           ,[ContentsGroupID])
     VALUES
           ('SearchHelpFacility'
           ,'Help'
           ,1
           ,'This is the help page available from Facility Search'
           ,'Facility Search Help Page'
           ,(SELECT LOV_ContentsGroupID FROM LOV_ContentsGroup WHERE Code='HELP'))
GO

INSERT INTO [EPRTRcms].[dbo].[ReviseResourceValue]
           ([ResourceKeyID]
           ,[CultureCode]
           ,[ResourceValue])
     VALUES
           ((SELECT ResourceKeyID FROM ReviseResourceKey WHERE (ResourceType='Help' AND ResourceKey='SearchHelpFacility'))
           ,'en-GB'
           ,'<p>This text helps you obtain more accurate search results with&nbsp;the E-PRTR website.</p>
<p>A search may include any number of criteria.</p>
<h2>Country</h2>
<p>Use the country selector to specify which country you are interested in. Alternatively, choose EU15 or EU25 to limit the search to sets of early member states.</p>
<h2>Region and River Bassin Districts</h2>
<p>If you have chosen an individual country, you may want to narrow down the geographical area even further. This can be done by selecting either a specific&nbsp; administrative region or a river bassin district.</p>
<h2>Year</h2>
<p>In the year selector you must specify which year your interested in. The default year is always the most recent for which data is available.</p>
<h2>Facility Name</h2>
<p>Here you can type the beginning of any word that is a part the facilities name. <strong>&nbsp;</strong></p>
<p>This search string is also applied on the list of Parent companies. I.e. the result may be larger than than expected because additional matches are found based on the parent company name.</p>
<h2>Town/village</h2>
<p>This text field is used to search for a specific town or village. The website only recognizes town names that have been reported by Member States. E.g. the Danish capital is only found typing "K&oslash;benhavn"; and not&nbsp;"Copenhagen" or any other translation.</p>
<h2>Activity</h2>
<p>Details ...</p>
<h2>Pollutant releases and transfers</h2>
<p>Details ...</p>
<h2>Waste transfers</h2>
<p>Details ...</p>
<p>&nbsp;</p>')
GO




