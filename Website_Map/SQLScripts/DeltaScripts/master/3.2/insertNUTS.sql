use EPRTRmaster
-- insert new values into LOV_NUTSREGION
-- Code: NOZZ  , name: Extra-Regio1
-- Code: NOZZZ , name: Extra-Regio2

if (
	select COUNT(*) 
	from LOV_NU
	where Code = 'NOZZ'
	) = 0
insert into LOV_NUTSREGION
select
	'NOZZ',
	'Extra-Regio1',
	2007,
	null,
	max(LOV_CountryID) 
from LOV_COUNTRY where Code = 'NO'	

if (
	select COUNT(*) 
	from LOV_NUTSREGION
	where Code = 'NOZZZ'
	) = 0
insert into LOV_NUTSREGION
select
	'NOZZZ',
	'Extra-Regio2',
	2007,
	null,
	max(LOV_CountryID) 
from LOV_COUNTRY where Code = 'NO'	

