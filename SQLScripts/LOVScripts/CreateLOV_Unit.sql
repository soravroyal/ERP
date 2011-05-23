INSERT INTO [dbo].[LOV_UNIT] ([Code], [Name], [StartYear], [EndYear])
 SELECT 'PCS', 'pieces', 2001, NULL
  UNION ALL
 SELECT 'KGM', 'kilogram', 2001, NULL
  UNION ALL
 SELECT 'TNE', 'tonne (metric ton)', 2001, NULL
  UNION ALL
 SELECT 'KWH', 'kilowatt hour', 2001, NULL
  UNION ALL
 SELECT 'MWH', 'megawatt hour', 2001, NULL
  UNION ALL
 SELECT 'GWH', 'gigawatt hour', 2001, NULL
  UNION ALL
 SELECT 'KWT', 'kilowatt', 2001, NULL
  UNION ALL
 SELECT 'MAW', 'megawatt', 2001, NULL
  UNION ALL
 SELECT 'A90', 'gigawatt', 2001, NULL
  UNION ALL
 SELECT 'GV', 'gigajoule', 2001, NULL
  UNION ALL
 SELECT 'LTR', 'litre', 2001, NULL
  UNION ALL
 SELECT 'HLT', 'hectolitre', 2001, NULL
  UNION ALL
 SELECT 'MTQ', 'cubic metre', 2001, NULL
  UNION ALL
 SELECT 'MTK', 'square metre', 2001, NULL
  UNION ALL
 SELECT 'UNKNOWN', 'N/A', 2001, 2004
GO
