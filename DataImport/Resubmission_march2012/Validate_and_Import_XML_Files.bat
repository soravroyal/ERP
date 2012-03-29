echo off
rem set /p SQLCMDSERVER= Type in name of server and press Enter:
rem set /p SQLCMDUSER= Type in name of database user and press Enter:
rem set /p SQLCMDPASSWORD= Type in password for database user and press Enter:

set SQLCMDSERVER=sdkcga6332
set SQLCMDUSER=gis
set SQLCMDPASSWORD=tmggis


for %%f in (*_imp.bat) do (
	echo %%f
	rem parameter %1: sqlscript_dir
	rem parameter %2: mapforce_dir
	rem parameter %3: data_dir (location of XML files)
	rem parameter %4: doValidate (true/false)
	call %%f > %%f.log 	%1 D:\EPRTRimport\EIONET\SQLScripts 	%2 D:\EPRTRimport\XML-import\MAPFORCE 	%3 D:\EPRTRimport\XML-import\XML_DOWNLOAD\submission_2012_03_01 %4 true
)
set /p name=press enter

	
	
	