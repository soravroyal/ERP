use EPRTRmaster
-- insert new values into LOV_RIVERBASINDISTRICT
-- Code: NO5105  , name: Hordaland
-- Code: NO5106 , name: Sogn og Fjordane

if (
	select COUNT(*) 
	from LOV_RIVERBASINDISTRICT
	where Code = 'NO5105'
	) = 0
insert into LOV_RIVERBASINDISTRICT
select
	'NO5105',
	'Hordaland',
	2007,
	null,
	max(LOV_CountryID) 
from LOV_COUNTRY where Code = 'NO'	

if (
	select COUNT(*) 
	from LOV_RIVERBASINDISTRICT
	where Code = 'NO5106'
	) = 0
insert into LOV_RIVERBASINDISTRICT
select
	'NO5106',
	'Sogn og Fjordane',
	2007,
	null,
	max(LOV_CountryID) 
from LOV_COUNTRY where Code = 'NO'	

