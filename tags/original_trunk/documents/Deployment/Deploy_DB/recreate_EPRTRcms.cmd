@ECHO OFF

REM See http://msdn.microsoft.com/en-us/library/ms162773.aspx for reference.
REM Set environment variables SQLCMDUSER, SQLCMDPASSWORD and SQLCMDSERVER
REM before running this script.

SET basedir=C:\E-PRTR\SQLScripts

REM Drop and recreate existing database:
SET SQLCMDDBNAME=master
sqlcmd -Q "ALTER DATABASE EPRTRcms SET SINGLE_USER WITH ROLLBACK IMMEDIATE; DROP DATABASE EPRTRcms;"
sqlcmd -Q "CREATE DATABASE EPRTRcms COLLATE Latin1_General_CI_AS;"

REM Restore database based on backup:
sqlcmd -Q "RESTORE DATABASE [EPRTRcms] FROM  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL10.MSSQLSERVER\MSSQL\Backup\EPRTRcms.bak' WITH  FILE = 1,  NOUNLOAD,  REPLACE,  STATS = 10"



