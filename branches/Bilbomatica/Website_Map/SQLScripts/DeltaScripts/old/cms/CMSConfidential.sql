UPDATE [EPRTRcms].[dbo].[ReviseResourceKey]
   SET [KeyDescription] = 'General description of confidentiality. Will be shown in menu: Facility Level, Sheet: Confidentiality.'
      ,[KeyTitle] = 'Facility Search - List'
 WHERE ResourceKey = 'ConfidentialityExplanationFacilityList' and ResourceType = 'Common'


UPDATE [EPRTRcms].[dbo].[ReviseResourceKey]
   SET [KeyDescription] = 'General description of confidentiality for a single facility. Will be shown on Facility Details: Sheet: Confidentiality.'
      ,[KeyTitle] = 'Facility Search - Facility Details'
 WHERE ResourceKey = 'ConfidentialityExplanationFacilityLevel' and ResourceType = 'Common'

UPDATE [EPRTRcms].[dbo].[ReviseResourceKey]
   SET [KeyDescription] = 'Short description of confidentiality for pollutant transfers. Will be shown in menu: Pollutant Transfers, Sheet: Confidentiality, Above tables.'
      ,[KeyTitle] = 'Pollutant Transfers - Text 1'
 WHERE ResourceKey = 'ConfidentialityExplanationPT1' and ResourceType = 'Common'

UPDATE [EPRTRcms].[dbo].[ReviseResourceKey]
   SET [KeyDescription] = 'Longer description of confidentiality for pollutant transfers. Will be shown in menu: Pollutant Transfers, Sheet: Confidentiality, Below tables.'
      ,[KeyTitle] = 'Pollutant Transfers - Text 2'
 WHERE ResourceKey = 'ConfidentialityExplanationPT2' and ResourceType = 'Common'

UPDATE [EPRTRcms].[dbo].[ReviseResourceKey]
   SET [KeyDescription] = 'Short description of confidentiality for pollutant releases. Will be shown in menu: Pollutant Releases, Sheet: Confidentiality, Above tables.'
      ,[KeyTitle] = 'Pollutant Releases - Text 1'
 WHERE ResourceKey = 'ConfidentialityExplanationPR1' and ResourceType = 'Common'

UPDATE [EPRTRcms].[dbo].[ReviseResourceKey]
   SET [KeyDescription] = 'Longer description of confidentiality for pollutant releases. Will be shown in menu: Pollutant Releases, Sheet: Confidentiality, Below tables.'
      ,[KeyTitle] = 'Pollutant Releases - Text 2'
 WHERE ResourceKey = 'ConfidentialityExplanationPR2' and ResourceType = 'Common'

UPDATE [EPRTRcms].[dbo].[ReviseResourceKey]
   SET [KeyDescription] = 'Short description of confidentiality for waste transfers. Will be shown in menu: Waste Transfers, Sheet: Confidentiality, Above tables.'
      ,[KeyTitle] = 'Waste Transfers - Text 1'
 WHERE ResourceKey = 'ConfidentialityExplanationWT1' and ResourceType = 'Common'

UPDATE [EPRTRcms].[dbo].[ReviseResourceKey]
   SET [KeyDescription] = 'Longer description of confidentiality for waste transfers. Will be shown in menu: Waste Transfers, Sheet: Confidentiality, Below tables.'
      ,[KeyTitle] = 'Waste Transfers - Text 2'
 WHERE ResourceKey = 'ConfidentialityExplanationWT2' and ResourceType = 'Common'

UPDATE [EPRTRcms].[dbo].[ReviseResourceKey]
   SET [KeyDescription] = 'Short description of confidentiality for waste receivers. Will be shown in menu: Waste Transfers, Sheet: Haz. receivers, Sub sheet for one country, Sheet: Confidentiality, Above tables.'
      ,[KeyTitle] = 'Waste receivers - Text 1'
 WHERE ResourceKey = 'ConfidentialityExplanationWTRecievers1' and ResourceType = 'Common'

UPDATE [EPRTRcms].[dbo].[ReviseResourceKey]
   SET [KeyDescription] = 'Longer description of confidentiality for waste recievers. Will be shown in menu: Waste Transfers, Sheet: Haz. receivers, Sub sheet for one country, Sheet: Confidentiality, Below tables.'
      ,[KeyTitle] = 'Waste receivers - Text 2'
 WHERE ResourceKey = 'ConfidentialityExplanationWTRecievers2' and ResourceType = 'Common'


UPDATE [EPRTRcms].[dbo].[ReviseResourceKey]
   SET [KeyDescription] = 'Short description of confidentiality for pollutant releases. Will be shown in menu: Industrial Activities, Sheet: Confidentiality, Radio button:Pollutant releases, Above tables.'
      ,[KeyTitle] = 'Industrial Activities - Pollutant Releases'
 WHERE ResourceKey = 'ConfReleaseDesc' and ResourceType = 'Pollutant'

UPDATE [EPRTRcms].[dbo].[ReviseResourceKey]
   SET [KeyDescription] = 'Short description of confidentiality for pollutant transfers. Will be shown in menu: Industrial Activities, Sheet: Confidentiality, Radio button:Pollutant transfers, Above tables.'
      ,[KeyTitle] = 'Industrial Activities - Pollutant Transfers'
 WHERE ResourceKey = 'ConfTransfersDesc' and ResourceType = 'Pollutant'

UPDATE [EPRTRcms].[dbo].[ReviseResourceKey]
   SET [KeyDescription] = 'Short description of confidentiality for waste transfers. Will be shown in menu: Industrial Activities, Sheet: Confidentiality, Radio button:Waste transfers, Above tables.'
      ,[KeyTitle] = 'Industrial Activities - Waste Transfers'
 WHERE ResourceKey = 'ConfWasteDesc' and ResourceType = 'WasteTransfers'

GO


