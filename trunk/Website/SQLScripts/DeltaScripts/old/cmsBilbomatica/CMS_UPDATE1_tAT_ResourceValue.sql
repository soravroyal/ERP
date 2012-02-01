--UPDATE the ResourceValue from '%EPER regulation%' to 'EPER Decision 2000/479/EC'
UPDATE [EPRTRcms].[dbo].[tAT_ResourceValue] 
SET [ResourceValue] = 'EPER Decision 2000/479/EC' 
WHERE Resourcekeyid = (SELECT [ResourceKeyID]
FROM [EPRTRcms].[dbo].[tAT_ResourceValue] where ResourceValue like '%EPER regulation%');