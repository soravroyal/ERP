use EPRTRmaster
-- insert new values into LOV_RIVERBASINDISTRICT
-- Code: NOBAR  , name: Barents Sea
-- Code: NONOS , name: Norwegian Sea
-- Code: NONS , name: North Sea

if (
	select COUNT(*) 
	from LOV_RIVERBASINDISTRICT
	where Code = 'NOBAR'
	) = 0
insert into LOV_RIVERBASINDISTRICT
select
	'NOBAR',
	'Barents Sea',
	2007,
	null,
	max(LOV_CountryID) 
from LOV_COUNTRY where Code = 'NO'	

if (
	select COUNT(*) 
	from LOV_RIVERBASINDISTRICT
	where Code = 'NONOS'
	) = 0
insert into LOV_RIVERBASINDISTRICT
select
	'NONOS',
	'Norwegian Sea',
	2007,
	null,
	max(LOV_CountryID) 
from LOV_COUNTRY where Code = 'NO'	

if (
	select COUNT(*) 
	from LOV_RIVERBASINDISTRICT
	where Code = 'NONS'
	) = 0
insert into LOV_RIVERBASINDISTRICT
select
	'NONS',
	'North Sea',
	2007,
	null,
	max(LOV_CountryID) 
from LOV_COUNTRY where Code = 'NO'	

--select * from LOV_RIVERBASINDISTRICT