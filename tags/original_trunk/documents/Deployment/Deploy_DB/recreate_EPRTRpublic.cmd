@ECHO OFF

REM See http://msdn.microsoft.com/en-us/library/ms162773.aspx for reference.
REM Set environment variables SQLCMDUSER, SQLCMDPASSWORD and SQLCMDSERVER
REM before running this script.

SET basedir=C:\E-PRTR\SQLScripts

REM Drop and recreate existing database:
SET SQLCMDDBNAME=master
sqlcmd -Q "ALTER DATABASE EPRTRpublic SET SINGLE_USER WITH ROLLBACK IMMEDIATE; DROP DATABASE EPRTRpublic;"
sqlcmd -Q "CREATE DATABASE EPRTRpublic COLLATE Latin1_General_CI_AS;"

REM Restore database based on backup:
sqlcmd -Q "RESTORE DATABASE [EPRTRpublic] FROM  DISK = N'C:\Program Files\Microsoft SQL Server\MSSQL10.MSSQLSERVER\MSSQL\Backup\EPRTRpublic.bak' WITH  FILE = 1,  NOUNLOAD,  REPLACE,  STATS = 10"

