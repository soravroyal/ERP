set /p SQLCMDSERVER= Type in name of server and press Enter:
set /p SQLCMDUSER= Type in name of database user and press Enter:
set /p SQLCMDPASSWORD= Type in password for database user and press Enter:
echo off
call xliff_import_cmd_version.bat EPRTR_DE.xlf de
call xliff_import_cmd_version.bat EPRTR_ES.xlf es
call xliff_import_cmd_version.bat EPRTR_FR.xlf fr
call xliff_import_cmd_version.bat EPRTR_IT.xlf it
call xliff_import_cmd_version.bat EPRTR_NL.xlf nl
call xliff_import_cmd_version.bat EPRTR_PL.xlf pl
call xliff_import_cmd_version.bat EPRTR_RO.xlf ro
pause