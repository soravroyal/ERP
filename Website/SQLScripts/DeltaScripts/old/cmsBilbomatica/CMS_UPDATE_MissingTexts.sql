USE EPRTRcms

--Facility.SubHeadlineEPER
INSERT INTO [EPRTRcms].[dbo].[tAT_ResourceKey] 
([ResourceKey],[ResourceType],[AllowHTML],[EditCMS],[KeyDescription]) 
VALUES ('SubHeadlineEPER','Facility',0,0,'');

INSERT INTO [EPRTRcms].[dbo].[tAT_ResourceValue] ([ResourceKeyID] ,[CultureCode],[ResourceValue]) 
VALUES ((SELECT ResourceKeyID FROM dbo.tAT_ResourceKey where ResourceKey = 'SubHeadlineEPER' and ResourceType = 'Facility'),'en-GB','This report will display the reported emissions of a specific facility. You can also search for a facility by using the map.');


--Common.ControlledEPER
INSERT INTO [EPRTRcms].[dbo].[tAT_ResourceKey] 
([ResourceKey],[ResourceType],[AllowHTML],[EditCMS],[KeyDescription]) 
VALUES ('ControlledEPER','Common',0,0,'');

INSERT INTO [EPRTRcms].[dbo].[tAT_ResourceValue] ([ResourceKeyID] ,[CultureCode],[ResourceValue]) 
VALUES ((SELECT ResourceKeyID FROM dbo.tAT_ResourceKey where ResourceKey = 'ControlledEPER' and ResourceType = 'Common'),'en-GB','Controlled emissions');


--UPDATE TO: DiffuseSources.aSubheadline
update ReviseResourceValue
set ResourceValue = '<p style="TEXT-ALIGN: justify"><span lang="EN-GB">This section presently provides only a limited set of maps on <span style="COLOR: #993300">releases into the air</span> from selected sectors considered as diffuse sources. </span></p>  <p style="TEXT-ALIGN: justify"><span lang="EN-GB">The data presented in this section are derived from a range of different sources and data collection processes. The data are based on datasets <span style="COLOR: #993300">officially reported</span> by countries to the United Nations Economic Commission for Europe (UNECE) Convention on Long-range Transboundary Air Pollution (<span style="COLOR: #993300">CLRTAP</span>). Each year, the Convention&rsquo;s EMEP <span style="COLOR: #993300">Centre on Emission Inventories and Projections (CEIP)</span> prepares gridded emission maps for certain pollutants and sectors. </span></p>  <p style="TEXT-ALIGN: justify"><span lang="EN-GB">A selection of these maps has been re-projected for use in this website. </span></p>  <p style="TEXT-ALIGN: justify"><span lang="EN-GB">The Commission, assisted by the European Environment Agency are currently working to enhance the content of this section. New information will be published during the course of 2011.</span></p>'
where ResourceKeyID = (select ResourceKeyID from ReviseResourceKey where ResourceType='DiffuseSources' and ResourceKey='aSubheadline')
	and CultureCode ='en-GB' 
