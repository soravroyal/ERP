UPDATE [dbo].[ReviseResourceValue]
   SET [ResourceValue] = 'The total releases and off site transfers in waste water of single pollutants as well as aggregated amount of waste transferred off-site might be effected by confidentiality claims.' 
   WHERE ResourcekeyID = (select ResourceKeyID from [dbo].[ReviseResourceKey] where ResourceType='AreaOverview' and ResourceKey='ConfidentialityExplanation')
GO