INSERT INTO [dbo].[LOV_MEDIUM] ([Code], [Name], [StartYear])
 SELECT 'AIR', 'Air', 2001
  UNION ALL
 SELECT 'LAND', 'Soil', 2001
  UNION ALL
 SELECT 'WATER', 'Water', 2001
  UNION ALL
 SELECT 'WASTEWATER', 'Waste Water', 2001
GO
