set /p SQLCMDSERVER= Type in name of server and press Enter:
set /p SQLCMDUSER= Type in name of database user and press Enter:
set /p SQLCMDPASSWORD= Type in password for database user and press Enter:
echo off
call xliff_import_cmd_version.bat EPRTR_DE.xlf de > deltareport.txt
pause