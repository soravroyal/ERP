SET basedir=C:\EIONET\EPRTRcms\CMS_XLIFF\Deploy\xliff_in
SET basedirexp=C:\EIONET\EPRTRcms\CMS_XLIFF\Deploy\xliff_out
SET filein=%basedir%\xliff_in.xlf
SET fileout1=xliff_delta.xml
SET fileout2=xliff_out.xlf
SET SQLCMDDBNAME=EPRTRcms

echo Resetting xliff import tables
sqlcmd -Q "EXEC EPRTRcms.dbo.xliff_reset_tables" 
echo -----------------------------------------------
echo Preprocessing xliff files replacing tags with escape characters
%basedir%\sed.exe -f %basedir%\language_import_preprocess.sed %basedir%\%1 > %filein%
echo -----------------------------------------------
echo Import xliff file into database
call %basedir%\Debug_cmd\XLIFF_IMPORT_CMD.exe %filein% %SQLCMDSERVER% %SQLCMDUSER% %SQLCMDPASSWORD% %SQLCMDDBNAME%
echo -----------------------------------------------
rem echo Copying data from import tables
rem The 'Report'-parameter produces only a delta report and does not import texts
rem sqlcmd -Q "EXEC EPRTRcms.dbo.xliff_import @pImportAndDeltaReport = 'Report';"
rem The 'Import'-parameter imports texts but does not produce a delta report
rem sqlcmd -Q "EXEC EPRTRcms.dbo.xliff_import @pImportAndDeltaReport = 'Import';"
rem The 'Both'-parameter produces a delta report and imports texts
sqlcmd -Q "EXEC EPRTRcms.dbo.xliff_import @pImportAndDeltaReport = 'Both';"
rem If no parameter is given the default parameter is 'Report' which produces a delta report
rem sqlcmd -Q "EXEC EPRTRcms.dbo.xliff_import;"
call %basedirexp%\Debug_cmd\XLIFF_EXPORT_CMD.exe %fileout1% %SQLCMDSERVER% %SQLCMDUSER% %SQLCMDPASSWORD% %SQLCMDDBNAME%
sqlcmd -Q "EXEC EPRTRcms.dbo.xliff_deltaexport @pSourceLanguage = N'en', @pTargetLanguage = N'%2';"
call %basedirexp%\Debug_cmd\XLIFF_EXPORT_CMD.exe %fileout2% %SQLCMDSERVER% %SQLCMDUSER% %SQLCMDPASSWORD% %SQLCMDDBNAME%
echo -----------------------------------------------
echo Replacing escape characters with tags
cscript  %basedir%\replace.vbs %fileout2% "&lt;" "<"
cscript  %basedir%\replace.vbs %fileout2% "&gt;" ">"
cscript  %basedir%\replace.vbs %fileout2% "<source>Previous year <</source>" "<source>Previous year &lt;</source>"
cscript  %basedir%\replace.vbs %fileout2% "<target>Previous year <</target>" "<target>Previous year &lt;</target>"

echo -----------------------------------------------
echo Ranaming the exported file
rename %fileout2% EPRTR_DELTA_%2.xlf
pause