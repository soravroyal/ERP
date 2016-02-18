
USE [EPRTRcms]
GO

/*
* APPEND ContentsGroups
*/

declare @temp table (ResourceKey varchar(max), ResourceType varchar(max), KeyTitle varchar(max), ResourceValue varchar(max), lang nvarchar(10));

INSERT INTO @temp (ResourceKey, ResourceType, KeyTitle, ResourceValue, lang)
 VALUES
('HR0','LOV_NUTSREGION','Label, NUTSREGION','HRVATSKA','en-GB'),
('HR03','LOV_NUTSREGION','Label, NUTSREGION','Jadranska Hrvatska','en-GB'),
('HR031','LOV_NUTSREGION','Label, NUTSREGION','Primorsko-goranska županija','en-GB'),
('HR032','LOV_NUTSREGION','Label, NUTSREGION','Licko-senjska županija','en-GB'),
('HR033','LOV_NUTSREGION','Label, NUTSREGION','Zadarska županija','en-GB'),
('HR034','LOV_NUTSREGION','Label, NUTSREGION','Šibensko-kninska županija','en-GB'),
('HR035','LOV_NUTSREGION','Label, NUTSREGION','Splitsko-dalmatinska županija','en-GB'),
('HR036','LOV_NUTSREGION','Label, NUTSREGION','Istarska županija','en-GB'),
('HR037','LOV_NUTSREGION','Label, NUTSREGION','Dubrovacko-neretvanska županija','en-GB'),
('HR04','LOV_NUTSREGION','Label, NUTSREGION','Kontinentalna Hrvatska','en-GB'),
('HR041','LOV_NUTSREGION','Label, NUTSREGION','Grad Zagreb','en-GB'),
('HR042','LOV_NUTSREGION','Label, NUTSREGION','Zagrebacka županija','en-GB'),
('HR043','LOV_NUTSREGION','Label, NUTSREGION','Krapinsko-zagorska županija','en-GB'),
('HR044','LOV_NUTSREGION','Label, NUTSREGION','Varaždinska županija','en-GB'),
('HR045','LOV_NUTSREGION','Label, NUTSREGION','Koprivnicko-križevacka županija','en-GB'),
('HR046','LOV_NUTSREGION','Label, NUTSREGION','Medimurska županija','en-GB'),
('HR047','LOV_NUTSREGION','Label, NUTSREGION','Bjelovarsko-bilogorska županija','en-GB'),
('HR048','LOV_NUTSREGION','Label, NUTSREGION','Viroviticko-podravska županija','en-GB'),
('HR049','LOV_NUTSREGION','Label, NUTSREGION','Požeško-slavonska županija','en-GB'),
('HR04A','LOV_NUTSREGION','Label, NUTSREGION','Brodsko-posavska županija','en-GB'),
('HR04B','LOV_NUTSREGION','Label, NUTSREGION','Osjecko-baranjska županija','en-GB'),
('HR04C','LOV_NUTSREGION','Label, NUTSREGION','Vukovarsko-srijemska županija','en-GB'),
('HR04D','LOV_NUTSREGION','Label, NUTSREGION','Karlovacka županija','en-GB'),
('HR04E','LOV_NUTSREGION','Label, NUTSREGION','Sisacko-moslavacka županija','en-GB'),
('HRZ','LOV_NUTSREGION','Label, NUTSREGION','EXTRA-REGIO NUTS 1','en-GB'),
('HRZZ','LOV_NUTSREGION','Label, NUTSREGION','Extra-Regio NUTS 2','en-GB')

DECLARE @rrkid int
DECLARE @rrk varchar(max)
DECLARE @rrt varchar(max)
DECLARE @rval varchar(max)
DECLARE @rttl varchar(max)
DECLARE @lcg varchar(max)
Declare @rlng nvarchar(10)

DECLARE cur CURSOR FOR SELECT ResourceKey, ResourceType, ResourceValue, lang FROM @temp
OPEN cur

FETCH NEXT FROM cur INTO @rrk, @rrt, @rval, @rlng

WHILE @@FETCH_STATUS = 0 BEGIN
    --EXEC mysp @rkey, @rval ... -- call your sp here

	SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;
	BEGIN TRANSACTION;
		SET @rrkid = (SELECT ResourceKeyID FROM [dbo].[tAT_ResourceKey] where [ResourceKey] = @rrk and [ResourceType] = @rrt);

		UPDATE [dbo].[tAT_ResourceValue]
			SET [ResourceValue] = @rval 
			WHERE [ResourceKeyID] = @rrkid and [CultureCode] = @rlng;

		IF @@ROWCOUNT = 0
		BEGIN
		
			INSERT INTO [dbo].[tAT_ResourceValue]
			([ResourceKeyID],[CultureCode],[ResourceValue])
				VALUES (@rrkid,@rlng,@rval);
		END
	COMMIT TRANSACTION;

	FETCH NEXT FROM cur INTO  @rrk, @rrt, @rval, @rlng
END

CLOSE cur    
DEALLOCATE cur