echo update

set SQLCMDSERVER=sdkcga6302
set SQLCMDDBNAME=EPRTRcms
set SQLCMDUSER=gis
set SQLCMDPASSWORD=tmggis


rem update from ver 2.0
SET basedir=2.0
sqlcmd -i %basedir%\00_upgrade.sql

PAUSE