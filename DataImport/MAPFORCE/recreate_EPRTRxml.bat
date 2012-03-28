@ECHO OFF

REM See http://msdn.microsoft.com/en-us/library/ms162773.aspx for reference.
REM Set environment variables SQLCMDUSER, SQLCMDPASSWORD and SQLCMDSERVER
REM before running this script.

SET basedir=C:\EIONET\SQLScripts

REM Clear existing database:
SET SQLCMDDBNAME=master
sqlcmd -Q "ALTER DATABASE EPRTRxml SET SINGLE_USER WITH ROLLBACK IMMEDIATE; DROP DATABASE EPRTRxml;"
sqlcmd -Q "CREATE DATABASE EPRTRxml COLLATE Latin1_General_CI_AS;"

REM Create database structure:
SET SQLCMDDBNAME=EPRTRxml
sqlcmd -i %basedir%\CreateTables_EPRTRxml.sql
sqlcmd -i %basedir%\CreateReferences_EPRTRxml.sql
sqlcmd -i %basedir%\Add_aux_cols_4_xmlimport.sql
sqlcmd -i %basedir%\copyXMLdata2EPRTR.sql
pause
