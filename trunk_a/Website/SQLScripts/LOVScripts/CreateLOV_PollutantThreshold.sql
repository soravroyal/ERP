--truncate table EPRTRmaster.dbo.LOV_POLLUTANTTHRESHOLD
insert into EPRTRmaster.dbo.LOV_POLLUTANTTHRESHOLD(
	[LOV_PollutantID],
	[LOV_MediumID],
	[Threshold],
	[StartYear]
)
select
	LOV_PollutantID,
	LOV_MediumID,
	Value,
	2007 
from 
	EPRTRshapes.dbo.PullutantThreshold_2 t
inner join
	EPRTRmaster.dbo.LOV_POLLUTANT p
on	t.PollutantCode = p.Code
inner join
	EPRTRmaster.dbo.LOV_MEDIUM m
on	t.MediumCode = m.Code 


--select * from EPRTRmaster.dbo.LOV_POLLUTANTTHRESHOLD
