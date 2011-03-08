--------------------------------------------------------------------------------
--
--	Data import sript that needs to be called befor 
--	copyEPRTRmasterViews2EPRTRwebTables is called
-- 	(when copying newly imported data from a member state to the WEB DB)
--
--	WOS, Atkins 02032010
--
--------------------------------------------------------------------------------

exec EPRTRmaster.dbo.pAT_METHOD

--/****** Object:  StoredProcedure [dbo].[pAT_WASTETRANSFER]    Script Date: 03/08/2011 13:06:42 ******/
--SET ANSI_NULLS ON
--GO

--SET QUOTED_IDENTIFIER ON
--GO

--create procedure [dbo].[pAT_METHOD]
--as 
--begin

--	truncate table EPRTRmaster.dbo.tAT_METHOD
	 
--	insert into EPRTRmaster.dbo.tAT_METHOD (MethodListID,MethodCode,MethodDesignation)
--	select
--		mu.MethodListID,
--		lov.Code,
--		mu.MethodDesignation
--	from METHODUSED mu
--	inner join LOV_METHODTYPE lov
--	on mu.LOV_MethodTypeID = lov.LOV_MethodTypeID
--	where mu.MethodListID in (
--		select mu.MethodListID from METHODUSED mu
--		group by mu.MethodListID
--		having COUNT(mu.MethodListID) = 1
--		)

--	insert into EPRTRmaster.dbo.tAT_METHOD (MethodListID,MethodCode,MethodDesignation)
--	select
--		MethodListID, 
--		EPRTRmaster.dbo.fAT_GETMETHODTYPE(MethodListID),
--		EPRTRmaster.dbo.fAT_GETMETHODDESIGNATION(MethodListID)
--	from(
--			select mu.MethodListID from METHODUSED mu
--			group by mu.MethodListID
--			having COUNT(mu.MethodListID) > 1
--	)i

--end