--------------------------------------------------------------------------------
--
--	Data import sript that needs to be called befor 
--	copyEPRTRmasterViews2EPRTRwebTables is called
-- 	(when copying newly imported data from a member state to the WEB DB)
--
--	WOS, Atkins 0202201
--
--------------------------------------------------------------------------------

use EPRTRmaster

truncate table EPRTRmaster.dbo.tAT_METHOD
 
insert into EPRTRmaster.dbo.tAT_METHOD (MethodListID,MethodCode,MethodDesignation)
select
	mu.MethodListID,
	lov.Code,
	mu.MethodDesignation
from METHODUSED mu
inner join LOV_METHODTYPE lov
on mu.LOV_MethodTypeID = lov.LOV_MethodTypeID
where mu.MethodListID in (
	select mu.MethodListID from METHODUSED mu
	group by mu.MethodListID
	having COUNT(mu.MethodListID) = 1
	)
go 

insert into EPRTRmaster.dbo.tAT_METHOD (MethodListID,MethodCode,MethodDesignation)
select
	MethodListID, 
	EPRTRmaster.dbo.fAT_GETMETHODTYPE(MethodListID),
	EPRTRmaster.dbo.fAT_GETMETHODDESIGNATION(MethodListID)
from(
		select mu.MethodListID from METHODUSED mu
		group by mu.MethodListID
		having COUNT(mu.MethodListID) > 1
)i

--select * from EPRTRmaster.dbo.tAT_METHOD where MethodCode like '%|%' order by 4