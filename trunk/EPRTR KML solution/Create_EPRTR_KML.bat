set LOGFILE=Create_KML.log
SET CURDATE=%DATE%:%TIME% 

echo ********************************************************* >> %LOGFILE%
echo ******* Start Creating E-PRTR KML file	  ****** %CURDATE% >> %LOGFILE%
echo ********************************************************* >> %LOGFILE%

call EPER_fill_mxd.py  >> %LOGFILE%

echo ********************************************************* >> %LOGFILE%
echo ******* End Creating E-PRTR KML file	  ****** %CURDATE% >> %LOGFILE%
echo ********************************************************* >> %LOGFILE%
