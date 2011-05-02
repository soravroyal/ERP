--UPDATE to take out the sting '(EPER)' from [EPRTRcms].dbo.tAT_ResourceValue.ResourceValue
UPDATE [EPRTRcms].dbo.tAT_ResourceValue
SET [EPRTRcms].dbo.tAT_ResourceValue.ResourceValue = replace([EPRTRcms].dbo.tAT_ResourceValue.ResourceValue, '(EPER)', '')
FROM
[EPRTRcms].dbo.tAT_ResourceValue INNER JOIN [EPRTRcms].dbo.tAT_ResourceKey
ON tAT_ResourceValue.ResourceKeyID = tAT_ResourceKey.ResourceKeyID
WHERE [EPRTRcms].dbo.tAT_ResourceValue.ResourceValue LIKE '%(EPER)%'
and [EPRTRcms].dbo.tAT_ResourceKey.ResourceType like '%lov_an%';
