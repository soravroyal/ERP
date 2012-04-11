echo off
echo Importing Switzerland 2009
echo -----------------------------------------------

SET sqlscript_dir=%1
SET mapforce_dir=%2
SET data_dir=%3
SET doValidate=%4

rem Recreating EPRTRxml database
call %sqlscript_dir%\recreate_EPRTRxml.bat %1 %sqlscript_dir%
rem Importing xml file into EPRTRxml database 
call %mapforce_dir%\EPRTR_Import_CMD.exe "%data_dir%\CH_EPRTR-2009.xml" %SQLCMDSERVER% %SQLCMDUSER% %SQLCMDPASSWORD%
rem -----------------------------------------------

if "%doValidate%"=="true" (
  SET SQLCMDDBNAME=EPRTRxml
  echo Validating data
  sqlcmd -Q "EXEC EPRTRxml.dbo.validate_xml_data"
  echo -----------------------------------------------
)

echo Copying data from xml to master
sqlcmd -i %sqlscript_dir%\reset_cols_4_xmlimport.sql
sqlcmd -Q "EXEC EPRTRxml.dbo.import_xml @pCDRURL=N'http://cdr.eionet.europa.eu/ch/eu/eprtr/envtz50bw',@pCDRUploaded=N'2012-02-17 16:39:00', @pCDRReleased=N'2012-02-20 11:34:10', @pResubmitReason='E-PRTR data 2009';"
echo -----------------------------------------------