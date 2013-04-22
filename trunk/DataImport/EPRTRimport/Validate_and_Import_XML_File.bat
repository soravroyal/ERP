echo off

rem remove quotes if any
SET basedir=%~1
SET data_dir=%~2
SET doValidate=%~3
SET title=%~4
SET filename=%~5
SET cdrUrl=%~6
SET cdrUploaded=%~7
SET cdrReleased=%~8
SET cdrDescription=%~9
shift
SET SQLCMDSERVER=%~9
shift
SET SQLCMDUSER=%~9
shift
SET SQLCMDPASSWORD=%~9

SET sqlscript_dir=%basedir%\SQLScripts
SET mapforce_dir=%basedir%\MAPFORCE

echo Importing %title% 
echo -----------------------------------------------

rem echo basedir %basedir%
rem echo data_dir %data_dir%
rem echo doValidate %doValidate%
rem echo title %title%
rem echo filename %filename%
rem echo cdrUrl %cdrUrl%
rem echo cdrUploaded %cdrUploaded%
rem echo cdrReleased %cdrReleased%
rem echo cdrDescription %cdrDescription%

SET sqlscript_dir=%basedir%\SQLScripts
SET mapforce_dir=%basedir%\MAPFORCE

rem Recreating EPRTRxml database
rem call %sqlscript_dir%\recreate_EPRTRxml.bat %sqlscript_dir%

echo Test: %mapforce_dir% "%data_dir%\%filename%" %SQLCMDSERVER% %SQLCMDUSER% %SQLCMDPASSWORD%

rem Importing xml file into EPRTRxml database 
call %mapforce_dir%\EPRTR_Import_CMD.exe "%data_dir%\%filename%" %SQLCMDSERVER% %SQLCMDUSER% %SQLCMDPASSWORD%

if "%doValidate%"=="true" (
  SET SQLCMDDBNAME=EPRTRxml
  echo Validating data
  sqlcmd -Q "EXEC EPRTRxml.dbo.validate_xml_data"
  echo -----------------------------------------------
)

echo Copying data from xml to master
sqlcmd -i %sqlscript_dir%\reset_cols_4_xmlimport.sql
sqlcmd -Q "EXEC EPRTRxml.dbo.import_xml @pCDRURL=N'%cdrUrl%',@pCDRUploaded=N'%cdrUploaded%', @pCDRReleased=N'%cdrReleased%', @pResubmitReason='%cdrDescription%';"
echo -----------------------------------------------
