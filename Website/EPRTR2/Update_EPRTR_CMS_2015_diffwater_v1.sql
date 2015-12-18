USE [EPRTRcms]
GO


declare @temp table (ResourceKey varchar(max), KeyTitle varchar(max), ResourceValue varchar(max), LOV_ContentsGroup varchar(max));

INSERT INTO @temp (ResourceKey, KeyTitle, ResourceValue, LOV_ContentsGroup)
 VALUES
('AtmosphericDeposition','Atmospheric deposition','Atmospheric deposition','DIFSRC_WATER'),
('Agriculture', 'Agriculture','Agriculture','DIFSRC_WATER'),
('Transport', 'Transport','Transport','DIFSRC_WATER'),
('UWWTP','UWWTP','UWWTPs not in E-PRTR','DIFSRC_WATER'),
('Un-connectedHouseholds','Un-connected households','Un-connected households','DIFSRC_WATER'),
('InlandNavigation', 'Inland navigation','Inland navigation','DIFSRC_WATER'),
('WATER_ZN_UWWTP.TitleShort', 'WATER_ZN_UWWTP, Title Short','Zinc emissions from UWWTPs not in E-PRTR (kg/ha surface water RBDSU)','Diffuse Sources Water, ZN');


DECLARE @cntgrp int
DECLARE @rrkid int
DECLARE @rrk varchar(max)
DECLARE @rval varchar(max)
DECLARE @rttl varchar(max)
DECLARE @lcg varchar(max)
/*
* APPEND ReviseResourceKeys with correct LOV_ContentsGroupIDs
*/

DECLARE cur CURSOR FOR SELECT ResourceKey, KeyTitle, LOV_ContentsGroup FROM @temp
OPEN cur

FETCH NEXT FROM cur INTO @rrk, @rttl, @lcg

WHILE @@FETCH_STATUS = 0 BEGIN
    --EXEC mysp @rkey, @rval ... -- call your sp here
	SET @cntgrp = (SELECT [LOV_ContentsGroupID] FROM [dbo].[LOV_ContentsGroup] where Code = @lcg);
	SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
	BEGIN TRANSACTION;
		INSERT INTO [dbo].[ReviseResourceKey]
			([ResourceKey] ,[ResourceType] ,[AllowHTML] ,[KeyDescription] ,[KeyTitle] ,[ContentsGroupID])
		VALUES
			(@rrk,'DiffuseSources','1','',@rttl,@cntgrp);

	COMMIT TRANSACTION;

	FETCH NEXT FROM cur INTO  @rrk, @rttl, @lcg
END

CLOSE cur    
DEALLOCATE cur


DECLARE cur CURSOR FOR SELECT ResourceKey, ResourceValue FROM @temp
OPEN cur

FETCH NEXT FROM cur INTO @rrk, @rval

WHILE @@FETCH_STATUS = 0 BEGIN
    --EXEC mysp @rkey, @rval ... -- call your sp here

	SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
	BEGIN TRANSACTION;
		SET @rrkid = (SELECT ResourceKeyID FROM [dbo].[ReviseResourceKey] where [ResourceKey] = @rrk);

		UPDATE [dbo].[ReviseResourceValue]
			SET [ResourceValue] = @rval 
			WHERE [ResourceKeyID] = @rrkid and [CultureCode] = 'en-GB';

		IF @@ROWCOUNT = 0
		BEGIN
			INSERT INTO [dbo].[ReviseResourceValue]
			([ResourceKeyID],[CultureCode],[ResourceValue])
				VALUES (@rrkid, 'en-GB',@rval);
		END
	COMMIT TRANSACTION;

	FETCH NEXT FROM cur INTO  @rrk, @rval
END

CLOSE cur    
DEALLOCATE cur



/*
* DELETE dublicates from tAT_ResourceValue 
*/
declare @temp2 table (ResourceValueID int);

INSERT INTO @temp2 (ResourceValueID)
  SELECT a.[ResourceValueID]
  FROM [dbo].[tAT_ResourceValue] a inner join
	   [dbo].[tAT_ResourceKey] b on a.ResourceKeyID = b.ResourceKeyID inner join
	   [dbo].[ReviseResourceKey] c on b.ResourceKey = c.ResourceKey left outer join
	   [dbo].[ReviseResourceValue] d on a.CultureCode = d.CultureCode and c.ResourceKeyID = d.ResourceKeyID
  where a.CultureCode = 'en-GB' and ((a.ChangedDate > d.ChangedDate) or (d.ChangedDate is Null));

DECLARE @rvid int

DECLARE cur CURSOR FOR SELECT ResourceValueID FROM @temp2
OPEN cur

FETCH NEXT FROM cur INTO @rvid

WHILE @@FETCH_STATUS = 0 BEGIN
    --EXEC mysp @rkey, @rval ... -- call your sp here

	SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
	BEGIN TRANSACTION;

		DELETE FROM [dbo].[tAT_ResourceValue]
		WHERE ResourceValueID = @rvid;

	COMMIT TRANSACTION;

	FETCH NEXT FROM cur INTO @rvid
END

CLOSE cur    
DEALLOCATE cur

