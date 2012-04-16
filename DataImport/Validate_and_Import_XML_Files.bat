echo off
rem set up database server, user and password
SET SQLCMDSERVER=sdkcga6332
SET SQLCMDUSER=gis
SET SQLCMDPASSWORD=tmggis

rem set up base directory of scripts and data
SET basedir=D:\EPRTR\DataImport
SET data_dir=D:\EPRTR\XML_DOWNLOAD\submission_2012_04_15

rem set doValidate true/false to indicate if validations are to be performed or not 
SET doValidate=false

SET sqlscript_dir=%basedir%\SQLScripts
SET mapforce_dir=%basedir%\MAPFORCE
SET config=%data_dir%\00_config.csv

rem start importing all files as defined in config file
if not exist %data_dir%\logs mkdir %data_dir%\logs

SETLOCAL EnableDelayedExpansion

for /f "eol=# tokens=1,2,3,4,5,6,7 delims=;" %%a in (%config%) do (

	SET title=%%c %%a
	SET filename=%%b_EPRTR-%%a.xml
	SET cdrUrl=%%d
	SET cdrUploaded=%%e
	SET cdrReleased=%%f
	SET cdrDescription=%%g

	echo Importing:!filename!
	call Validate_and_Import_XML_File.bat > %data_dir%\logs\!filename!.log %basedir%  %data_dir%  %doValidate%  "!title!"  !filename!  "!cdrUrl!"  "!cdrUploaded!"  "!cdrReleased!"  "!cdrDescription!"
)

set /p name=press enter