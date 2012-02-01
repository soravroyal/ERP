rem set /p SQLCMDSERVER= Type in name of server and press Enter:
rem set /p SQLCMDUSER= Type in name of database user and press Enter:
rem set /p SQLCMDPASSWORD= Type in password for database user and press Enter: 
rem set SQLCMDSERVER=SDKCGA6306
rem set SQLCMDUSER=SA
rem set SQLCMDPASSWORD=TMGGIS
rem call recreate_EPRTRweb.cmd
rem call recreate_EPRTRcms.cmd
call recreate_EPRTRmaster.cmd
call recreate_EPRTRreview.cmd
call recreate_EPRTRpublic.cmd
sqlcmd -i Grant_rights.sql
sqlcmd -i Delete_Entries_EPRTRcms.sql
sqlcmd -i Update_EPRTRcms.sql
pause