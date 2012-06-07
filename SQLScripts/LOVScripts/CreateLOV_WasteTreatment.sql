INSERT INTO [dbo].[LOV_WASTETREATMENT] ([Code], [Name], [StartYear])
 SELECT 'R', 'Destined for recovery', 2007
  UNION ALL
 SELECT 'D', 'Destined for disposal', 2007
GO
