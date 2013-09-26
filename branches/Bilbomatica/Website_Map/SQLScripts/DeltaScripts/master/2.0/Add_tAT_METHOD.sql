--------------------------------------------------------------------------------
--
--	Delta script creating at new table METHOD table and importing data
--
--	WOS, Atkins 0202201
--
--------------------------------------------------------------------------------

use EPRTRmaster

if object_id('EPRTRmaster.dbo.tAT_METHOD')is not null DROP TABLE EPRTRmaster.dbo.tAT_METHOD
CREATE TABLE EPRTRmaster.dbo.tAT_METHOD(
	[MethodID] [int] IDENTITY(1,1) NOT NULL,
	[MethodListID] [int] NOT NULL,
	[MethodCode] [nvarchar](255) NULL,
	[MethodDesignation] [nvarchar](4000) NULL,
CONSTRAINT [MethodID] PRIMARY KEY CLUSTERED ([MethodID] ASC)) ON [PRIMARY]
go
 
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

