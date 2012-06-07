INSERT INTO [dbo].[LOV_AREAGROUP] ([Code], [Name])
 SELECT 'E-PRTR', 'All Reporting States for E-PRTR'
  UNION ALL
 SELECT 'EU15', 'EU15'
  UNION ALL
 SELECT 'EU25', 'EU25'
  UNION ALL
 SELECT 'EU27', 'EU27'
GO

