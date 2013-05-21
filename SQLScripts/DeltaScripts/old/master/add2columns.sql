----------------------------------------------------------------------------------
--	Column eperAnnex3_ID and eperPollutant_ID have been removed 
--	by Bilbomatica's script that uploads 
--	the updated data of EPER into E-PRTR.
--	Unfortunately these column are referenced by the web-application and thus 
--	they have to be reinserted into the table
--	wos, 26-08-2010
----------------------------------------------------------------------------------

IF NOT EXISTS ( SELECT * FROM [EPRTRmaster].[INFORMATION_SCHEMA].[COLUMNS]
    WHERE
        TABLE_NAME='LOV_ANNEXIACTIVITY' AND
        COLUMN_NAME='eperAnnex3_ID'
)
 ALTER TABLE [EPRTRmaster].[dbo].[LOV_ANNEXIACTIVITY]
    ADD eperAnnex3_ID [int]


IF NOT EXISTS ( SELECT * FROM [EPRTRmaster].[INFORMATION_SCHEMA].[COLUMNS]
    WHERE
        TABLE_NAME='LOV_POLLUTANT' AND
        COLUMN_NAME='eperPollutant_ID'
)
 ALTER TABLE [EPRTRmaster].[dbo].[LOV_POLLUTANT]
    ADD eperPollutant_ID [int]
