DECLARE @GROUP INT
SELECT @GROUP=[LOV_PollutantID] FROM [dbo].[LOV_POLLUTANT] WHERE [Code]='GRHGAS'
INSERT INTO [dbo].[LOV_POLLUTANT] (
	[Code],
	[Name],
	[StartYear],
	[ParentID],
	[CAS]
)
 SELECT 'CO2 EXCL BIOMASS', 'Carbon dioxide (CO2) excluding biomass', 2007, @GROUP, NULL
