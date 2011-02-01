-------------------------------------------------------------------
--	This scipt adds the following 5 lines to file ControllerString
--	with culture code en-GB
--
--	menuTools=Tools
--	Overview_Map=Overview Map
--	Find_Location=Find Location
--	Print_and_Download=Print and Download
--	Bookmarks=Bookmarks
-------------------------------------------------------------------

use EPRTRcms

insert into tAT_ResourceKey values('menuTools','MAP_ControllerStrings',0,0,null)	
insert into tAT_ResourceValue values(
	(
		select ResourceKeyID from tAT_ResourceKey 
		where ResourceKey = 'menuTools'
		and	 ResourceType = 'MAP_ControllerStrings'
	),
	'en-GB',
	'Tools')
	
insert into tAT_ResourceKey values('Overview_Map','MAP_ControllerStrings',0,0,null)	
insert into tAT_ResourceValue values(
	(
		select ResourceKeyID from tAT_ResourceKey 
		where ResourceKey = 'Overview_Map'
		and	 ResourceType = 'MAP_ControllerStrings'
	),
	'en-GB',
	'Overview Map')
	
insert into tAT_ResourceKey values('Find_Location','MAP_ControllerStrings',0,0,null)	
insert into tAT_ResourceValue values(
	(
		select ResourceKeyID from tAT_ResourceKey 
		where ResourceKey = 'Find_Location'
		and	 ResourceType = 'MAP_ControllerStrings'
	),
	'en-GB',
	'Find Location')
	
insert into tAT_ResourceKey values('Print_and_Download','MAP_ControllerStrings',0,0,null)	
insert into tAT_ResourceValue values(
	(
		select ResourceKeyID from tAT_ResourceKey 
		where ResourceKey = 'Print_and_Download'
		and	 ResourceType = 'MAP_ControllerStrings'
	),
	'en-GB',
	'Print and Download')
	
insert into tAT_ResourceKey values('Bookmarks','MAP_ControllerStrings',0,0,null)	
insert into tAT_ResourceValue values(
	(
		select ResourceKeyID from tAT_ResourceKey 
		where ResourceKey = 'Bookmarks'
		and	 ResourceType = 'MAP_ControllerStrings'
	),
	'en-GB',
	'Bookmarks')
