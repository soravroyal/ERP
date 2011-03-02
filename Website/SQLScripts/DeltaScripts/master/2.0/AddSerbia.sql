/*
 Add Serbia as reporting country
*/

DECLARE @RS INT
SELECT @RS=[LOV_CountryID] FROM [dbo].[LOV_COUNTRY] WHERE [Code]='RS'


--RBD
IF NOT EXISTS (SELECT * FROM LOV_RIVERBASINDISTRICT WHERE LOV_CountryID = @RS)
	INSERT INTO [dbo].[LOV_RIVERBASINDISTRICT](	[Code],	[Name],	[StartYear],[LOV_CountryID])
		SELECT 'RS-1', 'Serbia', 2011, @RS

--NUTS1
IF NOT EXISTS (SELECT * FROM LOV_NUTSREGION WHERE LOV_CountryID = @RS)
	INSERT INTO [dbo].[LOV_NUTSREGION](	[Code],	[Name],	[StartYear],[ParentID],[LOV_CountryID])
		SELECT 'RS1', 'Serbia - North', 2011, NULL, @RS
		UNION ALL
		SELECT 'RS2', 'RS2: Serbia - South', 2011, NULL, @RS

--NUTS2
DECLARE @NUTS2 INT

SELECT @NUTS2=[LOV_NUTSREGIONID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='RS1'
IF NOT EXISTS (SELECT * FROM LOV_NUTSREGION WHERE ParentID = @NUTS2)		
	INSERT INTO [dbo].[LOV_NUTSREGION](	[Code],	[Name],	[StartYear],[ParentID],[LOV_CountryID])
		SELECT 'RS11', 'City of Belgrade', 2011, @NUTS2, @RS
		UNION ALL
		SELECT 'RS12', 'Region of Vojvodina', 2011, @NUTS2, @RS

SELECT @NUTS2=[LOV_NUTSREGIONID] FROM [dbo].[LOV_NUTSREGION] WHERE [Code]='RS2'
IF NOT EXISTS (SELECT * FROM LOV_NUTSREGION WHERE ParentID = @NUTS2)		
	INSERT INTO [dbo].[LOV_NUTSREGION](	[Code],	[Name],	[StartYear],[ParentID],[LOV_CountryID])
		SELECT 'RS21', 'Region of Sumadija and Western Serbia', 2011, @NUTS2, @RS
		UNION ALL
		SELECT 'RS22', 'Region of South and Easth Serbia', 2011, @NUTS2, @RS
		UNION ALL
		SELECT 'RS23', 'Region of Kosovo and Metohia', 2011, @NUTS2, @RS

-- Add to area group		
IF NOT EXISTS (SELECT * FROM LOV_COUNTRYAREAGROUP WHERE LOV_AreaGroupID = 1 AND LOV_CountryID =@RS)		
	insert into [dbo].LOV_COUNTRYAREAGROUP (LOV_AreaGroupID, LOV_CountryID)
	values (1, @RS)