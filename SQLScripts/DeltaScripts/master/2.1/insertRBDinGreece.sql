use EPRTRmaster
-- insert new values into LOV_RIVERBASINDISTRICT
-- Code: NOBS  , name: Barents Sea
-- Code: NONOS , name: Norwegian Sea
-- Code: NONS , name: North Sea

if (
	select COUNT(*) 
	from LOV_RIVERBASINDISTRICT
	where Code = 'GR15'
	) = 0
insert into LOV_RIVERBASINDISTRICT
select
	'GR15',
	'North Aegean Sea',
	2007,
	null,
	max(LOV_CountryID) 
from LOV_COUNTRY where Code = 'GR'	



--select * from LOV_RIVERBASINDISTRICT