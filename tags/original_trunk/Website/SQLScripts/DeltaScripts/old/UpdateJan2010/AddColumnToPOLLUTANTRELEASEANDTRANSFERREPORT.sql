--------------------------------------------------------------------------------------
--	Ticket #753:
--	The database currently only holds information about the "Published" date. 
--	This information is set automatically.
--	This should be changed so the published date can be set manually to the date where data 
--	are to be published on the website. In addition, the inforamtion about the date where 
--	data was imported should be stored in the database.
--	Action:
--	To store the import date, column "Imported" is added to table
--	"POLLUTANTRELEASEANDTRANSFERREPORT"
--------------------------------------------------------------------------------------

if not exists ( select * from EPRTRmaster.INFORMATION_SCHEMA.COLUMNS
	where TABLE_NAME='POLLUTANTRELEASEANDTRANSFERREPORT' and COLUMN_NAME='Imported' )
	alter table EPRTRmaster.dbo.POLLUTANTRELEASEANDTRANSFERREPORT ADD Imported datetime NULL

