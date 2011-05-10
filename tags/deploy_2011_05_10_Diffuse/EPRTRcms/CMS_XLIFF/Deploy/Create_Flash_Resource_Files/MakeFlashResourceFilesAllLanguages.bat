echo off
SET SQLCMDDBNAME=EPRTRcms
SET SQLCMDSERVER=sdkcga6306
set basedir=%CD%
set password=tmggis

call MakeFlashResourceFiles.bat de_DE de-DE
call MakeFlashResourceFiles.bat en_GB en-GB
call MakeFlashResourceFiles.bat es_ES es-ES
call MakeFlashResourceFiles.bat fr_FR fr-FR
call MakeFlashResourceFiles.bat it_IT it-IT
call MakeFlashResourceFiles.bat nl_NL nl-NL
call MakeFlashResourceFiles.bat pl_PL pl-PL
call MakeFlashResourceFiles.bat ro_RO ro-RO

echo -----------------------------------------------
pause
