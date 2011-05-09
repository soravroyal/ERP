/*
Upgrading CMS database from ver 1.9 (prior to version in DB)
*/

--set new version number
:Setvar major 2
:Setvar minor 0

PRINT 'UPDATING: $(SQLCMDSERVER)\$(SQLCMDDBNAME) FROM VERSION $(basedir) . . .'

:On Error exit
:out upgrade.log

-- Include deltascripts here
:r$(basedir)\..\..\common\AddVersion.sql
go
:r$(basedir)\DiffuseAir.sql
go


--Uncomment this when released (will only insert version no. once) :
/*
IF NOT EXISTS (SELECT * FROM tAT_version WHERE Major_version = $(major) AND Minor_version = $(minor))
	INSERT INTO tAT_version(Major_version, Minor_version) VALUES ($(major), $(minor));
*/
