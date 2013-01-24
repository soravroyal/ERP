/*
Upgrading MASTER database from ver 2.0
*/

--set new version number
:Setvar major 2
:Setvar minor 1

PRINT 'UPDATING: $(SQLCMDSERVER)\$(SQLCMDDBNAME) FROM VERSION $(basedir) . . .'

:On Error exit
:out upgrade.log


-- Include deltascripts here

:r $(basedir)\..\..\common\AddVersion.sql
go

:r $(basedir)\update_script_AllIn1.sql
go

:r $(basedir)\update_script_AddAccidentalColumn.sql
go

:r $(basedir)\alter_WEB_RECEIVINGCOUNTRY.sql
go

--Uncomment this when released (will only insert version no. once) :

IF NOT EXISTS (SELECT * FROM tAT_version WHERE Major_version = $(major) AND Minor_version = $(minor))
	INSERT INTO tAT_version(Major_version, Minor_version) VALUES ($(major), $(minor));

