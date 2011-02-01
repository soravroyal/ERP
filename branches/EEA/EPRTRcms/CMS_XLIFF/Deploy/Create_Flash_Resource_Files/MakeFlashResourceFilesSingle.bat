sqlcmd -Q "EXEC %SQLCMDDBNAME%.dbo.create_makeflashresourcefile @pLanguage = '%1',@pCategory = '%2';"
dtexec /f "flash_out_utf8.dtsx" /De %password%
rename %basedir%\files\flash_out.txt %3.properties