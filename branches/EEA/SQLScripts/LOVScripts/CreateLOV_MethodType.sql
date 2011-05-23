INSERT INTO [dbo].[LOV_METHODTYPE] ([Code], [Name], [StartYear])
 SELECT 'CEN/ISO', 'Internationally approved measurement standard', 2007
  UNION ALL
 SELECT 'ETS', 'Guidelines for the monitoring and reporting of greenhouse gas emissions under the Emission Trading Scheme.', 2007
  UNION ALL
 SELECT 'IPCC', 'IPCC Guidelines', 2007
  UNION ALL
 SELECT 'UNECE/EMEP', 'UNECE/EMEP EMEP/CORINAIR Emission Inventory Guidebook', 2007
  UNION ALL
 SELECT 'PER', 'Measurement/Calculation Methodology already prescribed by the competent authority in a licence or an operating permit for that facility', 2007
  UNION ALL
 SELECT 'NRB', 'National or regional binding measurement/calculation methodology prescribed by legal act for the pollutant and facility concerned.', 2007
  UNION ALL
 SELECT 'ALT', 'Alternative measurement methodology in accordance with existing CEN/ISO measurement standards', 2007
  UNION ALL
 SELECT 'CRM', 'Measurement methodology for the performance of which is demonstrated by means of certified reference materials and accepted by competent authority.', 2007
  UNION ALL
 SELECT 'MAB', 'Mass balance method which is accepted by the competent authority', 2007
  UNION ALL
 SELECT 'SSC', 'European-wide sector specific calculation method', 2007
  UNION ALL
 SELECT 'WEIGH', 'Weighing', 2007
  UNION ALL
 SELECT 'OTH', 'Other measurement/calculation methodology', 2007
GO
