use EPRTRmaster
-- insert new values into LOV_NACEACTIVITY
-- Code = '46.63'
-- Code = '46.64'

if (
	select COUNT(*) 
	from LOV_NACEACTIVITY
	where Code = '46.63'
	) = 0
insert into LOV_NACEACTIVITY
select
	'46.63',
	'Wholesale of mining, construction and civil engineering machinery',
	2007,
	null,
	234,
	null,
	null,
	null


if (
	select COUNT(*) 
	from LOV_NACEACTIVITY
	where Code = '46.64'
	) = 0
insert into LOV_NACEACTIVITY
select
	'46.64',
	'Wholesale of machinery for the textile industry and of sewing and knitting machines',
	2007,
	null,
	234,
	null,
	null,
	null

select * from LOV_NACEACTIVITY where Code like '46.6%'
