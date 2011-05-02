----------------------------------------------------------------------
--	The following script insert a new column for EPER codes 
--	in table LOV_POLLUTANT in both the EPRTRmaster and EPRTRpublic DB
----------------------------------------------------------------------

if not exists ( select * from EPRTRmaster.INFORMATION_SCHEMA.COLUMNS
	where TABLE_NAME='LOV_POLLUTANT' and COLUMN_NAME='CodeEPER' )
alter table EPRTRmaster.dbo.LOV_POLLUTANT add CodeEPER nvarchar(255)


if not exists ( select * from EPRTRpublic.INFORMATION_SCHEMA.COLUMNS
	where TABLE_NAME='LOV_POLLUTANT' and COLUMN_NAME='CodeEPER' )
alter table EPRTRpublic.dbo.LOV_POLLUTANT add CodeEPER nvarchar(255)
go 


----------------------------------------------------------------------
--	The following script updates pollutants with existing EPRTR Codes 
----------------------------------------------------------------------

update EPRTRpublic.dbo.LOV_POLLUTANT set 
	CodeEPER = Code + 'EPER',
	StartYear='2001'
where LOV_PollutantID in (1,2,3,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,23,24,25,26,27,28,29,30,31,32,33,57,58,59,60
	,61,62,63,65,67,68,69,70,72,73,75,81,83,85,93,94,95,97,98,99)

update EPRTRpublic.dbo.LOV_POLLUTANT set 
	CodeEPER = Code + 'EPER',
	StartYear='2007'
where LOV_PollutantID in (47,89,90,91,92)


update EPRTRpublic.dbo.LOV_POLLUTANT set 
	CodeEPER = Code 
where LOV_PollutantID =100



update EPRTRmaster.dbo.LOV_POLLUTANT set 
	CodeEPER = Code + 'EPER',
	StartYear='2001'
where LOV_PollutantID in (1,2,3,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,23,24,25,26,27,28,29,30,31,32,33,57,58,59,60
	,61,62,63,65,67,68,69,70,72,73,75,81,83,85,93,94,95,97,98,99)

update EPRTRmaster.dbo.LOV_POLLUTANT set 
	CodeEPER = Code + 'EPER',
	StartYear='2007'
where LOV_PollutantID in (47,89,90,91,92)


update EPRTRmaster.dbo.LOV_POLLUTANT set 
	CodeEPER = Code 
where LOV_PollutantID =100


----------------------------------------------------------------------
--	more updates realated to implementation of 
--	extended functionallity developed by Biblomatica
----------------------------------------------------------------------

update EPRTRmaster.dbo.LOV_POLLUTANT set 
	StartYear = 2007,
	EPERPollutant_ID = null,
	CodeEPER = null
where Code = 'CO2'

update EPRTRmaster.dbo.LOV_POLLUTANT set 
	CodeEPER = 'CO2EPER'
where Code = 'CO2 in EPER'

