INSERT INTO [dbo].[LOV_METHODBASIS] ([Code], [Name], [StartYear])
 SELECT 'M', 'Measured', 2001
  UNION ALL
 SELECT 'C', 'Calculated', 2001
  UNION ALL
 SELECT 'E', 'Estimated', 2001
GO
