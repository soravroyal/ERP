SET basedir=C:\EIONET\EPRTRcms\CMS_XLIFF\Deploy\xliff_out
SET fileout=%basedir%\xliff_out.xlf
SET SQLCMDDBNAME=EPRTRcms

echo Copying data to export tables
rem sqlcmd -Q "EXEC EPRTRcms.dbo.xliff_export @pSourceLanguage = N'en', @pTargetLanguage = N'%1',@pSpecificPart = N'N',@pChangedDateStartInput = N'2010-04-08 12:09:01';" 
rem sqlcmd -Q "EXEC EPRTRcms.dbo.xliff_export @pSourceLanguage = N'en', @pTargetLanguage = N'%1',@pChangedDateStartInput = N'2010-04-20 12:09:01',@pChangedDateStopInput = N'2010-06-03 14:37:40';" 
rem sqlcmd -Q "EXEC EPRTRcms.dbo.xliff_export @pSourceLanguage = N'en', @pTargetLanguage = N'%1',@pChangedDateStartInput = N'2010-04-20 12:09:01',@pChangedDateStopInput = N'2010-06-03 14:37:40',@pLanguageInTargetField = N'de';" 
rem sqlcmd -Q "EXEC EPRTRcms.dbo.xliff_export @pSourceLanguage = N'en', @pTargetLanguage = N'%1',@pChangedDateStartInput = N'2010-04-08 12:09:01';" 
rem sqlcmd -Q "EXEC EPRTRcms.dbo.xliff_export @pSourceLanguage = N'en', @pTargetLanguage = N'%1', @pLanguageInTargetField = N'de',@pChangedDateStartInput = N'2010-04-08 12:09:01';" 
sqlcmd -Q "EXEC EPRTRcms.dbo.xliff_export @pSourceLanguage = N'en', @pTargetLanguage = N'%1';"

echo -----------------------------------------------

echo Exporting data to xliff text file
call %basedir%\Debug_cmd\XLIFF_EXPORT_CMD.exe %fileout% %SQLCMDSERVER% %SQLCMDUSER% %SQLCMDPASSWORD% %SQLCMDDBNAME%

echo -----------------------------------------------
echo Replacing escape characters with tags
cscript  %basedir%\replace.vbs %fileout% "&lt;" "<"
cscript  %basedir%\replace.vbs %fileout% "&gt;" ">"
cscript  %basedir%\replace.vbs %fileout% "<source>Previous year <</source>" "<source>Previous year &lt;</source>"
cscript  %basedir%\replace.vbs %fileout% "<target>Previous year <</target>" "<target>Previous year &lt;</target>"

echo -----------------------------------------------
echo Ranaming the exported file
rename %fileout% EPRTR_%2.xlf